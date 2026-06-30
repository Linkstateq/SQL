-- 02_create_tables.sql
-- Purpose: Create the complete MySQL 8.0 schema for the Phase 2 Airbnb-style
-- accommodation booking database. All tables use InnoDB for FK enforcement.
-- The schema includes explicit primary keys, foreign keys, UNIQUE constraints,
-- CHECK constraints, ENUM status fields, and documented ON DELETE/ON UPDATE rules.

USE airbnb_booking_phase2;

-- Entity purpose: Stores platform login accounts for guests, hosts, admins, and support agents.
-- Key attributes: email, password hash, role, account status, and timestamps.
-- Relationship logic: Profile tables, social accounts, messages, and support records link back to users.
-- Important constraints: email is unique; role and status are explicit ENUM fields.
CREATE TABLE users (
  user_id INT NOT NULL AUTO_INCREMENT,
  email VARCHAR(255) NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  `role` ENUM('guest','host','admin','support_agent') NOT NULL,
  `status` ENUM('active','inactive','suspended','deleted') NOT NULL DEFAULT 'active',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT pk_users PRIMARY KEY (user_id),
  CONSTRAINT uq_users_email UNIQUE (email),
  CONSTRAINT chk_users_email_format CHECK (email LIKE '%_@_%._%')
) ENGINE = InnoDB;

