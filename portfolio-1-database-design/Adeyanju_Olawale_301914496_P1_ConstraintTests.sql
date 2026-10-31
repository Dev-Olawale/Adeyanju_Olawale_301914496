-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. t venue pk. Expected: pk_venue, SQLSTATE 23505.
INSERT INTO portfolio."venue" ("venue_id", "venue_name", "city", "capacity", "is_active")
VALUES (1, 'Pk Venue', 'Faro', 50, TRUE);

-- 2. t venue uq. Expected: uq_venue_0, SQLSTATE 23505.
INSERT INTO portfolio."venue" ("venue_id", "venue_name", "city", "capacity", "is_active")
VALUES (101, 'Grand Hotel', 'Lisbon', 50, TRUE);

-- 3. t venue nn id. Expected: venue_id, SQLSTATE 23502.
INSERT INTO portfolio."venue" ("venue_id", "venue_name", "city", "capacity", "is_active")
VALUES (NULL, 'Nn A', 'Faro', 50, TRUE);

-- 4. t venue nn name. Expected: venue_name, SQLSTATE 23502.
INSERT INTO portfolio."venue" ("venue_id", "venue_name", "city", "capacity", "is_active")
VALUES (102, NULL, 'Faro', 50, TRUE);

-- 5. t venue nn city. Expected: city, SQLSTATE 23502.
INSERT INTO portfolio."venue" ("venue_id", "venue_name", "city", "capacity", "is_active")
VALUES (103, 'Nn C', NULL, 50, TRUE);

-- 6. t venue nn cap. Expected: capacity, SQLSTATE 23502.
INSERT INTO portfolio."venue" ("venue_id", "venue_name", "city", "capacity", "is_active")
VALUES (104, 'Nn D', 'Faro', NULL, TRUE);

-- 7. t venue nn act. Expected: is_active, SQLSTATE 23502.
INSERT INTO portfolio."venue" ("venue_id", "venue_name", "city", "capacity", "is_active")
VALUES (105, 'Nn E', 'Faro', 50, NULL);

-- 8. t event pk. Expected: pk_event, SQLSTATE 23505.
INSERT INTO portfolio."event" ("event_id", "venue_id", "event_name", "event_date", "starts_at", "ends_at", "status")
VALUES (11, 1, 'Pk Event', '2027-05-01', '2027-05-01T18:00:00Z', '2027-05-01T21:00:00Z', 'open');

-- 9. t event uq. Expected: uq_event_0, SQLSTATE 23505.
INSERT INTO portfolio."event" ("event_id", "venue_id", "event_name", "event_date", "starts_at", "ends_at", "status")
VALUES (111, 1, 'Gala Dinner', '2027-03-15', '2027-03-15T18:00:00Z', '2027-03-15T22:00:00Z', 'open');

-- 10. t event fk. Expected: fk_event_0, SQLSTATE 23503.
INSERT INTO portfolio."event" ("event_id", "venue_id", "event_name", "event_date", "starts_at", "ends_at", "status")
VALUES (112, 999, 'Fk Event', '2027-05-02', '2027-05-02T18:00:00Z', '2027-05-02T21:00:00Z', 'open');

-- 11. t event nn id. Expected: event_id, SQLSTATE 23502.
INSERT INTO portfolio."event" ("event_id", "venue_id", "event_name", "event_date", "starts_at", "ends_at", "status")
VALUES (NULL, 1, 'Nn Ev A', '2027-05-03', '2027-05-03T18:00:00Z', '2027-05-03T21:00:00Z', 'open');

-- 12. t event nn venue. Expected: venue_id, SQLSTATE 23502.
INSERT INTO portfolio."event" ("event_id", "venue_id", "event_name", "event_date", "starts_at", "ends_at", "status")
VALUES (113, NULL, 'Nn Ev B', '2027-05-03', '2027-05-03T18:00:00Z', '2027-05-03T21:00:00Z', 'open');

-- 13. t event nn name. Expected: event_name, SQLSTATE 23502.
INSERT INTO portfolio."event" ("event_id", "venue_id", "event_name", "event_date", "starts_at", "ends_at", "status")
VALUES (114, 1, NULL, '2027-05-03', '2027-05-03T18:00:00Z', '2027-05-03T21:00:00Z', 'open');

-- 14. t event nn date. Expected: event_date, SQLSTATE 23502.
INSERT INTO portfolio."event" ("event_id", "venue_id", "event_name", "event_date", "starts_at", "ends_at", "status")
VALUES (115, 1, 'Nn Ev D', NULL, '2027-05-03T18:00:00Z', '2027-05-03T21:00:00Z', 'open');

-- 15. t event nn start. Expected: starts_at, SQLSTATE 23502.
INSERT INTO portfolio."event" ("event_id", "venue_id", "event_name", "event_date", "starts_at", "ends_at", "status")
VALUES (116, 1, 'Nn Ev E', '2027-05-03', NULL, '2027-05-03T21:00:00Z', 'open');

