import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { ReportsService, ReportFilters } from './reports.service.js';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard.js';
import { CurrentUser } from '../common/decorators/current-user.decorator.js';

@UseGuards(JwtAuthGuard)
@Controller('api/v1/reports')
export class ReportsController {
  constructor(private service: ReportsService) {}

  private filters(user: any, q: any): ReportFilters {
    return {
      businessId: user.businessId,
      depotId: q.depotId,
      from: q.from,
      to: q.to,
      productId: q.productId,
      categoryId: q.categoryId,
      customerId: q.customerId,
      userId: q.userId,
      paymentMethod: q.paymentMethod,
      page: q.page ? parseInt(q.page) : 1,
    };
  }

  @Get('r1/daily-journal')
  r1(@CurrentUser() u: any, @Query() q: any) {
    return this.service.dailySalesJournal(this.filters(u, q));
  }

  @Get('r2/by-payment-method')
  r2(@CurrentUser() u: any, @Query() q: any) {
    return this.service.salesByPaymentMethod(this.filters(u, q));
  }

  @Get('r3/by-product')
  r3(@CurrentUser() u: any, @Query() q: any) {
    return this.service.salesByProduct(this.filters(u, q));
  }

  @Get('r5/profit')
  r5(@CurrentUser() u: any, @Query() q: any) {
    return this.service.profitReport(this.filters(u, q));
  }

  @Get('r7/current-stock')
  r7(@CurrentUser() u: any, @Query() q: any) {
    return this.service.currentStock(this.filters(u, q));
  }

  @Get('r8/stock-movements')
  r8(@CurrentUser() u: any, @Query() q: any) {
    return this.service.stockMovements(this.filters(u, q));
  }

  @Get('r10/low-stock')
  r10(@CurrentUser() u: any, @Query() q: any) {
    return this.service.lowStockList(this.filters(u, q));
  }

  @Get('r11/customer-debts')
  r11(@CurrentUser() u: any, @Query() q: any) {
    return this.service.customerDebts(this.filters(u, q));
  }

  @Get('r16/by-employee')
  r16(@CurrentUser() u: any, @Query() q: any) {
    return this.service.salesByEmployee(this.filters(u, q));
  }

  @Get('r17/cancellations')
  r17(@CurrentUser() u: any, @Query() q: any) {
    return this.service.cancellationsAndDiscounts(this.filters(u, q));
  }

  @Get('graph/time-series')
  timeSeries(@CurrentUser() u: any, @Query() q: any) {
    return this.service.salesTimeSeries(this.filters(u, q), q.days ? parseInt(q.days) : 30);
  }

  @Get('graph/top-products')
  topProducts(@CurrentUser() u: any, @Query() q: any) {
    return this.service.topProducts(this.filters(u, q), q.limit ? parseInt(q.limit) : 10);
  }
}
