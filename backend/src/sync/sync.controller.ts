import { Controller, Post, Get, Body, Query, UseGuards, Headers } from '@nestjs/common';
import { SyncService, SyncRow } from './sync.service.js';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard.js';
import { CurrentUser } from '../common/decorators/current-user.decorator.js';

@UseGuards(JwtAuthGuard)
@Controller('api/v1/sync')
export class SyncController {
  constructor(private service: SyncService) {}

  @Post('push')
  push(
    @Body() body: { rows: SyncRow[] },
    @CurrentUser() user: any,
    @Headers('x-app-version') appVersion: string,
  ) {
    return this.service.push(body.rows, user.businessId, user.deviceId, appVersion ?? '1.0.0');
  }

  @Get('pull')
  pull(
    @Query('since') since: string,
    @Query('limit') limit: string,
    @CurrentUser() user: any,
  ) {
    return this.service.pull(
      user.businessId,
      user.deviceId,
      BigInt(since ?? '0'),
      Math.min(parseInt(limit ?? '1000'), 1000),
      user.role,
    );
  }
}
