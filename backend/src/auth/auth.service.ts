import { Injectable, UnauthorizedException, NotFoundException, BadRequestException, ConflictException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { PrismaService } from '../prisma/prisma.service.js';
import { LoginDto, PairDeviceDto, RefreshTokenDto, RegisterDto } from './auth.dto.js';
import * as bcrypt from 'bcrypt';
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class AuthService {
  constructor(
    private prisma: PrismaService,
    private jwtService: JwtService,
  ) {}

  async register(dto: RegisterDto) {
    const normalizedPhone = dto.phone.replace(/\s+/g, '');
    const existing = await this.prisma.user.findFirst({ where: { phone: normalizedPhone } });
    if (existing) throw new ConflictException('Un compte avec ce numéro existe déjà');

    const businessId = uuidv4();
    const depotId = uuidv4();
    const userId = uuidv4();
    const deviceId = uuidv4();
    const pinHash = await bcrypt.hash(dto.pin, 10);

    await this.prisma.business.create({
      data: { id: businessId, name: dto.businessName, phone: normalizedPhone },
    });

    await this.prisma.depot.create({
      data: { id: depotId, businessId, name: dto.depotName ?? 'Dépôt principal', isDefault: true },
    });

    await this.prisma.user.create({
      data: {
        id: userId, businessId, depotId,
        name: dto.ownerName,
        phone: normalizedPhone,
        role: 'OWNER' as any,
        pinHash,
        active: true,
      },
    });

    await this.prisma.device.create({
      data: {
        id: deviceId, businessId, depotId,
        name: dto.deviceName ?? 'Appareil principal',
        platform: dto.platform ?? 'windows',
        appVersion: '1.0.0',
      },
    });

    return {
      ...(await this.issueTokens(userId, deviceId, businessId)),
      deviceId, businessId, depotId,
    };
  }

  async login(dto: LoginDto) {
    const normalizedPhone = dto.phone.replace(/\s+/g, '');
    const users = await this.prisma.user.findMany({
      where: { active: true, deleted: false },
    });
    const user = users.find(u => u.phone?.replace(/\s+/g, '') === normalizedPhone);
    if (!user) throw new UnauthorizedException('Numéro ou PIN incorrect');
    if (!user.pinHash) throw new UnauthorizedException('PIN non configuré');

    const valid = await bcrypt.compare(dto.pin, user.pinHash);
    if (!valid) throw new UnauthorizedException('Numéro ou PIN incorrect');

    // Use provided deviceId or auto-create one for this login
    let deviceId = dto.deviceId;
    if (deviceId) {
      const device = await this.prisma.device.findFirst({ where: { id: deviceId, revoked: false } });
      if (!device) deviceId = undefined;
    }

    if (!deviceId) {
      deviceId = uuidv4();
      const depot = await this.prisma.depot.findFirst({ where: { businessId: user.businessId } });
      await this.prisma.device.create({
        data: {
          id: deviceId,
          businessId: user.businessId,
          depotId: depot!.id,
          name: dto.deviceName ?? 'Appareil',
          platform: dto.platform ?? 'windows',
          appVersion: '1.0.0',
        },
      });
    }

    const depot = await this.prisma.device.findUnique({ where: { id: deviceId } });
    return {
      ...(await this.issueTokens(user.id, deviceId, user.businessId)),
      deviceId,
      businessId: user.businessId,
      depotId: depot?.depotId ?? '',
    };
  }

  async pairDevice(dto: PairDeviceDto) {
    const code = await this.prisma.pairingCode.findUnique({ where: { code: dto.code } });
    if (!code || code.used || code.expiresAt < new Date()) {
      throw new BadRequestException('Code de jumelage invalide ou expiré');
    }

    const deviceId = uuidv4();
    await this.prisma.device.create({
      data: {
        id: deviceId,
        businessId: code.businessId,
        depotId: code.depotId,
        name: dto.deviceName,
        platform: dto.platform,
        appVersion: dto.appVersion,
      },
    });
    await this.prisma.pairingCode.update({ where: { id: code.id }, data: { used: true } });

    return { deviceId, businessId: code.businessId, depotId: code.depotId };
  }

  async refresh(dto: RefreshTokenDto) {
    const stored = await this.prisma.refreshToken.findUnique({
      where: { token: dto.refreshToken },
      include: { user: true },
    });

    if (!stored || stored.revoked || stored.expiresAt < new Date() || stored.deviceId !== dto.deviceId) {
      throw new UnauthorizedException('Session expirée, veuillez vous reconnecter');
    }

    await this.prisma.refreshToken.update({ where: { id: stored.id }, data: { revoked: true } });
    return this.issueTokens(stored.userId, stored.deviceId, stored.user.businessId);
  }

  private async issueTokens(userId: string, deviceId: string, businessId: string) {
    const payload = { sub: userId, deviceId, businessId };
    const accessToken = this.jwtService.sign(payload);

    const refreshToken = uuidv4();
    const expiresAt = new Date();
    expiresAt.setDate(expiresAt.getDate() + 30);

    await this.prisma.refreshToken.create({
      data: { userId, deviceId, token: refreshToken, expiresAt },
    });

    return { accessToken, refreshToken, expiresAt };
  }

  async generatePairingCode(businessId: string, deviceId: string) {
    const device = await this.prisma.device.findFirst({ where: { id: deviceId, businessId, revoked: false } });
    if (!device) throw new UnauthorizedException('Appareil introuvable');

    const code = Math.floor(100000 + Math.random() * 900000).toString();
    const expiresAt = new Date();
    expiresAt.setMinutes(expiresAt.getMinutes() + 15);

    await this.prisma.pairingCode.create({ data: { code, businessId, depotId: device.depotId, expiresAt } });
    return { code, expiresAt };
  }

  async revokeDevice(deviceId: string, requestingBusinessId: string) {
    const device = await this.prisma.device.findFirst({ where: { id: deviceId, businessId: requestingBusinessId } });
    if (!device) throw new NotFoundException('Appareil introuvable');

    await this.prisma.device.update({ where: { id: deviceId }, data: { revoked: true } });
    await this.prisma.refreshToken.updateMany({ where: { deviceId }, data: { revoked: true } });
  }
}
