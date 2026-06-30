-- 03_insert_dummy_data.sql
-- Purpose: Insert deterministic, realistic dummy data for the complete Airbnb-style
-- accommodation booking workflow. The data is inserted in foreign-key order.
-- Every table receives at least 20 rows. The final SELECT section proves row counts.

USE airbnb_sql_data_mart;

-- Insert users
-- Users cover all platform roles: guests, hosts, admins, and support agents.
INSERT INTO users (user_id, email, password_hash, `role`, `status`, created_at) VALUES
  (1, 'aarav.sharma@example.com', 'hash_demo_001', 'guest', 'active', '2025-01-05 09:00:00'),
  (2, 'priya.banerjee@example.com', 'hash_demo_002', 'guest', 'active', '2025-01-06 09:10:00'),
  (3, 'rohan.mehta@example.com', 'hash_demo_003', 'guest', 'active', '2025-01-07 09:20:00'),
  (4, 'ananya.iyer@example.com', 'hash_demo_004', 'guest', 'active', '2025-01-08 09:30:00'),
  (5, 'kabir.khan@example.com', 'hash_demo_005', 'guest', 'active', '2025-01-09 09:40:00'),
  (6, 'neha.das@example.com', 'hash_demo_006', 'guest', 'active', '2025-01-10 09:50:00'),
  (7, 'vivaan.kapoor@example.com', 'hash_demo_007', 'guest', 'active', '2025-01-11 10:00:00'),
  (8, 'meera.nair@example.com', 'hash_demo_008', 'guest', 'active', '2025-01-12 10:10:00'),
  (9, 'arjun.sen@example.com', 'hash_demo_009', 'guest', 'active', '2025-01-13 10:20:00'),
  (10, 'sara.wilson@example.com', 'hash_demo_010', 'guest', 'active', '2025-01-14 10:30:00'),
  (11, 'lukas.meyer@example.com', 'hash_demo_011', 'guest', 'active', '2025-01-15 10:40:00'),
  (12, 'emma.fischer@example.com', 'hash_demo_012', 'guest', 'active', '2025-01-16 10:50:00'),
  (13, 'claire.dubois@example.com', 'hash_demo_013', 'guest', 'active', '2025-01-17 11:00:00'),
  (14, 'oliver.smith@example.com', 'hash_demo_014', 'guest', 'active', '2025-01-18 11:10:00'),
  (15, 'fatima.mansoori@example.com', 'hash_demo_015', 'guest', 'active', '2025-01-19 11:20:00'),
  (16, 'daniel.johnson@example.com', 'hash_demo_016', 'guest', 'active', '2025-01-20 11:30:00'),
  (17, 'yuki.tanaka@example.com', 'hash_demo_017', 'guest', 'active', '2025-01-21 11:40:00'),
  (18, 'mei.chen@example.com', 'hash_demo_018', 'guest', 'active', '2025-01-22 11:50:00'),
  (19, 'sophia.rossi@example.com', 'hash_demo_019', 'guest', 'inactive', '2025-01-23 12:00:00'),
  (20, 'noah.brown@example.com', 'hash_demo_020', 'guest', 'active', '2025-01-24 12:10:00'),
  (21, 'anil.gupta.host@example.com', 'hash_demo_021', 'host', 'active', '2024-11-01 08:00:00'),
  (22, 'sunita.rao.host@example.com', 'hash_demo_022', 'host', 'active', '2024-11-02 08:10:00'),
  (23, 'imran.sheikh.host@example.com', 'hash_demo_023', 'host', 'active', '2024-11-03 08:20:00'),
  (24, 'kavya.reddy.host@example.com', 'hash_demo_024', 'host', 'active', '2024-11-04 08:30:00'),
  (25, 'mario.fernandes.host@example.com', 'hash_demo_025', 'host', 'active', '2024-11-05 08:40:00'),
  (26, 'hanna.schmidt.host@example.com', 'hash_demo_026', 'host', 'active', '2024-11-06 08:50:00'),
  (27, 'thomas.bauer.host@example.com', 'hash_demo_027', 'host', 'active', '2024-11-07 09:00:00'),
  (28, 'camille.martin.host@example.com', 'hash_demo_028', 'host', 'active', '2024-11-08 09:10:00'),
  (29, 'james.turner.host@example.com', 'hash_demo_029', 'host', 'active', '2024-11-09 09:20:00'),
  (30, 'layla.alfarsi.host@example.com', 'hash_demo_030', 'host', 'active', '2024-11-10 09:30:00'),
  (31, 'olivia.carter.host@example.com', 'hash_demo_031', 'host', 'active', '2024-11-11 09:40:00'),
  (32, 'kenji.sato.host@example.com', 'hash_demo_032', 'host', 'active', '2024-11-12 09:50:00'),
  (33, 'siti.rahman.host@example.com', 'hash_demo_033', 'host', 'active', '2024-11-13 10:00:00'),
  (34, 'liam.connor.host@example.com', 'hash_demo_034', 'host', 'active', '2024-11-14 10:10:00'),
  (35, 'emily.clark.host@example.com', 'hash_demo_035', 'host', 'active', '2024-11-15 10:20:00'),
  (36, 'noor.ahmed.host@example.com', 'hash_demo_036', 'host', 'active', '2024-11-16 10:30:00'),
  (37, 'giulia.bianchi.host@example.com', 'hash_demo_037', 'host', 'active', '2024-11-17 10:40:00'),
  (38, 'diego.martinez.host@example.com', 'hash_demo_038', 'host', 'active', '2024-11-18 10:50:00'),
  (39, 'niran.chai.host@example.com', 'hash_demo_039', 'host', 'active', '2024-11-19 11:00:00'),
  (40, 'made.wijaya.host@example.com', 'hash_demo_040', 'host', 'active', '2024-11-20 11:10:00'),
  (41, 'mehul.admin@example.com', 'hash_demo_041', 'admin', 'active', '2024-10-01 08:00:00'),
  (42, 'hannah.admin@example.com', 'hash_demo_042', 'admin', 'active', '2024-10-02 08:00:00'),
  (43, 'riya.support@example.com', 'hash_demo_043', 'support_agent', 'active', '2024-10-03 08:00:00'),
  (44, 'peter.support@example.com', 'hash_demo_044', 'support_agent', 'active', '2024-10-04 08:00:00');