-- Entity purpose: Stores common personal data shared by all platform user roles.
-- Key attributes: first name, last name, phone number, birth date, and profile photo URL.
-- Relationship logic: One user has at most one common profile; deleting a user cascades to this profile.
-- Important constraints: user_id is both PK and FK, enforcing a one-to-one relationship.
CREATE TABLE user_profiles (
  user_id INT NOT NULL,
  first_name VARCHAR(80) NOT NULL,
  last_name VARCHAR(80) NOT NULL,
  phone_number VARCHAR(30) NULL,
  date_of_birth DATE NULL,
  profile_photo_url VARCHAR(500) NULL,
  bio VARCHAR(1000) NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT pk_user_profiles PRIMARY KEY (user_id),
  CONSTRAINT fk_user_profiles_users FOREIGN KEY (user_id)
    REFERENCES users (user_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT chk_user_profiles_phone_length CHECK (phone_number IS NULL OR CHAR_LENGTH(phone_number) BETWEEN 7 AND 30)
) ENGINE = InnoDB;

-- Entity purpose: Stores host-specific profile information used for listing ownership and host quality.
-- Key attributes: display name, response rate, response time, superhost flag, and host since date.
-- Relationship logic: One host profile belongs to one user; listings reference this table and restrict deletion.
-- Important constraints: response_rate must stay between 0 and 100.
CREATE TABLE host_profiles (
  user_id INT NOT NULL,
  host_display_name VARCHAR(120) NOT NULL,
  host_since DATE NOT NULL,
  response_rate DECIMAL(5,2) NOT NULL DEFAULT 0.00,
  response_time_minutes INT NULL,
  is_superhost BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT pk_host_profiles PRIMARY KEY (user_id),
  CONSTRAINT fk_host_profiles_users FOREIGN KEY (user_id)
    REFERENCES users (user_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT chk_host_profiles_response_rate CHECK (response_rate BETWEEN 0 AND 100),
  CONSTRAINT chk_host_profiles_response_time CHECK (response_time_minutes IS NULL OR response_time_minutes >= 0)
) ENGINE = InnoDB;

-- Entity purpose: Stores guest-specific profile data used for booking and guest preferences.
-- Key attributes: government name confirmation, preferred language, and marketing preference.
-- Relationship logic: One guest profile belongs to one user; bookings reference this table and restrict deletion.
-- Important constraints: user_id is a PK/FK so a guest profile cannot exist without a user.
CREATE TABLE guest_profiles (
  user_id INT NOT NULL,
  preferred_language VARCHAR(20) NOT NULL DEFAULT 'en',
  emergency_contact_name VARCHAR(120) NULL,
  emergency_contact_phone VARCHAR(30) NULL,
  marketing_opt_in BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT pk_guest_profiles PRIMARY KEY (user_id),
  CONSTRAINT fk_guest_profiles_users FOREIGN KEY (user_id)
    REFERENCES users (user_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT chk_guest_profiles_emergency_phone CHECK (
    emergency_contact_phone IS NULL OR CHAR_LENGTH(emergency_contact_phone) BETWEEN 7 AND 30
  )
) ENGINE = InnoDB;

-- Entity purpose: Stores countries used by addresses and identity document issuing countries.
-- Key attributes: ISO country code and country name.
-- Relationship logic: Cities and identity documents reference countries; delete is restricted while referenced.
-- Important constraints: country code and country name are unique.
CREATE TABLE countries (
  country_id INT NOT NULL AUTO_INCREMENT,
  country_code CHAR(2) NOT NULL,
  country_name VARCHAR(100) NOT NULL,
  CONSTRAINT pk_countries PRIMARY KEY (country_id),
  CONSTRAINT uq_countries_country_code UNIQUE (country_code),
  CONSTRAINT uq_countries_country_name UNIQUE (country_name),
  CONSTRAINT chk_countries_code_length CHECK (CHAR_LENGTH(country_code) = 2)
) ENGINE = InnoDB;

-- Entity purpose: Stores cities and regional subdivisions for listing addresses.
-- Key attributes: city name, state or region, and country reference.
-- Relationship logic: Cities belong to countries; addresses reference cities.
-- Important constraints: city names are unique inside the same country and region.
CREATE TABLE cities (
  city_id INT NOT NULL AUTO_INCREMENT,
  country_id INT NOT NULL,
  city_name VARCHAR(100) NOT NULL,
  state_region VARCHAR(100) NULL,
  CONSTRAINT pk_cities PRIMARY KEY (city_id),
  CONSTRAINT uq_cities_country_region_name UNIQUE (country_id, state_region, city_name),
  CONSTRAINT fk_cities_countries FOREIGN KEY (country_id)
    REFERENCES countries (country_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE = InnoDB;

-- Entity purpose: Stores physical addresses and geolocation for listings.
-- Key attributes: address lines, postal code, latitude, and longitude.
-- Relationship logic: Listings reference addresses and restrict deletion while a listing exists.
-- Important constraints: latitude and longitude are limited to valid geographic ranges.
CREATE TABLE addresses (
  address_id INT NOT NULL AUTO_INCREMENT,
  city_id INT NOT NULL,
  address_line1 VARCHAR(255) NOT NULL,
  address_line2 VARCHAR(255) NULL,
  postal_code VARCHAR(30) NOT NULL,
  latitude DECIMAL(9,6) NOT NULL,
  longitude DECIMAL(9,6) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT pk_addresses PRIMARY KEY (address_id),
  CONSTRAINT fk_addresses_cities FOREIGN KEY (city_id)
    REFERENCES cities (city_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT chk_addresses_latitude CHECK (latitude BETWEEN -90 AND 90),
  CONSTRAINT chk_addresses_longitude CHECK (longitude BETWEEN -180 AND 180)
) ENGINE = InnoDB;

-- Entity purpose: Stores government or identity verification documents for users.
-- Key attributes: document type, issuing country, document number, and verification status.
-- Relationship logic: Documents belong to users and are removed when the user is deleted.
-- Important constraints: verification_status is an explicit ENUM and document numbers are unique per issuing country.
CREATE TABLE identity_documents (
  document_id INT NOT NULL AUTO_INCREMENT,
  user_id INT NOT NULL,
  issuing_country_id INT NOT NULL,
  document_type VARCHAR(60) NOT NULL,
  document_number VARCHAR(120) NOT NULL,
  document_url VARCHAR(500) NOT NULL,
  verification_status ENUM('pending','verified','rejected') NOT NULL DEFAULT 'pending',
  submitted_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  verified_at TIMESTAMP NULL,
  CONSTRAINT pk_identity_documents PRIMARY KEY (document_id),
  CONSTRAINT uq_identity_documents_country_number UNIQUE (issuing_country_id, document_number),
  CONSTRAINT fk_identity_documents_users FOREIGN KEY (user_id)
    REFERENCES users (user_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT fk_identity_documents_countries FOREIGN KEY (issuing_country_id)
    REFERENCES countries (country_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE = InnoDB;

-- Entity purpose: Stores linked external social login or profile accounts.
-- Key attributes: provider name, provider account id, profile URL, and verification flag.
-- Relationship logic: Social accounts belong to users and cascade when a user is deleted.
-- Important constraints: a provider account can only be linked once across the platform.
CREATE TABLE social_accounts (
  social_account_id INT NOT NULL AUTO_INCREMENT,
  user_id INT NOT NULL,
  provider_name VARCHAR(80) NOT NULL,
  provider_account_id VARCHAR(180) NOT NULL,
  profile_url VARCHAR(500) NULL,
  is_verified BOOLEAN NOT NULL DEFAULT FALSE,
  linked_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT pk_social_accounts PRIMARY KEY (social_account_id),
  CONSTRAINT uq_social_accounts_provider_account UNIQUE (provider_name, provider_account_id),
  CONSTRAINT uq_social_accounts_user_provider UNIQUE (user_id, provider_name),
  CONSTRAINT fk_social_accounts_users FOREIGN KEY (user_id)
    REFERENCES users (user_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
) ENGINE = InnoDB;

-- Entity purpose: Stores reference categories for accommodation types.
-- Key attributes: type name and description.
-- Relationship logic: Listings reference property types; deletion is restricted while listings use the type.
-- Important constraints: type_name is unique.
CREATE TABLE property_types (
  property_type_id INT NOT NULL AUTO_INCREMENT,
  type_name VARCHAR(100) NOT NULL,
  description VARCHAR(500) NULL,
  CONSTRAINT pk_property_types PRIMARY KEY (property_type_id),
  CONSTRAINT uq_property_types_type_name UNIQUE (type_name)
) ENGINE = InnoDB;

-- Entity purpose: Stores cancellation policy templates available to listings.
-- Key attributes: policy name, refund percentage, refund cutoff hours, and description.
-- Relationship logic: Listing-policy assignments reference this table and restrict deletion while used.
-- Important constraints: refund_percentage must be between 0 and 100.
CREATE TABLE cancellation_policies (
  cancellation_policy_id INT NOT NULL AUTO_INCREMENT,
  policy_name VARCHAR(100) NOT NULL,
  description VARCHAR(1000) NOT NULL,
  refund_percentage DECIMAL(5,2) NOT NULL,
  refund_cutoff_hours INT NOT NULL DEFAULT 0,
  CONSTRAINT pk_cancellation_policies PRIMARY KEY (cancellation_policy_id),
  CONSTRAINT uq_cancellation_policies_policy_name UNIQUE (policy_name),
  CONSTRAINT chk_cancellation_policies_refund_pct CHECK (refund_percentage BETWEEN 0 AND 100),
  CONSTRAINT chk_cancellation_policies_cutoff CHECK (refund_cutoff_hours >= 0)
) ENGINE = InnoDB;

-- Entity purpose: Stores accommodation listings offered by hosts.
-- Key attributes: host, property type, address, title, base price, capacity, and publication status.
-- Relationship logic: Host, address, and property type deletes are restricted while listings exist.
-- Important constraints: base_price must be positive, capacity must be positive, and status is an ENUM.
CREATE TABLE listings (
  listing_id INT NOT NULL AUTO_INCREMENT,
  host_user_id INT NOT NULL,
  property_type_id INT NOT NULL,
  address_id INT NOT NULL,
  title VARCHAR(180) NOT NULL,
  description TEXT NOT NULL,
  base_price DECIMAL(10,2) NOT NULL,
  max_guests INT NOT NULL,
  bedrooms INT NOT NULL DEFAULT 0,
  bathrooms DECIMAL(4,2) NOT NULL DEFAULT 1.00,
  status ENUM('draft','published','paused','removed') NOT NULL DEFAULT 'draft',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT pk_listings PRIMARY KEY (listing_id),
  CONSTRAINT fk_listings_host_profiles FOREIGN KEY (host_user_id)
    REFERENCES host_profiles (user_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT fk_listings_property_types FOREIGN KEY (property_type_id)
    REFERENCES property_types (property_type_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT fk_listings_addresses FOREIGN KEY (address_id)
    REFERENCES addresses (address_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT chk_listings_base_price CHECK (base_price > 0),
  CONSTRAINT chk_listings_max_guests CHECK (max_guests > 0),
  CONSTRAINT chk_listings_bedrooms CHECK (bedrooms >= 0),
  CONSTRAINT chk_listings_bathrooms CHECK (bathrooms > 0)
) ENGINE = InnoDB;

-- Entity purpose: Stores photo URLs for listing galleries.
-- Key attributes: listing id, photo URL, caption, display order, and cover image flag.
-- Relationship logic: Photos are dependent on listings and cascade when a listing is deleted.
-- Important constraints: display order is unique per listing and cannot be negative.
CREATE TABLE listing_photos (
  photo_id INT NOT NULL AUTO_INCREMENT,
  listing_id INT NOT NULL,
  photo_url VARCHAR(500) NOT NULL,
  caption VARCHAR(255) NULL,
  display_order INT NOT NULL DEFAULT 0,
  is_cover_photo BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT pk_listing_photos PRIMARY KEY (photo_id),
  CONSTRAINT uq_listing_photos_order UNIQUE (listing_id, display_order),
  CONSTRAINT fk_listing_photos_listings FOREIGN KEY (listing_id)
    REFERENCES listings (listing_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT chk_listing_photos_display_order CHECK (display_order >= 0)
) ENGINE = InnoDB;

-- Entity purpose: Stores individual rooms or sleeping areas inside a listing.
-- Key attributes: room name, room type, capacity, bed count, and optional price adjustment.
-- Relationship logic: Rooms are dependent on listings and cascade when a listing is deleted.
-- Important constraints: room capacity must be positive and bed_count cannot be negative.
CREATE TABLE rooms (
  room_id INT NOT NULL AUTO_INCREMENT,
  listing_id INT NOT NULL,
  room_name VARCHAR(120) NOT NULL,
  room_type VARCHAR(80) NOT NULL,
  capacity INT NOT NULL,
  bed_count INT NOT NULL DEFAULT 0,
  price_adjustment DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  CONSTRAINT pk_rooms PRIMARY KEY (room_id),
  CONSTRAINT uq_rooms_listing_room_name UNIQUE (listing_id, room_name),
  CONSTRAINT uq_rooms_room_listing UNIQUE (room_id, listing_id),
  CONSTRAINT fk_rooms_listings FOREIGN KEY (listing_id)
    REFERENCES listings (listing_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT chk_rooms_capacity CHECK (capacity > 0),
  CONSTRAINT chk_rooms_bed_count CHECK (bed_count >= 0)
) ENGINE = InnoDB;

-- Entity purpose: Stores amenity reference data shared by listings and rooms.
-- Key attributes: amenity name, category, and description.
-- Relationship logic: Junction tables reference amenities and restrict deletion while used.
-- Important constraints: amenity_name is unique.
CREATE TABLE amenities (
  amenity_id INT NOT NULL AUTO_INCREMENT,
  amenity_name VARCHAR(100) NOT NULL,
  amenity_category VARCHAR(100) NULL,
  description VARCHAR(500) NULL,
  CONSTRAINT pk_amenities PRIMARY KEY (amenity_id),
  CONSTRAINT uq_amenities_amenity_name UNIQUE (amenity_name)
) ENGINE = InnoDB;

-- Entity purpose: Links listings to amenities in a many-to-many relationship.
-- Key attributes: listing id and amenity id.
-- Relationship logic: Listing deletion cascades to this junction table; amenity deletion is restricted while used.
-- Important constraints: composite PK prevents duplicate amenity assignments for a listing.
CREATE TABLE listing_amenities (
  listing_id INT NOT NULL,
  amenity_id INT NOT NULL,
  CONSTRAINT pk_listing_amenities PRIMARY KEY (listing_id, amenity_id),
  CONSTRAINT fk_listing_amenities_listings FOREIGN KEY (listing_id)
    REFERENCES listings (listing_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT fk_listing_amenities_amenities FOREIGN KEY (amenity_id)
    REFERENCES amenities (amenity_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE = InnoDB;

-- Entity purpose: Links rooms to amenities in a many-to-many relationship.
-- Key attributes: room id and amenity id.
-- Relationship logic: Room deletion cascades to this junction table; amenity deletion is restricted while used.
-- Important constraints: composite PK prevents duplicate amenity assignments for a room.
CREATE TABLE room_amenities (
  room_id INT NOT NULL,
  amenity_id INT NOT NULL,
  CONSTRAINT pk_room_amenities PRIMARY KEY (room_id, amenity_id),
  CONSTRAINT fk_room_amenities_rooms FOREIGN KEY (room_id)
    REFERENCES rooms (room_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT fk_room_amenities_amenities FOREIGN KEY (amenity_id)
    REFERENCES amenities (amenity_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE = InnoDB;

-- Entity purpose: Stores rules that guests must follow for a listing.
-- Key attributes: rule title, description, and mandatory flag.
-- Relationship logic: House rules are dependent on listings and cascade when a listing is deleted.
-- Important constraints: rule titles are unique per listing.
CREATE TABLE house_rules (
  house_rule_id INT NOT NULL AUTO_INCREMENT,
  listing_id INT NOT NULL,
  rule_title VARCHAR(120) NOT NULL,
  rule_description VARCHAR(1000) NOT NULL,
  is_mandatory BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT pk_house_rules PRIMARY KEY (house_rule_id),
  CONSTRAINT uq_house_rules_listing_title UNIQUE (listing_id, rule_title),
  CONSTRAINT fk_house_rules_listings FOREIGN KEY (listing_id)
    REFERENCES listings (listing_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
) ENGINE = InnoDB;

-- Entity purpose: Stores nightly availability and custom price overrides for listings.
-- Key attributes: listing id, calendar date, availability flag, custom price, and stay limits.
-- Relationship logic: Calendar rows are dependent on listings and cascade when a listing is deleted.
-- Important constraints: custom_price must be non-negative when supplied.
CREATE TABLE availability_calendar (
  listing_id INT NOT NULL,
  calendar_date DATE NOT NULL,
  is_available BOOLEAN NOT NULL DEFAULT TRUE,
  custom_price DECIMAL(10,2) NULL,
  min_nights INT NOT NULL DEFAULT 1,
  max_nights INT NULL,
  notes VARCHAR(255) NULL,
  CONSTRAINT pk_availability_calendar PRIMARY KEY (listing_id, calendar_date),
  CONSTRAINT fk_availability_calendar_listings FOREIGN KEY (listing_id)
    REFERENCES listings (listing_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT chk_availability_custom_price CHECK (custom_price IS NULL OR custom_price >= 0),
  CONSTRAINT chk_availability_min_nights CHECK (min_nights > 0),
  CONSTRAINT chk_availability_max_nights CHECK (max_nights IS NULL OR max_nights >= min_nights)
) ENGINE = InnoDB;

-- Entity purpose: Stores confirmed or attempted reservations made by guests for listings.
-- Key attributes: listing, guest, stay dates, guest count, booking status, and financial totals.
-- Relationship logic: Listing and guest deletion are restricted while bookings exist.
-- Important constraints: checkout must be after checkin, guest count positive, and money amounts non-negative.
CREATE TABLE bookings (
  booking_id INT NOT NULL AUTO_INCREMENT,
  listing_id INT NOT NULL,
  guest_user_id INT NOT NULL,
  check_in_date DATE NOT NULL,
  check_out_date DATE NOT NULL,
  number_of_guests INT NOT NULL,
  booking_status ENUM('pending','confirmed','cancelled','completed','refunded') NOT NULL DEFAULT 'pending',
  subtotal_amount DECIMAL(10,2) NOT NULL,
  guest_service_fee DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  host_service_fee DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  total_amount DECIMAL(10,2) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT pk_bookings PRIMARY KEY (booking_id),
  CONSTRAINT uq_bookings_booking_listing UNIQUE (booking_id, listing_id),
  CONSTRAINT fk_bookings_listings FOREIGN KEY (listing_id)
    REFERENCES listings (listing_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT fk_bookings_guest_profiles FOREIGN KEY (guest_user_id)
    REFERENCES guest_profiles (user_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT chk_bookings_date_range CHECK (check_out_date > check_in_date),
  CONSTRAINT chk_bookings_number_of_guests CHECK (number_of_guests > 0),
  CONSTRAINT chk_bookings_subtotal_amount CHECK (subtotal_amount >= 0),
  CONSTRAINT chk_bookings_guest_service_fee CHECK (guest_service_fee >= 0),
  CONSTRAINT chk_bookings_host_service_fee CHECK (host_service_fee >= 0),
  CONSTRAINT chk_bookings_total_amount CHECK (total_amount >= 0)
) ENGINE = InnoDB;

-- Entity purpose: Assigns guests to rooms inside a booking; this is a ternary relationship.
-- Key attributes: booking id, room id, guest user id, and the shared listing id used for consistency checks.
-- Relationship logic: Booking deletion cascades assignments; room and guest deletion are restricted while assigned.
-- Important constraints: composite PK prevents duplicate booking-room-guest assignments.
CREATE TABLE booking_room_guests (
  booking_id INT NOT NULL,
  listing_id INT NOT NULL,
  room_id INT NOT NULL,
  guest_user_id INT NOT NULL,
  assigned_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT pk_booking_room_guests PRIMARY KEY (booking_id, room_id, guest_user_id),
  CONSTRAINT fk_brg_bookings FOREIGN KEY (booking_id, listing_id)
    REFERENCES bookings (booking_id, listing_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT fk_brg_rooms FOREIGN KEY (room_id, listing_id)
    REFERENCES rooms (room_id, listing_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT fk_brg_guest_profiles FOREIGN KEY (guest_user_id)
    REFERENCES guest_profiles (user_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE = InnoDB;

-- Entity purpose: Stores saved payment instruments for guest users.
-- Key attributes: payment type, provider token, masked details, expiry, and default flag.
-- Relationship logic: Payment methods belong to guest profiles; payments restrict deletion once used.
-- Important constraints: provider tokens are unique and expiry month must be valid when supplied.
CREATE TABLE payment_methods (
  payment_method_id INT NOT NULL AUTO_INCREMENT,
  user_id INT NOT NULL,
  method_type VARCHAR(60) NOT NULL,
  provider_name VARCHAR(80) NOT NULL,
  provider_payment_token VARCHAR(180) NOT NULL,
  masked_account_number VARCHAR(40) NOT NULL,
  expiry_month TINYINT UNSIGNED NULL,
  expiry_year SMALLINT UNSIGNED NULL,
  is_default BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT pk_payment_methods PRIMARY KEY (payment_method_id),
  CONSTRAINT uq_payment_methods_provider_token UNIQUE (provider_name, provider_payment_token),
  CONSTRAINT fk_payment_methods_guest_profiles FOREIGN KEY (user_id)
    REFERENCES guest_profiles (user_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT chk_payment_methods_expiry_month CHECK (expiry_month IS NULL OR expiry_month BETWEEN 1 AND 12),
  CONSTRAINT chk_payment_methods_expiry_year CHECK (expiry_year IS NULL OR expiry_year >= 2000)
) ENGINE = InnoDB;

-- Entity purpose: Stores payment transactions for bookings.
-- Key attributes: booking, payer, payment method, amount, status, and transaction reference.
-- Relationship logic: Booking deletion is restricted while payments exist; payer and method deletion are restricted once used.
-- Important constraints: payment_status is an ENUM and amount must be greater than zero.
CREATE TABLE payments (
  payment_id INT NOT NULL AUTO_INCREMENT,
  booking_id INT NOT NULL,
  payer_user_id INT NOT NULL,
  payment_method_id INT NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  currency_code CHAR(3) NOT NULL DEFAULT 'USD',
  payment_status ENUM('pending','paid','failed','refunded') NOT NULL DEFAULT 'pending',
  transaction_reference VARCHAR(120) NOT NULL,
  paid_at TIMESTAMP NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT pk_payments PRIMARY KEY (payment_id),
  CONSTRAINT uq_payments_transaction_reference UNIQUE (transaction_reference),
  CONSTRAINT fk_payments_bookings FOREIGN KEY (booking_id)
    REFERENCES bookings (booking_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT fk_payments_guest_profiles FOREIGN KEY (payer_user_id)
    REFERENCES guest_profiles (user_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT fk_payments_payment_methods FOREIGN KEY (payment_method_id)
    REFERENCES payment_methods (payment_method_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT chk_payments_amount CHECK (amount > 0),
  CONSTRAINT chk_payments_currency_code CHECK (CHAR_LENGTH(currency_code) = 3)
) ENGINE = InnoDB;

-- Entity purpose: Stores payout records owed to hosts after completed stays.
-- Key attributes: booking, host, payout amount, payout status, and release date.
-- Relationship logic: Booking and host deletion are restricted while payout records exist.
-- Important constraints: payout_status is an ENUM and amount cannot be negative.
CREATE TABLE host_payouts (
  payout_id INT NOT NULL AUTO_INCREMENT,
  booking_id INT NOT NULL,
  host_user_id INT NOT NULL,
  payout_amount DECIMAL(10,2) NOT NULL,
  payout_status ENUM('pending','released','failed') NOT NULL DEFAULT 'pending',
  payout_reference VARCHAR(120) NULL,
  released_at TIMESTAMP NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT pk_host_payouts PRIMARY KEY (payout_id),
  CONSTRAINT uq_host_payouts_booking UNIQUE (booking_id),
  CONSTRAINT uq_host_payouts_reference UNIQUE (payout_reference),
  CONSTRAINT fk_host_payouts_bookings FOREIGN KEY (booking_id)
    REFERENCES bookings (booking_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT fk_host_payouts_host_profiles FOREIGN KEY (host_user_id)
    REFERENCES host_profiles (user_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT chk_host_payouts_amount CHECK (payout_amount >= 0)
) ENGINE = InnoDB;

-- Entity purpose: Stores refund requests and processed refund transactions for bookings.
-- Key attributes: booking, source payment, refund amount, status, reason, and processed time.
-- Relationship logic: Booking and payment deletion are restricted while refunds exist.
-- Important constraints: refund_status is an ENUM and refund amount cannot be negative.
CREATE TABLE refunds (
  refund_id INT NOT NULL AUTO_INCREMENT,
  booking_id INT NOT NULL,
  payment_id INT NOT NULL,
  refund_amount DECIMAL(10,2) NOT NULL,
  refund_status ENUM('requested','approved','rejected','processed') NOT NULL DEFAULT 'requested',
  refund_reason VARCHAR(500) NULL,
  requested_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  processed_at TIMESTAMP NULL,
  CONSTRAINT pk_refunds PRIMARY KEY (refund_id),
  CONSTRAINT fk_refunds_bookings FOREIGN KEY (booking_id)
    REFERENCES bookings (booking_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT fk_refunds_payments FOREIGN KEY (payment_id)
    REFERENCES payments (payment_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT chk_refunds_amount CHECK (refund_amount >= 0)
) ENGINE = InnoDB;

-- Entity purpose: Assigns cancellation policies to listings over time.
-- Key attributes: listing, cancellation policy, effective start date, and optional end date.
-- Relationship logic: Listing deletion cascades assignments; policy deletion is restricted while assigned.
-- Important constraints: composite PK supports historical policy changes and date ranges must be valid.
CREATE TABLE listing_cancellation_policies (
  listing_id INT NOT NULL,
  cancellation_policy_id INT NOT NULL,
  effective_from DATE NOT NULL,
  effective_to DATE NULL,
  CONSTRAINT pk_listing_cancellation_policies PRIMARY KEY (listing_id, cancellation_policy_id, effective_from),
  CONSTRAINT fk_lcp_listings FOREIGN KEY (listing_id)
    REFERENCES listings (listing_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT fk_lcp_cancellation_policies FOREIGN KEY (cancellation_policy_id)
    REFERENCES cancellation_policies (cancellation_policy_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT chk_lcp_effective_dates CHECK (effective_to IS NULL OR effective_to >= effective_from)
) ENGINE = InnoDB;

-- Entity purpose: Stores guest reviews for completed booking experiences.
-- Key attributes: booking, reviewer, listing, host, rating, review text, and review date.
-- Relationship logic: Booking, reviewer, listing, and host deletion are restricted while reviews exist.
-- Important constraints: rating must be between 1 and 5; reviewer and host self-review prevention is enforced by triggers.
CREATE TABLE reviews (
  review_id INT NOT NULL AUTO_INCREMENT,
  booking_id INT NOT NULL,
  reviewer_guest_user_id INT NOT NULL,
  listing_id INT NOT NULL,
  host_user_id INT NOT NULL,
  rating INT NOT NULL,
  review_title VARCHAR(180) NULL,
  review_text VARCHAR(2000) NOT NULL,
  review_date DATE NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT pk_reviews PRIMARY KEY (review_id),
  CONSTRAINT uq_reviews_booking_reviewer UNIQUE (booking_id, reviewer_guest_user_id),
  CONSTRAINT fk_reviews_bookings FOREIGN KEY (booking_id)
    REFERENCES bookings (booking_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT fk_reviews_guest_profiles FOREIGN KEY (reviewer_guest_user_id)
    REFERENCES guest_profiles (user_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT fk_reviews_listings FOREIGN KEY (listing_id)
    REFERENCES listings (listing_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT fk_reviews_host_profiles FOREIGN KEY (host_user_id)
    REFERENCES host_profiles (user_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT chk_reviews_rating CHECK (rating BETWEEN 1 AND 5)
) ENGINE = InnoDB;

-- Entity purpose: Stores review scoring dimensions such as cleanliness or communication.
-- Key attributes: category name and description.
-- Relationship logic: Review score rows reference categories and restrict deletion while used.
-- Important constraints: category_name is unique.
CREATE TABLE review_categories (
  review_category_id INT NOT NULL AUTO_INCREMENT,
  category_name VARCHAR(100) NOT NULL,
  description VARCHAR(500) NULL,
  CONSTRAINT pk_review_categories PRIMARY KEY (review_category_id),
  CONSTRAINT uq_review_categories_category_name UNIQUE (category_name)
) ENGINE = InnoDB;

-- Entity purpose: Stores per-category scores for a review.
-- Key attributes: review id, category id, and numeric score.
-- Relationship logic: Scores cascade when reviews are deleted; category deletion is restricted while scores exist.
-- Important constraints: composite PK prevents duplicate category scores per review and score must be 1 to 5.
CREATE TABLE review_scores (
  review_id INT NOT NULL,
  review_category_id INT NOT NULL,
  score INT NOT NULL,
  CONSTRAINT pk_review_scores PRIMARY KEY (review_id, review_category_id),
  CONSTRAINT fk_review_scores_reviews FOREIGN KEY (review_id)
    REFERENCES reviews (review_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT fk_review_scores_review_categories FOREIGN KEY (review_category_id)
    REFERENCES review_categories (review_category_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT chk_review_scores_score CHECK (score BETWEEN 1 AND 5)
) ENGINE = InnoDB;

-- Entity purpose: Stores direct messages between platform users, optionally related to a booking.
-- Key attributes: sender, recipient, optional booking id, message body, and message status.
-- Relationship logic: User deletion is restricted for auditability; optional booking_id is set to NULL if booking is removed.
-- Important constraints: message_status is an explicit ENUM; self-messaging prevention is enforced by triggers.
CREATE TABLE messages (
  message_id INT NOT NULL AUTO_INCREMENT,
  sender_user_id INT NOT NULL,
  recipient_user_id INT NOT NULL,
  booking_id INT NULL,
  message_body TEXT NOT NULL,
  message_status ENUM('sent','read','archived') NOT NULL DEFAULT 'sent',
  sent_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  read_at TIMESTAMP NULL,
  CONSTRAINT pk_messages PRIMARY KEY (message_id),
  CONSTRAINT fk_messages_sender_users FOREIGN KEY (sender_user_id)
    REFERENCES users (user_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT fk_messages_recipient_users FOREIGN KEY (recipient_user_id)
    REFERENCES users (user_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT fk_messages_bookings FOREIGN KEY (booking_id)
    REFERENCES bookings (booking_id)
    ON UPDATE CASCADE
    ON DELETE SET NULL
) ENGINE = InnoDB;

-- Entity purpose: Stores customer support cases raised by users, optionally for a booking.
-- Key attributes: opener, assigned support agent, optional booking, status, priority, subject, and description.
-- Relationship logic: Booking deletion is restricted while tickets exist; assigned agent can be unset if removed.
-- Important constraints: ticket_status and priority are explicit ENUM fields.
CREATE TABLE support_tickets (
  support_ticket_id INT NOT NULL AUTO_INCREMENT,
  opened_by_user_id INT NOT NULL,
  assigned_agent_user_id INT NULL,
  booking_id INT NULL,
  ticket_status ENUM('open','in_progress','resolved','closed') NOT NULL DEFAULT 'open',
  priority ENUM('low','medium','high','urgent') NOT NULL DEFAULT 'medium',
  subject VARCHAR(180) NOT NULL,
  description TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  resolved_at TIMESTAMP NULL,
  CONSTRAINT pk_support_tickets PRIMARY KEY (support_ticket_id),
  CONSTRAINT fk_support_tickets_opened_by_users FOREIGN KEY (opened_by_user_id)
    REFERENCES users (user_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT fk_support_tickets_assigned_users FOREIGN KEY (assigned_agent_user_id)
    REFERENCES users (user_id)
    ON UPDATE CASCADE
    ON DELETE SET NULL,
  CONSTRAINT fk_support_tickets_bookings FOREIGN KEY (booking_id)
    REFERENCES bookings (booking_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE = InnoDB;

-- Entity purpose: Stores conversation entries inside support tickets.
-- Key attributes: support ticket id, sender, message body, and sent timestamp.
-- Relationship logic: Messages cascade when the support ticket is deleted; sender deletion is restricted.
-- Important constraints: message body is required.
CREATE TABLE support_ticket_messages (
  support_ticket_message_id INT NOT NULL AUTO_INCREMENT,
  support_ticket_id INT NOT NULL,
  sender_user_id INT NOT NULL,
  message_body TEXT NOT NULL,
  sent_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT pk_support_ticket_messages PRIMARY KEY (support_ticket_message_id),
  CONSTRAINT fk_stm_support_tickets FOREIGN KEY (support_ticket_id)
    REFERENCES support_tickets (support_ticket_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT fk_stm_sender_users FOREIGN KEY (sender_user_id)
    REFERENCES users (user_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE = InnoDB;

-- Entity purpose: Stores platform commission calculations for bookings.
-- Key attributes: booking, guest commission rate, host commission rate, and calculated commission amounts.
-- Relationship logic: Booking deletion is restricted while commission audit rows exist.
-- Important constraints: commission rates must be between 0 and 100 and amounts cannot be negative.
CREATE TABLE platform_commissions (
  commission_id INT NOT NULL AUTO_INCREMENT,
  booking_id INT NOT NULL,
  guest_commission_rate DECIMAL(5,2) NOT NULL,
  host_commission_rate DECIMAL(5,2) NOT NULL,
  guest_commission_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  host_commission_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  calculated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT pk_platform_commissions PRIMARY KEY (commission_id),
  CONSTRAINT uq_platform_commissions_booking UNIQUE (booking_id),
  CONSTRAINT fk_platform_commissions_bookings FOREIGN KEY (booking_id)
    REFERENCES bookings (booking_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT chk_platform_commissions_guest_rate CHECK (guest_commission_rate BETWEEN 0 AND 100),
  CONSTRAINT chk_platform_commissions_host_rate CHECK (host_commission_rate BETWEEN 0 AND 100),
  CONSTRAINT chk_platform_commissions_guest_amount CHECK (guest_commission_amount >= 0),
  CONSTRAINT chk_platform_commissions_host_amount CHECK (host_commission_amount >= 0)
) ENGINE = InnoDB;

-- Entity purpose: Stores projected income estimates for listings by period.
-- Key attributes: listing, estimate period, projected occupancy, projected nights, and projected income.
-- Relationship logic: Estimates are derived from listings and cascade when the listing is deleted.
-- Important constraints: period dates must be valid and projected money/count values cannot be negative.
CREATE TABLE income_estimates (
  income_estimate_id INT NOT NULL AUTO_INCREMENT,
  listing_id INT NOT NULL,
  estimate_period_start DATE NOT NULL,
  estimate_period_end DATE NOT NULL,
  projected_occupancy_rate DECIMAL(5,2) NOT NULL,
  projected_booked_nights INT NOT NULL,
  projected_income DECIMAL(10,2) NOT NULL,
  model_version VARCHAR(80) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT pk_income_estimates PRIMARY KEY (income_estimate_id),
  CONSTRAINT uq_income_estimates_listing_period UNIQUE (listing_id, estimate_period_start, estimate_period_end),
  CONSTRAINT fk_income_estimates_listings FOREIGN KEY (listing_id)
    REFERENCES listings (listing_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT chk_income_estimates_period CHECK (estimate_period_end >= estimate_period_start),
  CONSTRAINT chk_income_estimates_occupancy CHECK (projected_occupancy_rate BETWEEN 0 AND 100),
  CONSTRAINT chk_income_estimates_nights CHECK (projected_booked_nights >= 0),
  CONSTRAINT chk_income_estimates_income CHECK (projected_income >= 0)
) ENGINE = InnoDB;

-- Entity purpose: Stores social connections between platform users.
-- Key attributes: requester user, addressee user, connection status, and timestamps.
-- Relationship logic: Connections cascade when either related user is deleted.
-- Important constraints: composite PK prevents duplicate directed connections; self-connection prevention is enforced by triggers.
CREATE TABLE social_connections (
  requester_user_id INT NOT NULL,
  addressee_user_id INT NOT NULL,
  connection_status ENUM('pending','accepted','blocked') NOT NULL DEFAULT 'pending',
  requested_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  responded_at TIMESTAMP NULL,
  CONSTRAINT pk_social_connections PRIMARY KEY (requester_user_id, addressee_user_id),
  CONSTRAINT fk_social_connections_requester_users FOREIGN KEY (requester_user_id)
    REFERENCES users (user_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT fk_social_connections_addressee_users FOREIGN KEY (addressee_user_id)
    REFERENCES users (user_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
) ENGINE = InnoDB;

-- Entity purpose: Controls review visibility through a user's social connection.
-- Key attributes: review id, requester user, addressee user, and two visibility flags.
-- Relationship logic: Visibility rows cascade when the review or social connection is deleted.
-- Important constraints: composite PK ties each review to one specific social connection only once.
CREATE TABLE social_review_visibility (
  review_id INT NOT NULL,
  requester_user_id INT NOT NULL,
  addressee_user_id INT NOT NULL,
  visible_to_requester BOOLEAN NOT NULL DEFAULT TRUE,
  visible_to_addressee BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT pk_social_review_visibility PRIMARY KEY (review_id, requester_user_id, addressee_user_id),
  CONSTRAINT fk_srv_reviews FOREIGN KEY (review_id)
    REFERENCES reviews (review_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT fk_srv_social_connections FOREIGN KEY (requester_user_id, addressee_user_id)
    REFERENCES social_connections (requester_user_id, addressee_user_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
) ENGINE = InnoDB;

-- Trigger-based cross-column validation
-- MySQL 8.0 can reject CHECK constraints that compare columns participating in
-- foreign-key referential actions. These triggers keep the same business rules
-- without weakening foreign keys or removing required value CHECK constraints.

DELIMITER $$

CREATE TRIGGER trg_social_connections_prevent_self_insert
BEFORE INSERT ON social_connections
FOR EACH ROW
BEGIN
  IF NEW.requester_user_id = NEW.addressee_user_id THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'A user cannot create a social connection with themself.';
  END IF;
END$$

CREATE TRIGGER trg_social_connections_prevent_self_update
BEFORE UPDATE ON social_connections
FOR EACH ROW
BEGIN
  IF NEW.requester_user_id = NEW.addressee_user_id THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'A user cannot create a social connection with themself.';
  END IF;
END$$

CREATE TRIGGER trg_messages_prevent_self_insert
BEFORE INSERT ON messages
FOR EACH ROW
BEGIN
  IF NEW.sender_user_id = NEW.recipient_user_id THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'A message sender and recipient cannot be the same user.';
  END IF;
END$$

CREATE TRIGGER trg_messages_prevent_self_update
BEFORE UPDATE ON messages
FOR EACH ROW
BEGIN
  IF NEW.sender_user_id = NEW.recipient_user_id THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'A message sender and recipient cannot be the same user.';
  END IF;
END$$

CREATE TRIGGER trg_reviews_prevent_self_insert
BEFORE INSERT ON reviews
FOR EACH ROW
BEGIN
  IF NEW.reviewer_guest_user_id = NEW.host_user_id THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'A reviewer cannot review themself as the host.';
  END IF;
END$$

CREATE TRIGGER trg_reviews_prevent_self_update
BEFORE UPDATE ON reviews
FOR EACH ROW
BEGIN
  IF NEW.reviewer_guest_user_id = NEW.host_user_id THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'A reviewer cannot review themself as the host.';
  END IF;
END$$

DELIMITER ;
