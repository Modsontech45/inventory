import { PrismaClient, UserRole, PaymentMethod, StockMovementType, SaleStatus, CustomerType } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';
import pg from 'pg';
import bcrypt from 'bcrypt';
import { randomUUID } from 'crypto';

const pool = new pg.Pool({ connectionString: process.env.DATABASE_URL });
const adapter = new PrismaPg(pool);
const prisma = new PrismaClient({ adapter } as any);

async function main() {
  console.log('Seeding databaseâ€¦');

  // Business â€” fixed ID so re-runs are idempotent
  const businessId = '67ef4683-01ce-4cee-9d78-afd685d39a91';
  const business = await prisma.business.upsert({
    where: { id: businessId },
    update: {},
    create: {
      id: businessId,
      name: 'MatÃ©riaux KODA',
      address: 'Rue des BÃ¢tisseurs, LomÃ©',
      phone: '+228 90 00 00 01',
      nif: 'TG-NIF-123456',
      rccm: 'RCCM-TG-LOC-123',
      taxEnabled: false,
      taxRate: 18,
    },
  });
  console.log('  âœ“ Business:', business.name);

  // Depot â€” fixed ID so re-runs are idempotent
  const depotId = 'a2feefcc-dc98-4b49-a447-574b53130f16';
  const depot = await prisma.depot.upsert({
    where: { id: depotId },
    update: {},
    create: {
      id: depotId,
      businessId,
      name: 'DÃ©pÃ´t Agoe',
      address: 'Agoe NyivÃ©, LomÃ©',
      phone: '+228 90 00 00 02',
      isDefault: true,
    },
  });
  console.log('  âœ“ Depot:', depot.name);

  // Owner
  const ownerPassword = await bcrypt.hash('1234', 10);
  const ownerId = randomUUID();
  const owner = await prisma.user.upsert({
    where: { id: ownerId },
    update: {},
    create: {
      id: ownerId,
      businessId,
      depotId,
      name: 'Komi KODA',
      phone: '+228 90 00 00 03',
      role: UserRole.OWNER,
      pinHash: ownerPassword,
      active: true,
    },
  });
  console.log('  âœ“ Owner:', owner.name);

  // Seller 1
  const seller1Id = randomUUID();
  const seller1Pin = await bcrypt.hash('5678', 10);
  const seller1 = await prisma.user.upsert({
    where: { id: seller1Id },
    update: {},
    create: {
      id: seller1Id,
      businessId,
      depotId,
      name: 'Akossiwa SEGO',
      phone: '+228 91 00 00 04',
      role: UserRole.CASHIER,
      pinHash: seller1Pin,
      active: true,
    },
  });
  console.log('  âœ“ Seller 1:', seller1.name);

  // Seller 2
  const seller2Id = randomUUID();
  const seller2Pin = await bcrypt.hash('9012', 10);
  const seller2 = await prisma.user.upsert({
    where: { id: seller2Id },
    update: {},
    create: {
      id: seller2Id,
      businessId,
      depotId,
      name: 'Kofi MENSAH',
      phone: '+228 92 00 00 05',
      role: UserRole.CASHIER,
      pinHash: seller2Pin,
      active: true,
    },
  });
  console.log('  âœ“ Seller 2:', seller2.name);

  // Seed device (for seeded transactions)
  const seedDeviceId = randomUUID();
  await prisma.device.upsert({
    where: { id: seedDeviceId },
    update: {},
    create: {
      id: seedDeviceId,
      businessId,
      depotId,
      name: 'Seed Device',
      platform: 'seed',
      appVersion: '1.0.0',
    },
  });
  console.log('  âœ“ Seed device created');

  // Initial pairing code for first device bootstrap
  const pairingCode = '000001';
  await prisma.pairingCode.upsert({
    where: { code: pairingCode },
    update: { used: false, expiresAt: new Date(Date.now() + 365 * 24 * 60 * 60 * 1000) },
    create: {
      id: randomUUID(),
      code: pairingCode,
      businessId,
      depotId,
      expiresAt: new Date(Date.now() + 365 * 24 * 60 * 60 * 1000),
    },
  });
  console.log('  âœ“ Pairing code: 000001 (valable 1 an)');

  // Categories
  const catCimentId = randomUUID();
  const catFerrailleId = randomUUID();
  const catPeintureId = randomUUID();

  await prisma.category.createMany({
    data: [
      { id: catCimentId, businessId, name: 'Ciment & BÃ©ton' },
      { id: catFerrailleId, businessId, name: 'Ferraille & Armatures' },
      { id: catPeintureId, businessId, name: 'Peinture & RevÃªtement' },
    ],
    skipDuplicates: true,
  });
  console.log('  âœ“ Categories: 3');

  // Products with units
  const products = [
    {
      id: randomUUID(),
      name: 'Ciment Dangote 32.5',
      brand: 'Dangote',
      categoryId: catCimentId,
      internalCode: 'CIM-001',
      units: [
        { id: randomUUID(), name: 'Sac 50kg', isBase: true, factor: 1, purchasePrice: 3800, retailPrice: 4200, wholesalePrice: 4000, wholesaleMinQty: 10 },
        { id: randomUUID(), name: 'Palette (50 sacs)', isBase: false, factor: 50, purchasePrice: 190000, retailPrice: 200000, wholesalePrice: 195000, wholesaleMinQty: 1 },
      ],
    },
    {
      id: randomUUID(),
      name: 'Fer Ã  BÃ©ton âŒ€8',
      brand: 'SISCO',
      categoryId: catFerrailleId,
      internalCode: 'FER-008',
      units: [
        { id: randomUUID(), name: 'Barre 12m', isBase: true, factor: 1, purchasePrice: 2800, retailPrice: 3200, wholesalePrice: 3000, wholesaleMinQty: 50 },
        { id: randomUUID(), name: 'Tonne', isBase: false, factor: 104, purchasePrice: 290000, retailPrice: 330000, wholesalePrice: 310000, wholesaleMinQty: 1 },
      ],
    },
    {
      id: randomUUID(),
      name: 'Peinture GlycÃ©rophtalique Blanche',
      brand: 'Corona',
      categoryId: catPeintureId,
      internalCode: 'PNT-001',
      units: [
        { id: randomUUID(), name: 'Pot 1L', isBase: true, factor: 1, purchasePrice: 2500, retailPrice: 3200, wholesalePrice: 2900, wholesaleMinQty: 12 },
        { id: randomUUID(), name: 'Bidon 20L', isBase: false, factor: 20, purchasePrice: 48000, retailPrice: 60000, wholesalePrice: 55000, wholesaleMinQty: 1 },
      ],
    },
    {
      id: randomUUID(),
      name: 'Fer Ã  BÃ©ton âŒ€12',
      brand: 'SISCO',
      categoryId: catFerrailleId,
      internalCode: 'FER-012',
      units: [
        { id: randomUUID(), name: 'Barre 12m', isBase: true, factor: 1, purchasePrice: 5500, retailPrice: 6200, wholesalePrice: 5800, wholesaleMinQty: 50 },
      ],
    },
    {
      id: randomUUID(),
      name: 'Carrelage Sol 60x60 Beige',
      brand: 'Maroc',
      categoryId: catPeintureId,
      internalCode: 'CAR-001',
      units: [
        { id: randomUUID(), name: 'MÂ²', isBase: true, factor: 1, purchasePrice: 4200, retailPrice: 5500, wholesalePrice: 5000, wholesaleMinQty: 20 },
        { id: randomUUID(), name: 'BoÃ®te (1.44 mÂ²)', isBase: false, factor: 1, purchasePrice: 6100, retailPrice: 7900, wholesalePrice: 7200, wholesaleMinQty: 10 },
      ],
    },
  ];

  for (const p of products) {
    const { units, ...productData } = p;
    await prisma.product.upsert({
      where: { id: p.id },
      update: {},
      create: {
        ...productData,
        businessId,
        createdBy: ownerId,
        units: {
          create: units.map(u => ({ ...u, businessId })),
        },
        stockLevels: {
          create: [{ id: randomUUID(), businessId, depotId, minLevel: 5, cachedQty: 0 }],
        },
      },
    });

    // Initial stock entry
    const baseUnit = units.find(u => u.isBase);
    if (baseUnit) {
      const stockQty = Math.floor(Math.random() * 200) + 20;
      await prisma.stockMovement.create({
        data: {
          id: randomUUID(),
          businessId,
          depotId,
          productId: p.id,
          userId: ownerId,
          deviceId: seedDeviceId,
          type: StockMovementType.PURCHASE_RECEPTION,
          qtyInBase: stockQty,
          reason: 'Stock initial (seed)',
        },
      });
      await prisma.productStockLevel.update({
        where: { productId_depotId: { productId: p.id, depotId } },
        data: { cachedQty: stockQty },
      });
    }
  }
  console.log('  âœ“ Products: 5 with stock movements');

  // Customers
  const customers = [
    { id: randomUUID(), businessId, name: 'Entreprise GBADOE BTP', phone: '+228 93 00 01 01', type: CustomerType.COMPANY },
    { id: randomUUID(), businessId, name: 'Yao AGBENOTO', phone: '+228 94 00 02 02', type: CustomerType.INDIVIDUAL },
    { id: randomUUID(), businessId, name: 'Constructions ATAKPAME', phone: '+228 95 00 03 03', type: CustomerType.COMPANY },
  ];
  await prisma.customer.createMany({ data: customers, skipDuplicates: true });
  console.log('  âœ“ Customers: 3');

  // Sample sales for the past 7 days
  const sellers = [ownerId, seller1Id, seller2Id];
  const productList = products;
  let salesCount = 0;

  for (let day = 6; day >= 0; day--) {
    const date = new Date();
    date.setDate(date.getDate() - day);
    const salesPerDay = Math.floor(Math.random() * 4) + 2;

    for (let s = 0; s < salesPerDay; s++) {
      const sellerId = sellers[Math.floor(Math.random() * sellers.length)];
      const prod = productList[Math.floor(Math.random() * productList.length)];
      const baseUnit = prod.units.find(u => u.isBase)!;
      const qty = Math.floor(Math.random() * 5) + 1;
      const lineTotal = qty * baseUnit.retailPrice;

      const saleId = randomUUID();
      const payMethod = [PaymentMethod.CASH, PaymentMethod.FLOOZ, PaymentMethod.MIXX][Math.floor(Math.random() * 3)];

      await prisma.sale.create({
        data: {
          id: saleId,
          businessId,
          depotId,
          userId: sellerId,
          deviceId: seedDeviceId,
          number: `AGO-${date.getFullYear()}-${String(salesCount + 1).padStart(6, '0')}`,
          status: SaleStatus.ACTIVE,
          totalAmount: lineTotal,
          createdAt: date,
          updatedAt: date,
          lines: {
            create: [{
              id: randomUUID(),
              businessId,
              productId: prod.id,
              unitId: baseUnit.id,
              qty,
              unitPrice: baseUnit.retailPrice,
              lineTotal,
            }],
          },
          payments: {
            create: [{
              id: randomUUID(),
              businessId,
              depotId,
              deviceId: seedDeviceId,
              method: payMethod,
              amount: lineTotal,
            }],
          },
        },
      });

      // Stock out movement
      await prisma.stockMovement.create({
        data: {
          id: randomUUID(),
          businessId,
          depotId,
          productId: prod.id,
          userId: sellerId,
          deviceId: seedDeviceId,
          type: StockMovementType.SALE_EXIT,
          qtyInBase: -qty,
          refDocId: saleId,
          refDocType: 'SALE',
          createdAt: date,
          updatedAt: date,
        },
      });

      await prisma.productStockLevel.update({
        where: { productId_depotId: { productId: prod.id, depotId } },
        data: { cachedQty: { decrement: qty } },
      });

      salesCount++;
    }
  }
  console.log(`  âœ“ Sales: ${salesCount} over past 7 days`);

  console.log('\nâœ… Seed complete!');
  console.log('\nLogin credentials (PIN):');
  console.log(`  Owner (${owner.name}): PIN 1234`);
  console.log(`  Seller 1 (${seller1.name}): PIN 5678`);
  console.log(`  Seller 2 (${seller2.name}): PIN 9012`);
  console.log(`\nBusiness ID: ${businessId}`);
  console.log(`Depot ID:    ${depotId}`);
}

main()
  .catch(e => { console.error(e); process.exit(1); })
  .finally(() => prisma.$disconnect());