-- Insert profiles
-- Public profiles exist for all users. Guest and host role-specific profiles support booking and listing workflows.
INSERT INTO user_profiles (user_id, first_name, last_name, phone_number, date_of_birth, profile_photo_url, bio) VALUES
  (1, 'Aarav', 'Sharma', '+91 90000 00001', '1993-04-12', 'https://cdn.example.com/profiles/001.jpg', 'Frequent weekend traveller from Kolkata.'),
  (2, 'Priya', 'Banerjee', '+91 90000 00002', '1991-08-21', 'https://cdn.example.com/profiles/002.jpg', 'Enjoys heritage walks and homestays.'),
  (3, 'Rohan', 'Mehta', '+91 90000 00003', '1988-02-18', 'https://cdn.example.com/profiles/003.jpg', 'Business traveller looking for quiet stays.'),
  (4, 'Ananya', 'Iyer', '+91 90000 00004', '1995-10-02', 'https://cdn.example.com/profiles/004.jpg', 'Designer who prefers studios with workspaces.'),
  (5, 'Kabir', 'Khan', '+91 90000 00005', '1990-06-09', 'https://cdn.example.com/profiles/005.jpg', 'Travels with family across India.'),
  (6, 'Neha', 'Das', '+91 90000 00006', '1994-12-14', 'https://cdn.example.com/profiles/006.jpg', 'Food blogger and coastal travel fan.'),
  (7, 'Vivaan', 'Kapoor', '+91 90000 00007', '1992-03-29', 'https://cdn.example.com/profiles/007.jpg', 'Prefers central apartments near metro stations.'),
  (8, 'Meera', 'Nair', '+91 90000 00008', '1989-07-11', 'https://cdn.example.com/profiles/008.jpg', 'Travels for conferences and remote work.'),
  (9, 'Arjun', 'Sen', '+91 90000 00009', '1996-01-25', 'https://cdn.example.com/profiles/009.jpg', 'Backpacker interested in local neighborhoods.'),
  (10, 'Sara', 'Wilson', '+44 7700 900010', '1990-09-17', 'https://cdn.example.com/profiles/010.jpg', 'London-based traveller visiting Asia and Europe.'),
  (11, 'Lukas', 'Meyer', '+49 151 10000011', '1987-05-03', 'https://cdn.example.com/profiles/011.jpg', 'Berlin guest who enjoys city apartments.'),
  (12, 'Emma', 'Fischer', '+49 151 10000012', '1992-11-27', 'https://cdn.example.com/profiles/012.jpg', 'Travels for museums and weekend markets.'),
  (13, 'Claire', 'Dubois', '+33 600 000013', '1986-04-06', 'https://cdn.example.com/profiles/013.jpg', 'Parisian traveller interested in design stays.'),
  (14, 'Oliver', 'Smith', '+44 7700 900014', '1985-02-22', 'https://cdn.example.com/profiles/014.jpg', 'Family traveller and football fan.'),
  (15, 'Fatima', 'Mansoori', '+971 50 000 0015', '1991-12-08', 'https://cdn.example.com/profiles/015.jpg', 'Dubai resident exploring boutique homes.'),
  (16, 'Daniel', 'Johnson', '+1 212 555 0016', '1984-06-19', 'https://cdn.example.com/profiles/016.jpg', 'US traveller who values fast Wi-Fi.'),
  (17, 'Yuki', 'Tanaka', '+81 90 0000 0017', '1993-09-30', 'https://cdn.example.com/profiles/017.jpg', 'Tokyo guest interested in long city stays.'),
  (18, 'Mei', 'Chen', '+65 8000 0018', '1997-03-05', 'https://cdn.example.com/profiles/018.jpg', 'Singapore guest who books short work trips.'),
  (19, 'Sophia', 'Rossi', '+39 320 000 0019', '1989-10-13', 'https://cdn.example.com/profiles/019.jpg', 'Enjoys villas, food tours, and historic centers.'),
  (20, 'Noah', 'Brown', '+1 416 555 0020', '1994-01-07', 'https://cdn.example.com/profiles/020.jpg', 'Canadian guest travelling with friends.'),
  (21, 'Anil', 'Gupta', '+91 91000 00021', '1978-03-11', 'https://cdn.example.com/profiles/021.jpg', 'Kolkata host with renovated heritage apartments.'),
  (22, 'Sunita', 'Rao', '+91 91000 00022', '1980-07-20', 'https://cdn.example.com/profiles/022.jpg', 'Delhi host focused on private rooms for students.'),
  (23, 'Imran', 'Sheikh', '+91 91000 00023', '1975-12-02', 'https://cdn.example.com/profiles/023.jpg', 'Mumbai host near Bandra and sea-facing studios.'),
  (24, 'Kavya', 'Reddy', '+91 91000 00024', '1983-04-25', 'https://cdn.example.com/profiles/024.jpg', 'Bangalore host with work-friendly serviced flats.'),
  (25, 'Mario', 'Fernandes', '+91 91000 00025', '1979-08-08', 'https://cdn.example.com/profiles/025.jpg', 'Goa host offering villas near beaches.'),
  (26, 'Hanna', 'Schmidt', '+49 151 20000026', '1981-05-16', 'https://cdn.example.com/profiles/026.jpg', 'Berlin host with design apartments.'),
  (27, 'Thomas', 'Bauer', '+49 151 20000027', '1977-09-24', 'https://cdn.example.com/profiles/027.jpg', 'Munich host for fair and festival visitors.'),
  (28, 'Camille', 'Martin', '+33 600 000028', '1982-01-30', 'https://cdn.example.com/profiles/028.jpg', 'Paris host managing compact city studios.'),
  (29, 'James', 'Turner', '+44 7700 900029', '1974-11-04', 'https://cdn.example.com/profiles/029.jpg', 'London host with transport-friendly homes.'),
  (30, 'Layla', 'Alfarsi', '+971 50 000 0030', '1986-06-26', 'https://cdn.example.com/profiles/030.jpg', 'Dubai host managing marina apartments.'),
  (31, 'Olivia', 'Carter', '+1 212 555 0031', '1981-02-14', 'https://cdn.example.com/profiles/031.jpg', 'New York host with loft-style stays.'),
  (32, 'Kenji', 'Sato', '+81 90 0000 0032', '1976-10-21', 'https://cdn.example.com/profiles/032.jpg', 'Tokyo host near transit and restaurants.'),
  (33, 'Siti', 'Rahman', '+65 8000 0033', '1984-12-17', 'https://cdn.example.com/profiles/033.jpg', 'Singapore host offering compact business stays.'),
  (34, 'Liam', 'Connor', '+61 400 000 034', '1979-07-09', 'https://cdn.example.com/profiles/034.jpg', 'Sydney host near the harbor.'),
  (35, 'Emily', 'Clark', '+1 416 555 0035', '1982-09-01', 'https://cdn.example.com/profiles/035.jpg', 'Toronto host with downtown condos.'),
  (36, 'Noor', 'Ahmed', '+31 600 000 036', '1987-04-18', 'https://cdn.example.com/profiles/036.jpg', 'Amsterdam host near canals.'),
  (37, 'Giulia', 'Bianchi', '+39 320 000 0037', '1980-02-05', 'https://cdn.example.com/profiles/037.jpg', 'Rome host for historic center stays.'),
  (38, 'Diego', 'Martinez', '+34 600 000 038', '1978-05-27', 'https://cdn.example.com/profiles/038.jpg', 'Barcelona host near markets and transit.'),
  (39, 'Niran', 'Chai', '+66 80 000 0039', '1985-03-15', 'https://cdn.example.com/profiles/039.jpg', 'Bangkok host with serviced rooms.'),
  (40, 'Made', 'Wijaya', '+62 812 0000 0040', '1976-08-19', 'https://cdn.example.com/profiles/040.jpg', 'Bali host with garden villas.'),
  (41, 'Mehul', 'Admin', '+91 92000 00041', '1984-05-11', 'https://cdn.example.com/profiles/041.jpg', 'Platform administrator.'),
  (42, 'Hannah', 'Admin', '+49 151 30000042', '1986-07-17', 'https://cdn.example.com/profiles/042.jpg', 'Marketplace operations administrator.'),
  (43, 'Riya', 'Support', '+91 93000 00043', '1992-09-09', 'https://cdn.example.com/profiles/043.jpg', 'Support agent handling booking issues.'),
  (44, 'Peter', 'Support', '+44 7700 900044', '1988-01-19', 'https://cdn.example.com/profiles/044.jpg', 'Support agent handling payments and refunds.');

INSERT INTO host_profiles (user_id, host_display_name, host_since, response_rate, response_time_minutes, is_superhost) VALUES
  (21, 'Anil Kolkata Stays', '2021-02-01', 96.50, 35, TRUE),
  (22, 'Sunita Delhi Rooms', '2021-03-12', 92.00, 50, FALSE),
  (23, 'Imran Mumbai Homes', '2020-11-08', 98.00, 20, TRUE),
  (24, 'Kavya Workstay Bangalore', '2022-01-14', 95.00, 28, TRUE),
  (25, 'Mario Goa Villas', '2019-12-21', 90.00, 70, FALSE),
  (26, 'Hanna Berlin Apartments', '2020-06-03', 97.00, 25, TRUE),
  (27, 'Thomas Munich Guest Homes', '2021-09-17', 88.50, 85, FALSE),
  (28, 'Camille Paris Studios', '2022-04-10', 93.50, 45, FALSE),
  (29, 'James London Lets', '2020-02-28', 94.00, 40, TRUE),
  (30, 'Layla Dubai Marina Stays', '2021-05-19', 91.00, 55, FALSE),
  (31, 'Olivia NYC Lofts', '2019-10-10', 99.00, 15, TRUE),
  (32, 'Kenji Tokyo Homes', '2020-07-07', 96.00, 30, TRUE),
  (33, 'Siti Singapore Stays', '2021-01-27', 89.00, 95, FALSE),
  (34, 'Liam Sydney Harbor Homes', '2020-12-05', 93.00, 44, FALSE),
  (35, 'Emily Toronto Condos', '2022-02-22', 95.50, 33, TRUE),
  (36, 'Noor Amsterdam Canals', '2021-06-15', 90.50, 60, FALSE),
  (37, 'Giulia Rome Rooms', '2020-08-24', 94.50, 38, TRUE),
  (38, 'Diego Barcelona Homes', '2021-11-30', 92.50, 52, FALSE),
  (39, 'Niran Bangkok Serviced Stays', '2022-03-18', 87.50, 100, FALSE),
  (40, 'Made Bali Garden Villas', '2019-04-04', 98.50, 18, TRUE);

