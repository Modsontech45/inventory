import { Controller, Get, Post, Put, Body, Param, Query, UseGuards } from '@nestjs/common';
import { CustomersService } from './customers.service.js';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard.js';
import { CurrentUser } from '../common/decorators/current-user.decorator.js';
import { PaymentMethod } from '@prisma/client';

@UseGuards(JwtAuthGuard)
@Controller('api/v1/customers')
export class CustomersController {
  constructor(private service: CustomersService) {}

  @Get()
  findAll(@CurrentUser() user: any) {
    return this.service.findAll(user.businessId);
  }

  @Get('debtors')
  getDebtors(@CurrentUser() user: any) {
    return this.service.getDebtors(user.businessId);
  }

  @Get(':id')
  findOne(@Param('id') id: string, @CurrentUser() user: any) {
    return this.service.findOne(id, user.businessId);
  }

  @Post()
  create(@Body() body: any, @CurrentUser() user: any) {
    return this.service.create(body, user.businessId, user.userId, user.deviceId);
  }

  @Put(':id')
  update(@Param('id') id: string, @Body() body: any, @CurrentUser() user: any) {
    return this.service.update(id, body, user.businessId);
  }

  @Post(':id/payments')
  recordPayment(@Param('id') id: string, @Body() body: { amount: number; method: PaymentMethod; reference?: string; depotId: string }, @CurrentUser() user: any) {
    return this.service.recordPayment(id, body.amount, body.method, body.reference, user.businessId, body.depotId, user.userId, user.deviceId);
  }
}
