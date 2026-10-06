ALTER TABLE "users" ADD COLUMN "email" TEXT;
ALTER TABLE "users" ADD COLUMN "passwordHash" TEXT;
ALTER TABLE "users" ADD COLUMN "isVendeur" BOOLEAN NOT NULL DEFAULT false;
ALTER TABLE "users" ADD COLUMN "isCaissier" BOOLEAN NOT NULL DEFAULT false;
CREATE UNIQUE INDEX IF NOT EXISTS "users_email_key" ON "users"("email");
