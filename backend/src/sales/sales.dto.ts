import { IsUUID, IsOptional, IsString, IsInt, IsArray, ValidateNested, IsEnum, Min } from 'class-validator';
import { Type } from 'class-transformer';
import { PaymentMethod } from '@prisma/client';

export class SaleLineDto {
  @IsUUID()
  id: string;

  @IsUUID()
  productId: string;

  @IsUUID()
  unitId: string;

  @IsInt()
  @Min(1)
  qty: number;

  @IsInt()
  @Min(0)
  unitPrice: number;

  @IsInt()
  @Min(0)
  discount: number;

  @IsInt()
  lineTotal: number;
}

export class SalePaymentDto {
  @IsUUID()
  id: string;

  @IsEnum(PaymentMethod)
  method: PaymentMethod;

  @IsInt()
  @Min(0)
  amount: number;

  @IsOptional()
  @IsString()
  reference?: string;
}

export class CreateSaleDto {
  @IsUUID()
  id: string;

  @IsOptional()
  @IsUUID()
  customerId?: string;

  @IsOptional()
  @IsUUID()
  cashSessionId?: string;

  @IsOptional()
  @IsString()
  notes?: string;

  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => SaleLineDto)
  lines: SaleLineDto[];

  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => SalePaymentDto)
  payments: SalePaymentDto[];
}

export class CancelSaleDto {
  @IsString()
  reason: string;
}