INSERT INTO guest_profiles (user_id, preferred_language, emergency_contact_name, emergency_contact_phone, marketing_opt_in) VALUES
  (1, 'en-IN', 'Ravi Sharma', '+91 98000 10001', TRUE),
  (2, 'bn-IN', 'Mitali Banerjee', '+91 98000 10002', TRUE),
  (3, 'en-IN', 'Nisha Mehta', '+91 98000 10003', FALSE),
  (4, 'ta-IN', 'Suresh Iyer', '+91 98000 10004', TRUE),
  (5, 'hi-IN', 'Amina Khan', '+91 98000 10005', TRUE),
  (6, 'en-IN', 'Ranjan Das', '+91 98000 10006', FALSE),
  (7, 'en-IN', 'Rhea Kapoor', '+91 98000 10007', TRUE),
  (8, 'ml-IN', 'Hari Nair', '+91 98000 10008', FALSE),
  (9, 'bn-IN', 'Mousumi Sen', '+91 98000 10009', TRUE),
  (10, 'en-GB', 'Mark Wilson', '+44 7700 100010', TRUE),
  (11, 'de-DE', 'Anna Meyer', '+49 151 90000011', FALSE),
  (12, 'de-DE', 'Karl Fischer', '+49 151 90000012', TRUE),
  (13, 'fr-FR', 'Luc Dubois', '+33 600 100013', TRUE),
  (14, 'en-GB', 'Grace Smith', '+44 7700 100014', FALSE),
  (15, 'ar-AE', 'Mariam Mansoori', '+971 50 100 0015', TRUE),
  (16, 'en-US', 'Laura Johnson', '+1 212 555 1016', TRUE),
  (17, 'ja-JP', 'Hiro Tanaka', '+81 90 1000 0017', FALSE),
  (18, 'zh-SG', 'Wei Chen', '+65 8100 0018', TRUE),
  (19, 'it-IT', 'Marco Rossi', '+39 320 100 0019', FALSE),
  (20, 'en-CA', 'Ella Brown', '+1 416 555 1020', TRUE);

-- Insert countries
-- Country records support city/address data and document issuing countries.
INSERT INTO countries (country_id, country_code, country_name) VALUES
  (1, 'IN', 'India'),
  (2, 'DE', 'Germany'),
  (3, 'FR', 'France'),
  (4, 'GB', 'United Kingdom'),
  (5, 'AE', 'United Arab Emirates'),
  (6, 'US', 'United States'),
  (7, 'JP', 'Japan'),
  (8, 'SG', 'Singapore'),
  (9, 'AU', 'Australia'),
  (10, 'CA', 'Canada'),
  (11, 'NL', 'Netherlands'),
  (12, 'IT', 'Italy'),
  (13, 'ES', 'Spain'),
  (14, 'TH', 'Thailand'),
  (15, 'ID', 'Indonesia'),
  (16, 'CH', 'Switzerland'),
  (17, 'AT', 'Austria'),
  (18, 'PT', 'Portugal'),
  (19, 'TR', 'Turkey'),
  (20, 'MY', 'Malaysia');

-- Insert cities
-- Indian and international cities provide realistic marketplace coverage.
INSERT INTO cities (city_id, country_id, city_name, state_region) VALUES
  (1, 1, 'Kolkata', 'West Bengal'),
  (2, 1, 'Delhi', 'Delhi'),
  (3, 1, 'Mumbai', 'Maharashtra'),
  (4, 1, 'Bangalore', 'Karnataka'),
  (5, 1, 'Goa', 'Goa'),
  (6, 2, 'Berlin', 'Berlin'),
  (7, 2, 'Munich', 'Bavaria'),
  (8, 3, 'Paris', 'Ile-de-France'),
  (9, 4, 'London', 'England'),
  (10, 5, 'Dubai', 'Dubai'),
  (11, 6, 'New York', 'New York'),
  (12, 7, 'Tokyo', 'Tokyo'),
  (13, 8, 'Singapore', 'Central Region'),
  (14, 9, 'Sydney', 'New South Wales'),
  (15, 10, 'Toronto', 'Ontario'),
  (16, 11, 'Amsterdam', 'North Holland'),
  (17, 12, 'Rome', 'Lazio'),
  (18, 13, 'Barcelona', 'Catalonia'),
  (19, 14, 'Bangkok', 'Bangkok'),
  (20, 15, 'Denpasar', 'Bali');

-- Insert addresses
-- Addresses include valid latitude and longitude values for listing locations.
INSERT INTO addresses (address_id, city_id, address_line1, address_line2, postal_code, latitude, longitude) VALUES
  (1, 1, '24 Park Street', 'Apartment 3B', '700016', 22.552672, 88.352885),
  (2, 2, '12 Hauz Khas Village', 'Second Floor', '110016', 28.549448, 77.200136),
  (3, 3, '88 Carter Road', 'Sea View Wing', '400050', 19.070223, 72.826497),
  (4, 4, '45 Indiranagar 100 Feet Road', 'Unit 5', '560038', 12.971891, 77.641151),
  (5, 5, '7 Candolim Beach Road', 'Villa A', '403515', 15.518973, 73.762243),
  (6, 6, '18 Prenzlauer Allee', 'Flat 4', '10405', 52.532103, 13.417209),
  (7, 7, '22 Schwabing West', 'Garden Level', '80796', 48.160930, 11.569610),
  (8, 8, '14 Rue de Rivoli', 'Studio 2', '75004', 48.856614, 2.352222),
  (9, 9, '31 Camden High Street', 'Flat 8', 'NW1 7JE', 51.539026, -0.142552),
  (10, 10, 'Marina Promenade Tower', 'Apartment 1204', '00000', 25.080850, 55.140350),
  (11, 11, '101 Spring Street', 'Loft 6', '10012', 40.724545, -73.997870),
  (12, 12, '5 Shinjuku Avenue', 'Room 702', '160-0022', 35.690921, 139.700258),
  (13, 13, '9 Tanjong Pagar Road', 'Suite 11', '088443', 1.276389, 103.843056),
  (14, 14, '6 Circular Quay West', 'Harbor Flat', '2000', -33.858732, 151.210005),
  (15, 15, '77 King Street West', 'Condo 2101', 'M5K 1A1', 43.648690, -79.381714),
  (16, 16, '42 Prinsengracht', 'Canal House', '1015', 52.373169, 4.883139),
  (17, 17, '19 Via del Corso', 'Piano 2', '00186', 41.902782, 12.496366),
  (18, 18, '25 Carrer de Mallorca', 'Atico', '08008', 41.392508, 2.162010),
  (19, 19, '66 Sukhumvit Road', 'Serviced Room', '10110', 13.736717, 100.523186),
  (20, 20, '11 Jalan Raya Ubud', 'Garden Villa', '80571', -8.506854, 115.262477);

-- Insert identity documents
-- Each user receives one deterministic document record linked to a valid issuing country.
INSERT INTO identity_documents (
  document_id, user_id, issuing_country_id, document_type, document_number, document_url, verification_status
)
SELECT
  user_id,
  user_id,
  MOD(user_id - 1, 20) + 1,
  CASE
    WHEN `role` = 'host' THEN 'Passport'
    WHEN `role` = 'support_agent' THEN 'Employee ID'
    WHEN `role` = 'admin' THEN 'Platform Admin ID'
    ELSE 'Government ID'
  END,
  CONCAT('DOC-2026-', LPAD(user_id, 4, '0')),
  CONCAT('https://secure.example.com/documents/', LPAD(user_id, 4, '0'), '.pdf'),
  CASE
    WHEN MOD(user_id, 9) = 0 THEN 'rejected'
    WHEN MOD(user_id, 4) = 0 THEN 'pending'
    ELSE 'verified'
  END
FROM users;

-- Insert social accounts
-- Each user links one stable external social account for login or profile trust.
INSERT INTO social_accounts (
  social_account_id, user_id, provider_name, provider_account_id, profile_url, is_verified
)
SELECT
  user_id,
  user_id,
  CASE MOD(user_id, 4)
    WHEN 0 THEN 'Google'
    WHEN 1 THEN 'LinkedIn'
    WHEN 2 THEN 'Facebook'
    ELSE 'Instagram'
  END,
  CONCAT('social-account-', LPAD(user_id, 4, '0')),
  CONCAT('https://social.example.com/u/', LPAD(user_id, 4, '0')),
  CASE WHEN MOD(user_id, 5) = 0 THEN FALSE ELSE TRUE END
FROM users;

-- Insert property types
-- Property types cover Indian homestays and international accommodation formats.
INSERT INTO property_types (property_type_id, type_name, description) VALUES
  (1, 'Apartment', 'Entire apartment suitable for short stays.'),
  (2, 'Private room', 'Private bedroom inside a shared home.'),
  (3, 'Villa', 'Standalone premium home with larger living space.'),
  (4, 'Shared room', 'Shared sleeping space for budget travellers.'),
  (5, 'Studio', 'Compact self-contained unit.'),
  (6, 'Serviced apartment', 'Professionally managed apartment with services.'),
  (7, 'Heritage home', 'Traditional or historic property.'),
  (8, 'Beach house', 'Property near a beach or coastal area.'),
  (9, 'Farm stay', 'Rural accommodation with open land.'),
  (10, 'Boutique hotel room', 'Individually designed hotel-style room.'),
  (11, 'Cabin', 'Small standalone nature stay.'),
  (12, 'Cottage', 'Cozy home for leisure stays.'),
  (13, 'Penthouse', 'Top-floor premium apartment.'),
  (14, 'Bungalow', 'Single-floor detached home.'),
  (15, 'Townhouse', 'Multi-level urban home.'),
  (16, 'Chalet', 'Mountain-style vacation home.'),
  (17, 'Houseboat', 'Floating accommodation.'),
  (18, 'Hostel dorm', 'Shared dormitory accommodation.'),
  (19, 'Loft', 'Open-plan urban apartment.'),
  (20, 'Condo', 'Privately owned apartment in a managed building.');

