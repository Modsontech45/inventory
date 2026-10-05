import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service.js';
import { SaleStatus, StockMovementType } from '@prisma/client';

export interface ReportFilters {
  businessId: string;
  depotId?: string;
  from?: string;
  to?: string;
  productId?: string;
  categoryId?: string;
  customerId?: string;
  userId?: string;
  paymentMethod?: string;
  page?: number;
}

function dateRange(from?: string, to?: string) {
  const gte = from ? new Date(from) : undefined;
  const lte = to ? new Date(to + 'T23:59:59.999Z') : undefined;
  return gte || lte ? { ...(gte ? { gte } : {}), ...(lte ? { lte } : {}) } : undefined;
}

@Injectable()
export class ReportsService {
  constructor(private prisma: PrismaService) {}

  // ── R1: Daily sales journal ──────────────────────────────────────────────
  async dailySalesJournal(f: ReportFilters) {
    const where: any = {
      businessId: f.businessId,
      status: SaleStatus.ACTIVE,
      deleted: false,
      ...(f.depotId ? { depotId: f.depotId } : {}),
      ...(f.userId ? { userId: f.userId } : {}),
      ...(f.customerId ? { customerId: f.customerId } : {}),
    };
    const dr = dateRange(f.from, f.to);
    if (dr) where.createdAt = dr;

    return this.prisma.sale.findMany({
      where,
      include: {
        lines: { include: { product: { select: { name: true, brand: true } }, unit: { select: { name: true } } } },
        payments: true,
        customer: { select: { id: true, name: true, phone: true } },
        user: { select: { id: true, name: true } },
        depot: { select: { id: true, name: true } },
      },
      orderBy: { createdAt: 'desc' },
      skip: ((f.page ?? 1) - 1) * 100,
      take: 100,
    });
  }

  // ── R2: Sales by payment method ──────────────────────────────────────────
  async salesByPaymentMethod(f: ReportFilters) {
    const where: any = {
      businessId: f.businessId,
      deleted: false,
      sale: { status: SaleStatus.ACTIVE, deleted: false, ...(f.depotId ? { depotId: f.depotId } : {}) },
    };
    const dr = dateRange(f.from, f.to);
    if (dr) where.createdAt = dr;
    if (f.paymentMethod) where.method = f.paymentMethod;

    const rows = await this.prisma.salePayment.groupBy({
      by: ['method'],
      where,
      _sum: { amount: true },
      _count: { id: true },
    });

    return rows.map((r) => ({ method: r.method, total: r._sum.amount ?? 0, count: r._count.id }));
  }

  // ── R3: Sales by product / category / brand ──────────────────────────────
  async salesByProduct(f: ReportFilters) {
    const where: any = {
      businessId: f.businessId,
      deleted: false,
      sale: { status: SaleStatus.ACTIVE, deleted: false, ...(f.depotId ? { depotId: f.depotId } : {}) },
    };
    const dr = dateRange(f.from, f.to);
    if (dr) where.createdAt = dr;
    if (f.productId) where.productId = f.productId;

    const lines = await this.prisma.saleLine.findMany({
      where,
      include: {
        product: { select: { id: true, name: true, brand: true, category: { select: { id: true, name: true } } } },
        unit: { select: { id: true, name: true, factor: true, purchasePrice: true } },
      },
    });

    // Aggregate by product
    const map = new Map<string, { productId: string; name: string; brand: string | null; category: string | null; totalQty: number; totalRevenue: number; totalCost: number }>();
    for (const l of lines) {
      const key = l.productId;
      const existing = map.get(key);
      const cost = l.qty * (l.unit.purchasePrice ?? 0);
      if (existing) {
        existing.totalQty += l.qty;
        existing.totalRevenue += l.lineTotal;
        existing.totalCost += cost;
      } else {
        map.set(key, {
          productId: l.productId,
          name: l.product.name,
          brand: l.product.brand,
          category: l.product.category?.name ?? null,
          totalQty: l.qty,
          totalRevenue: l.lineTotal,
          totalCost: cost,
        });
      }
    }

    return Array.from(map.values())
      .map((p) => ({ ...p, grossProfit: p.totalRevenue - p.totalCost, marginPct: p.totalRevenue > 0 ? Math.round(((p.totalRevenue - p.totalCost) / p.totalRevenue) * 100) : 0 }))
      .sort((a, b) => b.totalRevenue - a.totalRevenue);
  }

