-- 06_business_queries.sql
-- Purpose: Advanced business reporting and relationship queries for the complete
-- Airbnb-style Phase 2 MySQL database.

USE airbnb_sql_data_mart;

-- Query title:
-- 1. Complete booking workflow query
-- Business purpose:
-- Show the full operational path from guest booking to payment, platform commission, and host payout.
-- Tables used:
-- bookings, listings, addresses, cities, countries, user_profiles, payments, platform_commissions, host_payouts.
-- Expected insight:
-- A reviewer can see whether each booking has matching guest, host, payment, commission, and payout records.
SELECT
  b.booking_id,
  CONCAT(guest_profile.first_name, ' ', guest_profile.last_name) AS guest_name,
  CONCAT(host_profile.first_name, ' ', host_profile.last_name) AS host_name,
  l.title AS listing_title,
  c.city_name AS city,
  co.country_name AS country,
  b.check_in_date,
  b.check_out_date,
  b.booking_status,
  p.payment_status,
  p.amount AS payment_amount,
  (pc.guest_commission_amount + pc.host_commission_amount) AS total_platform_commission,
  hp.payout_status AS host_payout_status
FROM bookings AS b
JOIN listings AS l ON l.listing_id = b.listing_id
JOIN addresses AS a ON a.address_id = l.address_id
JOIN cities AS c ON c.city_id = a.city_id
JOIN countries AS co ON co.country_id = c.country_id
JOIN user_profiles AS guest_profile ON guest_profile.user_id = b.guest_user_id
JOIN user_profiles AS host_profile ON host_profile.user_id = l.host_user_id
LEFT JOIN payments AS p ON p.booking_id = b.booking_id
LEFT JOIN platform_commissions AS pc ON pc.booking_id = b.booking_id
LEFT JOIN host_payouts AS hp ON hp.booking_id = b.booking_id
ORDER BY b.booking_id;

-- Query title:
-- 2. Ternary relationship query: room amenities
-- Business purpose:
-- Show which amenities belong to a specific room inside a specific listing.
-- Tables used:
-- listings, rooms, amenities, room_amenities.
-- Expected insight:
-- Demonstrates that room-level amenities are not only listing-level facts; they depend on listing, room, and amenity.
SELECT
  l.listing_id,
  l.title AS listing_title,
  r.room_id,
  r.room_name,
  r.room_type,
  a.amenity_id,
  a.amenity_name,
  a.amenity_category
FROM listings AS l
JOIN rooms AS r ON r.listing_id = l.listing_id
JOIN room_amenities AS ra ON ra.room_id = r.room_id
JOIN amenities AS a ON a.amenity_id = ra.amenity_id
ORDER BY l.listing_id, r.room_id, a.amenity_name;

-- Query title:
-- 3. Ternary relationship query: booking room guests
-- Business purpose:
-- Show which guest is assigned to which room within a booking.
-- Tables used:
-- bookings, rooms, users, user_profiles, booking_room_guests, listings.
-- Expected insight:
-- Demonstrates the ternary assignment between booking, room, and guest.
SELECT
  b.booking_id,
  l.title AS listing_title,
  r.room_id,
  r.room_name AS assigned_room,
  u.email AS assigned_guest_email,
  CONCAT(up.first_name, ' ', up.last_name) AS assigned_guest_name,
  b.check_in_date,
  b.check_out_date,
  b.booking_status
FROM booking_room_guests AS brg
JOIN bookings AS b
  ON b.booking_id = brg.booking_id
 AND b.listing_id = brg.listing_id
JOIN rooms AS r
  ON r.room_id = brg.room_id
 AND r.listing_id = brg.listing_id
JOIN listings AS l ON l.listing_id = b.listing_id
JOIN users AS u ON u.user_id = brg.guest_user_id
JOIN user_profiles AS up ON up.user_id = u.user_id
ORDER BY b.booking_id, r.room_id, assigned_guest_name;

