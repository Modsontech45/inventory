import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service.js';
import { CreateSaleDto, CancelSaleDto } from './sales.dto.js';
import { StockMovementType, SaleStatus } from '@prisma/client';

@Injectable()
export class SalesService {
  constructor(private prisma: PrismaService) {}

  async create(dto: CreateSaleDto, businessId: string, depotId: string, userId: string, deviceId: string) {
    const totalAmount = dto.lines.reduce((s, l) => s + l.lineTotal, 0);
    const totalPaid = dto.payments.reduce((s, p) => s + p.amount, 0);

    if (totalPaid < totalAmount) {
      const hasCredit = dto.payments.some((p) => p.method === 'CREDIT');
      if (!hasCredit) throw new BadRequestException('Paiement insuffisant');
    }

    const number = await this.generateSaleNumber(businessId, depotId, deviceId);

    const sale = await this.prisma.sale.create({
      data: {
        id: dto.id,
        businessId,
        depotId,
        customerId: dto.customerId,
        userId,
        deviceId,
        number,
        totalAmount,
        cashSessionId: dto.cashSessionId,
        notes: dto.notes,
        lines: {
          create: dto.lines.map((l) => ({
            id: l.id,
            businessId,
            productId: l.productId,
            unitId: l.unitId,
            qty: l.qty,
            unitPrice: l.unitPrice,
            discount: l.discount,
            lineTotal: l.lineTotal,
          })),
        },
        payments: {
          create: dto.payments.map((p) => ({
            id: p.id,
            businessId,
            depotId,
            deviceId,
            method: p.method,
            amount: p.amount,
            reference: p.reference,
          })),
        },
      },
      include: { lines: true, payments: true },
    });

    // Create stock exit movements for each line
    for (const line of dto.lines) {
      const unit = await this.prisma.productUnit.findUnique({ where: { id: line.unitId } });
      if (!unit) continue;
      const qtyInBase = line.qty * unit.factor;

      await this.prisma.stockMovement.create({
        data: {
          id: crypto.randomUUID(),
          businessId,
          depotId,
          productId: line.productId,
          userId,
          deviceId,
          type: StockMovementType.SALE_EXIT,
          qtyInBase: -qtyInBase,
          refDocId: dto.id,
          refDocType: 'SALE',
        },
      });

      await this.prisma.productStockLevel.upsert({
        where: { productId_depotId: { productId: line.productId, depotId } },
        create: {
          id: crypto.randomUUID(),
          businessId,
          productId: line.productId,
          depotId,
          cachedQty: -qtyInBase,
        },
        update: { cachedQty: { decrement: qtyInBase } },
      });
    }

    return sale;
  }

  async findAll(businessId: string, depotId: string, query: { from?: string; to?: string; period?: string; customerId?: string; page?: number }) {
    const where: any = { businessId, deleted: false, status: SaleStatus.ACTIVE };
    if (depotId) where.depotId = depotId;

    // period shorthand: today | week | month
    if (query.period && !query.from) {
      const now = new Date();
      if (query.period === 'today') {
        const start = new Date(now.getFullYear(), now.getMonth(), now.getDate());
        where.createdAt = { gte: start };
      } else if (query.period === 'week') {
        const start = new Date(now); start.setDate(now.getDate() - 7);
        where.createdAt = { gte: start };
      } else if (query.period === 'month') {
        const start = new Date(now.getFullYear(), now.getMonth(), 1);
        where.createdAt = { gte: start };
      }
    }

    if (query.from) where.createdAt = { ...where.createdAt, gte: new Date(query.from) };
    if (query.to) where.createdAt = { ...where.createdAt, lte: new Date(query.to) };
    if (query.customerId) where.customerId = query.customerId;

    const page = query.page ?? 1;
    const take = 50;

    const [sales, total] = await Promise.all([
      this.prisma.sale.findMany({
        where,
        include: {
          lines: { include: { product: { select: { name: true } }, unit: { select: { name: true } } } },
          payments: true,
          customer: { select: { id: true, name: true, phone: true } },
        },
        orderBy: { createdAt: 'desc' },
        skip: (page - 1) * take,
        take,
      }),
      this.prisma.sale.count({ where }),
    ]);

    return { sales, total, page, totalPages: Math.ceil(total / take) };
  }

