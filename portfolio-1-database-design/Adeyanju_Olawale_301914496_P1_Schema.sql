-- Digital Event Ticketing Solution for the Hospitality Industry: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."venue" (
  "venue_id" bigint NOT NULL,
  "venue_name" text NOT NULL,
  "city" text NOT NULL,
  "capacity" bigint NOT NULL,
  "is_active" boolean NOT NULL,
  CONSTRAINT "pk_venue" PRIMARY KEY ("venue_id"),
  CONSTRAINT "uq_venue_0" UNIQUE ("venue_name", "city")
);
CREATE TABLE portfolio."event" (
  "event_id" bigint NOT NULL,
  "venue_id" bigint NOT NULL,
  "event_name" text NOT NULL,
  "event_date" date NOT NULL,
  "starts_at" timestamptz NOT NULL,
  "ends_at" timestamptz NOT NULL,
  "status" text NOT NULL,
  CONSTRAINT "pk_event" PRIMARY KEY ("event_id"),
  CONSTRAINT "uq_event_0" UNIQUE ("venue_id", "event_name", "event_date")
);
CREATE TABLE portfolio."ticket_type" (
  "ticket_type_id" bigint NOT NULL,
  "event_id" bigint NOT NULL,
  "type_name" text NOT NULL,
  "price" numeric(18,2) NOT NULL,
  "quota" bigint NOT NULL,
  CONSTRAINT "pk_ticket_type" PRIMARY KEY ("ticket_type_id"),
  CONSTRAINT "uq_ticket_type_0" UNIQUE ("event_id", "type_name")
);
CREATE TABLE portfolio."purchase" (
  "purchase_id" bigint NOT NULL,
  "buyer_email" text NOT NULL,
  "purchased_at" timestamptz NOT NULL,
  "total_amount" numeric(18,2) NOT NULL,
  "status" text NOT NULL,
  CONSTRAINT "pk_purchase" PRIMARY KEY ("purchase_id")
);
CREATE TABLE portfolio."ticket" (
  "ticket_id" bigint NOT NULL,
  "purchase_id" bigint NOT NULL,
  "ticket_type_id" bigint NOT NULL,
  "ticket_code" text NOT NULL,
  "seat_code" text,
  "status" text NOT NULL,
  "issued_at" timestamptz NOT NULL,
  CONSTRAINT "pk_ticket" PRIMARY KEY ("ticket_id"),
  CONSTRAINT "uq_ticket_0" UNIQUE ("ticket_code")
);
ALTER TABLE portfolio."event" ADD CONSTRAINT "fk_event_0" FOREIGN KEY ("venue_id") REFERENCES portfolio."venue" ("venue_id");
ALTER TABLE portfolio."ticket_type" ADD CONSTRAINT "fk_ticket_type_0" FOREIGN KEY ("event_id") REFERENCES portfolio."event" ("event_id");
ALTER TABLE portfolio."ticket" ADD CONSTRAINT "fk_ticket_0" FOREIGN KEY ("purchase_id") REFERENCES portfolio."purchase" ("purchase_id");
ALTER TABLE portfolio."ticket" ADD CONSTRAINT "fk_ticket_1" FOREIGN KEY ("ticket_type_id") REFERENCES portfolio."ticket_type" ("ticket_type_id");
ALTER TABLE portfolio."event" ADD CONSTRAINT "r_event_time_order" CHECK ("ends_at" > "starts_at");
ALTER TABLE portfolio."ticket_type" ADD CONSTRAINT "r_price_nonnegative" CHECK ("price" >= 0);
ALTER TABLE portfolio."ticket_type" ADD CONSTRAINT "r_quota_positive" CHECK ("quota" > 0);
CREATE UNIQUE INDEX "r_active_seat_unique" ON portfolio."ticket" ("ticket_type_id", "seat_code") WHERE (("seat_code" IS NOT NULL) AND (("status" = 'issued') OR ("status" = 'used')));
COMMIT;
