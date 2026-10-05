import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../data/sync/api_client.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final _urlCtrl = TextEditingController(text: 'http://');
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
                const Text('Configuration initiale', style: TextStyle(fontSize: 14, color: Colors.white70)),
                const SizedBox(height: 40),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Adresse du serveur', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        const Text(
                          'Entrez l\'adresse IP ou le domaine du serveur ENVentory de votre entreprise.',
                          style: TextStyle(fontSize: 13, color: kTextSecondary),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _urlCtrl,
                          keyboardType: TextInputType.url,
                          autocorrect: false,
                          decoration: const InputDecoration(
                            labelText: 'URL du serveur',
                            hintText: 'http://192.168.1.100:3000',
                            prefixIcon: Icon(Icons.dns),
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
                            onPressed: _loading ? null : _connect,
                            icon: _loading
                                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                : const Icon(Icons.arrow_forward),
                            label: Text(_loading ? 'Connexion…' : 'Continuer'),
                          ),
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

  Future<void> _connect() async {
    final url = _urlCtrl.text.trim();
    if (url.isEmpty || url == 'http://') {
      setState(() => _error = 'Veuillez entrer une adresse');
      return;
    }
    setState(() { _loading = true; _error = null; });

    await _api.saveServerUrl(url);

    final online = await _api.isOnline();
    if (!online) {
      setState(() {
        _loading = false;
        _error = 'Impossible de joindre le serveur. Vérifiez l\'adresse et votre réseau.';
      });
      return;
    }

    if (mounted) context.go('/pair');
  }
}
