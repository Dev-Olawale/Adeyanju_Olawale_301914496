# Digital Event Ticketing Solution for the Hospitality Industry — ER diagram

```mermaid
erDiagram
    direction LR
    venue {
        bigint venue_id PK
        text venue_name
        text city
        integer capacity
        boolean is_active
    }
    event {
        bigint event_id PK
        bigint venue_id FK
        text event_name
        date event_date
        timestamptz starts_at
        timestamptz ends_at
        text status
    }
    ticket_type {
        bigint ticket_type_id PK
        bigint event_id FK
        text type_name
        numeric price
        integer quota
    }
    purchase {
        bigint purchase_id PK
        text buyer_email
        timestamptz purchased_at
        numeric total_amount
        text status
    }
    ticket {
        bigint ticket_id PK
        bigint purchase_id FK
        bigint ticket_type_id FK
        text ticket_code UK
        text seat_code "Optional"
        text status
        timestamptz issued_at
    }
    venue ||--o{ event : "venue_id"
    event ||--o{ ticket_type : "event_id"
    purchase ||--o{ ticket : "purchase_id"
    ticket_type ||--o{ ticket : "ticket_type_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Adeyanju_Olawale_301914496_ERDiagram.png)
