import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/sales/sales_screen.dart';
import '../../features/stock/stock_screen.dart';
import '../../features/customers/customers_screen.dart';
import '../../features/products/products_screen.dart';
import '../../features/auth/welcome_screen.dart';
import '../../features/auth/pair_screen.dart';
import '../../features/auth/setup_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../shell/main_shell.dart';

const _storage = FlutterSecureStorage();

/// Default server URL based on platform:
/// - Android emulator reaches host machine at 10.0.2.2
/// - Windows desktop uses localhost
String get _defaultServerUrl =>
    Platform.isAndroid ? 'http://10.0.2.2:3000' : 'http://localhost:3000';

final appRouter = GoRouter(
  initialLocation: '/dashboard',
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Erreur: ${state.error}', style: const TextStyle(color: Colors.red))),
  ),
  redirect: (context, state) async {
    final token = await _storage.read(key: 'access_token');
    final loc = state.uri.path;

    if (loc == '/welcome' || loc == '/pair' || loc == '/setup') return null;

    // Ensure server URL is always set
    final serverUrl = await _storage.read(key: 'server_url');
    if (serverUrl == null || serverUrl.isEmpty) {
      await _storage.write(key: 'server_url', value: _defaultServerUrl);
    }

    if (token == null || token.isEmpty) return '/welcome';
    return null;
  },
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/dashboard', builder: (_, __) => const DashboardScreen()),
        GoRoute(path: '/sell', builder: (_, __) => const SalesScreen()),
        GoRoute(path: '/stock', builder: (_, __) => const StockScreen()),
        GoRoute(path: '/customers', builder: (_, __) => const CustomersScreen()),
        GoRoute(path: '/products', builder: (_, __) => const ProductsScreen()),
        GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
      ],
    ),
    GoRoute(path: '/welcome', builder: (_, __) => const WelcomeScreen()),
    GoRoute(path: '/pair', builder: (_, __) => const PairScreen()),
    GoRoute(path: '/setup', builder: (_, __) => const SetupScreen()),
  ],
);
