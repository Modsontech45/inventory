import { Module } from '@nestjs/common';
import { UnitsController } from './units.controller.js';
import { UnitsService } from './units.service.js';
import { PrismaModule } from '../prisma/prisma.module.js';

@Module({
  imports: [PrismaModule],
  controllers: [UnitsController],
  providers: [UnitsService],
})
export class UnitsModule {}
