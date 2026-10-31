# Digital Event Ticketing Solution for the Hospitality Industry — SQL queries

## 1. Show related venue, event, ticket_type, ticket records (up to 20).

```sql
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
```

| venue_venue_id | venue_venue_name | event_event_id | event_event_name | ticket_type_ticket_type_id | ticket_type_type_name | ticket_ticket_id | ticket_ticket_code |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | Grand Hotel | 11 | Gala Dinner | 21 | Standard | 41 | TKT-0001 |
| 1 | Grand Hotel | 11 | Gala Dinner | 21 | Standard | 42 | TKT-0002 |
| 2 | Harbor Bistro | 12 | Jazz Night | 22 | VIP | 43 | TKT-0003 |

## 2. Find event records where venue_id matches 1 (up to 20).

```sql
SELECT * FROM portfolio."event"
WHERE "venue_id" IS NOT DISTINCT FROM 1
ORDER BY "event_id"
LIMIT 20;
```

| event_id | venue_id | event_name | event_date | starts_at | ends_at | status |
| --- | --- | --- | --- | --- | --- | --- |
| 11 | 1 | Gala Dinner | 2027-03-15 | 2027-03-15T18:00:00+00:00 | 2027-03-15T22:00:00+00:00 | open |

## 3. Count event records for each venue_id (up to 20 groups).

```sql
SELECT "venue_id", count(*) AS record_count
FROM portfolio."event"
GROUP BY "venue_id"
ORDER BY record_count DESC, "venue_id" NULLS LAST
LIMIT 20;
```

| venue_id | record_count |
| --- | --- |
| 1 | 1 |
| 2 | 1 |

## 4. Count ticket records for each purchase_id (up to 20 groups).

```sql
SELECT "purchase_id", count(*) AS record_count
FROM portfolio."ticket"
GROUP BY "purchase_id"
ORDER BY record_count DESC, "purchase_id" NULLS LAST
LIMIT 20;
```

| purchase_id | record_count |
| --- | --- |
| 31 | 2 |
| 32 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 3.344 | 2.167, 3.344, 4.48 | Sort → Seq Scan | 274 |
| After index | 0.373 | 0.381, 0.373, 0.327 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 55 |

The median execution time changed from 3.344 ms to 0.373 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=2.123..2.126 rows=50 loops=1)
  Seq Scan on ticket (actual time=0.017..2.08 rows=50 loops=1)
Planning Time: 0.351 ms
Execution Time: 2.167 ms
```

### Before index, run 2

```text
Sort (actual time=3.298..3.302 rows=50 loops=1)
  Seq Scan on ticket (actual time=0.02..3.238 rows=50 loops=1)
Planning Time: 0.489 ms
Execution Time: 3.344 ms
```

### Before index, run 3

```text
Sort (actual time=4.436..4.44 rows=50 loops=1)
  Seq Scan on ticket (actual time=0.022..4.374 rows=50 loops=1)
Planning Time: 0.546 ms
Execution Time: 4.48 ms
```

### After index, run 1

```text
Sort (actual time=0.321..0.325 rows=50 loops=1)
  Bitmap Heap Scan on ticket (actual time=0.039..0.253 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.019..0.019 rows=50 loops=1)
Planning Time: 0.518 ms
Execution Time: 0.381 ms
```

### After index, run 2

```text
Sort (actual time=0.292..0.295 rows=50 loops=1)
  Bitmap Heap Scan on ticket (actual time=0.051..0.249 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.016..0.016 rows=50 loops=1)
Planning Time: 0.601 ms
Execution Time: 0.373 ms
```

### After index, run 3

```text
Sort (actual time=0.27..0.273 rows=50 loops=1)
  Bitmap Heap Scan on ticket (actual time=0.032..0.228 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.016..0.016 rows=50 loops=1)
Planning Time: 0.537 ms
Execution Time: 0.327 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Adeyanju_Olawale_301914496_P2_Queries.sql, then Adeyanju_Olawale_301914496_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Adeyanju_Olawale_301914496_P2_QueryResults.png) · [Index comparison](screenshots/Adeyanju_Olawale_301914496_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