  // ── R5: Profit report ────────────────────────────────────────────────────
  async profitReport(f: ReportFilters) {
    const where: any = {
      businessId: f.businessId,
      status: SaleStatus.ACTIVE,
      deleted: false,
      ...(f.depotId ? { depotId: f.depotId } : {}),
    };
    const dr = dateRange(f.from, f.to);
    if (dr) where.createdAt = dr;

    const expenseWhere: any = { businessId: f.businessId, deleted: false, ...(f.depotId ? { depotId: f.depotId } : {}) };
    if (dr) expenseWhere.createdAt = dr;

    const [sales, expenses] = await Promise.all([
      this.prisma.sale.findMany({
        where,
        select: {
          id: true, totalAmount: true, createdAt: true,
          lines: { select: { qty: true, lineTotal: true, unit: { select: { purchasePrice: true, factor: true } } } },
        },
      }),
      this.prisma.expense.findMany({ where: expenseWhere, select: { amount: true, category: true } }),
    ]);

    const totalRevenue = sales.reduce((s, sale) => s + sale.totalAmount, 0);
    const totalCOGS = sales.reduce((s, sale) => s + sale.lines.reduce((ls, l) => ls + l.qty * (l.unit.purchasePrice ?? 0), 0), 0);
    const totalExpenses = expenses.reduce((s, e) => s + e.amount, 0);
    const grossProfit = totalRevenue - totalCOGS;
    const netProfit = grossProfit - totalExpenses;

    const byCategory: Record<string, number> = {};
    for (const e of expenses) { byCategory[e.category] = (byCategory[e.category] ?? 0) + e.amount; }

    return { totalRevenue, totalCOGS, grossProfit, grossMarginPct: totalRevenue > 0 ? Math.round((grossProfit / totalRevenue) * 100) : 0, totalExpenses, netProfit, expensesByCategory: byCategory, saleCount: sales.length };
  }

  // ── R7: Current stock ────────────────────────────────────────────────────
  async currentStock(f: ReportFilters) {
    const where: any = { businessId: f.businessId, ...(f.depotId ? { depotId: f.depotId } : {}) };

    const levels = await this.prisma.productStockLevel.findMany({
      where,
      include: {
        product: {
          select: {
            id: true, name: true, brand: true, archived: true,
            category: { select: { name: true } },
            units: { where: { isBase: true, deleted: false }, select: { name: true, purchasePrice: true, retailPrice: true } },
          },
        },
        depot: { select: { id: true, name: true } },
      },
    });

    return levels
      .filter((l) => !l.product.archived)
      .map((l) => {
        const baseUnit = l.product.units[0];
        return {
          productId: l.productId,
          name: l.product.name,
          brand: l.product.brand,
          category: l.product.category?.name,
          depot: l.depot.name,
          depotId: l.depotId,
          qtyInBase: l.cachedQty,
          baseUnitName: baseUnit?.name ?? 'u',
          costValue: l.cachedQty * (baseUnit?.purchasePrice ?? 0),
          saleValue: l.cachedQty * (baseUnit?.retailPrice ?? 0),
          minLevel: l.minLevel,
          isLowStock: l.cachedQty > 0 && l.cachedQty <= l.minLevel && l.minLevel > 0,
          isOutOfStock: l.cachedQty <= 0,
          isNegative: l.cachedQty < 0,
        };
      });
  }

  // ── R8: Stock movements ──────────────────────────────────────────────────
  async stockMovements(f: ReportFilters) {
    const where: any = { businessId: f.businessId, deleted: false, ...(f.depotId ? { depotId: f.depotId } : {}), ...(f.productId ? { productId: f.productId } : {}) };
    const dr = dateRange(f.from, f.to);
    if (dr) where.createdAt = dr;

    const [movements, total] = await Promise.all([
      this.prisma.stockMovement.findMany({
        where,
        include: {
          product: { select: { id: true, name: true, brand: true } },
          user: { select: { id: true, name: true } },
          depot: { select: { id: true, name: true } },
        },
        orderBy: { createdAt: 'desc' },
        skip: ((f.page ?? 1) - 1) * 100,
        take: 100,
      }),
      this.prisma.stockMovement.count({ where }),
    ]);

    return { movements, total, page: f.page ?? 1, totalPages: Math.ceil(total / 100) };
  }

  // ── R10: Low stock / reorder list ────────────────────────────────────────
  async lowStockList(f: ReportFilters) {
    const levels = await this.currentStock(f);
    return levels.filter((l) => l.isLowStock || l.isOutOfStock || l.isNegative).sort((a, b) => a.qtyInBase - b.qtyInBase);
  }

