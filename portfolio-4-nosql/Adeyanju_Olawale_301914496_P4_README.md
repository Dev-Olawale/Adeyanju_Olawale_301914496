# Portfolio 4 — NoSQL and Advanced Data Models

I used MongoDB collection event_sales for ticket_issued and ticket_cancelled events. These are fictional event examples based on venue, event, ticket_type, purchase, ticket.

## Document model

| Field | Meaning |
| --- | --- |
| _id | Unique string event ID |
| eventType | One of the two selected case event labels |
| occurredAt | Native BSON Date; sample timestamps are in 2030 |
| source | Original entity, primary key and saved JSON snapshot |
| embedded | Linked record snapshots read with the event |
| references | Keys for linked sources kept outside the embedded snapshots |
| details | Event metadata whose fields vary |

Related venue, ticket_type details are stored as snapshots with the event. This makes an event readable in one document. It duplicates some information, and later SQL changes do not automatically update the snapshots. PostgreSQL continues to enforce the relational rules.

## Example document

```javascript
{
    "_id": "event_000001",
    "schemaVersion": 1,
    "simulation": true,
    "eventType": "ticket_issued",
    "occurredAt": ISODate("2030-01-01T10:00:00Z"),
    "source": {
        "entity": "ticket",
        "key": {
            "ticket_id": 41
        },
        "snapshot": {
            "ticket_id": 41,
            "purchase_id": 31,
            "ticket_type_id": 21,
            "ticket_code": "TKT-0001",
            "seat_code": "T1",
            "status": "issued",
            "issued_at": "2027-01-05T10:01:00Z"
        }
    },
    "embedded": {
        "venue": [
            {
                "key": {
                    "venue_id": 1
                },
                "snapshot": {
                    "venue_id": 1,
                    "venue_name": "Grand Hotel",
                    "city": "Lisbon",
                    "capacity": 200,
                    "is_active": true
                },
                "via": [
                    "ticket.ticket_type_id → ticket_type.event_id → event.venue_id → venue"
                ]
            }
        ],
        "ticket_type": [
            {
                "key": {
                    "ticket_type_id": 21
                },
                "snapshot": {
                    "ticket_type_id": 21,
                    "event_id": 11,
                    "type_name": "Standard",
                    "price": 50,
                    "quota": 100
                },
                "via": [
                    "ticket.ticket_type_id → ticket_type"
                ]
            }
        ]
    },
    "references": {
        "event": [
            {
                "key": {
                    "event_id": 11
                },
                "via": [
                    "ticket.ticket_type_id → ticket_type.event_id → event"
                ]
            }
        ],
        "purchase": [
            {
                "key": {
                    "purchase_id": 31
                },
                "via": [
                    "ticket.purchase_id → purchase"
                ]
            }
        ]
    },
    "details": {
        "channel": "web"
    }
}
```

## Queries and results

| Query | Returned documents |
| --- | --- |
| Find the first sample event type (up to five documents). | 3 |
| Find events for the first source record using nested key fields (up to five). | 2 |
| Find events in the sample time range using a MongoDB Date filter (up to five). | 5 |
| Count documents for each event type. | 2 |

## 1. Find the first sample event type (up to five documents).

```javascript
db.getCollection("event_sales").find({"eventType":"ticket_issued"}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "ticket_issued",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "ticket_id": 41
    }
  },
  {
    "_id": "event_000003",
    "eventType": "ticket_issued",
    "occurredAt": {
      "$date": "2030-01-01T10:02:00Z"
    },
    "source": {
      "ticket_id": 42
    }
  },
  {
    "_id": "event_000005",
    "eventType": "ticket_issued",
    "occurredAt": {
      "$date": "2030-01-01T10:04:00Z"
    },
    "source": {
      "ticket_id": 43
    }
  }
]
```

## 2. Find events for the first source record using nested key fields (up to five).

```javascript
db.getCollection("event_sales").find({"source.key.ticket_id":41}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "ticket_issued",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "ticket_id": 41
    }
  },
  {
    "_id": "event_000002",
    "eventType": "ticket_cancelled",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "ticket_id": 41
    }
  }
]
```

## 3. Find events in the sample time range using a MongoDB Date filter (up to five).

```javascript
db.getCollection("event_sales").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray();
```

Selected fields from the returned documents:

```json
[
  {
    "_id": "event_000001",
    "eventType": "ticket_issued",
    "occurredAt": {
      "$date": "2030-01-01T10:00:00Z"
    },
    "source": {
      "ticket_id": 41
    }
  },
  {
    "_id": "event_000002",
    "eventType": "ticket_cancelled",
    "occurredAt": {
      "$date": "2030-01-01T10:01:00Z"
    },
    "source": {
      "ticket_id": 41
    }
  },
  {
    "_id": "event_000003",
    "eventType": "ticket_issued",
    "occurredAt": {
      "$date": "2030-01-01T10:02:00Z"
    },
    "source": {
      "ticket_id": 42
    }
  },
  {
    "_id": "event_000004",
    "eventType": "ticket_cancelled",
    "occurredAt": {
      "$date": "2030-01-01T10:03:00Z"
    },
    "source": {
      "ticket_id": 42
    }
  },
  {
    "_id": "event_000005",
    "eventType": "ticket_issued",
    "occurredAt": {
      "$date": "2030-01-01T10:04:00Z"
    },
    "source": {
      "ticket_id": 43
    }
  }
]
```

## 4. Count documents for each event type.

```javascript
db.getCollection("event_sales").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray();
```

| _id | documentCount |
| --- | --- |
| ticket_cancelled | 3 |
| ticket_issued | 3 |

## Validation and suitability

MongoDB inserted 6 documents. An invalid date type was rejected with code 121 and a repeated event ID with 11000. The collection still contained 6 valid documents. The compound eventType/occurredAt index supports those access fields; this exercise does not measure its speed.

The details field can vary across event types, while the common fields have a validator. Events can be added as separate documents rather than growing one large history record.

## Run the script

Connect mongosh to a fresh exercise database and run Adeyanju_Olawale_301914496_P4_MongoDB.js. It selects portfolio_nosql, creates the collection, inserts the sample documents and displays the query results. [Implementation evidence](screenshots/Adeyanju_Olawale_301914496_P4_DocumentsAndQueries.png).

## References

- [MongoDB — data modelling](https://www.mongodb.com/docs/manual/data-modeling/)

