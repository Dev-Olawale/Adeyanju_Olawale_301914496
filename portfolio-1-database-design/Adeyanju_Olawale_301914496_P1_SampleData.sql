-- Fictional sample records for Digital Event Ticketing Solution for the Hospitality Industry.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."venue" ("venue_id", "venue_name", "city", "capacity", "is_active") VALUES (1, 'Grand Hotel', 'Lisbon', 200, TRUE);
INSERT INTO portfolio."venue" ("venue_id", "venue_name", "city", "capacity", "is_active") VALUES (2, 'Harbor Bistro', 'Porto', 80, TRUE);
INSERT INTO portfolio."purchase" ("purchase_id", "buyer_email", "purchased_at", "total_amount", "status") VALUES (31, 'guest1@example.test', '2027-01-05T10:00:00Z', 100, 'paid');
INSERT INTO portfolio."purchase" ("purchase_id", "buyer_email", "purchased_at", "total_amount", "status") VALUES (32, 'guest2@example.test', '2027-01-06T11:30:00Z', 120, 'paid');
INSERT INTO portfolio."event" ("event_id", "venue_id", "event_name", "event_date", "starts_at", "ends_at", "status") VALUES (11, 1, 'Gala Dinner', '2027-03-15', '2027-03-15T18:00:00Z', '2027-03-15T22:00:00Z', 'open');
INSERT INTO portfolio."event" ("event_id", "venue_id", "event_name", "event_date", "starts_at", "ends_at", "status") VALUES (12, 2, 'Jazz Night', '2027-04-10', '2027-04-10T20:00:00Z', '2027-04-10T23:30:00Z', 'scheduled');
INSERT INTO portfolio."ticket_type" ("ticket_type_id", "event_id", "type_name", "price", "quota") VALUES (21, 11, 'Standard', 50, 100);
INSERT INTO portfolio."ticket_type" ("ticket_type_id", "event_id", "type_name", "price", "quota") VALUES (22, 12, 'VIP', 120, 20);
INSERT INTO portfolio."ticket" ("ticket_id", "purchase_id", "ticket_type_id", "ticket_code", "seat_code", "status", "issued_at") VALUES (41, 31, 21, 'TKT-0001', 'T1', 'issued', '2027-01-05T10:01:00Z');
INSERT INTO portfolio."ticket" ("ticket_id", "purchase_id", "ticket_type_id", "ticket_code", "seat_code", "status", "issued_at") VALUES (42, 31, 21, 'TKT-0002', 'T2', 'issued', '2027-01-05T10:01:00Z');
INSERT INTO portfolio."ticket" ("ticket_id", "purchase_id", "ticket_type_id", "ticket_code", "seat_code", "status", "issued_at") VALUES (43, 32, 22, 'TKT-0003', NULL, 'issued', '2027-01-06T11:31:00Z');
COMMIT;
