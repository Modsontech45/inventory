import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service.js';
import { SaleStatus } from '@prisma/client';
import { ReportsService } from '../reports/reports.service.js';

type Period = 'today' | 'week' | 'month' | 'custom';

function periodRange(period: Period, from?: string, to?: string): { gte: Date; lte: Date } {
  const now = new Date();
  const lte = to ? new Date(to + 'T23:59:59.999Z') : new Date(now.getFullYear(), now.getMonth(), now.getDate(), 23, 59, 59);

  let gte: Date;
  if (period === 'today') {
    gte = new Date(now.getFullYear(), now.getMonth(), now.getDate(), 0, 0, 0);
  } else if (period === 'week') {
    const day = now.getDay();
    gte = new Date(now);
    gte.setDate(now.getDate() - day);
    gte.setHours(0, 0, 0, 0);
  } else if (period === 'month') {
    gte = new Date(now.getFullYear(), now.getMonth(), 1, 0, 0, 0);
  } else {
    gte = from ? new Date(from) : new Date(now.getFullYear(), now.getMonth(), 1, 0, 0, 0);
  }

  return { gte, lte };
}

@Injectable()
export class DashboardService {
  constructor(
    private prisma: PrismaService,
    private reports: ReportsService,
  ) {}

  async getSummary(businessId: string, depotId?: string, period: Period = 'today', from?: string, to?: string) {
    const { gte, lte } = periodRange(period, from, to);
    const salesWhere: any = {
      businessId,
      status: SaleStatus.ACTIVE,
      deleted: false,
      createdAt: { gte, lte },
      ...(depotId ? { depotId } : {}),
    };

    const [
      salesData,
      paymentsData,
      stockLevels,
      debtors,
      expenses,
      lowStockCount,
      negativeStockCount,
      recentSales,
      byEmployee,
    ] = await Promise.all([
      // Aggregate sales
      this.prisma.sale.aggregate({
        where: salesWhere,
        _sum: { totalAmount: true, discountAmount: true },
        _count: { id: true },
      }),

      // Breakdown by payment method
      this.prisma.salePayment.groupBy({
        by: ['method'],
        where: {
          businessId,
          deleted: false,
          createdAt: { gte, lte },
          sale: { status: SaleStatus.ACTIVE, deleted: false, ...(depotId ? { depotId } : {}) },
        },
        _sum: { amount: true },
      }),

      // Stock levels for value calculation
      this.prisma.productStockLevel.findMany({
        where: { businessId, ...(depotId ? { depotId } : {}) },
        include: {
          product: {
            select: { archived: true, units: { where: { isBase: true, deleted: false }, select: { purchasePrice: true, retailPrice: true } } },
          },
        },
      }),

      // Customer debt total
      this.prisma.salePayment.aggregate({
        where: { businessId, method: 'CREDIT', deleted: false, sale: { status: 'ACTIVE', deleted: false } },
        _sum: { amount: true },
      }),

      // Expenses in period
      this.prisma.expense.aggregate({
        where: { businessId, deleted: false, createdAt: { gte, lte }, ...(depotId ? { depotId } : {}) },
        _sum: { amount: true },
      }),

      // Low stock count
      this.prisma.productStockLevel.count({
        where: { businessId, ...(depotId ? { depotId } : {}), cachedQty: { lte: this.prisma.productStockLevel.fields.minLevel as any, gt: 0 } },
      }).catch(() => 0),

      // Negative stock count
      this.prisma.productStockLevel.count({
        where: { businessId, ...(depotId ? { depotId } : {}), cachedQty: { lt: 0 } },
      }),

      // Last 10 sales
      this.prisma.sale.findMany({
        where: salesWhere,
        include: {
          user: { select: { id: true, name: true } },
          customer: { select: { id: true, name: true } },
          payments: { select: { method: true, amount: true } },
        },
        orderBy: { createdAt: 'desc' },
        take: 10,
      }),

      // Sales by employee for period
      this.prisma.sale.groupBy({
        by: ['userId'],
        where: salesWhere,
        _sum: { totalAmount: true },
        _count: { id: true },
      }),
    ]);

    // Compute stock values
    const activeStock = stockLevels.filter((l) => !l.product.archived);
    const stockCostValue = activeStock.reduce((s, l) => s + l.cachedQty * (l.product.units[0]?.purchasePrice ?? 0), 0);
    const stockSaleValue = activeStock.reduce((s, l) => s + l.cachedQty * (l.product.units[0]?.retailPrice ?? 0), 0);

    // Compute COGS for gross profit
    const saleLines = await this.prisma.saleLine.findMany({
      where: {
        businessId,
        deleted: false,
        sale: { status: SaleStatus.ACTIVE, deleted: false, createdAt: { gte, lte }, ...(depotId ? { depotId } : {}) },
      },
      select: { qty: true, lineTotal: true, unit: { select: { purchasePrice: true } } },
    });
    const cogs = saleLines.reduce((s, l) => s + l.qty * (l.unit.purchasePrice ?? 0), 0);
    const totalRevenue = salesData._sum.totalAmount ?? 0;
    const grossProfit = totalRevenue - cogs;
    const expenseAmount = expenses._sum.amount ?? 0;
    const netProfit = grossProfit - expenseAmount;

    // Employee details
    const employeeIds = byEmployee.map((e) => e.userId);
    const employeeUsers = await this.prisma.user.findMany({
      where: { id: { in: employeeIds } },
      select: { id: true, name: true, role: true },
    });
    const employeeMap = Object.fromEntries(employeeUsers.map((u) => [u.id, u]));

    const employeeSales = byEmployee.map((e) => ({
      userId: e.userId,
      name: employeeMap[e.userId]?.name ?? 'Inconnu',
      role: employeeMap[e.userId]?.role ?? 'CASHIER',
      saleCount: e._count.id,
      totalAmount: e._sum.totalAmount ?? 0,
    })).sort((a, b) => b.totalAmount - a.totalAmount);

    // Payment method breakdown
    const paymentBreakdown = Object.fromEntries(paymentsData.map((p) => [p.method, p._sum.amount ?? 0]));

    // 7-day time series (always included for spark chart)
    const sparkFrom = new Date(Date.now() - 6 * 86400000);
    const sparkSales = await this.prisma.sale.findMany({
      where: {
        businessId,
        status: SaleStatus.ACTIVE,
        deleted: false,
        createdAt: { gte: sparkFrom },
        ...(depotId ? { depotId } : {}),
      },
      select: { totalAmount: true, createdAt: true },
    });
    const sparkMap = new Map<string, number>();
    for (const s of sparkSales) {
      const key = s.createdAt.toISOString().split('T')[0];
      sparkMap.set(key, (sparkMap.get(key) ?? 0) + s.totalAmount);
    }
    const sparkChart: { date: string; total: number }[] = [];
    for (let i = 6; i >= 0; i--) {
      const d = new Date(Date.now() - i * 86400000);
      const key = d.toISOString().split('T')[0];
      sparkChart.push({ date: key, total: sparkMap.get(key) ?? 0 });
    }

    // Customer repayments total (paid)
    const repayments = await this.prisma.customerPayment.aggregate({
      where: { businessId },
      _sum: { amount: true },
    });
    const totalDebt = Math.max(0, (debtors._sum.amount ?? 0) - (repayments._sum.amount ?? 0));

    // Top 8 products by revenue in period
    const topProductLines = await this.prisma.saleLine.groupBy({
      by: ['productId'],
      where: {
        businessId,
        deleted: false,
        sale: { status: SaleStatus.ACTIVE, deleted: false, createdAt: { gte, lte }, ...(depotId ? { depotId } : {}) },
      },
      _sum: { lineTotal: true, qty: true },
      orderBy: { _sum: { lineTotal: 'desc' } },
      take: 8,
    });
    const topProductIds = topProductLines.map((l) => l.productId);
    const topProductDetails = await this.prisma.product.findMany({
      where: { id: { in: topProductIds } },
      select: { id: true, name: true, brand: true },
    });
    const topProductMap = Object.fromEntries(topProductDetails.map((p) => [p.id, p]));
    const topProducts = topProductLines.map((l) => ({
      productId: l.productId,
      name: topProductMap[l.productId]?.name ?? '',
      brand: topProductMap[l.productId]?.brand ?? '',
      totalRevenue: l._sum.lineTotal ?? 0,
      totalQty: l._sum.qty ?? 0,
    }));

    // Low stock alerts with product names (max 10)
    const lowStockLevels = await this.prisma.productStockLevel.findMany({
      where: {
        businessId,
        ...(depotId ? { depotId } : {}),
        cachedQty: { lte: 5 },
      },
      include: { product: { select: { id: true, name: true, brand: true, archived: true } } },
      orderBy: { cachedQty: 'asc' },
      take: 10,
    });
    const stockAlerts = lowStockLevels
      .filter((l) => !l.product.archived)
      .map((l) => ({ productId: l.productId, name: l.product.name, brand: l.product.brand, qty: l.cachedQty, minLevel: l.minLevel }));

    return {
      period: { type: period, from: gte.toISOString(), to: lte.toISOString() },
      sales: {
        totalAmount: totalRevenue,
        saleCount: salesData._count.id,
        totalDiscount: salesData._sum.discountAmount ?? 0,
        byPaymentMethod: paymentBreakdown,
      },
      profit: {
        cogs,
        grossProfit,
        grossMarginPct: totalRevenue > 0 ? Math.round((grossProfit / totalRevenue) * 100) : 0,
        expenses: expenseAmount,
        netProfit,
      },
      stock: {
        costValue: stockCostValue,
        saleValue: stockSaleValue,
        lowStockCount,
        negativeStockCount,
      },
      debts: { totalCustomerDebt: totalDebt },
      employees: employeeSales,
      recentSales: recentSales.map((s) => ({
        id: s.id,
        number: (s as any).number,
        totalAmount: s.totalAmount,
        createdAt: s.createdAt,
        seller: s.user.name,
        sellerId: s.user.id,
        customer: s.customer?.name ?? null,
        payments: s.payments,
      })),
      sparkChart,
      topProducts,
      stockAlerts,
    };
  }
}
