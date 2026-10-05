import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/api.dart';
import '../../data/sync/api_client.dart';

class PairScreen extends StatefulWidget {
  const PairScreen({super.key});

  @override
  State<PairScreen> createState() => _PairScreenState();
}

class _PairScreenState extends State<PairScreen> {
  final _codeCtrl = TextEditingController();
  bool _loading = false;
  String? _error;
  final _api = ApiClient();

  String get _platform {
    try {
      if (Platform.isWindows) return 'windows';
      if (Platform.isAndroid) return 'android';
      if (Platform.isIOS) return 'ios';
      if (Platform.isMacOS) return 'macos';
      if (Platform.isLinux) return 'linux';
    } catch (_) {}
    return 'unknown';
  }

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
                const Icon(Icons.phone_android, size: 72, color: Colors.white),
                const SizedBox(height: 16),
                const Text('Jumelage', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white)),
                const SizedBox(height: 8),
                const Text('Liez cet appareil à votre entreprise', style: TextStyle(fontSize: 14, color: Colors.white70)),
                const SizedBox(height: 40),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Code de jumelage', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        const Text(
                          'Dans le panneau d\'administration, allez dans Appareils → Nouveau et notez le code à 6 chiffres.',
                          style: TextStyle(fontSize: 13, color: kTextSecondary),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _codeCtrl,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: 12),
                          decoration: const InputDecoration(
                            hintText: '000000',
                            hintStyle: TextStyle(letterSpacing: 12, fontSize: 28, color: Colors.black26),
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
                            onPressed: _loading ? null : _pair,
                            icon: _loading
                                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                : const Icon(Icons.link),
                            label: Text(_loading ? 'Jumelage…' : 'Jumeler'),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () => context.go('/setup'),
                          child: const Text('← Changer l\'adresse du serveur'),
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

  Future<void> _pair() async {
    final code = _codeCtrl.text.trim();
    if (code.length != 6) {
      setState(() => _error = 'Le code doit contenir 6 chiffres');
      return;
    }
    setState(() { _loading = true; _error = null; });

    try {
      final res = await _api.post(Api.authPair, data: {
        'code': code,
        'deviceName': 'ENVentory $_platform',
        'platform': _platform,
        'appVersion': '1.0.0',
      });
      final body = res.data as Map<String, dynamic>;

      // Save device pairing (no tokens yet — user must still log in)
      await _api.saveTokens(
        accessToken: '',
        refreshToken: '',
        deviceId: body['deviceId'] as String,
        businessId: body['businessId'] as String,
        depotId: body['depotId'] as String,
      );

      if (mounted) context.go('/login');
    } catch (e) {
      setState(() => _error = 'Code invalide ou expiré. Demandez-en un nouveau.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}