-- Query title:
-- 4. Ternary relationship query: social review visibility
-- Business purpose:
-- Show which viewer can see which review through a social connection and why.
-- Tables used:
-- social_review_visibility, reviews, users, social_connections.
-- Expected insight:
-- Demonstrates review visibility as a relationship between review, viewer, and social connection.
WITH visibility_viewers AS (
  SELECT
    srv.review_id,
    srv.requester_user_id,
    srv.addressee_user_id,
    srv.requester_user_id AS viewer_user_id,
    srv.visible_to_requester AS can_view,
    'requester' AS viewer_side
  FROM social_review_visibility AS srv
  UNION ALL
  SELECT
    srv.review_id,
    srv.requester_user_id,
    srv.addressee_user_id,
    srv.addressee_user_id AS viewer_user_id,
    srv.visible_to_addressee AS can_view,
    'addressee' AS viewer_side
  FROM social_review_visibility AS srv
)
SELECT
  vv.review_id,
  viewer.email AS viewer_email,
  requester.email AS requester_email,
  addressee.email AS addressee_email,
  sc.connection_status,
  vv.viewer_side,
  vv.can_view,
  r.rating,
  r.review_text,
  CASE
    WHEN sc.connection_status = 'blocked' THEN 'Connection is blocked, so visibility is disabled or limited.'
    WHEN vv.can_view = TRUE THEN 'Viewer is allowed by the social_review_visibility rule for this connection.'
    ELSE 'Viewer is part of the connection but this review is hidden for this side.'
  END AS visibility_reason
FROM visibility_viewers AS vv
JOIN social_review_visibility AS srv
  ON srv.review_id = vv.review_id
 AND srv.requester_user_id = vv.requester_user_id
 AND srv.addressee_user_id = vv.addressee_user_id
JOIN reviews AS r ON r.review_id = vv.review_id
JOIN social_connections AS sc
  ON sc.requester_user_id = vv.requester_user_id
 AND sc.addressee_user_id = vv.addressee_user_id
JOIN users AS viewer ON viewer.user_id = vv.viewer_user_id
JOIN users AS requester ON requester.user_id = vv.requester_user_id
JOIN users AS addressee ON addressee.user_id = vv.addressee_user_id
ORDER BY vv.review_id, vv.viewer_side;

-- Query title:
-- 5. Host revenue query
-- Business purpose:
-- Calculate completed booking value, host service fees, payout amount, and completed stay count per host.
-- Tables used:
-- host_profiles, user_profiles, listings, bookings, host_payouts.
-- Expected insight:
-- Shows which hosts generated completed-stay revenue and how much was paid out after host service fees.
SELECT
  hp.user_id AS host_user_id,
  hp.host_display_name,
  CONCAT(up.first_name, ' ', up.last_name) AS host_name,
  COUNT(DISTINCT CASE WHEN b.booking_status = 'completed' THEN b.booking_id END) AS completed_stays,
  COALESCE(SUM(CASE WHEN b.booking_status = 'completed' THEN b.total_amount ELSE 0 END), 0) AS completed_booking_value,
  COALESCE(SUM(CASE WHEN b.booking_status = 'completed' THEN b.host_service_fee ELSE 0 END), 0) AS total_host_service_fee,
  COALESCE(SUM(CASE WHEN b.booking_status = 'completed' THEN hpayout.payout_amount ELSE 0 END), 0) AS total_payout_amount
FROM host_profiles AS hp
JOIN user_profiles AS up ON up.user_id = hp.user_id
LEFT JOIN listings AS l ON l.host_user_id = hp.user_id
LEFT JOIN bookings AS b ON b.listing_id = l.listing_id
LEFT JOIN host_payouts AS hpayout ON hpayout.booking_id = b.booking_id
GROUP BY hp.user_id, hp.host_display_name, up.first_name, up.last_name
ORDER BY completed_booking_value DESC, completed_stays DESC;

-- Query title:
-- 6. Guest spending query
-- Business purpose:
-- Show total guest spending based on paid payment records.
-- Tables used:
-- users, user_profiles, guest_profiles, payments.
-- Expected insight:
-- Identifies highest-value guests using actual successful payment data.
SELECT
  gp.user_id AS guest_user_id,
  u.email AS guest_email,
  CONCAT(up.first_name, ' ', up.last_name) AS guest_name,
  COUNT(p.payment_id) AS paid_payment_count,
  COALESCE(SUM(p.amount), 0) AS total_paid_amount
FROM guest_profiles AS gp
JOIN users AS u ON u.user_id = gp.user_id
JOIN user_profiles AS up ON up.user_id = gp.user_id
LEFT JOIN payments AS p
  ON p.payer_user_id = gp.user_id
 AND p.payment_status = 'paid'
GROUP BY gp.user_id, u.email, up.first_name, up.last_name
ORDER BY total_paid_amount DESC, paid_payment_count DESC;

