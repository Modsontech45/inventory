import { Controller, Get, Post, Body, Param, Query, UseGuards } from '@nestjs/common';
import { SalesService } from './sales.service.js';
import { CreateSaleDto, ConfirmSaleDto, CancelSaleDto } from './sales.dto.js';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard.js';
import { CurrentUser } from '../common/decorators/current-user.decorator.js';

@UseGuards(JwtAuthGuard)
@Controller('api/v1/sales')
export class SalesController {
  constructor(private service: SalesService) {}

  @Get()
  findAll(@CurrentUser() user: any, @Query() query: any) {
    return this.service.findAll(user.businessId, query.depotId ?? '', query);
  }

  @Get('pending')
  findPending(@CurrentUser() user: any, @Query('depotId') depotId: string) {
    return this.service.findPending(user.businessId, depotId ?? '');
  }

  @Get('daily-summary')
  dailySummary(@CurrentUser() user: any, @Query('depotId') depotId: string, @Query('date') date?: string) {
    return this.service.getDailySummary(user.businessId, depotId, date);
  }

  @Get(':id')
  findOne(@Param('id') id: string, @CurrentUser() user: any) {
    return this.service.findOne(id, user.businessId);
  }

  @Post()
  create(@Body() dto: CreateSaleDto, @CurrentUser() user: any, @Query('depotId') depotId: string) {
    return this.service.create(dto, user.businessId, depotId, user.userId, user.deviceId);
  }

  @Post(':id/confirm')
  confirm(@Param('id') id: string, @Body() dto: ConfirmSaleDto, @CurrentUser() user: any, @Query('depotId') depotId: string) {
    return this.service.confirm(id, dto, user.businessId, depotId, user.userId, user.deviceId);
  }

  @Post(':id/cancel')
  cancel(@Param('id') id: string, @Body() dto: CancelSaleDto, @CurrentUser() user: any, @Query('depotId') depotId: string) {
    return this.service.cancel(id, dto, user.businessId, depotId, user.userId, user.deviceId);
  }
}
