# Digital Event Ticketing Solution for the Hospitality Industry — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| purchase_id | ticket records (list) |
| --- | --- |
| 31 | [41,42] |
| 32 | [43] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| ticket.ticket_id | ticket.purchase_id | ticket.ticket_type_id | ticket.ticket_code | purchase.purchase_id | purchase.buyer_email | ticket_type.ticket_type_id | ticket_type.event_id |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 41 | 31 | 21 | TKT-0001 | 31 | guest1@example.test | 21 | 11 |
| 42 | 31 | 21 | TKT-0002 | 31 | guest1@example.test | 21 | 11 |
| 43 | 32 | 22 | TKT-0003 | 32 | guest2@example.test | 22 | 12 |

Key: ticket_id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## ticket_example

| ticket.ticket_id | ticket.purchase_id | ticket.ticket_type_id | ticket.ticket_code | purchase.purchase_id | purchase.buyer_email | ticket_type.ticket_type_id | ticket_type.event_id |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 41 | 31 | 21 | TKT-0001 | 31 | guest1@example.test | 21 | 11 |
| 42 | 31 | 21 | TKT-0002 | 31 | guest1@example.test | 21 | 11 |
| 43 | 32 | 22 | TKT-0003 | 32 | guest2@example.test | 22 | 12 |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## venue

| venue_id | venue_name | city | capacity | is_active |
| --- | --- | --- | --- | --- |
| 1 | Grand Hotel | Lisbon | 200 | true |
| 2 | Harbor Bistro | Porto | 80 | true |

## event

| event_id | venue_id | event_name | event_date | starts_at | ends_at | status |
| --- | --- | --- | --- | --- | --- | --- |
| 11 | 1 | Gala Dinner | 2027-03-15 | 2027-03-15T18:00:00+00:00 | 2027-03-15T22:00:00+00:00 | open |
| 12 | 2 | Jazz Night | 2027-04-10 | 2027-04-10T20:00:00+00:00 | 2027-04-10T23:30:00+00:00 | scheduled |

## ticket_type

| ticket_type_id | event_id | type_name | price | quota |
| --- | --- | --- | --- | --- |
| 21 | 11 | Standard | 50 | 100 |
| 22 | 12 | VIP | 120 | 20 |

## purchase

| purchase_id | buyer_email | purchased_at | total_amount | status |
| --- | --- | --- | --- | --- |
| 31 | guest1@example.test | 2027-01-05T10:00:00+00:00 | 100 | paid |
| 32 | guest2@example.test | 2027-01-06T11:30:00+00:00 | 120 | paid |

## ticket

| ticket_id | purchase_id | ticket_type_id | ticket_code | seat_code | status | issued_at |
| --- | --- | --- | --- | --- | --- | --- |
| 41 | 31 | 21 | TKT-0001 | T1 | issued | 2027-01-05T10:01:00+00:00 |
| 42 | 31 | 21 | TKT-0002 | T2 | issued | 2027-01-05T10:01:00+00:00 |
| 43 | 32 | 22 | TKT-0003 | NULL | issued | 2027-01-06T11:31:00+00:00 |

## Dependencies

- venue: (venue_id) → venue_name, city, capacity, is_active
- event: (event_id) → venue_id, event_name, event_date, starts_at, ends_at, status
- ticket_type: (ticket_type_id) → event_id, type_name, price, quota
- purchase: (purchase_id) → buyer_email, purchased_at, total_amount, status
- ticket: (ticket_id) → purchase_id, ticket_type_id, ticket_code, seat_code, status, issued_at

Joining the decomposed sample tables reproduces the original 3 example rows. The design assumes the declared keys describe the relevant business dependencies.
