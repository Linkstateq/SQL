-- 04_indexes.sql
-- Purpose: Add indexing considerations for high-frequency search and join fields.
-- The schema already creates indexes for PRIMARY KEY and UNIQUE constraints. Where a
-- requested index is already covered by a primary or unique key, this file documents
-- that coverage instead of creating a duplicate index.

USE airbnb_sql_data_mart;

-- Users: email lookup for login is already indexed by UNIQUE constraint uq_users_email.
-- No duplicate email index is created because the unique key supports exact email searches.

-- Users: speeds filtering users by platform role, for example host, guest, admin, or support agent.
CREATE INDEX idx_users_role
  ON users (`role`);

-- Users: speeds account administration reports filtered by active, inactive, suspended, or deleted users.
CREATE INDEX idx_users_status
  ON users (`status`);

-- Listings: supports host dashboards that list all properties owned by one host.
-- Requested tutor name host_id maps to schema column host_user_id.
CREATE INDEX idx_listings_host_user_id
  ON listings (host_user_id);

-- Listings: supports joins from listings to addresses and location-based listing reports.
CREATE INDEX idx_listings_address_id
  ON listings (address_id);

-- Listings: supports filtering inventory by accommodation category.
CREATE INDEX idx_listings_property_type_id
  ON listings (property_type_id);

-- Listings: supports search pages that include or exclude draft, published, paused, and removed listings.
CREATE INDEX idx_listings_status
  ON listings (`status`);

-- Listings: supports price-range searches and sorting by nightly base price.
CREATE INDEX idx_listings_base_price
  ON listings (base_price);

-- Listings: supports recently created listing reports and host onboarding checks.
CREATE INDEX idx_listings_created_at
  ON listings (created_at);

-- Listings: supports common search filters combining publication status and price.
CREATE INDEX idx_listings_status_price
  ON listings (`status`, base_price);

-- Bookings: supports availability checks and joins from listings to reservations.
CREATE INDEX idx_bookings_listing_id
  ON bookings (listing_id);

-- Bookings: supports guest booking history. Requested tutor name guest_id maps to guest_user_id.
CREATE INDEX idx_bookings_guest_user_id
  ON bookings (guest_user_id);

-- Bookings: supports operational reports grouped by pending, confirmed, cancelled, completed, and refunded states.
CREATE INDEX idx_bookings_booking_status
  ON bookings (booking_status);

-- Bookings: supports arrival-date reports and check-in calendars.
CREATE INDEX idx_bookings_check_in_date
  ON bookings (check_in_date);

-- Bookings: supports departure-date reports and checkout workload planning.
CREATE INDEX idx_bookings_check_out_date
  ON bookings (check_out_date);

-- Bookings: supports date-overlap availability checks for a listing.
CREATE INDEX idx_bookings_listing_date_range
  ON bookings (listing_id, check_in_date, check_out_date);

-- Bookings: supports guest dashboards filtered by booking status.
CREATE INDEX idx_bookings_guest_status
  ON bookings (guest_user_id, booking_status);

-- Payments: supports joins from bookings to payment transactions.
CREATE INDEX idx_payments_booking_id
  ON payments (booking_id);

-- Payments: supports payer history and payment audit reports. Requested tutor name guest_id maps to payer_user_id.
CREATE INDEX idx_payments_payer_user_id
  ON payments (payer_user_id);

-- Payments: supports reconciliation by pending, paid, failed, and refunded states.
CREATE INDEX idx_payments_payment_status
  ON payments (payment_status);

-- Payments: supports payment timeline reports. Requested tutor name payment_date maps to schema column paid_at.
CREATE INDEX idx_payments_paid_at
  ON payments (paid_at);

-- Payments: supports transaction creation audits when paid_at is NULL for pending or failed payments.
CREATE INDEX idx_payments_created_at
  ON payments (created_at);

-- Payments: supports booking-level payment reconciliation by status.
CREATE INDEX idx_payments_booking_status
  ON payments (booking_id, payment_status);

-- Messages: supports sent-message inbox queries by sender. Requested tutor name sender_id maps to sender_user_id.
CREATE INDEX idx_messages_sender_user_id
  ON messages (sender_user_id);

-- Messages: supports received-message inbox queries by receiver. Requested tutor name receiver_id maps to recipient_user_id.
CREATE INDEX idx_messages_recipient_user_id
  ON messages (recipient_user_id);

