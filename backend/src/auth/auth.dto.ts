import { IsString, IsUUID, IsNotEmpty, Length, IsOptional, MinLength, IsEmail } from 'class-validator';

export class RegisterDto {
  @IsString() @IsNotEmpty() businessName: string;
  @IsString() @IsNotEmpty() depotName: string;
  @IsString() @IsNotEmpty() ownerName: string;
  @IsEmail() email: string;
  @IsString() @MinLength(6) password: string;
  @IsString() @IsOptional() phone?: string;
  @IsString() @IsOptional() platform?: string;
  @IsString() @IsOptional() deviceName?: string;
}

export class LoginDto {
  @IsEmail() email: string;
  @IsString() @MinLength(6) password: string;
  @IsUUID() @IsOptional() deviceId?: string;
  @IsString() @IsOptional() platform?: string;
  @IsString() @IsOptional() deviceName?: string;
}

// Keep old phone+pin login for backward compat during transition
export class LoginPinDto {
  @IsString() @IsNotEmpty() phone: string;
  @IsString() @Length(4, 8) pin: string;
  @IsUUID() @IsOptional() deviceId?: string;
  @IsString() @IsOptional() platform?: string;
  @IsString() @IsOptional() deviceName?: string;
}

export class PairDeviceDto {
  @IsString() @Length(6, 6) code: string;
  @IsString() @IsNotEmpty() deviceName: string;
  @IsString() @IsNotEmpty() platform: string;
  @IsString() @IsNotEmpty() appVersion: string;
}

export class RefreshTokenDto {
  @IsString() @IsNotEmpty() refreshToken: string;
  @IsUUID() deviceId: string;
}