-- Insert cancellation policies
-- Policies use valid refund percentages and cutoff windows.
INSERT INTO cancellation_policies (cancellation_policy_id, policy_name, description, refund_percentage, refund_cutoff_hours) VALUES
  (1, 'Flexible 24h', 'Full refund until 24 hours before check-in.', 100.00, 24),
  (2, 'Flexible 48h', 'Full refund until 48 hours before check-in.', 100.00, 48),
  (3, 'Moderate 72h', 'Partial refund until 72 hours before check-in.', 75.00, 72),
  (4, 'Moderate 5 days', 'Partial refund until five days before check-in.', 70.00, 120),
  (5, 'Strict 7 days', 'Half refund until seven days before check-in.', 50.00, 168),
  (6, 'Strict 14 days', 'Half refund until fourteen days before check-in.', 50.00, 336),
  (7, 'Long stay flexible', 'Long-stay guests receive strong refund protection.', 90.00, 168),
  (8, 'Business flexible', 'Business bookings can cancel close to arrival.', 95.00, 24),
  (9, 'Festival strict', 'Festival dates have limited refund options.', 25.00, 336),
  (10, 'Non refundable', 'Lowest rate with no refund after booking.', 0.00, 0),
  (11, 'Beach season moderate', 'Coastal high-season partial refund policy.', 60.00, 120),
  (12, 'Monsoon flexible', 'Flexible policy for monsoon travel changes.', 85.00, 48),
  (13, 'Winter strict', 'Strict winter holiday refund policy.', 40.00, 240),
  (14, 'Family stay flexible', 'Family-friendly cancellation terms.', 80.00, 72),
  (15, 'Corporate monthly', 'Corporate monthly stay cancellation terms.', 65.00, 168),
  (16, 'Early bird moderate', 'Moderate refund for advance-purchase rates.', 55.00, 240),
  (17, 'Last minute strict', 'Last-minute rates have limited refunds.', 20.00, 24),
  (18, 'Luxury villa strict', 'Premium villa refund terms.', 35.00, 336),
  (19, 'Hostel flexible', 'Flexible terms for hostel dorm bookings.', 90.00, 24),
  (20, 'Local experience policy', 'Balanced policy for smaller city homes.', 75.00, 96);

-- Insert listings
-- Hosts create listings linked to host profiles, addresses, and property types.
INSERT INTO listings (
  listing_id, host_user_id, property_type_id, address_id, title, description,
  base_price, max_guests, bedrooms, bathrooms, status
) VALUES
  (1, 21, 1, 1, 'Kolkata Park Street Heritage Apartment', 'Renovated central apartment near restaurants and metro.', 4500.00, 4, 2, 1.50, 'published'),
  (2, 22, 2, 2, 'Delhi Hauz Khas Private Room', 'Quiet private room near cafes, metro, and university areas.', 2800.00, 2, 1, 1.00, 'published'),
  (3, 23, 5, 3, 'Mumbai Bandra Sea View Studio', 'Compact studio with sea breeze and fast Wi-Fi.', 7000.00, 2, 0, 1.00, 'published'),
  (4, 24, 6, 4, 'Bangalore Indiranagar Workstay', 'Serviced apartment with workspace and weekly cleaning.', 5200.00, 3, 1, 1.00, 'published'),
  (5, 25, 3, 5, 'Goa Candolim Pool Villa', 'Family villa close to the beach with private pool access.', 12000.00, 6, 3, 3.00, 'published'),
  (6, 26, 19, 6, 'Berlin Prenzlauer Loft', 'Bright loft close to trams, cafes, and galleries.', 10500.00, 3, 1, 1.00, 'published'),
  (7, 27, 1, 7, 'Munich Schwabing Apartment', 'Comfortable apartment for fair visitors and city breaks.', 9800.00, 4, 2, 1.50, 'published'),
  (8, 28, 5, 8, 'Paris Marais Design Studio', 'Design-forward studio near museums and metro stations.', 11500.00, 2, 0, 1.00, 'published'),
  (9, 29, 15, 9, 'London Camden Townhouse Room', 'Private room in a townhouse close to Camden Market.', 9200.00, 2, 1, 1.00, 'published'),
  (10, 30, 20, 10, 'Dubai Marina High Floor Condo', 'Modern condo with skyline view and building gym.', 13500.00, 4, 2, 2.00, 'published'),
  (11, 31, 19, 11, 'New York SoHo Loft', 'Open-plan loft near galleries, cafes, and subway lines.', 16500.00, 3, 1, 1.00, 'published'),
  (12, 32, 5, 12, 'Tokyo Shinjuku Compact Studio', 'Efficient studio near Shinjuku transport links.', 8800.00, 2, 0, 1.00, 'published'),
  (13, 33, 6, 13, 'Singapore Tanjong Pagar Suite', 'Business-ready serviced suite in the CBD.', 12500.00, 2, 1, 1.00, 'published'),
  (14, 34, 13, 14, 'Sydney Circular Quay Penthouse', 'Harbor-view penthouse for premium city stays.', 21000.00, 4, 2, 2.50, 'published'),
  (15, 35, 20, 15, 'Toronto King West Condo', 'Downtown condo near offices, restaurants, and transit.', 9500.00, 3, 1, 1.00, 'published'),
  (16, 36, 7, 16, 'Amsterdam Canal Heritage Home', 'Historic canal-side home with modern interiors.', 14500.00, 4, 2, 1.50, 'published'),
  (17, 37, 10, 17, 'Rome Centro Boutique Room', 'Boutique room near the historic center.', 8700.00, 2, 1, 1.00, 'paused'),
  (18, 38, 1, 18, 'Barcelona Eixample Apartment Draft', 'Draft apartment listing awaiting final photography.', 9900.00, 4, 2, 1.50, 'draft'),
  (19, 39, 6, 19, 'Bangkok Sukhumvit Serviced Room', 'Serviced room with daily cleaning and transit access.', 6200.00, 2, 1, 1.00, 'published'),
  (20, 40, 3, 20, 'Bali Ubud Garden Villa', 'Garden villa surrounded by rice fields and local cafes.', 11000.00, 5, 2, 2.00, 'published');

-- Insert listing photos
-- One cover photo per listing keeps every listing visible in search results.
INSERT INTO listing_photos (photo_id, listing_id, photo_url, caption, display_order, is_cover_photo)
SELECT
  listing_id,
  listing_id,
  CONCAT('https://cdn.example.com/listings/', LPAD(listing_id, 3, '0'), '/cover.jpg'),
  CONCAT(title, ' cover photo'),
  1,
  TRUE
FROM listings;

-- Insert rooms
-- One primary room per listing supports room-level guest assignment and room amenities.
INSERT INTO rooms (room_id, listing_id, room_name, room_type, capacity, bed_count, price_adjustment)
SELECT
  listing_id,
  listing_id,
  'Primary sleeping area',
  CASE
    WHEN bedrooms = 0 THEN 'Studio sleeping area'
    WHEN max_guests <= 2 THEN 'Private bedroom'
    ELSE 'Main bedroom'
  END,
  max_guests,
  CASE WHEN bedrooms = 0 THEN 1 ELSE bedrooms END,
  0.00
FROM listings;

-- Insert amenities
-- Amenity master data is reused by listing_amenities and room_amenities.
INSERT INTO amenities (amenity_id, amenity_name, amenity_category, description) VALUES
  (1, 'Wi-Fi', 'Connectivity', 'High-speed internet access.'),
  (2, 'Air conditioning', 'Comfort', 'Cooling available in main rooms.'),
  (3, 'Kitchen', 'Cooking', 'Guest access to cooking facilities.'),
  (4, 'Washer', 'Laundry', 'Washer available for guest use.'),
  (5, 'Dedicated workspace', 'Work', 'Desk or table suitable for laptop work.'),
  (6, 'Free parking', 'Transport', 'Parking included with the stay.'),
  (7, 'Pool', 'Leisure', 'Pool access for guests.'),
  (8, 'Beach access', 'Location', 'Easy access to beach areas.'),
  (9, 'Gym', 'Fitness', 'Fitness center or gym access.'),
  (10, 'Elevator', 'Accessibility', 'Elevator access in the building.'),
  (11, 'Heating', 'Comfort', 'Heating available in cold weather.'),
  (12, 'Balcony', 'Outdoor', 'Private balcony or terrace.'),
  (13, 'Breakfast', 'Food', 'Breakfast included or available.'),
  (14, 'Pet friendly', 'Policy', 'Pets allowed with host approval.'),
  (15, 'Family friendly', 'Policy', 'Suitable for families with children.'),
  (16, 'Smoke alarm', 'Safety', 'Smoke alarm installed.'),
  (17, 'First aid kit', 'Safety', 'Basic first aid supplies available.'),
  (18, 'Smart TV', 'Entertainment', 'Streaming-ready television.'),
  (19, 'Iron', 'Laundry', 'Iron and ironing board available.'),
  (20, 'Self check-in', 'Access', 'Guests can check in without meeting host.');

