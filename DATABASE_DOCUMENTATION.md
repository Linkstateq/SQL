# Database Documentation

## 1. Business Purpose

The database models an Airbnb-style accommodation booking system. Guests book listings owned by hosts, payments are recorded for bookings, hosts receive payouts, guests can leave reviews, listings can have amenities, and guests can request additional paid services during a stay.

The design supports Phase 2 portfolio requirements for SQL implementation, constraint enforcement, relationship behavior, and analytical query examples.

## 2. Main Entities

| Table | Purpose | Primary Key |
| --- | --- | --- |
| `locations` | City, region, country, and postal information for listings. | `location_id` |
| `guests` | Customer records for people booking or staying at properties. | `guest_id` |
| `hosts` | Property owner or management company records. | `host_id` |
| `property_types` | Controlled list of listing categories. | `property_type_id` |
| `amenities` | Controlled list of listing amenities. | `amenity_id` |
| `service_types` | Extra services such as airport pickup or breakfast. | `service_id` |
| `listings` | Accommodation units offered by hosts. | `listing_id` |
| `listing_amenities` | Many-to-many relationship between listings and amenities. | `(listing_id, amenity_id)` |
| `bookings` | Stay reservations made by guests for listings. | `booking_id` |
| `booking_guests` | Guests attached to a booking. | `(booking_id, guest_id)` |
| `payments` | Payment records for bookings. | `payment_id` |
| `host_payouts` | Payout records from bookings to hosts. | `payout_id` |
| `reviews` | Guest review records for completed stays. | `review_id` |
| `booking_service_requests` | Ternary relationship between booking, guest, and service. | `(booking_id, guest_id, service_id, requested_for_date)` |

## 3. Relationship Summary

| Relationship | Foreign Key | Delete Behavior | Reason |
| --- | --- | --- | --- |
| Host to listings | `listings.host_id -> hosts.host_id` | `RESTRICT` | A host with listings should not be deleted accidentally. |
| Location to listings | `listings.location_id -> locations.location_id` | `RESTRICT` | Location reference data remains stable while listings exist. |
| Property type to listings | `listings.property_type_id -> property_types.property_type_id` | `RESTRICT` | Type reference data remains stable while listings exist. |
| Listing to amenities | `listing_amenities.listing_id -> listings.listing_id` | `CASCADE` | Removing a listing removes its amenity links. |
| Amenity to listing links | `listing_amenities.amenity_id -> amenities.amenity_id` | `RESTRICT` | Amenity definitions should not be deleted while used. |
| Listing to bookings | `bookings.listing_id -> listings.listing_id` | `RESTRICT` | Booked listings must remain available for audit history. |
| Guest to bookings | `bookings.primary_guest_id -> guests.guest_id` | `RESTRICT` | Booking history requires the primary guest record. |
| Booking to booking guests | `booking_guests.booking_id -> bookings.booking_id` | `CASCADE` | Deleting a test booking removes its guest links. |
| Guest to booking guests | `booking_guests.guest_id -> guests.guest_id` | `RESTRICT` | Guest history should not be removed while bookings exist. |
| Booking to payments | `payments.booking_id -> bookings.booking_id` | `CASCADE` | Deleting a test booking removes payment rows. |
| Guest to payments | `payments.guest_id -> guests.guest_id` | `RESTRICT` | Payment audit history requires payer identity. |
| Booking to payouts | `host_payouts.booking_id -> bookings.booking_id` | `CASCADE` | Test bookings remove test payout records. |
| Host to payouts | `host_payouts.host_id -> hosts.host_id` | `RESTRICT` | Payout history requires host identity. |
| Booking to reviews | `reviews.booking_id -> bookings.booking_id` | `CASCADE` | Test bookings remove related reviews. |
| Guest to reviews | `reviews.guest_id -> guests.guest_id` | `SET NULL` | Reviews can remain anonymized if a guest profile is removed. |
| Listing to reviews | `reviews.listing_id -> listings.listing_id` | `CASCADE` | Listing cleanup removes listing-specific reviews. |
| Booking guest to service requests | `booking_service_requests.(booking_id, guest_id) -> booking_guests.(booking_id, guest_id)` | `CASCADE` | Service requests belong to a guest inside a booking. |
| Service type to service requests | `booking_service_requests.service_id -> service_types.service_id` | `RESTRICT` | Service definitions are retained while requests exist. |

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

The table `booking_service_requests` is the explicit ternary relationship required for Phase 2.

It answers this business question:

> Which guest, within which booking, requested which additional service for a specific date?

The relationship is ternary because one row cannot be represented accurately by only two entities:

- `booking_id` identifies the stay.
- `guest_id` identifies the specific person in that stay.
- `service_id` identifies the requested service.

The composite foreign key `(booking_id, guest_id)` references `booking_guests`, which ensures that only guests attached to a booking can request services for that booking.

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

- 5 locations.
- 6 guests.
- 4 hosts.
- 4 property types.
- 8 amenities.
- 5 service types.
- 5 listings.
- 6 bookings.
- 12 booking guest links.
- 6 payments.
- 3 host payouts.
- 2 reviews.
- 6 guest-specific service requests.

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
