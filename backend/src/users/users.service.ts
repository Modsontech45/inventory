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
      select: { id: true, name: true, phone: true, email: true, role: true, depotId: true, photoUrl: true, active: true, isVendeur: true, isCaissier: true, createdAt: true },
      orderBy: { name: 'asc' },
    });
  }

  async findMe(userId: string, businessId: string) {
    const user = await this.prisma.user.findFirst({
      where: { id: userId, businessId, deleted: false },
      select: { id: true, name: true, phone: true, email: true, role: true, photoUrl: true, active: true, isVendeur: true, isCaissier: true },
    });
    if (!user) throw new NotFoundException('Utilisateur introuvable');

    const [business, depot] = await Promise.all([
      this.prisma.business.findUnique({ where: { id: businessId }, select: { id: true, name: true, currency: true } }),
      this.prisma.depot.findFirst({ where: { businessId }, select: { id: true, name: true } }),
    ]);

    return { ...user, business, depot };
  }

  async findDepots(businessId: string) {
    return this.prisma.depot.findMany({
      where: { businessId },
      orderBy: { name: 'asc' },
    });
  }

  async create(
    data: { id: string; name: string; email?: string; phone?: string; role: UserRole; depotId?: string; password?: string; pin?: string; photoUrl?: string; isVendeur?: boolean; isCaissier?: boolean },
    businessId: string, createdBy: string, deviceId: string,
  ) {
    if (!data.email && !data.phone) throw new ConflictException('Email ou téléphone requis');
    if (data.email) {
      const existing = await this.prisma.user.findFirst({ where: { email: data.email.toLowerCase().trim() } });
      if (existing) throw new ConflictException('Un utilisateur avec cet email existe déjà');
    }
    const passwordHash = data.password ? await bcrypt.hash(data.password, 10) : undefined;
    const pinHash = data.pin ? await bcrypt.hash(data.pin, 10) : undefined;
    return this.prisma.user.create({
      data: {
        id: data.id,
        businessId,
        name: data.name,
        email: data.email ? data.email.toLowerCase().trim() : undefined,
        phone: data.phone,
        role: data.role,
        depotId: data.depotId,
        passwordHash,
        pinHash,
        photoUrl: data.photoUrl,
        isVendeur: data.isVendeur ?? false,
        isCaissier: data.isCaissier ?? false,
        createdBy,
        deviceId,
      },
      select: { id: true, name: true, email: true, phone: true, role: true, depotId: true, photoUrl: true, active: true, isVendeur: true, isCaissier: true },
    });
  }

  async update(id: string, data: any, businessId: string) {
    const user = await this.prisma.user.findFirst({ where: { id, businessId, deleted: false } });
    if (!user) throw new NotFoundException('Utilisateur introuvable');

    const updates: any = {};
    if (data.name) updates.name = data.name;
    if (data.phone !== undefined) updates.phone = data.phone;
    if (data.email !== undefined) updates.email = data.email?.toLowerCase().trim();
    if (data.role) updates.role = data.role;
    if (data.depotId !== undefined) updates.depotId = data.depotId;
    if (data.photoUrl !== undefined) updates.photoUrl = data.photoUrl;
    if (data.active !== undefined) updates.active = data.active;
    if (data.pin) updates.pinHash = await bcrypt.hash(data.pin, 10);
    if (data.password) updates.passwordHash = await bcrypt.hash(data.password, 10);
    if (data.isVendeur !== undefined) updates.isVendeur = data.isVendeur;
    if (data.isCaissier !== undefined) updates.isCaissier = data.isCaissier;

    return this.prisma.user.update({ where: { id }, data: updates, select: { id: true, name: true, email: true, phone: true, role: true, depotId: true, active: true, isVendeur: true, isCaissier: true } });
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
