import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/api.dart';
import '../../data/sync/api_client.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneCtrl = TextEditingController();
  final _pinCtrl = TextEditingController();
  bool _loading = false;
  String? _error;
  final _api = ApiClient();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimary,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.inventory_2, size: 72, color: Colors.white),
                const SizedBox(height: 16),
                const Text('ENVentory', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white)),
                const SizedBox(height: 8),
                const Text('Gestion de stock et ventes', style: TextStyle(fontSize: 14, color: Colors.white70)),
                const SizedBox(height: 40),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        TextField(
                          controller: _phoneCtrl,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'Numéro de téléphone',
                            prefixIcon: Icon(Icons.person),
                            hintText: '+228 90 00 00 00',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _pinCtrl,
                          obscureText: true,
                          keyboardType: TextInputType.number,
                          maxLength: 8,
                          decoration: const InputDecoration(
                            labelText: 'Code PIN',
                            prefixIcon: Icon(Icons.lock),
                            counterText: '',
                          ),
                        ),
                        if (_error != null) ...[
                          const SizedBox(height: 8),
                          Text(_error!, style: const TextStyle(color: kDanger, fontSize: 13)),
                        ],
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: _loading ? null : _login,
                            icon: _loading
                                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                : const Icon(Icons.login),
                            label: Text(_loading ? 'Connexion…' : 'Se connecter'),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => context.go('/pair'),
                          child: const Text('Problème ? Re-jumeler l\'appareil'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (_phoneCtrl.text.trim().isEmpty || _pinCtrl.text.isEmpty) {
      setState(() => _error = 'Renseignez votre numéro et votre PIN');
      return;
    }

    final deviceId = await _api.getDeviceId();
    if (deviceId == null) {
      if (mounted) context.go('/pair');
      return;
    }

    setState(() { _loading = true; _error = null; });

    try {
      final res = await _api.post(Api.authLogin, data: {
        'deviceId': deviceId,
        'phone': _phoneCtrl.text.trim(),
        'pin': _pinCtrl.text,
      });
      final body = res.data as Map<String, dynamic>;
      await _api.saveTokens(
        accessToken: body['accessToken'] as String,
        refreshToken: body['refreshToken'] as String,
        deviceId: deviceId,
        businessId: body['businessId'] as String? ?? await _api.getBusinessId() ?? '',
        depotId: body['depotId'] as String? ?? await _api.getDepotId() ?? '',
      );
      if (mounted) context.go('/dashboard');
    } catch (e) {
      setState(() => _error = 'Numéro ou PIN incorrect');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}
