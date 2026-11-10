import csv
from pathlib import Path

raw_data = Path(__file__).resolve().parents[1] / "raw_data"
source = raw_data / "olist_order_reviews_dataset.csv"
output = raw_data / "reviews_analysis_import.csv"

fields = [
    "review_id",
    "order_id",
    "review_score",
    "review_creation_date",
    "review_answer_timestamp",
]

with source.open(encoding="utf-8-sig", newline="") as file:
    reader = csv.DictReader(file)
    missing_fields = set(fields) - set(reader.fieldnames or [])
    if missing_fields:
        raise ValueError(f"Missing CSV columns: {sorted(missing_fields)}")
    rows = [{field: row[field] for field in fields} for row in reader]

with output.open("w", encoding="utf-8", newline="") as file:
    writer = csv.DictWriter(file, fieldnames=fields)
    writer.writeheader()
    writer.writerows(rows)

print(f"Wrote {len(rows):,} reviews to {output.name}")