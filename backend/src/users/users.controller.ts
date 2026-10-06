import { Controller, Get, Post, Put, Body, Param, UseGuards } from '@nestjs/common';
import { UsersService } from './users.service.js';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard.js';
import { CurrentUser } from '../common/decorators/current-user.decorator.js';
import { UserRole } from '@prisma/client';

@UseGuards(JwtAuthGuard)
@Controller('api/v1/depots')
export class DepotsController {
  constructor(private service: UsersService) {}

  @Get()
  findAll(@CurrentUser() user: any) {
    return this.service.findDepots(user.businessId);
  }
}

@UseGuards(JwtAuthGuard)
@Controller('api/v1/users')
export class UsersController {
  constructor(private service: UsersService) {}

  @Get()
  findAll(@CurrentUser() user: any) {
    return this.service.findAll(user.businessId);
  }

  @Get('me')
  findMe(@CurrentUser() user: any) {
    return this.service.findMe(user.userId, user.businessId);
  }

  @Post()
  create(@Body() body: { id: string; name: string; phone?: string; role: UserRole; depotId?: string; pin: string; photoUrl?: string }, @CurrentUser() user: any) {
    return this.service.create(body, user.businessId, user.userId, user.deviceId);
  }

  @Put(':id')
  update(@Param('id') id: string, @Body() body: any, @CurrentUser() user: any) {
    return this.service.update(id, body, user.businessId);
  }

  @Get('devices')
  getDevices(@CurrentUser() user: any) {
    return this.service.getDevices(user.businessId);
  }

  @Post('pairing-code')
  generatePairingCode(@Body() body: { depotId: string }, @CurrentUser() user: any) {
    return this.service.generatePairingCode(user.businessId, body.depotId);
  }
}