-- Insert listing amenities
-- Each listing has Wi-Fi plus one destination-specific amenity.
INSERT INTO listing_amenities (listing_id, amenity_id)
SELECT listing_id, 1 FROM listings
UNION ALL
SELECT listing_id, 2 + MOD(listing_id, 19) FROM listings;

-- Insert room amenities
-- Each primary room has safety and comfort amenities.
INSERT INTO room_amenities (room_id, amenity_id)
SELECT room_id, 16 FROM rooms
UNION ALL
SELECT room_id, 18 FROM rooms;

-- Insert house rules
-- Two rules per listing document expected guest behavior.
INSERT INTO house_rules (house_rule_id, listing_id, rule_title, rule_description, is_mandatory)
SELECT
  listing_id,
  listing_id,
  'Quiet hours',
  'Please keep noise low between 10 PM and 7 AM.',
  TRUE
FROM listings
UNION ALL
SELECT
  listing_id + 20,
  listing_id,
  'Verified guests only',
  'Only guests included in the booking may stay overnight.',
  TRUE
FROM listings;

-- Insert availability calendar
-- Calendar rows include valid custom prices and date-specific availability.
INSERT INTO availability_calendar (listing_id, calendar_date, is_available, custom_price, min_nights, max_nights, notes)
SELECT
  listing_id,
  DATE_ADD('2026-08-01', INTERVAL listing_id DAY),
  CASE WHEN MOD(listing_id, 7) = 0 THEN FALSE ELSE TRUE END,
  ROUND(base_price * 1.10, 2),
  CASE WHEN listing_id IN (5, 14, 20) THEN 2 ELSE 1 END,
  CASE WHEN listing_id IN (5, 14, 20) THEN 14 ELSE 30 END,
  'Seeded calendar price for portfolio testing.'
FROM listings;

-- Insert bookings
-- Bookings cover pending, confirmed, completed, cancelled, and refunded statuses.
INSERT INTO bookings (
  booking_id, listing_id, guest_user_id, check_in_date, check_out_date,
  number_of_guests, booking_status, subtotal_amount, guest_service_fee,
  host_service_fee, total_amount
) VALUES
  (1, 1, 1, '2026-01-10', '2026-01-13', 2, 'completed', 13500.00, 1800.00, 540.00, 15300.00),
  (2, 2, 2, '2026-01-12', '2026-01-15', 2, 'completed', 8400.00, 1100.00, 336.00, 9500.00),
  (3, 3, 3, '2026-02-05', '2026-02-08', 2, 'completed', 21000.00, 2600.00, 840.00, 23600.00),
  (4, 4, 4, '2026-02-12', '2026-02-16', 2, 'completed', 20800.00, 2500.00, 832.00, 23300.00),
  (5, 5, 5, '2026-03-01', '2026-03-05', 4, 'completed', 48000.00, 5200.00, 1920.00, 53200.00),
  (6, 6, 6, '2026-03-10', '2026-03-13', 2, 'completed', 31500.00, 3600.00, 1260.00, 35100.00),
  (7, 7, 7, '2026-04-03', '2026-04-06', 3, 'completed', 29400.00, 3300.00, 1176.00, 32700.00),
  (8, 8, 8, '2026-04-15', '2026-04-18', 2, 'completed', 34500.00, 3900.00, 1380.00, 38400.00),
  (9, 9, 9, '2026-05-02', '2026-05-05', 2, 'completed', 27600.00, 3100.00, 1104.00, 30700.00),
  (10, 10, 10, '2026-05-18', '2026-05-22', 3, 'completed', 54000.00, 5700.00, 2160.00, 59700.00),
  (11, 11, 11, '2026-06-05', '2026-06-09', 2, 'confirmed', 66000.00, 6600.00, 2640.00, 72600.00),
  (12, 12, 12, '2026-06-20', '2026-06-24', 2, 'confirmed', 35200.00, 3800.00, 1408.00, 39000.00),
  (13, 13, 13, '2026-07-02', '2026-07-06', 2, 'confirmed', 50000.00, 5200.00, 2000.00, 55200.00),
  (14, 14, 14, '2026-07-15', '2026-07-19', 4, 'pending', 84000.00, 8400.00, 3360.00, 92400.00),
  (15, 15, 15, '2026-07-21', '2026-07-24', 2, 'pending', 28500.00, 3000.00, 1140.00, 31500.00),
  (16, 16, 16, '2026-08-03', '2026-08-07', 2, 'cancelled', 58000.00, 6000.00, 2320.00, 64000.00),
  (17, 1, 17, '2026-08-10', '2026-08-13', 2, 'cancelled', 13500.00, 1800.00, 540.00, 15300.00),
  (18, 2, 18, '2026-08-12', '2026-08-15', 1, 'cancelled', 8400.00, 1100.00, 336.00, 9500.00),
  (19, 3, 19, '2026-09-01', '2026-09-04', 2, 'refunded', 21000.00, 2600.00, 840.00, 23600.00),
  (20, 4, 20, '2026-09-08', '2026-09-12', 2, 'refunded', 20800.00, 2500.00, 832.00, 23300.00);

-- Insert booking room guests
-- Completed bookings include a second assigned guest; other bookings assign the primary guest.
INSERT INTO booking_room_guests (booking_id, listing_id, room_id, guest_user_id) VALUES
  (1, 1, 1, 1), (1, 1, 1, 2),
  (2, 2, 2, 2), (2, 2, 2, 3),
  (3, 3, 3, 3), (3, 3, 3, 4),
  (4, 4, 4, 4), (4, 4, 4, 5),
  (5, 5, 5, 5), (5, 5, 5, 6),
  (6, 6, 6, 6), (6, 6, 6, 7),
  (7, 7, 7, 7), (7, 7, 7, 8),
  (8, 8, 8, 8), (8, 8, 8, 9),
  (9, 9, 9, 9), (9, 9, 9, 10),
  (10, 10, 10, 10), (10, 10, 10, 11),
  (11, 11, 11, 11),
  (12, 12, 12, 12),
  (13, 13, 13, 13),
  (14, 14, 14, 14),
  (15, 15, 15, 15),
  (16, 16, 16, 16),
  (17, 1, 1, 17),
  (18, 2, 2, 18),
  (19, 3, 3, 19),
  (20, 4, 4, 20);

-- Insert payment methods
-- Each guest has one saved payment method.
INSERT INTO payment_methods (
  payment_method_id, user_id, method_type, provider_name, provider_payment_token,
  masked_account_number, expiry_month, expiry_year, is_default
) VALUES
  (1, 1, 'credit_card', 'Razorpay', 'tok_guest_001', '**** **** **** 1001', 3, 2030, TRUE),
  (2, 2, 'upi', 'Razorpay', 'tok_guest_002', 'UPI **** 1002', NULL, NULL, TRUE),
  (3, 3, 'credit_card', 'Stripe', 'tok_guest_003', '**** **** **** 1003', 4, 2031, TRUE),
  (4, 4, 'debit_card', 'Razorpay', 'tok_guest_004', '**** **** **** 1004', 5, 2029, TRUE),
  (5, 5, 'credit_card', 'Razorpay', 'tok_guest_005', '**** **** **** 1005', 6, 2030, TRUE),
  (6, 6, 'paypal', 'PayPal', 'tok_guest_006', 'paypal-1006', NULL, NULL, TRUE),
  (7, 7, 'credit_card', 'Stripe', 'tok_guest_007', '**** **** **** 1007', 7, 2031, TRUE),
  (8, 8, 'credit_card', 'Stripe', 'tok_guest_008', '**** **** **** 1008', 8, 2032, TRUE),
  (9, 9, 'upi', 'Razorpay', 'tok_guest_009', 'UPI **** 1009', NULL, NULL, TRUE),
  (10, 10, 'credit_card', 'Stripe', 'tok_guest_010', '**** **** **** 1010', 9, 2030, TRUE),
  (11, 11, 'sepa_card', 'Stripe', 'tok_guest_011', '**** **** **** 1011', 10, 2031, TRUE),
  (12, 12, 'sepa_card', 'Stripe', 'tok_guest_012', '**** **** **** 1012', 11, 2031, TRUE),
  (13, 13, 'credit_card', 'Stripe', 'tok_guest_013', '**** **** **** 1013', 12, 2032, TRUE),
  (14, 14, 'credit_card', 'Stripe', 'tok_guest_014', '**** **** **** 1014', 1, 2030, TRUE),
  (15, 15, 'credit_card', 'Checkout', 'tok_guest_015', '**** **** **** 1015', 2, 2031, TRUE),
  (16, 16, 'credit_card', 'Stripe', 'tok_guest_016', '**** **** **** 1016', 3, 2030, TRUE),
  (17, 17, 'credit_card', 'Stripe', 'tok_guest_017', '**** **** **** 1017', 4, 2031, TRUE),
  (18, 18, 'credit_card', 'Stripe', 'tok_guest_018', '**** **** **** 1018', 5, 2032, TRUE),
  (19, 19, 'credit_card', 'Stripe', 'tok_guest_019', '**** **** **** 1019', 6, 2031, TRUE),
  (20, 20, 'credit_card', 'Stripe', 'tok_guest_020', '**** **** **** 1020', 7, 2030, TRUE);

