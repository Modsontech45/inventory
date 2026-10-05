import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/api.dart';
import '../../data/sync/api_client.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  final _api = ApiClient();

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimary,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inventory_2, size: 72, color: Colors.white),
                  const SizedBox(height: 12),
                  const Text('ENVentory',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: Colors.white)),
                  const Text('Gestion de stock et ventes',
                      style: TextStyle(fontSize: 14, color: Colors.white70)),
                  const SizedBox(height: 32),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      children: [
                        TabBar(
                          controller: _tabs,
                          labelColor: kPrimary,
                          unselectedLabelColor: kTextSecondary,
                          indicatorColor: kPrimary,
                          tabs: const [Tab(text: 'Connexion'), Tab(text: 'Nouveau compte')],
                        ),
                        SizedBox(
                          height: 340,
                          child: TabBarView(
                            controller: _tabs,
                            children: [
                              _LoginTab(api: _api),
                              _RegisterTab(api: _api),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginTab extends StatefulWidget {
  final ApiClient api;
  const _LoginTab({required this.api});

  @override
  State<_LoginTab> createState() => _LoginTabState();
}

class _LoginTabState extends State<_LoginTab> {
  final _phoneCtrl = TextEditingController();
  final _pinCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _login() async {
    if (_phoneCtrl.text.trim().isEmpty || _pinCtrl.text.isEmpty) {
      setState(() => _error = 'Renseignez votre numéro et votre PIN');
      return;
    }
    setState(() { _loading = true; _error = null; });
    try {
      final storedDeviceId = await widget.api.getDeviceId();
      final res = await widget.api.post(Api.authLogin, data: {
        'phone': _phoneCtrl.text.trim(),
        'pin': _pinCtrl.text,
        if (storedDeviceId != null) 'deviceId': storedDeviceId,
        'platform': Platform.isAndroid ? 'android' : 'windows',
        'deviceName': Platform.isAndroid ? 'Mobile Android' : 'PC Windows',
      });
      final body = res.data as Map<String, dynamic>;
      await widget.api.saveTokens(
        accessToken: body['accessToken'] as String,
        refreshToken: body['refreshToken'] as String,
        deviceId: body['deviceId'] as String,
        businessId: body['businessId'] as String,
        depotId: body['depotId'] as String,
      );
      if (mounted) context.go('/dashboard');
    } catch (_) {
      setState(() => _error = 'Numéro ou PIN incorrect');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          TextField(
            controller: _phoneCtrl,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Numéro de téléphone',
              prefixIcon: Icon(Icons.phone),
              hintText: '+228 90 00 00 00',
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _pinCtrl,
            obscureText: true,
            keyboardType: TextInputType.number,
            maxLength: 8,
            onSubmitted: (_) => _login(),
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
        ],
      ),
    );
  }
}

class _RegisterTab extends StatefulWidget {
  final ApiClient api;
  const _RegisterTab({required this.api});

  @override
  State<_RegisterTab> createState() => _RegisterTabState();
}

class _RegisterTabState extends State<_RegisterTab> {
  final _businessCtrl = TextEditingController();
  final _depotCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _pinCtrl = TextEditingController();
  final _pinConfirmCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _register() async {
    if (_businessCtrl.text.trim().isEmpty || _nameCtrl.text.trim().isEmpty ||
        _phoneCtrl.text.trim().isEmpty || _pinCtrl.text.isEmpty) {
      setState(() => _error = 'Renseignez tous les champs');
      return;
    }
    if (_pinCtrl.text != _pinConfirmCtrl.text) {
      setState(() => _error = 'Les PIN ne correspondent pas');
      return;
    }
    setState(() { _loading = true; _error = null; });
    try {
      final res = await widget.api.post(Api.authRegister, data: {
        'businessName': _businessCtrl.text.trim(),
        'depotName': _depotCtrl.text.trim().isEmpty ? 'Dépôt principal' : _depotCtrl.text.trim(),
        'ownerName': _nameCtrl.text.trim(),
        'phone': _phoneCtrl.text.trim(),
        'pin': _pinCtrl.text,
        'platform': Platform.isAndroid ? 'android' : 'windows',
        'deviceName': Platform.isAndroid ? 'Mobile Android' : 'PC Windows',
      });
      final body = res.data as Map<String, dynamic>;
      await widget.api.saveTokens(
        accessToken: body['accessToken'] as String,
        refreshToken: body['refreshToken'] as String,
        deviceId: body['deviceId'] as String,
        businessId: body['businessId'] as String,
        depotId: body['depotId'] as String,
      );
      if (mounted) context.go('/dashboard');
    } catch (e) {
      setState(() => _error = 'Erreur: vérifiez vos informations');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          TextField(
            controller: _businessCtrl,
            decoration: const InputDecoration(labelText: 'Nom du commerce *', prefixIcon: Icon(Icons.store)),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _depotCtrl,
            decoration: const InputDecoration(labelText: 'Nom du dépôt (optionnel)', prefixIcon: Icon(Icons.warehouse)),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(labelText: 'Votre nom *', prefixIcon: Icon(Icons.person)),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _phoneCtrl,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: 'Numéro de téléphone *', prefixIcon: Icon(Icons.phone), hintText: '+228 90 00 00 00'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _pinCtrl,
            obscureText: true,
            keyboardType: TextInputType.number,
            maxLength: 8,
            decoration: const InputDecoration(labelText: 'PIN (4-8 chiffres) *', prefixIcon: Icon(Icons.lock), counterText: ''),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _pinConfirmCtrl,
            obscureText: true,
            keyboardType: TextInputType.number,
            maxLength: 8,
            onSubmitted: (_) => _register(),
            decoration: const InputDecoration(labelText: 'Confirmer le PIN *', prefixIcon: Icon(Icons.lock_outline), counterText: ''),
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(_error!, style: const TextStyle(color: kDanger, fontSize: 13)),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _loading ? null : _register,
              icon: _loading
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.app_registration),
              label: Text(_loading ? 'Création…' : 'Créer le compte'),
            ),
          ),
        ],
      ),
    );
  }
}
