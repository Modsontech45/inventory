import { Injectable, NotFoundException, ConflictException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service.js';
import { UserRole } from '@prisma/client';
import * as bcrypt from 'bcrypt';

@Injectable()
export class UsersService {
  constructor(private prisma: PrismaService) {}

  async findAll(businessId: string) {
    return this.prisma.user.findMany({
      where: { businessId, deleted: false },
      select: { id: true, name: true, phone: true, role: true, depotId: true, photoUrl: true, active: true, createdAt: true },
      orderBy: { name: 'asc' },
    });
  }

  async create(data: { id: string; name: string; phone?: string; role: UserRole; depotId?: string; pin: string; photoUrl?: string }, businessId: string, createdBy: string, deviceId: string) {
    const pinHash = await bcrypt.hash(data.pin, 10);
    return this.prisma.user.create({
      data: {
        id: data.id,
        businessId,
        name: data.name,
        phone: data.phone,
        role: data.role,
        depotId: data.depotId,
        pinHash,
        photoUrl: data.photoUrl,
        createdBy,
        deviceId,
      },
      select: { id: true, name: true, phone: true, role: true, depotId: true, photoUrl: true, active: true },
    });
  }

  async update(id: string, data: any, businessId: string) {
    const user = await this.prisma.user.findFirst({ where: { id, businessId, deleted: false } });
    if (!user) throw new NotFoundException('Utilisateur introuvable');

    const updates: any = {};
    if (data.name) updates.name = data.name;
    if (data.phone !== undefined) updates.phone = data.phone;
    if (data.role) updates.role = data.role;
    if (data.depotId !== undefined) updates.depotId = data.depotId;
    if (data.photoUrl !== undefined) updates.photoUrl = data.photoUrl;
    if (data.active !== undefined) updates.active = data.active;
    if (data.pin) updates.pinHash = await bcrypt.hash(data.pin, 10);

    return this.prisma.user.update({ where: { id }, data: updates, select: { id: true, name: true, phone: true, role: true, depotId: true, active: true } });
  }

  async generatePairingCode(businessId: string, depotId: string) {
    const code = Math.floor(100000 + Math.random() * 900000).toString();
    const expiresAt = new Date(Date.now() + 15 * 60 * 1000);

    await this.prisma.pairingCode.create({
      data: { id: crypto.randomUUID(), businessId, depotId, code, expiresAt },
    });

    return { code, expiresAt };
  }

  async getDevices(businessId: string) {
    return this.prisma.device.findMany({
      where: { businessId },
      include: { depot: { select: { id: true, name: true } } },
      orderBy: { createdAt: 'desc' },
    });
  }
}
