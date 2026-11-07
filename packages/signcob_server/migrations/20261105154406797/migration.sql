BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "billing_charge" ADD COLUMN "environment" text;
ALTER TABLE "billing_charge" ADD COLUMN "accountId" text;
ALTER TABLE "billing_charge" ADD COLUMN "kind" text;
ALTER TABLE "billing_charge" ADD COLUMN "method" text;
ALTER TABLE "billing_charge" ADD COLUMN "flow" text;
ALTER TABLE "billing_charge" ADD COLUMN "installmentCount" bigint;
ALTER TABLE "billing_charge" ADD COLUMN "cycle" text;
ALTER TABLE "billing_charge" ADD COLUMN "providerCustomerId" text;
ALTER TABLE "billing_charge" ADD COLUMN "externalReference" text;
ALTER TABLE "billing_charge" ADD COLUMN "providerGroupId" text;
ALTER TABLE "billing_charge" ADD COLUMN "creationState" text;
ALTER TABLE "billing_charge" ADD COLUMN "subscriptionStatus" text;
--
-- ACTION CREATE TABLE
--
CREATE TABLE "billing_customer" (
    "id" bigserial PRIMARY KEY,
    "environment" text NOT NULL,
    "accountId" text NOT NULL,
    "legalClientId" bigint NOT NULL,
    "document" text NOT NULL,
    "externalReference" text NOT NULL,
    "providerCustomerId" text,
    "state" text NOT NULL,
    "createAttempted" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "billing_customer_client_idx" ON "billing_customer" USING btree ("environment", "accountId", "legalClientId");
CREATE UNIQUE INDEX "billing_customer_document_idx" ON "billing_customer" USING btree ("environment", "accountId", "document");
CREATE UNIQUE INDEX "billing_customer_provider_idx" ON "billing_customer" USING btree ("environment", "accountId", "providerCustomerId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "billing_payment" (
    "id" bigserial PRIMARY KEY,
    "chargeId" bigint NOT NULL,
    "environment" text NOT NULL,
    "accountId" text NOT NULL,
    "providerId" text NOT NULL,
    "amountCents" bigint NOT NULL,
    "dueDate" text NOT NULL,
    "installmentNumber" bigint,
    "status" text NOT NULL,
    "confirmedAt" timestamp without time zone,
    "receivedAt" timestamp without time zone,
    "invoiceUrl" text,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "billing_payment_provider_idx" ON "billing_payment" USING btree ("environment", "accountId", "providerId");
CREATE INDEX "billing_payment_charge_idx" ON "billing_payment" USING btree ("chargeId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "billing_customer"
    ADD CONSTRAINT "billing_customer_fk_0"
    FOREIGN KEY("legalClientId")
    REFERENCES "legal_client"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "billing_payment"
    ADD CONSTRAINT "billing_payment_fk_0"
    FOREIGN KEY("chargeId")
    REFERENCES "billing_charge"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR signcob
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('signcob', '20261105154406797', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261105154406797', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20251208110333922-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110333922-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260109031533194', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260109031533194', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20251208110412389-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110412389-v3-0-0', "timestamp" = now();


COMMIT;
