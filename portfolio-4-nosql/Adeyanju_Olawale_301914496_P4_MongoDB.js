// Run once in mongosh against a fresh exercise database.
// These records are fictional events for the case study.
(async function () {
  db = db.getSiblingDB('portfolio_nosql');
  if ((await db.getCollectionNames()).includes("event_sales")) {
    throw new Error('The exercise collection already exists. Use a fresh database.');
  }

  // The validator checks the stable event fields while details can vary.
  await db.createCollection("event_sales", {
    validator: {
    "$jsonSchema": {
        "bsonType": "object",
        "required": [
            "_id",
            "schemaVersion",
            "simulation",
            "eventType",
            "occurredAt",
            "source",
            "embedded",
            "references",
            "details"
        ],
        "properties": {
            "_id": {
                "bsonType": "string",
                "minLength": 1
            },
            "schemaVersion": {
                "enum": [
                    1
                ]
            },
            "simulation": {
                "enum": [
                    true
                ]
            },
            "eventType": {
                "bsonType": "string",
                "enum": [
                    "ticket_issued",
                    "ticket_cancelled"
                ]
            },
            "occurredAt": {
                "bsonType": "date"
            },
            "source": {
                "bsonType": "object",
                "required": [
                    "entity",
                    "key",
                    "snapshot"
                ],
                "properties": {
                    "entity": {
                        "enum": [
                            "ticket"
                        ]
                    },
                    "key": {
                        "bsonType": "object",
                        "required": [
                            "ticket_id"
                        ]
                    },
                    "snapshot": {
                        "bsonType": "object"
                    }
                }
            },
            "embedded": {
                "bsonType": "object"
            },
            "references": {
                "bsonType": "object"
            },
            "details": {
                "bsonType": "object"
            }
        }
    }
},
    validationLevel: 'strict', validationAction: 'error'
  });

  // Insert the four example events and show their IDs.
  printjson(await db.getCollection("event_sales").insertMany([
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
    },
    {
        "_id": "event_000002",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "ticket_cancelled",
        "occurredAt": ISODate("2030-01-01T10:01:00Z"),
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
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "attributes": [
                {
                    "entity": "ticket",
                    "key": {
                        "ticket_id": 41
                    },
                    "field": "seat_code",
                    "value": "T1"
                }
            ],
            "examples": {
                "dietary_note": "illustrative dietary_note",
                "table_group": "illustrative table_group",
                "scan_device": "illustrative scan_device"
            }
        }
    },
    {
        "_id": "event_000003",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "ticket_issued",
        "occurredAt": ISODate("2030-01-01T10:02:00Z"),
        "source": {
            "entity": "ticket",
            "key": {
                "ticket_id": 42
            },
            "snapshot": {
                "ticket_id": 42,
                "purchase_id": 31,
                "ticket_type_id": 21,
                "ticket_code": "TKT-0002",
                "seat_code": "T2",
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
    },
    {
        "_id": "event_000004",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "ticket_cancelled",
        "occurredAt": ISODate("2030-01-01T10:03:00Z"),
        "source": {
            "entity": "ticket",
            "key": {
                "ticket_id": 42
            },
            "snapshot": {
                "ticket_id": 42,
                "purchase_id": 31,
                "ticket_type_id": 21,
                "ticket_code": "TKT-0002",
                "seat_code": "T2",
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
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "attributes": [
                {
                    "entity": "ticket",
                    "key": {
                        "ticket_id": 42
                    },
                    "field": "seat_code",
                    "value": "T2"
                }
            ],
            "examples": {
                "dietary_note": "illustrative dietary_note",
                "table_group": "illustrative table_group",
                "scan_device": "illustrative scan_device"
            }
        }
    },
    {
        "_id": "event_000005",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "ticket_issued",
        "occurredAt": ISODate("2030-01-01T10:04:00Z"),
        "source": {
            "entity": "ticket",
            "key": {
                "ticket_id": 43
            },
            "snapshot": {
                "ticket_id": 43,
                "purchase_id": 32,
                "ticket_type_id": 22,
                "ticket_code": "TKT-0003",
                "seat_code": null,
                "status": "issued",
                "issued_at": "2027-01-06T11:31:00Z"
            }
        },
        "embedded": {
            "venue": [
                {
                    "key": {
                        "venue_id": 2
                    },
                    "snapshot": {
                        "venue_id": 2,
                        "venue_name": "Harbor Bistro",
                        "city": "Porto",
                        "capacity": 80,
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
                        "ticket_type_id": 22
                    },
                    "snapshot": {
                        "ticket_type_id": 22,
                        "event_id": 12,
                        "type_name": "VIP",
                        "price": 120,
                        "quota": 20
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
                        "event_id": 12
                    },
                    "via": [
                        "ticket.ticket_type_id → ticket_type.event_id → event"
                    ]
                }
            ],
            "purchase": [
                {
                    "key": {
                        "purchase_id": 32
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
    },
    {
        "_id": "event_000006",
        "schemaVersion": 1,
        "simulation": true,
        "eventType": "ticket_cancelled",
        "occurredAt": ISODate("2030-01-01T10:05:00Z"),
        "source": {
            "entity": "ticket",
            "key": {
                "ticket_id": 43
            },
            "snapshot": {
                "ticket_id": 43,
                "purchase_id": 32,
                "ticket_type_id": 22,
                "ticket_code": "TKT-0003",
                "seat_code": null,
                "status": "issued",
                "issued_at": "2027-01-06T11:31:00Z"
            }
        },
        "embedded": {
            "venue": [
                {
                    "key": {
                        "venue_id": 2
                    },
                    "snapshot": {
                        "venue_id": 2,
                        "venue_name": "Harbor Bistro",
                        "city": "Porto",
                        "capacity": 80,
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
                        "ticket_type_id": 22
                    },
                    "snapshot": {
                        "ticket_type_id": 22,
                        "event_id": 12,
                        "type_name": "VIP",
                        "price": 120,
                        "quota": 20
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
                        "event_id": 12
                    },
                    "via": [
                        "ticket.ticket_type_id → ticket_type.event_id → event"
                    ]
                }
            ],
            "purchase": [
                {
                    "key": {
                        "purchase_id": 32
                    },
                    "via": [
                        "ticket.purchase_id → purchase"
                    ]
                }
            ]
        },
        "details": {
            "channel": "mobile",
            "note": "Illustrative event-specific metadata",
            "attributes": [
                {
                    "entity": "ticket",
                    "key": {
                        "ticket_id": 43
                    },
                    "field": "seat_code",
                    "value": null
                }
            ],
            "examples": {
                "dietary_note": "illustrative dietary_note",
                "table_group": "illustrative table_group",
                "scan_device": "illustrative scan_device"
            }
        }
    }
]));
  await db.getCollection("event_sales").createIndex({eventType: 1, occurredAt: -1}, {name: 'event_type_time'});

  // 1. Find the first sample event type (up to five documents).
  printjson(await db.getCollection("event_sales").find({"eventType":"ticket_issued"}).sort({_id:1}).limit(5).toArray());

  // 2. Find events for the first source record using nested key fields (up to five).
  printjson(await db.getCollection("event_sales").find({"source.key.ticket_id":41}).sort({_id:1}).limit(5).toArray());

  // 3. Find events in the sample time range using a MongoDB Date filter (up to five).
  printjson(await db.getCollection("event_sales").find({"occurredAt":{"$gte":ISODate("2030-01-01T10:00:00Z"), "$lt":ISODate("2030-01-01T11:00:00Z")}}).sort({_id:1}).limit(5).toArray());

  // 4. Count documents for each event type.
  printjson(await db.getCollection("event_sales").aggregate([{"$group":{"_id":"$eventType", "documentCount":{"$sum":1}}}, {"$sort":{"_id":1}}]).toArray());

  // A date stored as text should be rejected by the validator.
  try {
    await db.getCollection("event_sales").insertOne({...{
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
}, _id: 'invalid_date_example', occurredAt: 'not-a-date'});
  } catch (error) { print('Invalid date error: ' + error.code); }

  // Reusing an event ID should be rejected by the unique _id index.
  try { await db.getCollection("event_sales").insertOne({
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
}); }
  catch (error) { print('Duplicate ID error: ' + error.code); }

  print('Document count: ' + await db.getCollection("event_sales").countDocuments());
})().catch(error => { print(error.stack || String(error)); quit(1); });
