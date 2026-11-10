SELECT VERSION() AS mysql_version;
CREATE DATABASE IF NOT EXISTS olist_delivery_analysis
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE olist_delivery_analysis;

SELECT DATABASE() AS active_database;