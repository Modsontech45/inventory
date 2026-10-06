import { Module } from '@nestjs/common';
import { UsersService } from './users.service.js';
import { UsersController, DepotsController } from './users.controller.js';

@Module({
  providers: [UsersService],
  controllers: [UsersController, DepotsController],
  exports: [UsersService],
})
export class UsersModule {}