-- Messages: supports message threads attached to a booking.
CREATE INDEX idx_messages_booking_id
  ON messages (booking_id);

-- Messages: supports chronological inbox and conversation ordering.
CREATE INDEX idx_messages_sent_at
  ON messages (sent_at);

-- Messages: supports direct conversations between two users.
CREATE INDEX idx_messages_sender_recipient
  ON messages (sender_user_id, recipient_user_id);

-- Messages: supports ordered booking conversations and booking support context.
CREATE INDEX idx_messages_booking_sent_at
  ON messages (booking_id, sent_at);

-- Reviews: booking_id is already the leftmost column in UNIQUE constraint uq_reviews_booking_reviewer.
-- No duplicate booking-only review index is created because that unique key supports booking review lookup.

-- Reviews: supports finding reviews written by a guest. Requested tutor name reviewer_id maps to reviewer_guest_user_id.
CREATE INDEX idx_reviews_reviewer_guest_user_id
  ON reviews (reviewer_guest_user_id);

-- Reviews: supports finding reviews received by a host. Requested tutor name reviewee_id maps to host_user_id.
CREATE INDEX idx_reviews_host_user_id
  ON reviews (host_user_id);

-- Reviews: supports quality reports filtered or sorted by rating.
CREATE INDEX idx_reviews_rating
  ON reviews (rating);

-- Reviews: supports listing-level quality reports by rating.
CREATE INDEX idx_reviews_listing_rating
  ON reviews (listing_id, rating);

-- Support tickets: supports finding tickets related to a booking.
CREATE INDEX idx_support_tickets_booking_id
  ON support_tickets (booking_id);

-- Support tickets: supports support history for the user who created the ticket.
-- Requested tutor name created_by_user_id maps to opened_by_user_id.
CREATE INDEX idx_support_tickets_opened_by_user_id
  ON support_tickets (opened_by_user_id);

-- Support tickets: supports agent workload dashboards.
-- Requested tutor name assigned_agent_id maps to assigned_agent_user_id.
CREATE INDEX idx_support_tickets_assigned_agent_user_id
  ON support_tickets (assigned_agent_user_id);

-- Support tickets: supports operational queues by ticket status.
CREATE INDEX idx_support_tickets_ticket_status
  ON support_tickets (ticket_status);

-- Support ticket messages: supports loading all messages for a ticket in creation order.
-- Requested tutor name ticket_id maps to support_ticket_id.
CREATE INDEX idx_support_ticket_messages_ticket_id
  ON support_ticket_messages (support_ticket_id);

-- Support ticket messages: supports ordered support-ticket conversation display.
CREATE INDEX idx_support_ticket_messages_ticket_sent
  ON support_ticket_messages (support_ticket_id, sent_at);

-- Room amenities: the table has room_id and amenity_id; listing_id is reached through rooms.
-- The primary key already covers room_id lookups, so this reverse index supports amenity-to-room searches.
CREATE INDEX idx_room_amenities_amenity_room
  ON room_amenities (amenity_id, room_id);

-- Rooms: supports listing-to-room joins used before joining to room_amenities by room_id.
CREATE INDEX idx_rooms_listing_room
  ON rooms (listing_id, room_id);

-- Booking room guests: the primary key already covers (booking_id, room_id, guest_user_id).
-- This reverse index supports finding all room assignments for a guest across bookings.
CREATE INDEX idx_booking_room_guests_guest_booking
  ON booking_room_guests (guest_user_id, booking_id);

-- Booking room guests: supports room occupancy reports across bookings.
CREATE INDEX idx_booking_room_guests_room_booking
  ON booking_room_guests (room_id, booking_id);

-- Social review visibility: the primary key already covers review_id plus the social-connection columns.
-- Requested tutor names viewer_user_id and connection_id map to requester_user_id/addressee_user_id in this schema.

-- Social review visibility: supports finding reviews visible through a requester/addressee social connection.
CREATE INDEX idx_srv_connection_review
  ON social_review_visibility (requester_user_id, addressee_user_id, review_id);

-- Social review visibility: supports addressee-centered visibility checks.
CREATE INDEX idx_srv_addressee_requester
  ON social_review_visibility (addressee_user_id, requester_user_id);

