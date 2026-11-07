BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "chat_conversation" ADD COLUMN "createdByAuthUserId" text;
ALTER TABLE "chat_conversation" ADD COLUMN "creationRequestId" text;
CREATE UNIQUE INDEX "chat_conversation_creation_request_unique" ON "chat_conversation" USING btree ("createdByAuthUserId", "creationRequestId");

--
-- MIGRATION VERSION FOR signcob
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('signcob', '20261107164547739-chat-provisioning', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261107164547739-chat-provisioning', "timestamp" = now();

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
