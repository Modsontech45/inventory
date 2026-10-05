// Path segments only — base URL is stored in secure storage and resolved by ApiClient
class Api {
  static const String health = 'health';
  static const String authRegister = 'auth/register';
  static const String authPair = 'auth/pair';
  static const String authLogin = 'auth/login';
  static const String authRefresh = 'auth/refresh';
  static const String authPairingCodes = 'auth/pairing-codes';

  static const String products = 'products';
  static const String sales = 'sales';
  static const String stock = 'stock';
  static const String customers = 'customers';
  static const String users = 'users';
  static const String syncPush = 'sync/push';
  static const String syncPull = 'sync/pull';
  static const String dashboard = 'dashboard';
  static const String reports = 'reports';
}
