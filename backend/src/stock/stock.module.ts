import { Module } from '@nestjs/common';
import { StockService } from './stock.service.js';
import { StockController } from './stock.controller.js';

@Module({
  providers: [StockService],
  controllers: [StockController],
  exports: [StockService],
})
export class StockModule {}
