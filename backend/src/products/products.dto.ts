import { IsString, IsUUID, IsOptional, IsBoolean, IsInt, IsArray, ValidateNested, IsUrl, Min } from 'class-validator';
import { Type } from 'class-transformer';

export class CreateProductUnitDto {
  @IsUUID()
  id: string;

  @IsString()
  name: string;

  @IsBoolean()
  isBase: boolean;

  @IsInt()
  @Min(1)
  factor: number;

  @IsInt()
  @Min(0)
  purchasePrice: number;

  @IsInt()
  @Min(0)
  retailPrice: number;

  @IsInt()
  @Min(0)
  wholesalePrice: number;

  @IsInt()
  @Min(1)
  wholesaleMinQty: number;
}

export class CreateProductDto {
  @IsUUID()
  id: string;

  @IsString()
  name: string;

  @IsOptional()
  @IsString()
  brand?: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsOptional()
  @IsString()
  photoUrl?: string;

  @IsOptional()
  @IsString()
  barcode?: string;

  @IsOptional()
  @IsString()
  internalCode?: string;

  @IsOptional()
  @IsUUID()
  categoryId?: string;

  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => CreateProductUnitDto)
  units: CreateProductUnitDto[];

  @IsOptional()
  @IsInt()
  @Min(0)
  minStockLevel?: number;
}

export class UpdateProductDto {
  @IsOptional()
  @IsString()
  name?: string;

  @IsOptional()
  @IsString()
  brand?: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsOptional()
  @IsString()
  photoUrl?: string;

  @IsOptional()
  @IsString()
  barcode?: string;

  @IsOptional()
  @IsUUID()
  categoryId?: string;

  @IsOptional()
  @IsBoolean()
  archived?: boolean;

  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => CreateProductUnitDto)
  units?: CreateProductUnitDto[];
}