  // ── R11: Customer debts ──────────────────────────────────────────────────
  async customerDebts(f: ReportFilters) {
    const where: any = { businessId: f.businessId, deleted: false, ...(f.customerId ? { id: f.customerId } : {}) };

    const customers = await this.prisma.customer.findMany({
      where,
      select: { id: true, name: true, phone: true, type: true, creditLimit: true },
    });

    const withBalances = await Promise.all(
      customers.map(async (c) => {
        const [creditSales, repayments] = await Promise.all([
          this.prisma.salePayment.aggregate({
            where: { businessId: f.businessId, method: 'CREDIT', deleted: false, sale: { customerId: c.id, status: 'ACTIVE' } },
            _sum: { amount: true },
          }),
          this.prisma.customerPayment.aggregate({
            where: { businessId: f.businessId, customerId: c.id },
            _sum: { amount: true },
          }),
        ]);
        return {
          ...c,
          totalDebt: creditSales._sum.amount ?? 0,
          totalPaid: repayments._sum.amount ?? 0,
          balance: (creditSales._sum.amount ?? 0) - (repayments._sum.amount ?? 0),
        };
      }),
    );

    return withBalances.filter((c) => c.balance > 0).sort((a, b) => b.balance - a.balance);
  }

  // ── R16: Sales by employee ───────────────────────────────────────────────
  async salesByEmployee(f: ReportFilters) {
    const where: any = { businessId: f.businessId, status: SaleStatus.ACTIVE, deleted: false, ...(f.depotId ? { depotId: f.depotId } : {}) };
    const dr = dateRange(f.from, f.to);
    if (dr) where.createdAt = dr;

    const sales = await this.prisma.sale.findMany({
      where,
      select: {
        userId: true,
        totalAmount: true,
        discountAmount: true,
        user: { select: { id: true, name: true, role: true } },
      },
    });

    const cancelledSales = await this.prisma.sale.findMany({
      where: { ...where, status: SaleStatus.CANCELLED },
      select: { cancelledBy: true },
    });

    const map = new Map<string, { userId: string; name: string; role: string; saleCount: number; totalAmount: number; totalDiscount: number; cancellations: number }>();
    for (const s of sales) {
      const key = s.userId;
      const existing = map.get(key);
      if (existing) {
        existing.saleCount++;
        existing.totalAmount += s.totalAmount;
        existing.totalDiscount += s.discountAmount;
      } else {
        map.set(key, { userId: s.userId, name: s.user.name, role: s.user.role, saleCount: 1, totalAmount: s.totalAmount, totalDiscount: s.discountAmount, cancellations: 0 });
      }
    }
    for (const c of cancelledSales) {
      if (c.cancelledBy && map.has(c.cancelledBy)) {
        map.get(c.cancelledBy)!.cancellations++;
      }
    }

    return Array.from(map.values()).sort((a, b) => b.totalAmount - a.totalAmount);
  }

  // ── R17: Cancellations and discounts ─────────────────────────────────────
  async cancellationsAndDiscounts(f: ReportFilters) {
    const where: any = { businessId: f.businessId, deleted: false, ...(f.depotId ? { depotId: f.depotId } : {}) };
    const dr = dateRange(f.from, f.to);
    if (dr) where.createdAt = dr;

    const [cancelled, discounted] = await Promise.all([
      this.prisma.sale.findMany({
        where: { ...where, status: SaleStatus.CANCELLED },
        include: { user: { select: { name: true } }, customer: { select: { name: true } } },
        orderBy: { createdAt: 'desc' },
        take: 200,
      }),
      this.prisma.sale.findMany({
        where: { ...where, status: SaleStatus.ACTIVE, discountAmount: { gt: 0 } },
        select: { id: true, number: true, totalAmount: true, discountAmount: true, createdAt: true, user: { select: { name: true } }, customer: { select: { name: true } } },
        orderBy: { createdAt: 'desc' },
        take: 200,
      }),
    ]);

    return { cancelled, discounted };
  }

  // ── Time-series data for graphs ──────────────────────────────────────────
  async salesTimeSeries(f: ReportFilters, days: number = 30) {
    const to = f.to ? new Date(f.to) : new Date();
    const from = f.from ? new Date(f.from) : new Date(to.getTime() - days * 86400000);

    const where: any = {
      businessId: f.businessId,
      status: SaleStatus.ACTIVE,
      deleted: false,
      createdAt: { gte: from, lte: to },
      ...(f.depotId ? { depotId: f.depotId } : {}),
    };

    const sales = await this.prisma.sale.findMany({
      where,
      select: { totalAmount: true, createdAt: true },
    });

    // Group by day
    const byDay = new Map<string, number>();
    for (const s of sales) {
      const key = s.createdAt.toISOString().split('T')[0];
      byDay.set(key, (byDay.get(key) ?? 0) + s.totalAmount);
    }

    // Fill all days in range
    const result: { date: string; total: number }[] = [];
    const cursor = new Date(from);
    while (cursor <= to) {
      const key = cursor.toISOString().split('T')[0];
      result.push({ date: key, total: byDay.get(key) ?? 0 });
      cursor.setDate(cursor.getDate() + 1);
    }

    return result;
  }

  // ── Top products ──────────────────────────────────────────────────────────
  async topProducts(f: ReportFilters, limit = 10) {
    const all = await this.salesByProduct(f);
    return { top: all.slice(0, limit), bottom: all.slice(-limit).reverse() };
  }
}
