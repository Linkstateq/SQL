-- 07_referential_integrity_tests.sql
-- File purpose: Document and demonstrate CHECK constraints, foreign keys, and ON DELETE behavior.
--
-- Important execution note:
-- Tests 1 through 6 are intentionally written inside comments because they are
-- expected to fail. Run those blocks manually one at a time when taking screenshots.
-- Tests 7 and 8 are safe to run automatically because they use transactions and
-- ROLLBACK, so 08_full_run.sql will not fail or leave test data behind.

USE airbnb_sql_data_mart;

-- Test name:
-- 1. CHECK constraint test for invalid booking dates
-- Purpose:
-- Prove that chk_bookings_date_range rejects updates where check_out_date is not after check_in_date.
-- SQL statement:
/*
-- Run this UPDATE first. It is expected to fail.
UPDATE bookings
SET check_out_date = DATE_SUB(check_in_date, INTERVAL 1 DAY)
WHERE booking_id = 1;

-- After capturing the error, run this SELECT separately to verify the row stayed valid.
SELECT
  booking_id,
  check_in_date,
  check_out_date
FROM bookings
WHERE booking_id = 1;
*/
-- Expected result:
-- MySQL rejects the UPDATE because check_out_date must be later than check_in_date.
-- Screenshot instruction:
-- Capture the CHECK constraint error, then capture the SELECT result showing booking 1 still has valid dates.

-- Test name:
-- 2. CHECK constraint test for invalid payment amount
-- Purpose:
-- Prove that chk_payments_amount rejects updates where amount is negative.
-- SQL statement:
/*
-- Run this UPDATE first. It is expected to fail.
UPDATE payments
SET amount = -100.00
WHERE payment_id = 1;

-- After capturing the error, run this SELECT separately to verify the row stayed valid.
SELECT
  payment_id,
  amount,
  payment_status
FROM payments
WHERE payment_id = 1;
*/
-- Expected result:
-- MySQL rejects the UPDATE because payment amount must be greater than 0.
-- Screenshot instruction:
-- Capture the CHECK constraint error, then capture the SELECT result showing payment 1 still has a positive amount.

-- Test name:
-- 3. CHECK constraint test for invalid review rating
-- Purpose:
-- Prove that chk_reviews_rating rejects updates outside the allowed 1 to 5 range.
-- SQL statement:
/*
-- Run this UPDATE first. It is expected to fail.
UPDATE reviews
SET rating = 6
WHERE review_id = 1;

-- After capturing the error, run this SELECT separately to verify the row stayed valid.
SELECT
  review_id,
  rating
FROM reviews
WHERE review_id = 1;
*/
-- Expected result:
-- MySQL rejects the UPDATE because rating 6 is outside the 1 to 5 range.
-- Screenshot instruction:
-- Capture the CHECK constraint error, then capture the SELECT result showing review 1 still has a valid rating.

-- Test name:
-- 4. FK test for invalid booking
-- Purpose:
-- Prove that bookings cannot reference a non-existing listing or guest.
-- SQL statement:
/*
INSERT INTO bookings (
  booking_id, listing_id, guest_user_id, check_in_date, check_out_date,
  number_of_guests, booking_status, subtotal_amount, guest_service_fee,
  host_service_fee, total_amount
) VALUES (
  9002, 999999, 999999, '2026-10-10', '2026-10-12',
  2, 'pending', 9000.00, 900.00,
  360.00, 9900.00
);
*/
-- Expected result:
-- MySQL rejects the row with a foreign key error because listing_id and guest_user_id do not exist.
-- Screenshot instruction:
-- The error proves that bookings cannot be orphaned from listings or guests.

-- Test name:
-- 5. FK test for invalid payment
-- Purpose:
-- Prove that payments cannot reference a non-existing booking.
-- SQL statement:
/*
INSERT INTO payments (
  payment_id, booking_id, payer_user_id, payment_method_id, amount,
  currency_code, payment_status, transaction_reference, paid_at
) VALUES (
  9002, 999999, 1, 1, 2500.00,
  'INR', 'paid', 'PAY-INVALID-BOOKING', '2026-10-01 10:00:00'
);
*/
-- Expected result:
-- MySQL rejects the row with a foreign key error because booking_id 999999 does not exist.
-- Screenshot instruction:
-- The error proves that payment transactions must belong to a valid booking.

-- Test name:
-- 6. ON DELETE RESTRICT test for users with listings or bookings
-- Purpose:
-- Prove that a user with existing listings or bookings cannot be deleted through restricted child relationships.
-- SQL statement:
/*
-- Host user 21 owns listings, so this delete should be restricted by listings.host_user_id.
DELETE FROM users
WHERE user_id = 21;

-- Guest user 1 owns bookings, so this delete should be restricted by bookings.guest_user_id.
DELETE FROM users
WHERE user_id = 1;
*/
-- Expected result:
-- MySQL rejects the delete because the user is referenced by listings or bookings.
-- Screenshot instruction:
-- The error proves that important marketplace history is protected from accidental user deletion.

-- Test name:
-- 7. ON DELETE CASCADE test for listing child tables
-- Purpose:
-- Prove that deleting a listing cascades to photos, rooms, room amenities, rules, availability, and listing amenities.
-- SQL statement:
-- The following block is safe to run automatically. It creates temporary test rows,
-- deletes the temporary listing, displays before/after child row counts, and rolls back.
-- Expected result:
-- The first SELECT shows child rows exist. The second SELECT shows zero child rows after deleting the listing.
-- Screenshot instruction:
-- Capture both result sets to show that listing-dependent data is removed automatically by ON DELETE CASCADE.
START TRANSACTION;

