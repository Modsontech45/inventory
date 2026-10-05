import { Controller, Get, Post, Delete, Body, Param, UseGuards } from '@nestjs/common';
import { UnitsService } from './units.service.js';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard.js';
import { CurrentUser } from '../common/decorators/current-user.decorator.js';

@UseGuards(JwtAuthGuard)
@Controller('api/v1/units')
export class UnitsController {
  constructor(private service: UnitsService) {}

  @Get()
  findAll(@CurrentUser() user: any) {
    return this.service.findAll(user.businessId);
  }

  @Post()
  create(@Body() body: { name: string }, @CurrentUser() user: any) {
    return this.service.create(body.name, user.businessId);
  }

  @Delete(':id')
  remove(@Param('id') id: string, @CurrentUser() user: any) {
    return this.service.remove(id, user.businessId);
  }
}
