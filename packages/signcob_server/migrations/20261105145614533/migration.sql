BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "billing_charge" (
    "id" bigserial PRIMARY KEY,
    "legalClientId" bigint NOT NULL,
    "negotiationId" bigint,
    "idempotencyKey" text NOT NULL,
    "providerId" text,
    "amountCents" bigint NOT NULL,
    "dueDate" text NOT NULL,
    "status" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "billing_charge_client_key_idx" ON "billing_charge" USING btree ("legalClientId", "idempotencyKey");
CREATE UNIQUE INDEX "billing_charge_provider_idx" ON "billing_charge" USING btree ("providerId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "billing_charge"
    ADD CONSTRAINT "billing_charge_fk_0"
    FOREIGN KEY("legalClientId")
    REFERENCES "legal_client"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "billing_charge"
    ADD CONSTRAINT "billing_charge_fk_1"
    FOREIGN KEY("negotiationId")
    REFERENCES "negotiation"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR signcob
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('signcob', '20261105145614533', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261105145614533', "timestamp" = now();

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
