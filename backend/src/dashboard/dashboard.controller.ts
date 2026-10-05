import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { DashboardService } from './dashboard.service.js';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard.js';
import { CurrentUser } from '../common/decorators/current-user.decorator.js';

@UseGuards(JwtAuthGuard)
@Controller('api/v1/dashboard')
export class DashboardController {
  constructor(private service: DashboardService) {}

  @Get()
  getSummary(
    @CurrentUser() user: any,
    @Query('depotId') depotId?: string,
    @Query('period') period: 'today' | 'week' | 'month' | 'custom' = 'today',
    @Query('from') from?: string,
    @Query('to') to?: string,
  ) {
    return this.service.getSummary(user.businessId, depotId, period, from, to);
  }
}
