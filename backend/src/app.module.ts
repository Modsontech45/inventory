import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { PrismaModule } from './prisma/prisma.module.js';
import { AuthModule } from './auth/auth.module.js';
import { ProductsModule } from './products/products.module.js';
import { StockModule } from './stock/stock.module.js';
import { SalesModule } from './sales/sales.module.js';
import { CustomersModule } from './customers/customers.module.js';
import { UsersModule } from './users/users.module.js';
import { SyncModule } from './sync/sync.module.js';
import { ReportsModule } from './reports/reports.module.js';
import { DashboardModule } from './dashboard/dashboard.module.js';
import { HealthController } from './health/health.controller.js';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    PrismaModule,
    AuthModule,
    ProductsModule,
    StockModule,
    SalesModule,
    CustomersModule,
    UsersModule,
    SyncModule,
    ReportsModule,
    DashboardModule,
  ],
  controllers: [HealthController],
})
export class AppModule {}
