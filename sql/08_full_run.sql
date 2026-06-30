-- 08_full_run.sql
-- Purpose: Run the complete Airbnb Phase 2 database implementation in order.
--
-- MySQL Workbench instructions:
-- 1. Open MySQL Workbench and connect to your MySQL 8.0 server.
-- 2. Open this file from the project root folder: airbnb-sql-data-mart/sql/08_full_run.sql.
-- 3. Make sure the project root is the working directory for SOURCE path resolution.
-- 4. Run the full script, not only the current statement.
-- 5. If Workbench cannot resolve relative SOURCE paths, open and run files 00 through 06 manually in the order below.
--
-- MySQL command-line instructions:
-- From the airbnb-sql-data-mart project root folder, run:
-- mysql -u root -p < sql/08_full_run.sql
-- If the mysql client cannot resolve source paths in your terminal, run files
-- 00 through 06 manually in the same order shown below.
--
-- Why 07_referential_integrity_tests.sql is separate:
-- That file contains manual tests where some SQL statements are intentionally expected
-- to fail, such as invalid CHECK and FK inserts. It is kept out of the automated full
-- run so the complete build, data load, index creation, validation queries, and business
-- queries can finish successfully without stopping on expected errors.

source sql/00_drop_database.sql
source sql/01_create_database.sql
source sql/02_create_tables.sql
source sql/03_insert_dummy_data.sql
source sql/04_indexes.sql
source sql/05_validation_queries.sql
source sql/06_business_queries.sql
