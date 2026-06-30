# Database Documentation

## 1. Business Purpose

The database models an Airbnb-style accommodation booking system. Guests book listings owned by hosts, payments are recorded for bookings, hosts receive payouts, guests can leave reviews, listings can have amenities, and guests can request additional paid services during a stay.

The design supports Phase 2 portfolio requirements for SQL implementation, constraint enforcement, relationship behavior, and analytical query examples.

## 2. Main Entities

| Table | Purpose | Primary Key |
| --- | --- | --- |
| `users` | Stores platform login accounts for guests, hosts, admins, and support agents. | `user_id` |
| `user_profiles` | Stores common personal data shared by all platform user roles. | `user_id` |
| `host_profiles` | Stores host-specific profile information used for listing ownership and host quality. | `user_id` |
| `guest_profiles` | Stores guest-specific profile data used for booking and guest preferences. | `user_id` |
| `countries` | Stores countries used by addresses and identity document issuing countries. | `country_id` |
| `cities` | Stores cities and regional subdivisions for listing addresses. | `city_id` |
| `addresses` | Stores physical addresses and geolocation for listings. | `address_id` |
| `identity_documents` | Stores government or identity verification documents for users. | `document_id` |
| `social_accounts` | Stores linked external social login or profile accounts. | `social_account_id` |
| `property_types` | Stores reference categories for accommodation types. | `property_type_id` |
| `cancellation_policies` | Stores cancellation policy templates available to listings. | `cancellation_policy_id` |
| `listings` | Stores accommodation listings offered by hosts. | `listing_id` |
| `listing_photos` | Stores photo URLs for listing galleries. | `photo_id` |
| `rooms` | Stores individual rooms or sleeping areas inside a listing. | `room_id` |
| `amenities` | Stores amenity reference data shared by listings and rooms. | `amenity_id` |
| `listing_amenities` | Links listings to amenities in a many-to-many relationship. | `listing_id, amenity_id` |
| `room_amenities` | Links rooms to amenities in a many-to-many relationship. | `room_id, amenity_id` |
| `house_rules` | Stores rules that guests must follow for a listing. | `house_rule_id` |
| `availability_calendar` | Stores nightly availability and custom price overrides for listings. | `listing_id, calendar_date` |
| `bookings` | Stores confirmed or attempted reservations made by guests for listings. | `booking_id` |
| `booking_room_guests` | Assigns guests to rooms inside a booking; this is a ternary relationship. | `booking_id, room_id, guest_user_id` |
| `payment_methods` | Stores saved payment instruments for guest users. | `payment_method_id` |
| `payments` | Stores payment transactions for bookings. | `payment_id` |
| `host_payouts` | Stores payout records owed to hosts after completed stays. | `payout_id` |
| `refunds` | Stores refund requests and processed refund transactions for bookings. | `refund_id` |
| `listing_cancellation_policies` | Assigns cancellation policies to listings over time. | `listing_id, cancellation_policy_id, effective_from` |
| `reviews` | Stores guest reviews for completed booking experiences. | `review_id` |
| `review_categories` | Stores review scoring dimensions such as cleanliness or communication. | `review_category_id` |
| `review_scores` | Stores per-category scores for a review. | `review_id, review_category_id` |
| `messages` | Stores direct messages between platform users, optionally related to a booking. | `message_id` |
| `support_tickets` | Stores customer support cases raised by users, optionally for a booking. | `support_ticket_id` |
| `support_ticket_messages` | Stores conversation entries inside support tickets. | `support_ticket_message_id` |
| `platform_commissions` | Stores platform commission calculations for bookings. | `commission_id` |
| `income_estimates` | Stores projected income estimates for listings by period. | `income_estimate_id` |
| `social_connections` | Stores social connections between platform users. | `requester_user_id, addressee_user_id` |
| `social_review_visibility` | Controls review visibility through a user's social connection. | `review_id, requester_user_id, addressee_user_id` |

## 3. Relationship Summary

