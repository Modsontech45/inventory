import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  late final Dio _dio;
  final _storage = const FlutterSecureStorage();

  ApiClient._internal() {
    _dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'access_token');
        if (token != null) options.headers['Authorization'] = 'Bearer $token';
        options.headers['x-app-version'] = '1.0.0';
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          final refreshed = await _tryRefresh();
          if (refreshed) {
            final opts = error.requestOptions;
            final token = await _storage.read(key: 'access_token');
            opts.headers['Authorization'] = 'Bearer $token';
            try {
              final res = await _dio.fetch(opts);
              return handler.resolve(res);
            } catch (_) {}
          }
        }
        handler.next(error);
      },
    ));
  }

  Future<String> get baseUrl async {
    final stored = await _storage.read(key: 'server_url');
    return (stored != null && stored.isNotEmpty) ? stored : 'https://inventory-1axt.onrender.com';
  }

  String _buildUrl(String base, String path) {
    final b = base.endsWith('/') ? base.substring(0, base.length - 1) : base;
    final p = path.startsWith('/') ? path.substring(1) : path;
    return '$b/api/v1/$p';
  }

  Future<bool> _tryRefresh() async {
    try {
      final refresh = await _storage.read(key: 'refresh_token');
      final deviceId = await _storage.read(key: 'device_id');
      if (refresh == null || deviceId == null) return false;
      final base = await baseUrl;
      final res = await _dio.post(_buildUrl(base, 'auth/refresh'),
          data: {'refreshToken': refresh, 'deviceId': deviceId});
      await _storage.write(key: 'access_token', value: res.data['accessToken'] as String);
      await _storage.write(key: 'refresh_token', value: res.data['refreshToken'] as String);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<Response> get(String path, {Map<String, dynamic>? params}) async {
    final url = await _resolveUrl(path);
    return _dio.get(url, queryParameters: params);
  }

  Future<Response> post(String path, {dynamic data}) async {
    final url = await _resolveUrl(path);
    return _dio.post(url, data: data);
  }

  Future<Response> put(String path, {dynamic data}) async {
    final url = await _resolveUrl(path);
    return _dio.put(url, data: data);
  }

  Future<Response> delete(String path) async {
    final url = await _resolveUrl(path);
    return _dio.delete(url);
  }

  Future<String> _resolveUrl(String path) async {
    if (path.startsWith('http')) return path;
    final base = await baseUrl;
    return _buildUrl(base, path);
  }

  Future<bool> isOnline() async {
    try {
      final base = await baseUrl;
      await _dio.get(_buildUrl(base, 'health'),
          options: Options(receiveTimeout: const Duration(seconds: 3)));
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required String deviceId,
    required String businessId,
    required String depotId,
  }) async {
    await _storage.write(key: 'access_token', value: accessToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);
    await _storage.write(key: 'device_id', value: deviceId);
    await _storage.write(key: 'business_id', value: businessId);
    await _storage.write(key: 'depot_id', value: depotId);
  }

  Future<void> saveServerUrl(String url) =>
      _storage.write(key: 'server_url', value: url.trimRight().replaceAll(RegExp(r'/$'), ''));

  Future<String?> getServerUrl() => _storage.read(key: 'server_url');
  Future<String?> getDeviceId() => _storage.read(key: 'device_id');
  Future<String?> getBusinessId() => _storage.read(key: 'business_id');
  Future<String?> getDepotId() => _storage.read(key: 'depot_id');
  Future<String?> getAccessToken() => _storage.read(key: 'access_token');

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
