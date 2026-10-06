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
                          height: 380,
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
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _loading = false;
  bool _obscure = true;
  String? _error;

  Future<void> _login() async {
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;
    if (email.isEmpty || password.isEmpty) {
      setState(() => _error = 'Renseignez votre email et votre mot de passe');
      return;
    }
    setState(() { _loading = true; _error = null; });
    try {
      final storedDeviceId = await widget.api.getDeviceId();
      final res = await widget.api.post(Api.authLogin, data: {
        'email': email,
        'password': password,
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
        isVendeur: body['isVendeur'] == true,
        isCaissier: body['isCaissier'] == true,
        userName: body['userName'] as String?,
        userRole: body['role'] as String?,
      );
      if (mounted) context.go('/dashboard');
    } catch (e) {
      final msg = e.toString().contains('401') || e.toString().contains('Unauthorized')
          ? 'Email ou mot de passe incorrect'
          : 'Erreur réseau — vérifiez votre connexion';
      setState(() => _error = msg);
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
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Adresse email',
              prefixIcon: Icon(Icons.email_outlined),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _passwordCtrl,
            obscureText: _obscure,
            onSubmitted: (_) => _login(),
            decoration: InputDecoration(
              labelText: 'Mot de passe',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
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
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _passwordConfirmCtrl = TextEditingController();
  bool _loading = false;
  bool _obscure = true;
  String? _error;

  Future<void> _register() async {
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;
    if (_businessCtrl.text.trim().isEmpty || _nameCtrl.text.trim().isEmpty ||
        email.isEmpty || password.isEmpty) {
      setState(() => _error = 'Renseignez tous les champs obligatoires');
      return;
    }
    if (password.length < 6) {
      setState(() => _error = 'Mot de passe trop court (6 caractères minimum)');
      return;
    }
    if (password != _passwordConfirmCtrl.text) {
      setState(() => _error = 'Les mots de passe ne correspondent pas');
      return;
    }
    setState(() { _loading = true; _error = null; });
    try {
      final res = await widget.api.post(Api.authRegister, data: {
        'businessName': _businessCtrl.text.trim(),
        'depotName': _depotCtrl.text.trim().isEmpty ? 'Dépôt principal' : _depotCtrl.text.trim(),
        'ownerName': _nameCtrl.text.trim(),
        'email': email,
        'password': password,
        if (_phoneCtrl.text.trim().isNotEmpty) 'phone': _phoneCtrl.text.trim(),
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
        isVendeur: true,
        isCaissier: true,
        userRole: 'OWNER',
        userName: _nameCtrl.text.trim(),
      );
      if (mounted) context.go('/dashboard');
    } catch (e) {
      final msg = e.toString().contains('409') || e.toString().contains('Conflict')
          ? 'Cet email est déjà utilisé'
          : e.toString().contains('connectTimeout') || e.toString().contains('SocketException')
              ? 'Impossible de contacter le serveur'
              : 'Erreur: vérifiez vos informations';
      setState(() => _error = msg);
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
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Numéro WhatsApp',
              prefixIcon: Icon(Icons.phone),
              hintText: '+228 90 00 00 00',
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(labelText: 'Adresse email *', prefixIcon: Icon(Icons.email_outlined)),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _passwordCtrl,
            obscureText: _obscure,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'Mot de passe *',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _passwordConfirmCtrl,
            obscureText: _obscure,
            onSubmitted: (_) => _register(),
            decoration: const InputDecoration(
              labelText: 'Confirmer le mot de passe *',
              prefixIcon: Icon(Icons.lock_outline),
            ),
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
