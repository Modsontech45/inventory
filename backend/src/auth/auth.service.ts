import { Injectable, UnauthorizedException, NotFoundException, BadRequestException, ConflictException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { PrismaService } from '../prisma/prisma.service.js';
import { LoginDto, LoginPinDto, PairDeviceDto, RefreshTokenDto, RegisterDto } from './auth.dto.js';
import * as bcrypt from 'bcrypt';
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class AuthService {
  constructor(
    private prisma: PrismaService,
    private jwtService: JwtService,
  ) {}

  async register(dto: RegisterDto) {
    const email = dto.email.toLowerCase().trim();
    const existing = await this.prisma.user.findFirst({ where: { email } });
    if (existing) throw new ConflictException('Un compte avec cet email existe déjà');

    const businessId = uuidv4();
    const depotId = uuidv4();
    const userId = uuidv4();
    const deviceId = uuidv4();
    const passwordHash = await bcrypt.hash(dto.password, 10);

    await this.prisma.business.create({
      data: { id: businessId, name: dto.businessName, phone: dto.phone },
    });

    await this.prisma.depot.create({
      data: { id: depotId, businessId, name: dto.depotName ?? 'Dépôt principal', isDefault: true },
    });

    await this.prisma.user.create({
      data: {
        id: userId, businessId, depotId,
        name: dto.ownerName,
        email,
        phone: dto.phone,
        role: 'OWNER' as any,
        passwordHash,
        isVendeur: true,
        isCaissier: true,
        active: true,
      },
    });

    await this.prisma.device.create({
      data: {
        id: deviceId, businessId, depotId,
        name: dto.deviceName ?? 'Appareil principal',
        platform: dto.platform ?? 'android',
        appVersion: '1.0.0',
      },
    });

    return {
      ...(await this.issueTokens(userId, deviceId, businessId)),
      deviceId, businessId, depotId,
    };
  }

  async login(dto: LoginDto) {
    const email = dto.email.toLowerCase().trim();
    const user = await this.prisma.user.findFirst({
      where: { email, active: true, deleted: false },
    });
    if (!user) throw new UnauthorizedException('Email ou mot de passe incorrect');
    if (!user.passwordHash) throw new UnauthorizedException('Mot de passe non configuré');

    const valid = await bcrypt.compare(dto.password, user.passwordHash);
    if (!valid) throw new UnauthorizedException('Email ou mot de passe incorrect');

    return this._finishLogin(user, dto.deviceId, dto.platform, dto.deviceName);
  }

  // Legacy phone+PIN login kept for backward compat
  async loginPin(dto: LoginPinDto) {
    const normalizedPhone = dto.phone.replace(/\s+/g, '');
    const users = await this.prisma.user.findMany({ where: { active: true, deleted: false } });
    const user = users.find(u => u.phone?.replace(/\s+/g, '') === normalizedPhone);
    if (!user) throw new UnauthorizedException('Numéro ou PIN incorrect');
    if (!user.pinHash) throw new UnauthorizedException('PIN non configuré');
    const valid = await bcrypt.compare(dto.pin, user.pinHash);
    if (!valid) throw new UnauthorizedException('Numéro ou PIN incorrect');
    return this._finishLogin(user, dto.deviceId, dto.platform, dto.deviceName);
  }

  private async _finishLogin(user: any, deviceId?: string, platform?: string, deviceName?: string) {
    let dId = deviceId;
    if (dId) {
      const device = await this.prisma.device.findFirst({ where: { id: dId, revoked: false } });
      if (!device) dId = undefined;
    }
    if (!dId) {
      dId = uuidv4();
      const depot = await this.prisma.depot.findFirst({ where: { businessId: user.businessId } });
      await this.prisma.device.create({
        data: {
          id: dId,
          businessId: user.businessId,
          depotId: depot!.id,
          name: deviceName ?? 'Appareil',
          platform: platform ?? 'android',
          appVersion: '1.0.0',
        },
      });
    }
    const device = await this.prisma.device.findUnique({ where: { id: dId } });
    return {
      ...(await this.issueTokens(user.id, dId, user.businessId)),
      deviceId: dId,
      businessId: user.businessId,
      depotId: device?.depotId ?? '',
      role: user.role,
      isVendeur: user.isVendeur,
      isCaissier: user.isCaissier,
      userName: user.name,
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