-- Insert payments
-- Payments cover paid, pending, failed, and refunded states.
INSERT INTO payments (
  payment_id, booking_id, payer_user_id, payment_method_id, amount,
  currency_code, payment_status, transaction_reference, paid_at
) VALUES
  (1, 1, 1, 1, 15300.00, 'INR', 'paid', 'PAY-2026-0001', '2026-01-02 10:00:00'),
  (2, 2, 2, 2, 9500.00, 'INR', 'paid', 'PAY-2026-0002', '2026-01-03 10:05:00'),
  (3, 3, 3, 3, 23600.00, 'INR', 'paid', 'PAY-2026-0003', '2026-01-25 11:00:00'),
  (4, 4, 4, 4, 23300.00, 'INR', 'paid', 'PAY-2026-0004', '2026-02-02 11:10:00'),
  (5, 5, 5, 5, 53200.00, 'INR', 'paid', 'PAY-2026-0005', '2026-02-20 11:20:00'),
  (6, 6, 6, 6, 35100.00, 'INR', 'paid', 'PAY-2026-0006', '2026-02-25 11:30:00'),
  (7, 7, 7, 7, 32700.00, 'INR', 'paid', 'PAY-2026-0007', '2026-03-15 11:40:00'),
  (8, 8, 8, 8, 38400.00, 'INR', 'paid', 'PAY-2026-0008', '2026-03-28 11:50:00'),
  (9, 9, 9, 9, 30700.00, 'INR', 'paid', 'PAY-2026-0009', '2026-04-14 12:00:00'),
  (10, 10, 10, 10, 59700.00, 'INR', 'paid', 'PAY-2026-0010', '2026-05-01 12:10:00'),
  (11, 11, 11, 11, 72600.00, 'INR', 'paid', 'PAY-2026-0011', '2026-05-20 12:20:00'),
  (12, 12, 12, 12, 39000.00, 'INR', 'pending', 'PAY-2026-0012', NULL),
  (13, 13, 13, 13, 55200.00, 'INR', 'paid', 'PAY-2026-0013', '2026-06-10 12:30:00'),
  (14, 14, 14, 14, 92400.00, 'INR', 'pending', 'PAY-2026-0014', NULL),
  (15, 15, 15, 15, 31500.00, 'INR', 'failed', 'PAY-2026-0015', NULL),
  (16, 16, 16, 16, 64000.00, 'INR', 'refunded', 'PAY-2026-0016', '2026-07-20 13:00:00'),
  (17, 17, 17, 17, 15300.00, 'INR', 'refunded', 'PAY-2026-0017', '2026-07-25 13:10:00'),
  (18, 18, 18, 18, 9500.00, 'INR', 'refunded', 'PAY-2026-0018', '2026-07-26 13:20:00'),
  (19, 19, 19, 19, 23600.00, 'INR', 'refunded', 'PAY-2026-0019', '2026-08-10 13:30:00'),
  (20, 20, 20, 20, 23300.00, 'INR', 'refunded', 'PAY-2026-0020', '2026-08-20 13:40:00');

-- Insert platform commissions
-- Commission rows are deterministic calculations for every booking.
INSERT INTO platform_commissions (
  commission_id, booking_id, guest_commission_rate, host_commission_rate,
  guest_commission_amount, host_commission_amount
)
SELECT
  booking_id,
  booking_id,
  12.00,
  4.00,
  guest_service_fee,
  host_service_fee
FROM bookings;

-- Insert host payouts
-- One payout record per booking, linked to the listing host.
INSERT INTO host_payouts (
  payout_id, booking_id, host_user_id, payout_amount, payout_status, payout_reference, released_at
)
SELECT
  b.booking_id,
  b.booking_id,
  l.host_user_id,
  ROUND(GREATEST(b.subtotal_amount - b.host_service_fee, 1.00), 2),
  CASE
    WHEN b.booking_status = 'completed' THEN 'released'
    WHEN b.booking_status IN ('cancelled', 'refunded') THEN 'failed'
    ELSE 'pending'
  END,
  CONCAT('PAYOUT-2026-', LPAD(b.booking_id, 4, '0')),
  CASE WHEN b.booking_status = 'completed' THEN DATE_ADD(b.check_out_date, INTERVAL 2 DAY) ELSE NULL END
FROM bookings AS b
JOIN listings AS l ON l.listing_id = b.listing_id;

-- Insert refunds
-- Refund records are attached to cancelled/refunded bookings and valid payment rows.
INSERT INTO refunds (refund_id, booking_id, payment_id, refund_amount, refund_status, refund_reason, requested_at, processed_at) VALUES
  (1, 16, 16, 16000.00, 'processed', 'Guest cancelled before cutoff.', '2026-07-25 09:00:00', '2026-07-26 10:00:00'),
  (2, 16, 16, 8000.00, 'processed', 'Cleaning fee reversal.', '2026-07-25 09:05:00', '2026-07-26 10:05:00'),
  (3, 16, 16, 4000.00, 'approved', 'Service fee goodwill adjustment.', '2026-07-25 09:10:00', NULL),
  (4, 16, 16, 2000.00, 'requested', 'Additional bank charge review.', '2026-07-25 09:15:00', NULL),
  (5, 17, 17, 5000.00, 'processed', 'Host approved cancellation refund.', '2026-07-28 09:00:00', '2026-07-29 10:00:00'),
  (6, 17, 17, 2500.00, 'approved', 'Guest service fee refund.', '2026-07-28 09:05:00', NULL),
  (7, 17, 17, 1200.00, 'requested', 'Late refund review.', '2026-07-28 09:10:00', NULL),
  (8, 17, 17, 900.00, 'rejected', 'Non-refundable portion retained.', '2026-07-28 09:15:00', NULL),
  (9, 18, 18, 3000.00, 'processed', 'Travel plan changed.', '2026-07-29 09:00:00', '2026-07-30 10:00:00'),
  (10, 18, 18, 1800.00, 'approved', 'Partial guest fee refund.', '2026-07-29 09:05:00', NULL),
  (11, 18, 18, 1000.00, 'requested', 'Manual refund check.', '2026-07-29 09:10:00', NULL),
  (12, 18, 18, 700.00, 'rejected', 'Policy cutoff passed.', '2026-07-29 09:15:00', NULL),
  (13, 19, 19, 10000.00, 'processed', 'Listing unavailable after booking.', '2026-08-15 09:00:00', '2026-08-16 10:00:00'),
  (14, 19, 19, 5000.00, 'processed', 'Remaining nightly refund.', '2026-08-15 09:05:00', '2026-08-16 10:05:00'),
  (15, 19, 19, 2500.00, 'approved', 'Guest fee refund.', '2026-08-15 09:10:00', NULL),
  (16, 19, 19, 1100.00, 'requested', 'Currency adjustment.', '2026-08-15 09:15:00', NULL),
  (17, 20, 20, 9500.00, 'processed', 'Host cancelled due to maintenance.', '2026-08-25 09:00:00', '2026-08-26 10:00:00'),
  (18, 20, 20, 6000.00, 'processed', 'Remaining accommodation refund.', '2026-08-25 09:05:00', '2026-08-26 10:05:00'),
  (19, 20, 20, 2100.00, 'approved', 'Guest service fee refund.', '2026-08-25 09:10:00', NULL),
  (20, 20, 20, 850.00, 'requested', 'Payment processor difference.', '2026-08-25 09:15:00', NULL);

-- Insert listing cancellation policies
-- Each listing receives a clear policy assignment.
INSERT INTO listing_cancellation_policies (listing_id, cancellation_policy_id, effective_from, effective_to)
SELECT
  listing_id,
  listing_id,
  '2026-01-01',
  NULL