SET @cascade_listing_id = 9001;
SET @cascade_room_id = 9001;
SET @cascade_photo_id = 9001;
SET @cascade_rule_id = 9001;

INSERT INTO listings (
  listing_id, host_user_id, property_type_id, address_id, title, description,
  base_price, max_guests, bedrooms, bathrooms, status
) VALUES (
  @cascade_listing_id, 21, 1, 1, 'Temporary Cascade Test Listing',
  'Temporary listing used only for ON DELETE CASCADE screenshots.',
  5000.00, 2, 1, 1.00, 'draft'
);

INSERT INTO listing_photos (
  photo_id, listing_id, photo_url, caption, display_order, is_cover_photo
) VALUES (
  @cascade_photo_id, @cascade_listing_id,
  'https://cdn.example.com/listings/cascade-test.jpg',
  'Temporary cascade photo', 1, TRUE
);

INSERT INTO rooms (
  room_id, listing_id, room_name, room_type, capacity, bed_count, price_adjustment
) VALUES (
  @cascade_room_id, @cascade_listing_id, 'Temporary cascade room',
  'Private bedroom', 2, 1, 0.00
);

INSERT INTO room_amenities (room_id, amenity_id)
VALUES (@cascade_room_id, 1);

INSERT INTO house_rules (
  house_rule_id, listing_id, rule_title, rule_description, is_mandatory
) VALUES (
  @cascade_rule_id, @cascade_listing_id,
  'Temporary cascade rule',
  'This rule should be deleted when the listing is deleted.',
  TRUE
);

INSERT INTO availability_calendar (
  listing_id, calendar_date, is_available, custom_price, min_nights, max_nights, notes
) VALUES (
  @cascade_listing_id, '2026-12-01', TRUE, 5500.00, 1, 14,
  'Temporary cascade availability row.'
);

INSERT INTO listing_amenities (listing_id, amenity_id)
VALUES (@cascade_listing_id, 1);

SELECT
  'Before deleting temporary listing' AS cascade_step,
  (SELECT COUNT(*) FROM listing_photos WHERE listing_id = @cascade_listing_id) AS photo_rows,
  (SELECT COUNT(*) FROM rooms WHERE listing_id = @cascade_listing_id) AS room_rows,
  (SELECT COUNT(*) FROM room_amenities WHERE room_id = @cascade_room_id) AS room_amenity_rows,
  (SELECT COUNT(*) FROM house_rules WHERE listing_id = @cascade_listing_id) AS rule_rows,
  (SELECT COUNT(*) FROM availability_calendar WHERE listing_id = @cascade_listing_id) AS availability_rows,
  (SELECT COUNT(*) FROM listing_amenities WHERE listing_id = @cascade_listing_id) AS listing_amenity_rows;

DELETE FROM listings
WHERE listing_id = @cascade_listing_id;

SELECT
  'After deleting temporary listing' AS cascade_step,
  (SELECT COUNT(*) FROM listing_photos WHERE listing_id = @cascade_listing_id) AS photo_rows,
  (SELECT COUNT(*) FROM rooms WHERE listing_id = @cascade_listing_id) AS room_rows,
  (SELECT COUNT(*) FROM room_amenities WHERE room_id = @cascade_room_id) AS room_amenity_rows,
  (SELECT COUNT(*) FROM house_rules WHERE listing_id = @cascade_listing_id) AS rule_rows,
  (SELECT COUNT(*) FROM availability_calendar WHERE listing_id = @cascade_listing_id) AS availability_rows,
  (SELECT COUNT(*) FROM listing_amenities WHERE listing_id = @cascade_listing_id) AS listing_amenity_rows;

ROLLBACK;

-- Test name:
-- 8. ON DELETE SET NULL test for optional message booking reference
-- Purpose:
-- Prove that messages can keep their communication history when an optional booking reference is deleted.
-- SQL statement:
-- The following block is safe to run automatically. It creates a temporary booking and
-- message, deletes the booking, shows that messages.booking_id becomes NULL, and rolls back.
-- Expected result:
-- The final SELECT shows the temporary message still exists and booking_id is NULL.
-- Screenshot instruction:
-- The result proves that messages.booking_id uses ON DELETE SET NULL instead of deleting the message.
START TRANSACTION;

SET @set_null_booking_id = 9002;
SET @set_null_message_id = 9002;

INSERT INTO bookings (
  booking_id, listing_id, guest_user_id, check_in_date, check_out_date,
  number_of_guests, booking_status, subtotal_amount, guest_service_fee,
  host_service_fee, total_amount
) VALUES (
  @set_null_booking_id, 19, 1, '2026-12-10', '2026-12-12',
  1, 'pending', 12400.00, 1200.00,
  496.00, 13600.00
);

INSERT INTO messages (
  message_id, sender_user_id, recipient_user_id, booking_id,
  message_body, message_status, sent_at
) VALUES (
  @set_null_message_id, 1, 39, @set_null_booking_id,
  'Temporary message used to prove ON DELETE SET NULL for booking_id.',
  'sent', '2026-12-01 09:00:00'
);

SELECT
  'Before deleting temporary booking' AS set_null_step,
  message_id,
  booking_id,
  message_body
FROM messages
WHERE message_id = @set_null_message_id;

DELETE FROM bookings
WHERE booking_id = @set_null_booking_id;

SELECT
  'After deleting temporary booking' AS set_null_step,
  message_id,
  booking_id,
  message_body
FROM messages
WHERE message_id = @set_null_message_id;

ROLLBACK;
