BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "legal_case" (
    "id" bigserial PRIMARY KEY,
    "legalClientId" bigint NOT NULL,
    "number" text NOT NULL,
    "tribunal" text NOT NULL,
    "className" text,
    "courtName" text,
    "lastSyncedAt" timestamp without time zone,
    "syncError" text,
    "movementsJson" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "legal_case_tribunal_number_unique" ON "legal_case" USING btree ("tribunal", "number");


--
-- MIGRATION VERSION FOR signcob
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('signcob', '20261103135341689', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261103135341689', "timestamp" = now();

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