-- 16. t event nn end. Expected: ends_at, SQLSTATE 23502.
INSERT INTO portfolio."event" ("event_id", "venue_id", "event_name", "event_date", "starts_at", "ends_at", "status")
VALUES (117, 1, 'Nn Ev F', '2027-05-03', '2027-05-03T18:00:00Z', NULL, 'open');

-- 17. t event nn status. Expected: status, SQLSTATE 23502.
INSERT INTO portfolio."event" ("event_id", "venue_id", "event_name", "event_date", "starts_at", "ends_at", "status")
VALUES (118, 1, 'Nn Ev G', '2027-05-03', '2027-05-03T18:00:00Z', '2027-05-03T21:00:00Z', NULL);

-- 18. t event check. Expected: r_event_time_order, SQLSTATE 23514.
INSERT INTO portfolio."event" ("event_id", "venue_id", "event_name", "event_date", "starts_at", "ends_at", "status")
VALUES (119, 1, 'Check Event', '2027-05-04', '2027-05-04T21:00:00Z', '2027-05-04T18:00:00Z', 'open');

-- 19. t tt pk. Expected: pk_ticket_type, SQLSTATE 23505.
INSERT INTO portfolio."ticket_type" ("ticket_type_id", "event_id", "type_name", "price", "quota")
VALUES (21, 11, 'Pk Type', 10, 5);

-- 20. t tt uq. Expected: uq_ticket_type_0, SQLSTATE 23505.
INSERT INTO portfolio."ticket_type" ("ticket_type_id", "event_id", "type_name", "price", "quota")
VALUES (121, 11, 'Standard', 10, 5);

-- 21. t tt fk. Expected: fk_ticket_type_0, SQLSTATE 23503.
INSERT INTO portfolio."ticket_type" ("ticket_type_id", "event_id", "type_name", "price", "quota")
VALUES (122, 999, 'Fk Type', 10, 5);

-- 22. t tt nn id. Expected: ticket_type_id, SQLSTATE 23502.
INSERT INTO portfolio."ticket_type" ("ticket_type_id", "event_id", "type_name", "price", "quota")
VALUES (NULL, 11, 'Nn Type A', 10, 5);

-- 23. t tt nn event. Expected: event_id, SQLSTATE 23502.
INSERT INTO portfolio."ticket_type" ("ticket_type_id", "event_id", "type_name", "price", "quota")
VALUES (123, NULL, 'Nn Type B', 10, 5);

-- 24. t tt nn name. Expected: type_name, SQLSTATE 23502.
INSERT INTO portfolio."ticket_type" ("ticket_type_id", "event_id", "type_name", "price", "quota")
VALUES (124, 11, NULL, 10, 5);

-- 25. t tt nn price. Expected: price, SQLSTATE 23502.
INSERT INTO portfolio."ticket_type" ("ticket_type_id", "event_id", "type_name", "price", "quota")
VALUES (125, 11, 'Nn Type D', NULL, 5);

-- 26. t tt nn quota. Expected: quota, SQLSTATE 23502.
INSERT INTO portfolio."ticket_type" ("ticket_type_id", "event_id", "type_name", "price", "quota")
VALUES (126, 11, 'Nn Type E', 10, NULL);

-- 27. t tt check price. Expected: r_price_nonnegative, SQLSTATE 23514.
INSERT INTO portfolio."ticket_type" ("ticket_type_id", "event_id", "type_name", "price", "quota")
VALUES (127, 11, 'Neg Price', -1, 5);

-- 28. t tt check quota. Expected: r_quota_positive, SQLSTATE 23514.
INSERT INTO portfolio."ticket_type" ("ticket_type_id", "event_id", "type_name", "price", "quota")
VALUES (128, 11, 'Zero Quota', 10, 0);

-- 29. t pur pk. Expected: pk_purchase, SQLSTATE 23505.
INSERT INTO portfolio."purchase" ("purchase_id", "buyer_email", "purchased_at", "total_amount", "status")
VALUES (31, 'pk@example.test', '2027-02-01T10:00:00Z', 10, 'paid');

-- 30. t pur nn id. Expected: purchase_id, SQLSTATE 23502.
INSERT INTO portfolio."purchase" ("purchase_id", "buyer_email", "purchased_at", "total_amount", "status")
VALUES (NULL, 'nn1@example.test', '2027-02-01T10:00:00Z', 10, 'paid');

-- 31. t pur nn email. Expected: buyer_email, SQLSTATE 23502.
INSERT INTO portfolio."purchase" ("purchase_id", "buyer_email", "purchased_at", "total_amount", "status")
VALUES (131, NULL, '2027-02-01T10:00:00Z', 10, 'paid');

