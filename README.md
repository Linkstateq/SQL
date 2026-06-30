# Taher_Airbnb_SQL_Phase2

Portfolio project for IU course **DLBDSPBDM01 - Build a Data Mart in SQL**.

This project implements an Airbnb-style accommodation booking database in MySQL 8.0. It is designed for Phase 2 assessment requirements: explicit primary keys and foreign keys, `CHECK` constraints, documented `ON DELETE` behavior, indexes, dummy data, validation queries, business `JOIN` queries, ternary relationship queries, and referential integrity tests.

## Project Structure

```text
Taher_Airbnb_SQL_Phase2/
  README.md
  INSTALLATION_MANUAL.md
  DATABASE_DOCUMENTATION.md
  sql/
    00_drop_database.sql
    01_create_database.sql
    02_create_tables.sql
    03_insert_dummy_data.sql
    04_indexes.sql
    05_validation_queries.sql
    06_business_queries.sql
    07_referential_integrity_tests.sql
    08_full_run.sql
```

## Database Name

```sql
taher_airbnb_sql_phase2
```

## Quick Start

Open a terminal from the project root and run:

```bash
mysql -u root -p < sql/08_full_run.sql
```

The full run script uses MySQL client `SOURCE` commands, so run it from the project root folder. It recreates the database from scratch, inserts sample records, creates indexes, and runs validation, business, and integrity test queries.

## What Is Included

- Normalized Airbnb-style schema for hosts, guests, listings, bookings, payments, reviews, amenities, and service requests.
- Explicit PK/FK constraints with named relationships.
- `CHECK` constraints for business rules such as valid ratings, positive prices, valid statuses, and valid date ranges.
- Multiple `ON DELETE` behaviors: `RESTRICT`, `CASCADE`, and `SET NULL`.
- A documented ternary relationship: `booking_service_requests`, connecting one booking, one guest, and one service type.
- Dummy data for realistic query outputs.
- Validation queries for data quality and relationship checks.
- Business queries using multi-table joins, aggregations, CTEs, and the ternary relationship.
- Executable referential integrity tests that catch expected constraint failures without stopping the script.



