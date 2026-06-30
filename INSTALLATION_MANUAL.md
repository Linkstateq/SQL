# Installation Manual

## 1. Requirements

- MySQL Server 8.0 or later.
- MySQL command-line client or MySQL Workbench.
- VS Code, optionally with a SQL extension for reading and editing `.sql` files.

This project uses MySQL 8.0 features such as enforced `CHECK` constraints, generated columns, common table expressions, and named foreign key constraints.

## 2. Open the Project in VS Code

1. Open VS Code.
2. Select **File > Open Folder**.
3. Choose the folder `Taher_Airbnb_SQL_Phase2`.

## 3. Recommended Full Installation Using MySQL CLI

From the project root folder, run:

```bash
mysql -u root -p < sql/08_full_run.sql
```

When prompted, enter the MySQL password for the selected user.

The script performs the following steps:

1. Drops any previous copy of `taher_airbnb_sql_phase2`.
2. Creates a fresh database.
3. Creates all tables with PK, FK, `CHECK`, and `ON DELETE` rules.
4. Inserts dummy data.
5. Creates indexes.
6. Runs validation queries.
7. Runs business queries.
8. Runs referential integrity tests.

## 4. Alternative Manual Execution Order

If using MySQL Workbench and the `SOURCE` commands in `08_full_run.sql` do not resolve paths correctly, open and run the SQL files manually in this exact order:

```text
sql/00_drop_database.sql
sql/01_create_database.sql
sql/02_create_tables.sql
sql/03_insert_dummy_data.sql
sql/04_indexes.sql
sql/05_validation_queries.sql
sql/06_business_queries.sql
sql/07_referential_integrity_tests.sql
```

## 5. Verify Installation

After installation, run:

```sql
USE taher_airbnb_sql_phase2;
SHOW TABLES;
```

Expected tables include:

```text
amenities
booking_guests
booking_service_requests
bookings
guests
host_payouts
hosts
listing_amenities
listings
locations
payments
property_types
reviews
service_types
```

## 6. Common Troubleshooting

### SOURCE file not found

Run the full script from the project root folder:

```bash
cd Taher_Airbnb_SQL_Phase2
mysql -u root -p < sql/08_full_run.sql
```

### Access denied

Use a MySQL user that has permission to create and drop databases, or ask the administrator to grant appropriate privileges.

### CHECK constraints not enforced

Confirm that the server is MySQL 8.0.16 or later:

```sql
SELECT VERSION();
```

### Delimiter errors in integrity tests

Run `07_referential_integrity_tests.sql` as a complete script, not line by line, because it temporarily changes the statement delimiter for stored procedures.

