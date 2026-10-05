import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service.js';
import { CreateProductDto, UpdateProductDto } from './products.dto.js';

@Injectable()
export class ProductsService {
  constructor(private prisma: PrismaService) {}

  async findAll(businessId: string, depotId?: string) {
    const products = await this.prisma.product.findMany({
      where: { businessId, archived: false, deleted: false },
      include: {
        units: { where: { deleted: false } },
        category: true,
        stockLevels: depotId ? { where: { depotId } } : true,
      },
      orderBy: { name: 'asc' },
    });
    return products;
  }

  async findOne(id: string, businessId: string) {
    const product = await this.prisma.product.findFirst({
      where: { id, businessId, deleted: false },
      include: {
        units: { where: { deleted: false } },
        category: true,
        stockLevels: true,
        priceHistory: { orderBy: { createdAt: 'desc' }, take: 20 },
      },
    });
    if (!product) throw new NotFoundException('Produit introuvable');
    return product;
  }

  async create(dto: CreateProductDto, businessId: string, userId: string, deviceId: string) {
    const { units, minStockLevel, ...productData } = dto;

    const product = await this.prisma.product.create({
      data: {
        ...productData,
        businessId,
        createdBy: userId,
        deviceId,
        units: {
          create: units.map((u) => ({
            ...u,
            businessId,
          })),
        },
      },
      include: { units: true },
    });

    return product;
  }

  async update(id: string, dto: UpdateProductDto, businessId: string, userId: string, deviceId: string) {
    const existing = await this.prisma.product.findFirst({ where: { id, businessId, deleted: false } });
    if (!existing) throw new NotFoundException('Produit introuvable');

    const { units, ...productData } = dto;

    const priceHistoryEntries: any[] = [];
    if (units) {
      for (const unit of units) {
        const existingUnit = await this.prisma.productUnit.findUnique({ where: { id: unit.id } });
        if (existingUnit) {
          if (existingUnit.retailPrice !== unit.retailPrice) {
            priceHistoryEntries.push({ field: 'retailPrice', unitId: unit.id, oldValue: existingUnit.retailPrice, newValue: unit.retailPrice });
          }
          if (existingUnit.wholesalePrice !== unit.wholesalePrice) {
            priceHistoryEntries.push({ field: 'wholesalePrice', unitId: unit.id, oldValue: existingUnit.wholesalePrice, newValue: unit.wholesalePrice });
          }
          if (existingUnit.purchasePrice !== unit.purchasePrice) {
            priceHistoryEntries.push({ field: 'purchasePrice', unitId: unit.id, oldValue: existingUnit.purchasePrice, newValue: unit.purchasePrice });
          }
        }
      }
    }

    const updated = await this.prisma.product.update({
      where: { id },
      data: { ...productData, updatedAt: new Date() },
      include: { units: { where: { deleted: false } } },
    });

    if (units) {
      for (const unit of units) {
        await this.prisma.productUnit.upsert({
          where: { id: unit.id },
          create: { ...unit, businessId, productId: id },
          update: { ...unit },
        });
      }
    }

    for (const entry of priceHistoryEntries) {
      await this.prisma.priceHistory.create({
        data: {
          id: crypto.randomUUID(),
          businessId,
          productId: id,
          unitId: entry.unitId,
          field: entry.field,
          oldValue: entry.oldValue,
          newValue: entry.newValue,
          changedBy: userId,
          deviceId,
        },
      });
    }

    return updated;
  }

  async archive(id: string, businessId: string) {
    await this.prisma.product.updateMany({ where: { id, businessId }, data: { archived: true } });
  }

  async getUnitNames(businessId: string): Promise<string[]> {
    const rows = await this.prisma.productUnit.findMany({
      where: { businessId, deleted: false },
      select: { name: true },
      distinct: ['name'],
      orderBy: { name: 'asc' },
    });
    return rows.map((r) => r.name);
  }

  async getCategories(businessId: string) {
    return this.prisma.category.findMany({
      where: { businessId, deleted: false },
      orderBy: { name: 'asc' },
    });
  }

  async createCategory(name: string, businessId: string) {
    return this.prisma.category.create({
      data: { id: crypto.randomUUID(), businessId, name },
    });
  }

  async searchProducts(query: string, businessId: string) {
    return this.prisma.product.findMany({
      where: {
        businessId,
        archived: false,
        deleted: false,
        OR: [
          { name: { contains: query, mode: 'insensitive' } },
          { barcode: { contains: query, mode: 'insensitive' } },
          { internalCode: { contains: query, mode: 'insensitive' } },
          { brand: { contains: query, mode: 'insensitive' } },
        ],
      },
      include: { units: { where: { deleted: false } }, stockLevels: true },
      take: 20,
    });
  }
}
