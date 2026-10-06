import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { AppModule } from './app.module.js';
import { PrismaService } from './prisma/prisma.service.js';

// Prisma 7 + PrismaPg returns PostgreSQL integers as BigInt.
// Patch toJSON so JSON.stringify converts them to regular numbers.
(BigInt.prototype as any).toJSON = function () {
  const n = Number(this);
  return Number.isSafeInteger(n) ? n : this.toString();
};

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  app.useGlobalPipes(new ValidationPipe({ whitelist: true, transform: true }));
  app.enableCors();

  const port = process.env.PORT ?? 3000;
  await app.listen(port);
  console.log(`ENVentory API running on port ${port}`);

  const prisma = app.get(PrismaService);

  // Create units table if it doesn't exist yet (avoids needing prisma db push at build time)
  try {
    await prisma.$executeRawUnsafe(`
      CREATE TABLE IF NOT EXISTS "units" (
        "id"         UUID        NOT NULL DEFAULT gen_random_uuid(),
        "businessId" UUID        NOT NULL,
        "name"       TEXT        NOT NULL,
        "deleted"    BOOLEAN     NOT NULL DEFAULT false,
        "createdAt"  TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
        "updatedAt"  TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
        CONSTRAINT "units_pkey" PRIMARY KEY ("id")
      )
    `);
    await prisma.$executeRawUnsafe(`
      DO $$ BEGIN
        ALTER TABLE "units"
          ADD CONSTRAINT "units_businessId_fkey"
          FOREIGN KEY ("businessId") REFERENCES "businesses"("id")
          ON DELETE RESTRICT ON UPDATE CASCADE;
      EXCEPTION WHEN duplicate_object THEN NULL;
      END $$
    `);
    await prisma.$executeRawUnsafe(`
      CREATE UNIQUE INDEX IF NOT EXISTS "units_businessId_name_key"
        ON "units"("businessId", "name")
    `);
  } catch (e) {
    console.error('⚠️  Could not ensure units table:', e);
  }

  // Auto-generate a pairing code on startup for easy first-device setup
  try {
    const depot = await prisma.depot.findFirst();
    const business = depot ? await prisma.business.findUnique({ where: { id: depot.businessId } }) : null;

    if (business && depot) {
      const code = Math.floor(100000 + Math.random() * 900000).toString();
      const expiresAt = new Date(Date.now() + 60 * 60 * 1000); // 1 hour
      await prisma.pairingCode.create({
        data: { code, businessId: business.id, depotId: depot.id, expiresAt },
      });
      console.log('\n┌─────────────────────────────────────┐');
      console.log(`│  📱 CODE DE JUMELAGE : ${code}        │`);
      console.log(`│  Valable 1h — ${expiresAt.toLocaleTimeString()}              │`);
      console.log('└─────────────────────────────────────┘\n');
    }
  } catch (e) {
    console.error('⚠️  Could not generate pairing code:', e);
  }
}

await bootstrap();
