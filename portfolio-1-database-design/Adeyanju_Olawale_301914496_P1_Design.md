# Digital Event Ticketing Solution for the Hospitality Industry — database design

My case study records venue, event, ticket_type, purchase, ticket.

## Users

- Hospitality event manager
- Box office or front desk clerk
- Guest purchasing tickets
- Entry gate attendant

## Main operations

- Register a venue and schedule an event
- Define ticket types with price and quota
- Record a purchase and issue tickets
- Cancel a ticket
- Report sales by event and ticket type

## Entities

| Entity | Information stored |
| --- | --- |
| venue | Hospitality location that hosts events. |
| event | Scheduled event held at a venue. |
| ticket_type | Priced category of ticket with a quota for an event. |
| purchase | Guest purchase that groups issued tickets. |
| ticket | Individually issued digital ticket. |

## venue

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| venue_id | BIGINT | PK | Yes |
| venue_name | TEXT |  | Yes |
| city | TEXT |  | Yes |
| capacity | INTEGER |  | Yes |
| is_active | BOOLEAN |  | Yes |
- Unique key: (venue_name, city).

## event

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| event_id | BIGINT | PK | Yes |
| venue_id | BIGINT | FK | Yes |
| event_name | TEXT |  | Yes |
| event_date | DATE |  | Yes |
| starts_at | TIMESTAMPTZ |  | Yes |
| ends_at | TIMESTAMPTZ |  | Yes |
| status | TEXT |  | Yes |
- venue_id → venue.venue_id
- Unique key: (venue_id, event_name, event_date).

## ticket_type

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| ticket_type_id | BIGINT | PK | Yes |
| event_id | BIGINT | FK | Yes |
| type_name | TEXT |  | Yes |
| price | NUMERIC(18,2) |  | Yes |
| quota | INTEGER |  | Yes |
- event_id → event.event_id
- Unique key: (event_id, type_name).

## purchase

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| purchase_id | BIGINT | PK | Yes |
| buyer_email | TEXT |  | Yes |
| purchased_at | TIMESTAMPTZ |  | Yes |
| total_amount | NUMERIC(18,2) |  | Yes |
| status | TEXT |  | Yes |


## ticket

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| ticket_id | BIGINT | PK | Yes |
| purchase_id | BIGINT | FK | Yes |
| ticket_type_id | BIGINT | FK | Yes |
| ticket_code | TEXT | Unique | Yes |
| seat_code | TEXT |  | No |
| status | TEXT |  | Yes |
| issued_at | TIMESTAMPTZ |  | Yes |
- purchase_id → purchase.purchase_id
- ticket_type_id → ticket_type.ticket_type_id
- Unique key: (ticket_code).

## Relationships and business rules

- An event must end after it starts.
- Ticket price must not be negative.
- Ticket type quota must be greater than zero.
- Every ticket code is unique.
- A seat or table code may be held by at most one non-cancelled ticket per ticket type.
- Each ticket references an existing ticket type.
- A purchase must have a buyer email.

## Assumptions

- All data is synthetic.
- One purchase is made by one buyer identified only by a synthetic email address.
- Each ticket belongs to exactly one purchase and one ticket type.
- A seat or table code is optional; when present, it may be held by only one active ticket per ticket type.
- Ticket status is one of issued, used or cancelled.
- Event status is one of scheduled, open, closed or cancelled.
- Currency is a single unspecified currency and amounts are decimals.
- Worked normalisation example uses the ticket entity, whose root references purchase and ticket_type, with ticket_type reached only once.

