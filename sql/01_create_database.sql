-- 01_create_database.sql
-- Purpose: Create the MySQL 8.0 database used for the Airbnb-style Phase 2 schema.
-- utf8mb4 supports international text, names, addresses, and message content.
-- utf8mb4_unicode_ci is selected to match the requested portfolio configuration.

CREATE DATABASE IF NOT EXISTS airbnb_sql_data_mart
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE airbnb_sql_data_mart;

-- Use strict behavior so invalid data fails early during inserts and tests.
SET SESSION sql_mode = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
