-- Make depotId and deviceId optional on customer_payments
ALTER TABLE "customer_payments" ALTER COLUMN "depotId" DROP NOT NULL;
ALTER TABLE "customer_payments" ALTER COLUMN "deviceId" DROP NOT NULL;
