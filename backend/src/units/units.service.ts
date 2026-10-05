import { Injectable, ConflictException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service.js';

@Injectable()
export class UnitsService {
  constructor(private prisma: PrismaService) {}

  async findAll(businessId: string) {
    return this.prisma.unit.findMany({
      where: { businessId, deleted: false },
      orderBy: { name: 'asc' },
      select: { id: true, name: true, createdAt: true },
    });
  }

  async create(name: string, businessId: string) {
    const trimmed = name.trim();
    const existing = await this.prisma.unit.findUnique({
      where: { businessId_name: { businessId, name: trimmed } },
    });
    if (existing) {
      if (existing.deleted) {
        return this.prisma.unit.update({
          where: { id: existing.id },
          data: { deleted: false },
        });
      }
      throw new ConflictException(`L'unité "${trimmed}" existe déjà`);
    }
    return this.prisma.unit.create({
      data: { id: crypto.randomUUID(), businessId, name: trimmed },
    });
  }

  async remove(id: string, businessId: string) {
    await this.prisma.unit.updateMany({
      where: { id, businessId },
      data: { deleted: true },
    });
  }
}