| Relationship | Foreign Key | Delete Behavior | Reason |
| --- | --- | --- | --- |
| User to user_profiles | `user_profiles.user_id -> users.user_id` | `CASCADE` | Deleting a user deletes their generic profile. |
| User to guest_profiles | `guest_profiles.user_id -> users.user_id` | `CASCADE` | Deleting a user deletes their guest profile. |
| User to host_profiles | `host_profiles.user_id -> users.user_id` | `CASCADE` | Deleting a user deletes their host profile. |
| Address to country | `addresses.country_id -> countries.country_id` | `RESTRICT` | Cannot delete a country while addresses use it. |
| Listing to address | `listings.address_id -> addresses.address_id` | `RESTRICT` | Address must remain stable while a listing exists. |
| Room to listing | `rooms.listing_id -> listings.listing_id` | `CASCADE` | Deleting a listing removes all its rooms. |
| Listing to property type | `listings.property_type_id -> property_types.property_type_id` | `RESTRICT` | Property types cannot be deleted while in use. |
| Listing to amenity | `listing_amenities.listing_id -> listings.listing_id` | `CASCADE` | Removing a listing removes its amenity links. |
| Booking to listing | `bookings.listing_id -> listings.listing_id` | `RESTRICT` | Bookings require the listing to remain for history. |
| Booking to guest | `bookings.guest_user_id -> users.user_id` | `RESTRICT` | Booking history requires the guest user record. |
| Booking room to booking | `booking_room_guests.booking_id -> bookings.booking_id` | `CASCADE` | Deleting a booking removes room-guest assignments. |
| Payment to booking | `payments.booking_id -> bookings.booking_id` | `RESTRICT` | Payment audit history must retain the booking. |
| Review to booking | `reviews.booking_id -> bookings.booking_id` | `CASCADE` | Deleting a booking removes related reviews. |
| Social connection | `social_connections.requester_user_id -> users.user_id` | `CASCADE` | Social connections are deleted if user is deleted. |
| Social visibility | `social_review_visibility.review_id -> reviews.review_id` | `CASCADE` | Visibility preferences are removed if the review is deleted. |

## 4. CHECK Constraints

Examples of implemented business rules:

- Email fields must follow a basic email pattern.
- Guest date of birth must represent an adult sample user.
- Listing capacity, bedroom count, bathroom count, nightly rate, and cleaning fee must be valid positive values.
- Booking checkout date must be later than check-in date.
- Booking guest count and booking amounts must be positive.
- Booking, payment, payout, listing, and service statuses are restricted to allowed values.
- Review ratings must be between 1 and 5.
- Service request quantity and price must be positive.

## 5. Ternary Relationship

The table `booking_room_guests` is the explicit ternary relationship required for Phase 2.

It answers this business question:

> Which guest, within which booking, was assigned to which specific room for the stay?

The relationship is ternary because one row cannot be represented accurately by only two entities:

- `booking_id` identifies the stay.
- `room_id` identifies the specific physical room inside the listing.
- `guest_user_id` identifies the specific person staying in that room.

This ensures that complex multi-room bookings can accurately track exactly which guest is sleeping in which room, which is crucial for large group stays and liability.

## 6. Index Strategy

The index script adds performance-focused indexes for common portfolio queries:

- Searching active listings by location, status, and price.
- Checking bookings by listing and date range.
- Reporting bookings by status and dates.
- Auditing payments by booking and payment status.
- Summarizing host payouts.
- Filtering service requests by service and status.
- Reviewing listing ratings.

These indexes support the validation and business queries in `05_validation_queries.sql` and `06_business_queries.sql`.

## 7. Dummy Data Summary

The dummy dataset includes:

- 43 users records.
- 43 user profiles records.
- 19 host profiles records.
- 19 guest profiles records.
- 19 countries records.
- 19 cities records.
- 19 addresses records.
- 19 property types records.
- 19 cancellation policies records.
- 19 listings records.
- 19 amenities records.
- 19 bookings records.
- 29 booking room guests records.
- 19 payment methods records.
- 19 payments records.
- 19 refunds records.
- 19 reviews records.
- 19 review categories records.
- 19 messages records.
- 19 support tickets records.
- 19 social connections records.
- 19 social review visibility records.

## 8. SQL Portfolio Files

| File | Role |
| --- | --- |
| `00_drop_database.sql` | Removes the existing project database. |
| `01_create_database.sql` | Creates and selects the database. |
| `02_create_tables.sql` | Defines tables, keys, constraints, and delete behavior. |
| `03_insert_dummy_data.sql` | Inserts realistic test data. |
| `04_indexes.sql` | Adds query performance indexes. |
| `05_validation_queries.sql` | Checks data quality and relationship consistency. |
| `06_business_queries.sql` | Demonstrates reporting queries and joins. |
| `07_referential_integrity_tests.sql` | Tests constraints and delete behavior safely. |
| `08_full_run.sql` | Runs the full build from a clean database. |
