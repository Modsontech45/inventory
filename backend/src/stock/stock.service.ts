import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service.js';
import { StockMovementType } from '@prisma/client';

@Injectable()
export class StockService {
  constructor(private prisma: PrismaService) {}

  async getCurrentStock(businessId: string, depotId?: string) {
    const levels = await this.prisma.productStockLevel.findMany({
      where: { businessId, ...(depotId ? { depotId } : {}) },
      include: {
        product: {
          include: {
            units: { where: { deleted: false, isBase: true } },
            category: { select: { name: true } },
          },
        },
        depot: { select: { id: true, name: true } },
      },
      orderBy: { product: { name: 'asc' } },
    });

    return levels.map((l) => ({
      ...l,
      isLowStock: l.cachedQty <= l.minLevel && l.minLevel > 0,
      isOutOfStock: l.cachedQty <= 0,
    }));
  }

  async getMovements(businessId: string, filters: { depotId?: string; productId?: string; from?: string; to?: string; page?: number }) {
    const where: any = { businessId, deleted: false };
    if (filters.depotId) where.depotId = filters.depotId;
    if (filters.productId) where.productId = filters.productId;
    if (filters.from || filters.to) {
      where.createdAt = {};
      if (filters.from) where.createdAt.gte = new Date(filters.from);
      if (filters.to) where.createdAt.lte = new Date(filters.to);
    }

    const page = filters.page ?? 1;
    const take = 100;

    const [movements, total] = await Promise.all([
      this.prisma.stockMovement.findMany({
        where,
        include: {
          product: { select: { id: true, name: true } },
          user: { select: { id: true, name: true } },
          depot: { select: { id: true, name: true } },
        },
        orderBy: { createdAt: 'desc' },
        skip: (page - 1) * take,
        take,
      }),
      this.prisma.stockMovement.count({ where }),
    ]);

    return { movements, total, page, totalPages: Math.ceil(total / take) };
  }

  async recordAdjustment(
    businessId: string,
    depotId: string,
    productId: string,
    qtyInBase: number,
    reason: string,
    userId: string,
    deviceId: string,
  ) {
    const type = qtyInBase >= 0 ? StockMovementType.ADJUSTMENT_PLUS : StockMovementType.ADJUSTMENT_MINUS;

    await this.prisma.$transaction(async (tx) => {
      await tx.stockMovement.create({
        data: {
          id: crypto.randomUUID(),
          businessId,
          depotId,
          productId,
          userId,
          deviceId,
          type,
          qtyInBase,
          reason,
        },
      });

      await tx.productStockLevel.upsert({
        where: { productId_depotId: { productId, depotId } },
        create: { id: crypto.randomUUID(), businessId, productId, depotId, cachedQty: qtyInBase },
        update: { cachedQty: { increment: qtyInBase } },
      });
    });
  }

  async setMinStockLevel(businessId: string, depotId: string, productId: string, minLevel: number) {
    await this.prisma.productStockLevel.upsert({
      where: { productId_depotId: { productId, depotId } },
      create: { id: crypto.randomUUID(), businessId, productId, depotId, minLevel },
      update: { minLevel },
    });
  }

  async getLowStockAlerts(businessId: string, depotId?: string) {
    const levels = await this.prisma.productStockLevel.findMany({
      where: { businessId, ...(depotId ? { depotId } : {}) },
      include: {
        product: { select: { id: true, name: true, brand: true } },
        depot: { select: { id: true, name: true } },
      },
    });

    return levels.filter((l) => l.cachedQty <= l.minLevel).map((l) => ({
      productId: l.productId,
      productName: l.product.name,
      brand: l.product.brand,
      depotId: l.depotId,
      depotName: l.depot.name,
      currentQty: l.cachedQty,
      minLevel: l.minLevel,
      isNegative: l.cachedQty < 0,
    }));
  }

  async rebuildCachedStock(businessId: string, depotId: string) {
    const movements = await this.prisma.stockMovement.findMany({
      where: { businessId, depotId, deleted: false },
      select: { productId: true, qtyInBase: true },
    });

    const totals = new Map<string, number>();
    for (const m of movements) {
      totals.set(m.productId, (totals.get(m.productId) ?? 0) + m.qtyInBase);
    }

    for (const [productId, qty] of totals) {
      await this.prisma.productStockLevel.upsert({
        where: { productId_depotId: { productId, depotId } },
        create: { id: crypto.randomUUID(), businessId, productId, depotId, cachedQty: qty },
        update: { cachedQty: qty },
      });
    }

    return { rebuilt: totals.size };
  }
}