-- Query title:
-- 7. Listing performance query
-- Business purpose:
-- Show listing title, total bookings, average rating, total revenue, and booking count.
-- Tables used:
-- listings, bookings, reviews.
-- Expected insight:
-- Compares booking demand, revenue contribution, and guest satisfaction by listing.
WITH booking_performance AS (
  SELECT
    b.listing_id,
    COUNT(*) AS total_bookings,
    SUM(CASE WHEN b.booking_status IN ('completed', 'confirmed') THEN b.total_amount ELSE 0 END) AS total_revenue,
    COUNT(CASE WHEN b.booking_status IN ('completed', 'confirmed') THEN 1 END) AS revenue_booking_count
  FROM bookings AS b
  GROUP BY b.listing_id
),
review_performance AS (
  SELECT
    r.listing_id,
    ROUND(AVG(r.rating), 2) AS average_rating,
    COUNT(*) AS review_count
  FROM reviews AS r
  GROUP BY r.listing_id
)
SELECT
  l.listing_id,
  l.title AS listing_title,
  COALESCE(bp.total_bookings, 0) AS total_bookings,
  COALESCE(rp.average_rating, 0) AS average_rating,
  COALESCE(rp.review_count, 0) AS review_count,
  COALESCE(bp.total_revenue, 0) AS total_revenue,
  COALESCE(bp.revenue_booking_count, 0) AS booking_count
FROM listings AS l
LEFT JOIN booking_performance AS bp ON bp.listing_id = l.listing_id
LEFT JOIN review_performance AS rp ON rp.listing_id = l.listing_id
ORDER BY total_revenue DESC, average_rating DESC;

-- Query title:
-- 8. Cancellation and refund query
-- Business purpose:
-- Show cancelled or refunded bookings with policy terms and refund outcomes.
-- Tables used:
-- bookings, listings, listing_cancellation_policies, cancellation_policies, refunds, payments.
-- Expected insight:
-- Helps explain how cancellation policies connect to refund amounts and refund statuses.
SELECT
  b.booking_id,
  l.title AS listing_title,
  b.booking_status,
  cp.policy_name,
  cp.refund_percentage,
  cp.refund_cutoff_hours,
  p.payment_status,
  rf.refund_id,
  rf.refund_amount,
  rf.refund_status,
  rf.refund_reason
FROM bookings AS b
JOIN listings AS l ON l.listing_id = b.listing_id
JOIN listing_cancellation_policies AS lcp
  ON lcp.listing_id = l.listing_id
 AND lcp.effective_from <= b.check_in_date
 AND (lcp.effective_to IS NULL OR lcp.effective_to >= b.check_in_date)
JOIN cancellation_policies AS cp ON cp.cancellation_policy_id = lcp.cancellation_policy_id
LEFT JOIN payments AS p ON p.booking_id = b.booking_id
LEFT JOIN refunds AS rf ON rf.booking_id = b.booking_id
WHERE b.booking_status IN ('cancelled', 'refunded')
ORDER BY b.booking_id, rf.refund_id;

-- Query title:
-- 9. Support workload query
-- Business purpose:
-- Show the number of open, in-progress, resolved, and closed tickets per support agent.
-- Tables used:
-- support_tickets, users, user_profiles.
-- Expected insight:
-- Provides an operational workload view for support staffing and ticket follow-up.
SELECT
  st.assigned_agent_user_id,
  agent_user.email AS support_agent_email,
  CONCAT(agent_profile.first_name, ' ', agent_profile.last_name) AS support_agent_name,
  SUM(CASE WHEN st.ticket_status = 'open' THEN 1 ELSE 0 END) AS open_tickets,
  SUM(CASE WHEN st.ticket_status = 'in_progress' THEN 1 ELSE 0 END) AS in_progress_tickets,
  SUM(CASE WHEN st.ticket_status = 'resolved' THEN 1 ELSE 0 END) AS resolved_tickets,
  SUM(CASE WHEN st.ticket_status = 'closed' THEN 1 ELSE 0 END) AS closed_tickets,
  COUNT(*) AS total_assigned_tickets
FROM support_tickets AS st
LEFT JOIN users AS agent_user ON agent_user.user_id = st.assigned_agent_user_id
LEFT JOIN user_profiles AS agent_profile ON agent_profile.user_id = st.assigned_agent_user_id
GROUP BY
  st.assigned_agent_user_id,
  agent_user.email,
  agent_profile.first_name,
  agent_profile.last_name
ORDER BY total_assigned_tickets DESC, support_agent_name;

-- Query title:
-- 10. Review category score query
-- Business purpose:
-- Show average score per review category for each listing.
-- Tables used:
-- listings, reviews, review_scores, review_categories.
-- Expected insight:
-- Reveals whether listings perform better on cleanliness, accuracy, location, communication, or check-in.
SELECT
  l.listing_id,
  l.title AS listing_title,
  rc.category_name,
  ROUND(AVG(rs.score), 2) AS average_category_score,
  COUNT(rs.score) AS score_count
