import { Controller, Get, Post, Put, Delete, Body, Param, Query, UseGuards } from '@nestjs/common';
import { ProductsService } from './products.service.js';
import { CreateProductDto, UpdateProductDto } from './products.dto.js';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard.js';
import { CurrentUser } from '../common/decorators/current-user.decorator.js';

@UseGuards(JwtAuthGuard)
@Controller('api/v1/products')
export class ProductsController {
  constructor(private service: ProductsService) {}

  @Get()
  findAll(@CurrentUser() user: any, @Query('depotId') depotId?: string) {
    return this.service.findAll(user.businessId, depotId);
  }

  @Get('search')
  search(@Query('q') q: string, @CurrentUser() user: any) {
    return this.service.searchProducts(q ?? '', user.businessId);
  }

  @Get('categories')
  getCategories(@CurrentUser() user: any) {
    return this.service.getCategories(user.businessId);
  }

  @Post('categories')
  createCategory(@Body('name') name: string, @CurrentUser() user: any) {
    return this.service.createCategory(name, user.businessId);
  }

  @Get(':id')
  findOne(@Param('id') id: string, @CurrentUser() user: any) {
    return this.service.findOne(id, user.businessId);
  }

  @Post()
  create(@Body() dto: CreateProductDto, @CurrentUser() user: any) {
    return this.service.create(dto, user.businessId, user.userId, user.deviceId);
  }

  @Put(':id')
  update(@Param('id') id: string, @Body() dto: UpdateProductDto, @CurrentUser() user: any) {
    return this.service.update(id, dto, user.businessId, user.userId, user.deviceId);
  }

  @Delete(':id')
  archive(@Param('id') id: string, @CurrentUser() user: any) {
    return this.service.archive(id, user.businessId);
  }
}
