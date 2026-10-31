-- Show related venue, event, ticket_type, ticket records (up to 20).
SELECT t0."venue_id" AS "venue_venue_id",
       t0."venue_name" AS "venue_venue_name",
       t1."event_id" AS "event_event_id",
       t1."event_name" AS "event_event_name",
       t2."ticket_type_id" AS "ticket_type_ticket_type_id",
       t2."type_name" AS "ticket_type_type_name",
       t3."ticket_id" AS "ticket_ticket_id",
       t3."ticket_code" AS "ticket_ticket_code"
FROM portfolio."venue" t0
JOIN portfolio."event" t1 ON t1."venue_id" = t0."venue_id"
JOIN portfolio."ticket_type" t2 ON t2."event_id" = t1."event_id"
JOIN portfolio."ticket" t3 ON t3."ticket_type_id" = t2."ticket_type_id"
ORDER BY t0."venue_id", t1."event_id", t2."ticket_type_id", t3."ticket_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT t0."venue_id" AS "venue_venue_id",
       t0."venue_name" AS "venue_venue_name",
       t1."event_id" AS "event_event_id",
       t1."event_name" AS "event_event_name",
       t2."ticket_type_id" AS "ticket_type_ticket_type_id",
       t2."type_name" AS "ticket_type_type_name",
       t3."ticket_id" AS "ticket_ticket_id",
       t3."ticket_code" AS "ticket_ticket_code"
FROM portfolio."venue" t0
JOIN portfolio."event" t1 ON t1."venue_id" = t0."venue_id"
JOIN portfolio."ticket_type" t2 ON t2."event_id" = t1."event_id"
JOIN portfolio."ticket" t3 ON t3."ticket_type_id" = t2."ticket_type_id"
ORDER BY t0."venue_id", t1."event_id", t2."ticket_type_id", t3."ticket_id"
LIMIT 20;

-- Find event records where venue_id matches 1 (up to 20).
SELECT * FROM portfolio."event"
WHERE "venue_id" IS NOT DISTINCT FROM 1
ORDER BY "event_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."event"
WHERE "venue_id" IS NOT DISTINCT FROM 1
ORDER BY "event_id"
LIMIT 20;

-- Count event records for each venue_id (up to 20 groups).
SELECT "venue_id", count(*) AS record_count
FROM portfolio."event"
GROUP BY "venue_id"
ORDER BY record_count DESC, "venue_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "venue_id", count(*) AS record_count
FROM portfolio."event"
GROUP BY "venue_id"
ORDER BY record_count DESC, "venue_id" NULLS LAST
LIMIT 20;

-- Count ticket records for each purchase_id (up to 20 groups).
SELECT "purchase_id", count(*) AS record_count
FROM portfolio."ticket"
GROUP BY "purchase_id"
ORDER BY record_count DESC, "purchase_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "purchase_id", count(*) AS record_count
FROM portfolio."ticket"
GROUP BY "purchase_id"
ORDER BY record_count DESC, "purchase_id" NULLS LAST
LIMIT 20;
