import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service.js';
import { PaymentMethod } from '@prisma/client';

@Injectable()
export class CustomersService {
  constructor(private prisma: PrismaService) {}

  async findAll(businessId: string) {
    const customers = await this.prisma.customer.findMany({
      where: { businessId, deleted: false },
      orderBy: { name: 'asc' },
    });

    return Promise.all(
      customers.map(async (c) => ({
        ...c,
        totalDebt: await this.getCustomerBalance(c.id, businessId),
      })),
    );
  }

  async findOne(id: string, businessId: string) {
    const customer = await this.prisma.customer.findFirst({
      where: { id, businessId, deleted: false },
      include: {
        sales: {
          where: { deleted: false },
          select: { id: true, number: true, totalAmount: true, createdAt: true, status: true, payments: true },
          orderBy: { createdAt: 'desc' },
          take: 50,
        },
        payments: { orderBy: { createdAt: 'desc' }, take: 50 },
      },
    });
    if (!customer) throw new NotFoundException('Client introuvable');

    const balance = await this.getCustomerBalance(id, businessId);

    // Merge sales and debt payments into a single sorted transaction list
    const saleTxs = (customer.sales as any[]).map((s) => ({ ...s, type: 'SALE', amount: s.totalAmount }));
    const paymentTxs = (customer.payments as any[]).map((p) => ({ ...p, type: 'PAYMENT', totalAmount: p.amount }));
    const recentTransactions = [...saleTxs, ...paymentTxs]
      .sort((a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime())
      .slice(0, 50);

    const totalPurchased = (customer.sales as any[]).reduce((s: number, sale: any) => s + (sale.totalAmount ?? 0), 0);

    return { ...customer, balance, totalDebt: balance, totalPurchased, recentTransactions };
  }

  async create(data: any, businessId: string, userId: string, deviceId: string) {
    return this.prisma.customer.create({
      data: {
        id: data.id ?? crypto.randomUUID(),
        businessId,
        name: data.name,
        phone: data.phone,
        type: data.type ?? 'INDIVIDUAL',
        address: data.address,
        notes: data.notes,
        creditLimit: data.creditLimit,
        createdBy: userId,
        deviceId,
      },
    });
  }

  async update(id: string, data: any, businessId: string) {
    const existing = await this.prisma.customer.findFirst({ where: { id, businessId, deleted: false } });
    if (!existing) throw new NotFoundException('Client introuvable');

    return this.prisma.customer.update({
      where: { id },
      data: { name: data.name, phone: data.phone, type: data.type, address: data.address, notes: data.notes, creditLimit: data.creditLimit },
    });
  }

  async recordPayment(customerId: string, amount: number, method: PaymentMethod, reference: string | undefined, businessId: string, depotId: string | undefined, userId: string, deviceId: string | undefined) {
    const customer = await this.prisma.customer.findFirst({ where: { id: customerId, businessId, deleted: false } });
    if (!customer) throw new NotFoundException('Client introuvable');

    // Use provided depotId or fall back to the business's first depot
    let resolvedDepotId = depotId;
    if (!resolvedDepotId) {
      const depot = await this.prisma.depot.findFirst({ where: { businessId } });
      resolvedDepotId = depot?.id;
    }

    return this.prisma.customerPayment.create({
      data: {
        id: crypto.randomUUID(),
        businessId,
        depotId: resolvedDepotId,
        customerId,
        userId,
        deviceId,
        amount,
        method,
        reference,
      },
    });
  }

  async getCustomerBalance(customerId: string, businessId: string): Promise<number> {
    // Step 1: get sale IDs for this customer (avoid nested relation filter in aggregate)
    const customerSales = await this.prisma.sale.findMany({
      where: { businessId, customerId, deleted: false },
      select: { id: true },
    });
    const saleIds = customerSales.map((s) => s.id);

    let totalDebt = 0;
    if (saleIds.length > 0) {
      const creditPayments = await this.prisma.salePayment.aggregate({
        where: { businessId, method: 'CREDIT', deleted: false, saleId: { in: saleIds } },
        _sum: { amount: true },
      });
      totalDebt = creditPayments._sum.amount ?? 0;
    }

    const repayments = await this.prisma.customerPayment.aggregate({
      where: { businessId, customerId },
      _sum: { amount: true },
    });
    const totalPaid = repayments._sum.amount ?? 0;

    return totalDebt - totalPaid;
  }

  async getDebtors(businessId: string) {
    const customers = await this.prisma.customer.findMany({
      where: { businessId, deleted: false },
      select: { id: true, name: true, phone: true, type: true, creditLimit: true },
    });

    const withBalances = await Promise.all(
      customers.map(async (c) => ({
        ...c,
        balance: await this.getCustomerBalance(c.id, businessId),
      })),
    );

    return withBalances.filter((c) => c.balance > 0).sort((a, b) => b.balance - a.balance);
  }
}
