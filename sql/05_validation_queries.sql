-- 05_validation_queries.sql
-- File purpose: Prove that the Airbnb-style Phase 2 database is populated correctly
-- and that core relationships, reporting joins, and data quality rules work.

USE airbnb_sql_data_mart;

-- Purpose:
-- Count rows in every table to prove the dummy data loaded successfully.
-- Expected result:
-- Every table should show at least 20 rows.
-- Tables used:
-- users, user_profiles, host_profiles, guest_profiles, identity_documents, social_accounts,
-- countries, cities, addresses, property_types, listings, listing_photos, rooms, amenities,
-- listing_amenities, room_amenities, house_rules, availability_calendar, bookings,
-- booking_room_guests, payment_methods, payments, host_payouts, refunds,
-- cancellation_policies, listing_cancellation_policies, reviews, review_categories,
-- review_scores, messages, support_tickets, support_ticket_messages, platform_commissions,
-- income_estimates, social_connections, social_review_visibility.
SELECT 'users' AS table_name, COUNT(*) AS row_count FROM users
UNION ALL SELECT 'user_profiles', COUNT(*) FROM user_profiles
UNION ALL SELECT 'host_profiles', COUNT(*) FROM host_profiles
UNION ALL SELECT 'guest_profiles', COUNT(*) FROM guest_profiles
UNION ALL SELECT 'identity_documents', COUNT(*) FROM identity_documents
UNION ALL SELECT 'social_accounts', COUNT(*) FROM social_accounts
UNION ALL SELECT 'countries', COUNT(*) FROM countries
UNION ALL SELECT 'cities', COUNT(*) FROM cities
UNION ALL SELECT 'addresses', COUNT(*) FROM addresses
UNION ALL SELECT 'property_types', COUNT(*) FROM property_types
UNION ALL SELECT 'listings', COUNT(*) FROM listings
UNION ALL SELECT 'listing_photos', COUNT(*) FROM listing_photos
UNION ALL SELECT 'rooms', COUNT(*) FROM rooms
UNION ALL SELECT 'amenities', COUNT(*) FROM amenities
UNION ALL SELECT 'listing_amenities', COUNT(*) FROM listing_amenities
UNION ALL SELECT 'room_amenities', COUNT(*) FROM room_amenities
UNION ALL SELECT 'house_rules', COUNT(*) FROM house_rules
UNION ALL SELECT 'availability_calendar', COUNT(*) FROM availability_calendar
UNION ALL SELECT 'bookings', COUNT(*) FROM bookings
UNION ALL SELECT 'booking_room_guests', COUNT(*) FROM booking_room_guests
UNION ALL SELECT 'payment_methods', COUNT(*) FROM payment_methods
UNION ALL SELECT 'payments', COUNT(*) FROM payments
UNION ALL SELECT 'host_payouts', COUNT(*) FROM host_payouts
UNION ALL SELECT 'refunds', COUNT(*) FROM refunds
UNION ALL SELECT 'cancellation_policies', COUNT(*) FROM cancellation_policies
UNION ALL SELECT 'listing_cancellation_policies', COUNT(*) FROM listing_cancellation_policies
UNION ALL SELECT 'reviews', COUNT(*) FROM reviews
UNION ALL SELECT 'review_categories', COUNT(*) FROM review_categories
UNION ALL SELECT 'review_scores', COUNT(*) FROM review_scores
UNION ALL SELECT 'messages', COUNT(*) FROM messages
UNION ALL SELECT 'support_tickets', COUNT(*) FROM support_tickets
UNION ALL SELECT 'support_ticket_messages', COUNT(*) FROM support_ticket_messages
UNION ALL SELECT 'platform_commissions', COUNT(*) FROM platform_commissions
UNION ALL SELECT 'income_estimates', COUNT(*) FROM income_estimates
UNION ALL SELECT 'social_connections', COUNT(*) FROM social_connections
UNION ALL SELECT 'social_review_visibility', COUNT(*) FROM social_review_visibility
ORDER BY table_name;

-- Purpose:
-- Show all users grouped by role and account status.
-- Expected result:
-- Rows should include guest, host, admin, and support_agent roles with valid statuses.
-- Tables used:
-- users.
SELECT
  u.`role`,
  u.`status`,
  COUNT(*) AS user_count
FROM users AS u
GROUP BY u.`role`, u.`status`
ORDER BY u.`role`, u.`status`;

-- Purpose:
-- Show listing search data with host name, city, country, property type, price, and status.
-- Expected result:
-- Each listing should appear with a valid host profile, address, city, country, and property type.
-- Tables used:
-- listings, host_profiles, user_profiles, addresses, cities, countries, property_types.
SELECT
  l.listing_id,
  l.title AS listing_title,
  hp.host_display_name,
  CONCAT(up.first_name, ' ', up.last_name) AS host_full_name,
  c.city_name,
  co.country_name,
  pt.type_name AS property_type,
  l.base_price,
  l.`status`