FROM listings;

-- Insert reviews
-- Completed bookings receive guest reviews of the listing and host experience.
INSERT INTO reviews (
  review_id, booking_id, reviewer_guest_user_id, listing_id, host_user_id,
  rating, review_title, review_text, review_date
) VALUES
  (1, 1, 1, 1, 21, 5, 'Great Kolkata base', 'The apartment was central, clean, and the host gave useful local tips.', '2026-01-14'),
  (2, 2, 2, 2, 22, 4, 'Comfortable Delhi room', 'Good location near Hauz Khas and easy communication with the host.', '2026-01-16'),
  (3, 3, 3, 3, 23, 5, 'Excellent Mumbai studio', 'Sea view and Wi-Fi were both excellent for a short work stay.', '2026-02-09'),
  (4, 4, 4, 4, 24, 5, 'Perfect for remote work', 'Workspace, cleaning, and neighborhood access were all strong.', '2026-02-17'),
  (5, 5, 5, 5, 25, 4, 'Family Goa trip', 'Pool villa worked well for the family and beach access was convenient.', '2026-03-06'),
  (6, 6, 6, 6, 26, 5, 'Stylish Berlin loft', 'Bright apartment with very responsive hosting.', '2026-03-14'),
  (7, 7, 7, 7, 27, 4, 'Good Munich stay', 'Comfortable apartment and reliable check-in instructions.', '2026-04-07'),
  (8, 8, 8, 8, 28, 5, 'Paris studio gem', 'Small but beautifully designed and close to museums.', '2026-04-19'),
  (9, 9, 9, 9, 29, 4, 'Camden weekend', 'The room was simple, clean, and close to markets.', '2026-05-06'),
  (10, 10, 10, 10, 30, 5, 'Dubai skyline stay', 'Beautiful view, smooth building access, and strong amenities.', '2026-05-23'),
  (11, 1, 2, 1, 21, 5, 'Helpful host', 'The host responded quickly and made our group feel welcome.', '2026-01-14'),
  (12, 2, 3, 2, 22, 4, 'Easy check-in', 'Instructions were clear and the room matched the photos.', '2026-01-16'),
  (13, 3, 4, 3, 23, 5, 'Great for business travel', 'Quiet, clean, and well connected to Bandra.', '2026-02-09'),
  (14, 4, 5, 4, 24, 5, 'Very professional host', 'Kavya checked in during the stay and resolved a small Wi-Fi question quickly.', '2026-02-17'),
  (15, 5, 6, 5, 25, 4, 'Relaxed villa stay', 'Great pool and helpful suggestions for local food.', '2026-03-06'),
  (16, 6, 7, 6, 26, 5, 'Loved the neighborhood', 'Good public transport and a stylish apartment.', '2026-03-14'),
  (17, 7, 8, 7, 27, 4, 'Clean and practical', 'Good kitchen setup and enough space for three guests.', '2026-04-07'),
  (18, 8, 9, 8, 28, 5, 'Beautiful details', 'The studio had thoughtful design details and felt secure.', '2026-04-19'),
  (19, 9, 10, 9, 29, 4, 'Good value London room', 'Good value for the location and easy access to the Tube.', '2026-05-06'),
  (20, 10, 11, 10, 30, 5, 'Excellent building amenities', 'The gym and marina location made the stay memorable.', '2026-05-23');

-- Insert review categories
-- Categories support detailed review scoring.
INSERT INTO review_categories (review_category_id, category_name, description) VALUES
  (1, 'Cleanliness', 'How clean the property was on arrival.'),
  (2, 'Accuracy', 'How accurately the listing represented the stay.'),
  (3, 'Check-in', 'Ease and clarity of the check-in process.'),
  (4, 'Communication', 'Host communication quality.'),
  (5, 'Location', 'Guest satisfaction with the location.'),
  (6, 'Value', 'Perceived value for price.'),
  (7, 'Wi-Fi', 'Internet speed and stability.'),
  (8, 'Comfort', 'Bed, seating, and room comfort.'),
  (9, 'Safety', 'Guest perception of safety and security.'),
  (10, 'Amenities', 'Quality and availability of promised amenities.'),
  (11, 'Workspace', 'Suitability for remote work.'),
  (12, 'Kitchen', 'Quality of cooking facilities.'),
  (13, 'Noise level', 'Quietness of the stay.'),
  (14, 'Transport access', 'Access to public transport or parking.'),
  (15, 'Family suitability', 'Suitability for family travel.'),
  (16, 'Accessibility', 'Ease of access for different mobility needs.'),
  (17, 'Host hospitality', 'Warmth and helpfulness of the host.'),
  (18, 'Photo accuracy', 'How well photos matched the property.'),
  (19, 'Local guidance', 'Quality of host recommendations.'),
  (20, 'Overall experience', 'Overall guest impression.');

-- Insert review scores
-- Five category scores per review create a detailed review-score dataset.
INSERT INTO review_scores (review_id, review_category_id, score)
SELECT
  r.review_id,
  c.review_category_id,
  1 + MOD(r.review_id + c.review_category_id, 5)
FROM reviews AS r
JOIN review_categories AS c
  ON c.review_category_id BETWEEN 1 AND 5;

-- Insert messages
-- Users exchange booking-related messages before, during, and after stays.
INSERT INTO messages (message_id, sender_user_id, recipient_user_id, booking_id, message_body, message_status, sent_at, read_at) VALUES
  (1, 1, 21, 1, 'Hi Anil, can we check in after 7 PM?', 'read', '2026-01-08 18:00:00', '2026-01-08 18:20:00'),
  (2, 21, 1, 1, 'Yes, late check-in is fine. I will share smart lock details.', 'read', '2026-01-08 18:25:00', '2026-01-08 18:30:00'),
  (3, 2, 22, 2, 'Is there space to keep two suitcases?', 'read', '2026-01-10 09:00:00', '2026-01-10 09:40:00'),
  (4, 22, 2, 2, 'Yes, the wardrobe and under-bed space should be enough.', 'read', '2026-01-10 09:45:00', '2026-01-10 10:00:00'),
  (5, 3, 23, 3, 'Can you confirm Wi-Fi speed for video calls?', 'read', '2026-02-01 12:00:00', '2026-02-01 12:10:00'),
  (6, 23, 3, 3, 'The studio has a 200 Mbps fiber connection.', 'read', '2026-02-01 12:12:00', '2026-02-01 12:18:00'),
  (7, 4, 24, 4, 'Could I get an invoice for this work trip?', 'sent', '2026-02-10 15:00:00', NULL),
  (8, 5, 25, 5, 'Do you provide extra towels for the pool?', 'read', '2026-02-25 16:00:00', '2026-02-25 16:08:00'),
  (9, 25, 5, 5, 'Yes, extra towels are kept near the laundry area.', 'read', '2026-02-25 16:10:00', '2026-02-25 16:15:00'),
  (10, 6, 26, 6, 'What is the nearest tram stop?', 'archived', '2026-03-05 11:00:00', '2026-03-05 11:30:00'),
  (11, 7, 27, 7, 'We will arrive by train around noon.', 'read', '2026-03-28 10:00:00', '2026-03-28 10:20:00'),
  (12, 27, 7, 7, 'I can store luggage from 12:30 PM.', 'read', '2026-03-28 10:25:00', '2026-03-28 10:40:00'),
  (13, 8, 28, 8, 'Is the building elevator working?', 'read', '2026-04-11 13:00:00', '2026-04-11 13:14:00'),
  (14, 28, 8, 8, 'Yes, the elevator is working normally.', 'read', '2026-04-11 13:16:00', '2026-04-11 13:20:00'),
  (15, 9, 29, 9, 'Can I leave my bag before check-in?', 'sent', '2026-04-29 14:00:00', NULL),
  (16, 10, 30, 10, 'Is parking available in the tower?', 'read', '2026-05-12 17:00:00', '2026-05-12 17:25:00'),
  (17, 30, 10, 10, 'Visitor parking can be arranged with your car plate number.', 'read', '2026-05-12 17:30:00', '2026-05-12 17:35:00'),
  (18, 16, 36, 16, 'I need to cancel because of visa delays.', 'read', '2026-07-22 09:00:00', '2026-07-22 09:12:00'),
  (19, 19, 23, 19, 'The refund email says processing. Can you confirm?', 'sent', '2026-08-14 10:00:00', NULL),
  (20, 20, 24, 20, 'Thanks for helping with the maintenance cancellation.', 'read', '2026-08-26 18:00:00', '2026-08-26 18:40:00');

