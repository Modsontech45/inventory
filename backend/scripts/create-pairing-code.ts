import { PrismaClient } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';
import pg from 'pg';

const pool = new pg.Pool({ connectionString: process.env.DATABASE_URL });
const adapter = new PrismaPg(pool);
const prisma = new PrismaClient({ adapter } as any);

async function main() {
  const business = await prisma.business.findFirst();
  const depot = await prisma.depot.findFirst({ where: { businessId: business!.id } });

  if (!business || !depot) {
    console.error('No business/depot found. Run the seed first.');
    process.exit(1);
  }

  const code = Math.floor(100000 + Math.random() * 900000).toString();
  const expiresAt = new Date(Date.now() + 60 * 60 * 1000); // 1 hour

  await prisma.pairingCode.create({
    data: { code, businessId: business.id, depotId: depot.id, expiresAt },
  });

  console.log('\n✅ Pairing code created');
  console.log(`   Code:    ${code}`);
  console.log(`   Expires: ${expiresAt.toLocaleTimeString()}\n`);
}

main().catch(e => { console.error(e); process.exit(1); }).finally(() => prisma.$disconnect());
