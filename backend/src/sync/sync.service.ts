import { Injectable, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service.js';

// Tables that are append-only (events): rows are never updated after creation.
const APPEND_ONLY_TABLES = new Set([
  'sales', 'sale_lines', 'sale_payments', 'stock_movements',
  'customer_payments', 'supplier_payments', 'expenses',
  'cash_sessions', 'inventory_lines', 'audit_log', 'price_history',
  'receptions',
]);

// Tables that are master data: last-write-wins by updated_at.
const MASTER_DATA_TABLES = new Set([
  'products', 'product_units', 'product_stock_levels', 'categories',
  'customers', 'suppliers', 'users', 'depots', 'deliveries', 'delivery_lines',
  'transfers', 'transfer_lines', 'inventory_counts', 'quotes', 'quote_lines',
  'purchase_orders',
]);

// Maps table names to Prisma delegate keys
const TABLE_TO_MODEL: Record<string, string> = {
  sales: 'sale',
  sale_lines: 'saleLine',
  sale_payments: 'salePayment',
  stock_movements: 'stockMovement',
  customer_payments: 'customerPayment',
  supplier_payments: 'supplierPayment',
  expenses: 'expense',
  cash_sessions: 'cashSession',
  inventory_lines: 'inventoryLine',
  audit_log: 'auditLog',
  price_history: 'priceHistory',
  receptions: 'reception',
  products: 'product',
  product_units: 'productUnit',
  product_stock_levels: 'productStockLevel',
  categories: 'category',
  customers: 'customer',
  suppliers: 'supplier',
  users: 'user',
  depots: 'depot',
  deliveries: 'delivery',
  delivery_lines: 'deliveryLine',
  transfers: 'transfer',
  transfer_lines: 'transferLine',
  inventory_counts: 'inventoryCount',
  quotes: 'quote',
  quote_lines: 'quoteLine',
  purchase_orders: 'purchaseOrder',
};

export interface SyncRow {
  _table: string;
  id: string;
  [key: string]: any;
}

@Injectable()
export class SyncService {
  constructor(private prisma: PrismaService) {}

  async push(rows: SyncRow[], businessId: string, deviceId: string, appVersion: string) {
    this.checkAppVersion(appVersion);

    const accepted: string[] = [];
    const rejected: { id: string; table: string; reason: string }[] = [];

    for (const row of rows) {
      const { _table, ...data } = row;

      if (!TABLE_TO_MODEL[_table]) {
        rejected.push({ id: row.id, table: _table, reason: 'UNKNOWN_TABLE' });
        continue;
      }

      if (data.businessId && data.businessId !== businessId) {
        rejected.push({ id: row.id, table: _table, reason: 'BUSINESS_MISMATCH' });
        continue;
      }

      data.businessId = businessId;

      try {
        const model = (this.prisma as any)[TABLE_TO_MODEL[_table]];

        if (APPEND_ONLY_TABLES.has(_table)) {
          // Idempotent insert: ignore if already exists
          await model.upsert({
            where: { id: data.id },
            create: { ...data, serverReceivedAt: new Date() },
            update: {}, // Never update append-only rows
          });
        } else {
          // Master data: last-write-wins by updatedAt
          const existing = await model.findUnique({ where: { id: data.id } });
          if (!existing || !existing.updatedAt || !data.updatedAt || new Date(data.updatedAt) >= existing.updatedAt) {
            await model.upsert({
              where: { id: data.id },
              create: { ...data, serverReceivedAt: new Date() },
              update: { ...data, serverReceivedAt: new Date() },
            });
          }
        }

        accepted.push(row.id);
      } catch (err: any) {
        rejected.push({ id: row.id, table: _table, reason: err?.code ?? 'ERROR' });
      }
    }

    return { accepted, rejected, serverTime: new Date().toISOString() };
  }

  async pull(businessId: string, deviceId: string, since: bigint, limit: number, userRole: string) {
    const allRows: any[] = [];

    for (const [table, modelKey] of Object.entries(TABLE_TO_MODEL)) {
      const model = (this.prisma as any)[modelKey];
      if (!model) continue;

      try {
        const rows = await model.findMany({
          where: {
            businessId,
            serverSeq: { gt: since },
          },
          orderBy: { serverSeq: 'asc' },
          take: limit,
        });

        // Strip purchase prices for roles without permission
        const cleaned = rows.map((r: any) => {
          const out = { ...r, _table: table };
          if (userRole !== 'OWNER' && userRole !== 'MANAGER') {
            if ('purchasePrice' in out) out.purchasePrice = undefined;
          }
          return out;
        });

        allRows.push(...cleaned);
      } catch {
        // Table may not have serverSeq; skip gracefully
      }
    }

    // Sort all rows by serverSeq and take the first `limit`
    allRows.sort((a, b) => Number((a.serverSeq ?? 0n) - (b.serverSeq ?? 0n)));
    const page = allRows.slice(0, limit);
    const newCursor = page.length > 0 ? page[page.length - 1].serverSeq : since;

    return {
      rows: page,
      cursor: newCursor?.toString() ?? since.toString(),
      hasMore: allRows.length > limit,
      serverTime: new Date().toISOString(),
    };
  }

  private checkAppVersion(version: string) {
    const min = process.env.MIN_SUPPORTED_VERSION ?? '1.0.0';
    if (this.compareVersions(version, min) < 0) {
      throw new BadRequestException({
        code: 'VERSION_TOO_OLD',
        message: `Version ${version} non supportée. Mise à jour requise (min: ${min}).`,
        minVersion: min,
      });
    }
  }

  private compareVersions(a: string, b: string): number {
    const pa = a.split('.').map(Number);
    const pb = b.split('.').map(Number);
    for (let i = 0; i < 3; i++) {
      if ((pa[i] ?? 0) > (pb[i] ?? 0)) return 1;
      if ((pa[i] ?? 0) < (pb[i] ?? 0)) return -1;
    }
    return 0;
  }
}
