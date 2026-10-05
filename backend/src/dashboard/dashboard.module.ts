import { Module } from '@nestjs/common';
import { DashboardService } from './dashboard.service.js';
import { DashboardController } from './dashboard.controller.js';
import { ReportsModule } from '../reports/reports.module.js';

@Module({
  imports: [ReportsModule],
  providers: [DashboardService],
  controllers: [DashboardController],
})
export class DashboardModule {}