FROM listings AS l
JOIN host_profiles AS hp ON hp.user_id = l.host_user_id
JOIN user_profiles AS up ON up.user_id = hp.user_id
JOIN addresses AS a ON a.address_id = l.address_id
JOIN cities AS c ON c.city_id = a.city_id
JOIN countries AS co ON co.country_id = c.country_id
JOIN property_types AS pt ON pt.property_type_id = l.property_type_id
ORDER BY co.country_name, c.city_name, l.base_price;

-- Purpose:
-- Show bookings with guest name, listing title, dates, booking status, and total amount.
-- Expected result:
-- Every booking should join to one valid guest profile and one valid listing.
-- Tables used:
-- bookings, user_profiles, listings.
SELECT
  b.booking_id,
  CONCAT(gup.first_name, ' ', gup.last_name) AS guest_name,
  l.title AS listing_title,
  b.check_in_date,
  b.check_out_date,
  b.number_of_guests,
  b.booking_status,
  b.total_amount
FROM bookings AS b
JOIN user_profiles AS gup ON gup.user_id = b.guest_user_id
JOIN listings AS l ON l.listing_id = b.listing_id
ORDER BY b.check_in_date, b.booking_id;

-- Purpose:
-- Show payments with booking, guest, amount, payment method, and payment status.
-- Expected result:
-- Each payment should join to a booking, payer profile, and saved payment method.
-- Tables used:
-- payments, bookings, user_profiles, payment_methods.
SELECT
  p.payment_id,
  p.booking_id,
  CONCAT(up.first_name, ' ', up.last_name) AS payer_name,
  p.amount,
  p.currency_code,
  pm.method_type,
  pm.provider_name,
  pm.masked_account_number,
  p.payment_status,
  p.paid_at
FROM payments AS p
JOIN bookings AS b ON b.booking_id = p.booking_id
JOIN user_profiles AS up ON up.user_id = p.payer_user_id
JOIN payment_methods AS pm ON pm.payment_method_id = p.payment_method_id
ORDER BY p.payment_id;

-- Purpose:
-- Show refunds with booking, payment, refund amount, refund status, and reason.
-- Expected result:
-- Refund rows should only reference existing bookings and payments.
-- Tables used:
-- refunds, bookings, payments.
SELECT
  r.refund_id,
  r.booking_id,
  r.payment_id,
  b.booking_status,
  p.payment_status,
  r.refund_amount,
  r.refund_status,
  r.refund_reason
FROM refunds AS r
JOIN bookings AS b ON b.booking_id = r.booking_id
JOIN payments AS p ON p.payment_id = r.payment_id
ORDER BY r.refund_id;

-- Purpose:
-- Show host payouts with host name, booking, payout amount, and payout status.
-- Expected result:
-- Every payout should join to a valid host and booking.
-- Tables used:
-- host_payouts, user_profiles, bookings.
SELECT
  hp.payout_id,
  hp.booking_id,
  CONCAT(up.first_name, ' ', up.last_name) AS host_name,
  hp.payout_amount,
  hp.payout_status,
  hp.payout_reference,
  hp.released_at
FROM host_payouts AS hp
JOIN user_profiles AS up ON up.user_id = hp.host_user_id
JOIN bookings AS b ON b.booking_id = hp.booking_id
ORDER BY hp.payout_id;

-- Purpose:
-- Show reviews with reviewer, reviewee, listing, rating, and review text.
-- Expected result:
-- Every review should have a valid reviewer guest, reviewee host, listing, and rating from 1 to 5.
-- Tables used:
-- reviews, user_profiles, listings.
SELECT
  r.review_id,
  CONCAT(reviewer.first_name, ' ', reviewer.last_name) AS reviewer_name,
  CONCAT(reviewee.first_name, ' ', reviewee.last_name) AS reviewee_host_name,
  l.title AS listing_title,
  r.rating,
  r.review_title,
  r.review_text
FROM reviews AS r
JOIN user_profiles AS reviewer ON reviewer.user_id = r.reviewer_guest_user_id
JOIN user_profiles AS reviewee ON reviewee.user_id = r.host_user_id
JOIN listings AS l ON l.listing_id = r.listing_id
ORDER BY r.review_id;

-- Purpose:
-- Show support tickets with booking, creator, assigned support agent, priority, and status.
-- Expected result:
-- Every ticket should have a valid creator; assigned agent may be NULL only if no agent is assigned.
-- Tables used:
-- support_tickets, user_profiles, bookings.
SELECT
  st.support_ticket_id,
  st.booking_id,
  CONCAT(creator.first_name, ' ', creator.last_name) AS created_by_user,
  CONCAT(agent.first_name, ' ', agent.last_name) AS assigned_support_agent,
  st.priority,
  st.ticket_status,
  st.subject,
  st.created_at
