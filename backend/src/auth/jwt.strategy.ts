import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { PrismaService } from '../prisma/prisma.service.js';

export interface JwtPayload {
  sub: string;
  deviceId: string;
  businessId: string;
}

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(private prisma: PrismaService) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: process.env.JWT_SECRET ?? 'change-me',
    });
  }

  async validate(payload: JwtPayload) {
    const device = await this.prisma.device.findFirst({
      where: { id: payload.deviceId, revoked: false },
    });
    if (!device) throw new UnauthorizedException('Appareil révoqué');

    const user = await this.prisma.user.findFirst({
      where: { id: payload.sub, active: true, deleted: false },
    });
    if (!user) throw new UnauthorizedException('Utilisateur inactif');

    return { userId: payload.sub, deviceId: payload.deviceId, businessId: payload.businessId, role: user.role, permissions: user.permissions };
  }
}