  async findOne(id: string, businessId: string) {
    const sale = await this.prisma.sale.findFirst({
      where: { id, businessId, deleted: false },
      include: {
        lines: { include: { product: true, unit: true } },
        payments: true,
        customer: true,
      },
    });
    if (!sale) throw new NotFoundException('Vente introuvable');
    return sale;
  }

  async cancel(id: string, dto: CancelSaleDto, businessId: string, depotId: string, userId: string, deviceId: string) {
    const sale = await this.prisma.sale.findFirst({
      where: { id, businessId, status: SaleStatus.ACTIVE },
      include: { lines: { include: { unit: true } } },
    });
    if (!sale) throw new NotFoundException('Vente introuvable ou déjà annulée');

    await this.prisma.sale.update({
      where: { id },
      data: { status: SaleStatus.CANCELLED, cancelReason: dto.reason, cancelledBy: userId },
    });

    for (const line of sale.lines) {
      const qtyInBase = line.qty * line.unit.factor;
      await this.prisma.stockMovement.create({
        data: {
          id: crypto.randomUUID(),
          businessId,
          depotId,
          productId: line.productId,
          userId,
          deviceId,
          type: StockMovementType.CUSTOMER_RETURN,
          qtyInBase: qtyInBase,
          refDocId: id,
          refDocType: 'SALE',
          reason: `Annulation vente ${sale.number}: ${dto.reason}`,
        },
      });

      await this.prisma.productStockLevel.upsert({
        where: { productId_depotId: { productId: line.productId, depotId } },
        create: {
          id: crypto.randomUUID(),
          businessId,
          productId: line.productId,
          depotId,
          cachedQty: qtyInBase,
        },
        update: { cachedQty: { increment: qtyInBase } },
      });
    }
  }

  async getDailySummary(businessId: string, depotId: string, date?: string) {
    const d = date ? new Date(date) : new Date();
    const start = new Date(d.getFullYear(), d.getMonth(), d.getDate(), 0, 0, 0);
    const end = new Date(d.getFullYear(), d.getMonth(), d.getDate(), 23, 59, 59);

    const [sales, payments] = await Promise.all([
      this.prisma.sale.findMany({
        where: { businessId, depotId, status: SaleStatus.ACTIVE, createdAt: { gte: start, lte: end } },
        select: { id: true, totalAmount: true, createdAt: true },
      }),
      this.prisma.salePayment.findMany({
        where: {
          businessId,
          depotId,
          deleted: false,
          createdAt: { gte: start, lte: end },
          sale: { status: SaleStatus.ACTIVE },
        },
        select: { method: true, amount: true },
      }),
    ]);

    const byMethod: Record<string, number> = {};
    for (const p of payments) {
      byMethod[p.method] = (byMethod[p.method] ?? 0) + p.amount;
    }

    return {
      date: d.toISOString().split('T')[0],
      saleCount: sales.length,
      totalAmount: sales.reduce((s, x) => s + x.totalAmount, 0),
      byMethod,
    };
  }

  private async generateSaleNumber(businessId: string, depotId: string, deviceId: string): Promise<string> {
    const depot = await this.prisma.depot.findUnique({ where: { id: depotId }, select: { name: true } });
    const prefix = (depot?.name ?? 'DEP').substring(0, 3).toUpperCase();
    const year = new Date().getFullYear();
    const count = await this.prisma.sale.count({ where: { businessId, depotId, createdAt: { gte: new Date(year, 0, 1) } } });
    const seq = String(count + 1).padStart(6, '0');
    return `${prefix}-${year}-${seq}`;
  }
}