FROM support_tickets AS st
JOIN user_profiles AS creator ON creator.user_id = st.opened_by_user_id
LEFT JOIN user_profiles AS agent ON agent.user_id = st.assigned_agent_user_id
LEFT JOIN bookings AS b ON b.booking_id = st.booking_id
ORDER BY st.priority DESC, st.created_at;

-- Purpose:
-- Show messages between users, optionally linked to bookings.
-- Expected result:
-- Every message should have valid sender and recipient names; booking_id may be NULL.
-- Tables used:
-- messages, user_profiles, bookings.
SELECT
  m.message_id,
  CONCAT(sender.first_name, ' ', sender.last_name) AS sender_name,
  CONCAT(recipient.first_name, ' ', recipient.last_name) AS recipient_name,
  m.booking_id,
  b.booking_status,
  m.message_status,
  m.sent_at,
  m.message_body
FROM messages AS m
JOIN user_profiles AS sender ON sender.user_id = m.sender_user_id
JOIN user_profiles AS recipient ON recipient.user_id = m.recipient_user_id
LEFT JOIN bookings AS b ON b.booking_id = m.booking_id
ORDER BY m.sent_at, m.message_id;

-- Purpose:
-- Show availability calendar entries for published listings.
-- Expected result:
-- Only listings with status published should appear, with non-negative custom prices when present.
-- Tables used:
-- availability_calendar, listings.
SELECT
  ac.listing_id,
  l.title AS listing_title,
  ac.calendar_date,
  ac.is_available,
  ac.custom_price,
  ac.min_nights,
  ac.max_nights
FROM availability_calendar AS ac
JOIN listings AS l ON l.listing_id = ac.listing_id
WHERE l.`status` = 'published'
ORDER BY ac.calendar_date, ac.listing_id;

-- Purpose:
-- Show income estimates for hosts.
-- Expected result:
-- Each estimate should join to a listing and host and show valid period and positive projected income.
-- Tables used:
-- income_estimates, listings, host_profiles, user_profiles.
SELECT
  ie.income_estimate_id,
  CONCAT(up.first_name, ' ', up.last_name) AS host_name,
  l.title AS listing_title,
  ie.estimate_period_start,
  ie.estimate_period_end,
  ie.projected_occupancy_rate,
  ie.projected_booked_nights,
  ie.projected_income,
  ie.model_version
FROM income_estimates AS ie
JOIN listings AS l ON l.listing_id = ie.listing_id
JOIN host_profiles AS hp ON hp.user_id = l.host_user_id
JOIN user_profiles AS up ON up.user_id = hp.user_id
ORDER BY host_name, ie.estimate_period_start;

-- Purpose:
-- Show platform commissions for bookings.
-- Expected result:
-- Each commission row should join to one booking and show rates between 0 and 100.
-- Tables used:
-- platform_commissions, bookings, listings.
SELECT
  pc.commission_id,
  pc.booking_id,
  l.title AS listing_title,
  b.total_amount AS total_booking_amount,
  pc.guest_commission_rate,
  pc.host_commission_rate,
  pc.guest_commission_amount,
  pc.host_commission_amount,
  pc.calculated_at
FROM platform_commissions AS pc
JOIN bookings AS b ON b.booking_id = pc.booking_id
JOIN listings AS l ON l.listing_id = b.listing_id
ORDER BY pc.booking_id;

-- Purpose:
-- Find bookings where check_out_date is not later than check_in_date.
-- Expected result:
-- Zero rows, because chk_bookings_date_range prevents invalid date ranges.
-- Tables used:
-- bookings.
SELECT
  b.booking_id,
  b.check_in_date,
  b.check_out_date
FROM bookings AS b
WHERE b.check_out_date <= b.check_in_date;

-- Purpose:
-- Find payments with amount less than or equal to zero.
-- Expected result:
-- Zero rows, because chk_payments_amount requires amount > 0.
-- Tables used:
-- payments.
SELECT
  p.payment_id,
  p.booking_id,
  p.amount,
  p.payment_status
FROM payments AS p
WHERE p.amount <= 0;

-- Purpose:
-- Find reviews where rating is outside the valid 1 to 5 range.
-- Expected result:
-- Zero rows, because chk_reviews_rating requires rating between 1 and 5.
-- Tables used:
-- reviews.
SELECT
  r.review_id,
  r.rating,
  r.review_text
FROM reviews AS r
WHERE r.rating NOT BETWEEN 1 AND 5;
