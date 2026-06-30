-- 00_drop_database.sql
-- Purpose: Remove the Phase 2 Airbnb booking database before a fresh test run.
-- This file is used at the start of repeatable testing so old tables, constraints,
-- indexes, or sample data cannot affect the result of the current build.
-- Warning: This permanently deletes the database named below.

DROP DATABASE IF EXISTS airbnb_booking_phase2;