FROM listings AS l
JOIN reviews AS r ON r.listing_id = l.listing_id
JOIN review_scores AS rs ON rs.review_id = r.review_id
JOIN review_categories AS rc ON rc.review_category_id = rs.review_category_id
GROUP BY l.listing_id, l.title, rc.review_category_id, rc.category_name
ORDER BY l.listing_id, rc.category_name;

-- Query title:
-- 11. Availability and price query
-- Business purpose:
-- Show available dates with custom prices for published listings.
-- Tables used:
-- availability_calendar, listings, addresses, cities, countries.
-- Expected insight:
-- Helps hosts and analysts inspect available inventory and date-specific pricing.
SELECT
  l.listing_id,
  l.title AS listing_title,
  c.city_name,
  co.country_name,
  ac.calendar_date,
  ac.custom_price,
  ac.min_nights,
  ac.max_nights
FROM availability_calendar AS ac
JOIN listings AS l ON l.listing_id = ac.listing_id
JOIN addresses AS a ON a.address_id = l.address_id
JOIN cities AS c ON c.city_id = a.city_id
JOIN countries AS co ON co.country_id = c.country_id
WHERE l.`status` = 'published'
  AND ac.is_available = TRUE
ORDER BY ac.calendar_date, c.city_name, l.title;

-- Query title:
-- 12. Message traceability query
-- Business purpose:
-- Show all messages related to a booking with sender, receiver, message text, and sent time.
-- Tables used:
-- messages, bookings, listings, users, user_profiles.
-- Expected insight:
-- Provides an auditable communication trail for each booking.
SELECT
  m.booking_id,
  l.title AS listing_title,
  sender_user.email AS sender_email,
  CONCAT(sender_profile.first_name, ' ', sender_profile.last_name) AS sender_name,
  recipient_user.email AS receiver_email,
  CONCAT(recipient_profile.first_name, ' ', recipient_profile.last_name) AS receiver_name,
  m.message_status,
  m.sent_at,
  m.message_body
FROM messages AS m
JOIN bookings AS b ON b.booking_id = m.booking_id
JOIN listings AS l ON l.listing_id = b.listing_id
JOIN users AS sender_user ON sender_user.user_id = m.sender_user_id
JOIN user_profiles AS sender_profile ON sender_profile.user_id = m.sender_user_id
JOIN users AS recipient_user ON recipient_user.user_id = m.recipient_user_id
JOIN user_profiles AS recipient_profile ON recipient_profile.user_id = m.recipient_user_id
WHERE m.booking_id IS NOT NULL
ORDER BY m.booking_id, m.sent_at, m.message_id;

-- Query title:
-- 13A. Index demonstration query for booking availability checks
-- Business purpose:
-- Use EXPLAIN to show that the bookings date-range index can support listing availability searches.
-- Tables used:
-- bookings.
-- Expected insight:
-- MySQL should be able to use an index such as idx_bookings_listing_date_range for listing_id and date filters.
EXPLAIN
SELECT
  b.booking_id,
  b.listing_id,
  b.check_in_date,
  b.check_out_date,
  b.booking_status
FROM bookings AS b
WHERE b.listing_id = 1
  AND b.check_in_date < '2026-08-15'
  AND b.check_out_date > '2026-08-01';

-- Query title:
-- 13B. Index demonstration query for payment reconciliation
-- Business purpose:
-- Use EXPLAIN to show that the composite payment index supports booking and status filtering.
-- Tables used:
-- payments.
-- Expected insight:
-- MySQL should be able to use idx_payments_booking_status for booking-level reconciliation.
EXPLAIN
SELECT
  p.payment_id,
  p.booking_id,
  p.payment_status,
  p.amount
FROM payments AS p
WHERE p.booking_id = 16
  AND p.payment_status = 'refunded';

-- Query title:
-- 13C. Index demonstration query for booking message timelines
-- Business purpose:
-- Use EXPLAIN to show that the message timeline index supports booking-linked message lookup.
-- Tables used:
-- messages.
-- Expected insight:
-- MySQL should be able to use idx_messages_booking_sent_at for booking_id and sent_at filtering.
EXPLAIN
SELECT
  m.message_id,
  m.booking_id,
  m.sender_user_id,
  m.recipient_user_id,
  m.sent_at
FROM messages AS m
WHERE m.booking_id = 1
  AND m.sent_at >= '2026-01-01 00:00:00'
ORDER BY m.sent_at;

