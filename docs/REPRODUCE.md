# Rebuild the Olist delivery analysis

Use MySQL 8.0, MySQL Workbench, Python 3, and Power BI Desktop.
Run the setup in a fresh MySQL schema because several scripts
create tables and load them once.

## 1. Prepare the CSVs

Download the [Olist dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
and extract the orders, reviews, and customers CSVs into `raw_data/`.

From the project root, run:

```bash
python scripts/prepare_reviews_import.py
```

The script creates `raw_data/reviews_analysis_import.csv` with
99,224 rows and the five fields used in the analysis.

## 2. Build the SQL views

1. Run scripts `01` and `02`. Import `olist_orders_dataset.csv`
   into `raw_orders` using Workbench's import wizard.
2. Run scripts `03`–`08`. Import `reviews_analysis_import.csv`
   into `raw_reviews`. Map `review_answer_timestamp` to
   `review_timestamp` and leave the two comment columns unmapped.
3. Run scripts `09`–`14`. Import `olist_customers_dataset.csv`
   into `raw_customers`.
4. Create the customer index before running script `16`:

   ```sql
   ALTER TABLE raw_customers
   ADD UNIQUE INDEX ux_raw_customers_customer_id (customer_id);
   ```

5. Run script `16` to populate the indexed review table and create
   the state view. It supersedes the initial join in script `15`.
6. Run scripts `17` and `18`.

Expected import counts are 99,441 orders, 99,224 reviews, and
99,441 customers. The indexed review table should contain
98,673 rows, one per reviewed order. Rebuild that table if the
underlying review data changes.

## 3. Export to Power BI

In Workbench, set **Query → Limit Rows → Don't Limit**, then run:

```sql
SELECT *
FROM olist_delivery_analysis.delivery_dashboard;
```

Export the result grid as `delivery_dashboard.csv`. Import it
into Power BI as `DeliveryDashboard`. Keep `order_id` as text,
`purchase_month` as a date, and missing review scores as null.

The final dataset should have 96,470 rows, 6,534 late orders,
and 95,824 reviewed orders. Use the report PDF as a layout reference.

## 4. Recreate the Power BI measures

Create each measure separately in the DeliveryDashboard table.

```dax
Eligible Orders = COUNTROWS('DeliveryDashboard')

Late Orders = SUM('DeliveryDashboard'[is_late])

Reviewed Orders = COUNT('DeliveryDashboard'[review_score])

Late Delivery Rate = DIVIDE([Late Orders], [Eligible Orders])

Average Delivery Days =
AVERAGE('DeliveryDashboard'[delivery_duration_days])

Average Review Score =
AVERAGE('DeliveryDashboard'[review_score])
```

Format Late Delivery Rate as a percentage with two decimal
places. Format the two averages as decimal numbers with two
decimal places. Missing review scores remain blank and are
excluded from the review average.

Sort delay_band by delay_band_sort. Filter the state rate chart
to groups with at least 100 eligible orders. Use the PDF to
recreate the overview, findings, and methodology pages.

With filters cleared, confirm 96,470 eligible orders, 6,534
late orders, 95,824 reviewed orders, a 6.77% late-delivery
rate, and 12.56 average delivery days.