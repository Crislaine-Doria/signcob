BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "chat_conversation" (
    "id" bigserial PRIMARY KEY,
    "title" text NOT NULL,
    "legalClientId" bigint,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "chat_conversation_created_idx" ON "chat_conversation" USING btree ("createdAt", "id");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "chat_message" (
    "id" bigserial PRIMARY KEY,
    "conversationId" bigint NOT NULL,
    "authorAuthUserId" text NOT NULL,
    "content" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "chat_message_conversation_page_idx" ON "chat_message" USING btree ("conversationId", "createdAt", "id");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "chat_participant" (
    "id" bigserial PRIMARY KEY,
    "conversationId" bigint NOT NULL,
    "authUserId" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "removedAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "chat_participant_conversation_user_unique" ON "chat_participant" USING btree ("conversationId", "authUserId");
CREATE INDEX "chat_participant_user_active_idx" ON "chat_participant" USING btree ("authUserId", "removedAt", "conversationId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "chat_conversation"
    ADD CONSTRAINT "chat_conversation_fk_0"
    FOREIGN KEY("legalClientId")
    REFERENCES "legal_client"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "chat_message"
    ADD CONSTRAINT "chat_message_fk_0"
    FOREIGN KEY("conversationId")
    REFERENCES "chat_conversation"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "chat_participant"
    ADD CONSTRAINT "chat_participant_fk_0"
    FOREIGN KEY("conversationId")
    REFERENCES "chat_conversation"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR signcob
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('signcob', '20261107133745758-chat-first-slice', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261107133745758-chat-first-slice', "timestamp" = now();

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