-- 32. t pur nn at. Expected: purchased_at, SQLSTATE 23502.
INSERT INTO portfolio."purchase" ("purchase_id", "buyer_email", "purchased_at", "total_amount", "status")
VALUES (132, 'nn3@example.test', NULL, 10, 'paid');

-- 33. t pur nn total. Expected: total_amount, SQLSTATE 23502.
INSERT INTO portfolio."purchase" ("purchase_id", "buyer_email", "purchased_at", "total_amount", "status")
VALUES (133, 'nn4@example.test', '2027-02-01T10:00:00Z', NULL, 'paid');

-- 34. t pur nn status. Expected: status, SQLSTATE 23502.
INSERT INTO portfolio."purchase" ("purchase_id", "buyer_email", "purchased_at", "total_amount", "status")
VALUES (134, 'nn5@example.test', '2027-02-01T10:00:00Z', 10, NULL);

-- 35. t tk pk. Expected: pk_ticket, SQLSTATE 23505.
INSERT INTO portfolio."ticket" ("ticket_id", "purchase_id", "ticket_type_id", "ticket_code", "seat_code", "status", "issued_at")
VALUES (41, 31, 21, 'TKT-PK', NULL, 'issued', '2027-02-01T10:01:00Z');

-- 36. t tk uq. Expected: uq_ticket_0, SQLSTATE 23505.
INSERT INTO portfolio."ticket" ("ticket_id", "purchase_id", "ticket_type_id", "ticket_code", "seat_code", "status", "issued_at")
VALUES (141, 31, 21, 'TKT-0001', NULL, 'issued', '2027-02-01T10:01:00Z');

-- 37. t tk fk purchase. Expected: fk_ticket_0, SQLSTATE 23503.
INSERT INTO portfolio."ticket" ("ticket_id", "purchase_id", "ticket_type_id", "ticket_code", "seat_code", "status", "issued_at")
VALUES (142, 999, 21, 'TKT-FK1', NULL, 'issued', '2027-02-01T10:01:00Z');

-- 38. t tk fk type. Expected: fk_ticket_1, SQLSTATE 23503.
INSERT INTO portfolio."ticket" ("ticket_id", "purchase_id", "ticket_type_id", "ticket_code", "seat_code", "status", "issued_at")
VALUES (143, 31, 999, 'TKT-FK2', NULL, 'issued', '2027-02-01T10:01:00Z');

-- 39. t tk nn id. Expected: ticket_id, SQLSTATE 23502.
INSERT INTO portfolio."ticket" ("ticket_id", "purchase_id", "ticket_type_id", "ticket_code", "seat_code", "status", "issued_at")
VALUES (NULL, 31, 21, 'TKT-NN1', NULL, 'issued', '2027-02-01T10:01:00Z');

-- 40. t tk nn purchase. Expected: purchase_id, SQLSTATE 23502.
INSERT INTO portfolio."ticket" ("ticket_id", "purchase_id", "ticket_type_id", "ticket_code", "seat_code", "status", "issued_at")
VALUES (144, NULL, 21, 'TKT-NN2', NULL, 'issued', '2027-02-01T10:01:00Z');

-- 41. t tk nn type. Expected: ticket_type_id, SQLSTATE 23502.
INSERT INTO portfolio."ticket" ("ticket_id", "purchase_id", "ticket_type_id", "ticket_code", "seat_code", "status", "issued_at")
VALUES (145, 31, NULL, 'TKT-NN3', NULL, 'issued', '2027-02-01T10:01:00Z');

-- 42. t tk nn code. Expected: ticket_code, SQLSTATE 23502.
INSERT INTO portfolio."ticket" ("ticket_id", "purchase_id", "ticket_type_id", "ticket_code", "seat_code", "status", "issued_at")
VALUES (146, 31, 21, NULL, NULL, 'issued', '2027-02-01T10:01:00Z');

-- 43. t tk nn status. Expected: status, SQLSTATE 23502.
INSERT INTO portfolio."ticket" ("ticket_id", "purchase_id", "ticket_type_id", "ticket_code", "seat_code", "status", "issued_at")
VALUES (147, 31, 21, 'TKT-NN5', NULL, NULL, '2027-02-01T10:01:00Z');

-- 44. t tk nn issued. Expected: issued_at, SQLSTATE 23502.
INSERT INTO portfolio."ticket" ("ticket_id", "purchase_id", "ticket_type_id", "ticket_code", "seat_code", "status", "issued_at")
VALUES (148, 31, 21, 'TKT-NN6', NULL, 'issued', NULL);

-- 45. t tk partial. Expected: r_active_seat_unique, SQLSTATE 23505.
INSERT INTO portfolio."ticket" ("ticket_id", "purchase_id", "ticket_type_id", "ticket_code", "seat_code", "status", "issued_at")
VALUES (149, 31, 21, 'TKT-PU1', 'T1', 'issued', '2027-02-01T10:01:00Z');
