import { Controller, Post, Body, UseGuards, Delete, Param } from '@nestjs/common';
import { AuthService } from './auth.service.js';
import { LoginDto, LoginPinDto, PairDeviceDto, RefreshTokenDto, RegisterDto } from './auth.dto.js';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard.js';
import { CurrentUser } from '../common/decorators/current-user.decorator.js';

@Controller('api/v1/auth')
export class AuthController {
  constructor(private auth: AuthService) {}

  @Post('register')
  register(@Body() dto: RegisterDto) {
    return this.auth.register(dto);
  }

  @Post('pair')
  pair(@Body() dto: PairDeviceDto) {
    return this.auth.pairDevice(dto);
  }

  @Post('login')
  login(@Body() dto: LoginDto) {
    return this.auth.login(dto);
  }

  @Post('login/pin')
  loginPin(@Body() dto: LoginPinDto) {
    return this.auth.loginPin(dto);
  }

  @Post('refresh')
  refresh(@Body() dto: RefreshTokenDto) {
    return this.auth.refresh(dto);
  }

  @UseGuards(JwtAuthGuard)
  @Post('pairing-codes')
  generateCode(@CurrentUser() user: any) {
    return this.auth.generatePairingCode(user.businessId, user.deviceId);
  }

  @UseGuards(JwtAuthGuard)
  @Delete('devices/:deviceId')
  revokeDevice(@Param('deviceId') deviceId: string, @CurrentUser() user: any) {
    return this.auth.revokeDevice(deviceId, user.businessId);
  }
}
