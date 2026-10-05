import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { AppModule } from './app.module.js';
import { PrismaService } from './prisma/prisma.service.js';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  app.useGlobalPipes(new ValidationPipe({ whitelist: true, transform: true }));
  app.enableCors();

  const port = process.env.PORT ?? 3000;
  await app.listen(port);
  console.log(`ENVentory API running on port ${port}`);

  // Auto-generate a pairing code on startup for easy first-device setup
  try {
    const prisma = app.get(PrismaService);
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