-- Insert support tickets
-- Tickets cover open, in-progress, resolved, and closed cases with priority levels.
INSERT INTO support_tickets (
  support_ticket_id, opened_by_user_id, assigned_agent_user_id, booking_id,
  ticket_status, priority, subject, description, created_at, resolved_at
) VALUES
  (1, 1, 43, 1, 'closed', 'low', 'Late check-in question', 'Guest asked about late check-in instructions.', '2026-01-08 18:10:00', '2026-01-08 19:00:00'),
  (2, 2, 44, 2, 'closed', 'medium', 'Luggage space confirmation', 'Guest requested confirmation about suitcase storage.', '2026-01-10 09:15:00', '2026-01-10 11:00:00'),
  (3, 3, 43, 3, 'resolved', 'medium', 'Wi-Fi speed evidence', 'Guest requested Wi-Fi speed details for work calls.', '2026-02-01 12:15:00', '2026-02-01 14:00:00'),
  (4, 4, 44, 4, 'open', 'low', 'Invoice request', 'Guest needs a downloadable invoice.', '2026-02-10 15:10:00', NULL),
  (5, 5, 43, 5, 'resolved', 'low', 'Pool towel request', 'Guest asked about extra pool towels.', '2026-02-25 16:05:00', '2026-02-25 17:00:00'),
  (6, 6, 44, 6, 'closed', 'medium', 'Transit guidance', 'Guest needed nearest tram stop details.', '2026-03-05 11:05:00', '2026-03-05 12:00:00'),
  (7, 7, 43, 7, 'resolved', 'medium', 'Luggage drop request', 'Guest requested pre-check-in luggage storage.', '2026-03-28 10:10:00', '2026-03-28 12:00:00'),
  (8, 8, 44, 8, 'closed', 'low', 'Elevator confirmation', 'Guest asked about elevator status.', '2026-04-11 13:05:00', '2026-04-11 14:00:00'),
  (9, 9, 43, 9, 'in_progress', 'medium', 'Bag drop follow-up', 'Guest is waiting for host response about bag drop.', '2026-04-29 14:10:00', NULL),
  (10, 10, 44, 10, 'resolved', 'medium', 'Parking arrangement', 'Guest requested parking details.', '2026-05-12 17:15:00', '2026-05-12 19:00:00'),
  (11, 11, 43, 11, 'open', 'high', 'Payment confirmation', 'Guest asked for confirmation after international card charge.', '2026-05-21 10:00:00', NULL),
  (12, 12, 44, 12, 'open', 'medium', 'Pending payment', 'Payment is pending for confirmed booking.', '2026-06-01 10:00:00', NULL),
  (13, 13, 43, 13, 'resolved', 'low', 'Arrival time update', 'Guest updated arrival time.', '2026-06-20 10:00:00', '2026-06-20 11:00:00'),
  (14, 14, 44, 14, 'open', 'urgent', 'Large payment authorization', 'Guest needs help with a high-value pending payment.', '2026-07-01 10:00:00', NULL),
  (15, 15, 43, 15, 'in_progress', 'high', 'Failed payment retry', 'Guest reported failed card payment.', '2026-07-11 10:00:00', NULL),
  (16, 16, 44, 16, 'resolved', 'high', 'Visa delay cancellation', 'Guest requested cancellation support.', '2026-07-22 09:05:00', '2026-07-23 10:00:00'),
  (17, 17, 43, 17, 'closed', 'medium', 'Kolkata cancellation', 'Cancelled booking refund status checked.', '2026-07-28 09:20:00', '2026-07-29 12:00:00'),
  (18, 18, 44, 18, 'resolved', 'medium', 'Delhi refund question', 'Guest asked about partial refund policy.', '2026-07-29 09:20:00', '2026-07-30 11:00:00'),
  (19, 19, 43, 19, 'in_progress', 'urgent', 'Listing unavailable refund', 'Refund due to unavailable listing is being tracked.', '2026-08-14 10:05:00', NULL),
  (20, 20, 44, 20, 'resolved', 'urgent', 'Maintenance cancellation refund', 'Booking cancelled by host due to maintenance.', '2026-08-25 09:20:00', '2026-08-26 15:00:00');

-- Insert support ticket messages
-- Each ticket receives one guest/admin note and one support response.
INSERT INTO support_ticket_messages (support_ticket_message_id, support_ticket_id, sender_user_id, message_body, sent_at)
SELECT
  support_ticket_id,
  support_ticket_id,
  opened_by_user_id,
  CONCAT('Customer note for ticket ', support_ticket_id, ': ', subject),
  created_at
FROM support_tickets
UNION ALL
SELECT
  support_ticket_id + 20,
  support_ticket_id,
  COALESCE(assigned_agent_user_id, 43),
  CONCAT('Support response for ticket ', support_ticket_id, ' has been logged.'),
  DATE_ADD(created_at, INTERVAL 30 MINUTE)
FROM support_tickets;

-- Insert income estimates
-- Each listing receives one forecast row for host portfolio reporting.
INSERT INTO income_estimates (
  income_estimate_id, listing_id, estimate_period_start, estimate_period_end,
  projected_occupancy_rate, projected_booked_nights, projected_income, model_version
)
SELECT
  listing_id,
  listing_id,
  '2026-10-01',
  '2026-10-31',
  55.00 + MOD(listing_id, 10),
  12 + MOD(listing_id, 8),
  ROUND(base_price * (12 + MOD(listing_id, 8)), 2),
  'phase2-demo-v1'
FROM listings;

-- Insert social connections
-- Guests connect with hosts to model social trust and review visibility.
INSERT INTO social_connections (requester_user_id, addressee_user_id, connection_status, requested_at, responded_at) VALUES
  (1, 21, 'accepted', '2026-01-01 09:00:00', '2026-01-01 10:00:00'),
  (2, 22, 'accepted', '2026-01-02 09:00:00', '2026-01-02 10:00:00'),
  (3, 23, 'accepted', '2026-01-03 09:00:00', '2026-01-03 10:00:00'),
  (4, 24, 'accepted', '2026-01-04 09:00:00', '2026-01-04 10:00:00'),
  (5, 25, 'accepted', '2026-01-05 09:00:00', '2026-01-05 10:00:00'),
  (6, 26, 'accepted', '2026-01-06 09:00:00', '2026-01-06 10:00:00'),
  (7, 27, 'accepted', '2026-01-07 09:00:00', '2026-01-07 10:00:00'),
  (8, 28, 'accepted', '2026-01-08 09:00:00', '2026-01-08 10:00:00'),
  (9, 29, 'accepted', '2026-01-09 09:00:00', '2026-01-09 10:00:00'),
  (10, 30, 'accepted', '2026-01-10 09:00:00', '2026-01-10 10:00:00'),
  (11, 31, 'pending', '2026-01-11 09:00:00', NULL),
  (12, 32, 'pending', '2026-01-12 09:00:00', NULL),
  (13, 33, 'accepted', '2026-01-13 09:00:00', '2026-01-13 10:00:00'),
  (14, 34, 'pending', '2026-01-14 09:00:00', NULL),
  (15, 35, 'accepted', '2026-01-15 09:00:00', '2026-01-15 10:00:00'),
  (16, 36, 'blocked', '2026-01-16 09:00:00', '2026-01-16 10:00:00'),
  (17, 37, 'accepted', '2026-01-17 09:00:00', '2026-01-17 10:00:00'),
  (18, 38, 'pending', '2026-01-18 09:00:00', NULL),
  (19, 39, 'accepted', '2026-01-19 09:00:00', '2026-01-19 10:00:00'),
  (20, 40, 'accepted', '2026-01-20 09:00:00', '2026-01-20 10:00:00');

-- Insert social review visibility
-- Visibility links reviews to existing social connections and cascades with either parent.
INSERT INTO social_review_visibility (
  review_id, requester_user_id, addressee_user_id, visible_to_requester, visible_to_addressee
) VALUES
  (1, 1, 21, TRUE, TRUE),
  (2, 2, 22, TRUE, TRUE),
  (3, 3, 23, TRUE, TRUE),
  (4, 4, 24, TRUE, TRUE),
  (5, 5, 25, TRUE, TRUE),
  (6, 6, 26, TRUE, TRUE),
  (7, 7, 27, TRUE, TRUE),
  (8, 8, 28, TRUE, TRUE),
  (9, 9, 29, TRUE, TRUE),
  (10, 10, 30, TRUE, TRUE),
  (11, 11, 31, TRUE, FALSE),
  (12, 12, 32, TRUE, FALSE),
  (13, 13, 33, TRUE, TRUE),
  (14, 14, 34, TRUE, FALSE),
  (15, 15, 35, TRUE, TRUE),
  (16, 16, 36, FALSE, FALSE),
  (17, 17, 37, TRUE, TRUE),
  (18, 18, 38, TRUE, FALSE),
  (19, 19, 39, TRUE, TRUE),
  (20, 20, 40, TRUE, TRUE);

-- Count records in every table
-- Each row_count should be at least 20.
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
