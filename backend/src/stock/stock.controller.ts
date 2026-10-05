import { Controller, Get, Post, Body, Query, UseGuards } from '@nestjs/common';
import { StockService } from './stock.service.js';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard.js';
import { CurrentUser } from '../common/decorators/current-user.decorator.js';

@UseGuards(JwtAuthGuard)
@Controller('api/v1/stock')
export class StockController {
  constructor(private service: StockService) {}

  @Get()
  getCurrentStock(@CurrentUser() user: any, @Query('depotId') depotId?: string) {
    return this.service.getCurrentStock(user.businessId, depotId);
  }

  @Get('movements')
  getMovements(@CurrentUser() user: any, @Query() filters: any) {
    return this.service.getMovements(user.businessId, filters);
  }

  @Get('alerts')
  getLowStockAlerts(@CurrentUser() user: any, @Query('depotId') depotId?: string) {
    return this.service.getLowStockAlerts(user.businessId, depotId);
  }

  @Post('adjustment')
  adjust(
    @Body() body: { depotId: string; productId: string; qtyInBase: number; reason: string },
    @CurrentUser() user: any,
  ) {
    return this.service.recordAdjustment(user.businessId, body.depotId, body.productId, body.qtyInBase, body.reason, user.userId, user.deviceId);
  }

  @Post('min-level')
  setMinLevel(@Body() body: { depotId: string; productId: string; minLevel: number }, @CurrentUser() user: any) {
    return this.service.setMinStockLevel(user.businessId, body.depotId, body.productId, body.minLevel);
  }

  @Post('rebuild')
  rebuildCache(@Body() body: { depotId: string }, @CurrentUser() user: any) {
    return this.service.rebuildCachedStock(user.businessId, body.depotId);
  }
}
