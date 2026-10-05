import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/api.dart';
import '../../data/sync/api_client.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres')),
      body: ListView(
        children: [
          const ListTile(leading: Icon(Icons.business, color: kPrimary), title: Text('Entreprise'), subtitle: Text('Nom, logo, NIF, RCCM')),
          const ListTile(leading: Icon(Icons.store, color: kPrimary), title: Text('Dépôts'), subtitle: Text('Gérer les dépôts / boutiques')),
          const ListTile(leading: Icon(Icons.people, color: kPrimary), title: Text('Employés'), subtitle: Text('Gérer les utilisateurs et rôles')),
          ListTile(
            leading: const Icon(Icons.add_to_photos, color: kPrimary),
            title: const Text('Jumeler un nouvel appareil'),
            subtitle: const Text('Générer un code de jumelage à 6 chiffres'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _generateCode(context),
          ),
          const ListTile(leading: Icon(Icons.sync, color: kPrimary), title: Text('Synchronisation'), subtitle: Text('Statut et historique de sync')),
          const ListTile(leading: Icon(Icons.notifications, color: kPrimary), title: Text('Alertes WhatsApp'), subtitle: Text('Numéro et heure du résumé')),
          const ListTile(leading: Icon(Icons.language, color: kPrimary), title: Text('Langue'), subtitle: Text('Français / English')),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.dns, color: kTextSecondary),
            title: const Text('Adresse du serveur'),
            subtitle: const Text('Modifier l\'URL du serveur ENVentory'),
            onTap: () => context.go('/setup'),
          ),
          ListTile(
            leading: const Icon(Icons.link_off, color: kWarning),
            title: const Text('Re-jumeler l\'appareil', style: TextStyle(color: kWarning)),
            subtitle: const Text('Dissocier et jumeler à nouveau'),
            onTap: () => _repairDevice(context),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: kDanger),
            title: const Text('Déconnexion', style: TextStyle(color: kDanger)),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }

  Future<void> _generateCode(BuildContext context) async {
    final api = ApiClient();
    try {
      final res = await api.post(Api.authPairingCodes);
      final body = res.data as Map<String, dynamic>;
      final code = body['code'] as String;

      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Code de jumelage'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Entrez ce code sur le nouvel appareil. Il expire dans 15 minutes.', style: TextStyle(color: kTextSecondary)),
              const SizedBox(height: 20),
              Text(code, style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900, letterSpacing: 12, color: kPrimary)),
            ],
          ),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Fermer'))],
        ),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Impossible de générer un code')));
    }
  }

  Future<void> _repairDevice(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Re-jumeler l\'appareil ?'),
        content: const Text('Vous serez déconnecté et devrez entrer un nouveau code de jumelage.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Continuer')),
        ],
      ),
    );
    if (confirm == true) {
      final api = ApiClient();
      final url = await api.getServerUrl();
      await api.clearAll();
      if (url != null) await api.saveServerUrl(url);
      if (context.mounted) context.go('/pair');
    }
  }

  Future<void> _logout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Se déconnecter ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Déconnexion')),
        ],
      ),
    );
    if (confirm == true) {
      final api = ApiClient();
      final deviceId = await api.getDeviceId();
      final businessId = await api.getBusinessId();
      final depotId = await api.getDepotId();
      final url = await api.getServerUrl();
      await api.clearAll();
      if (url != null) await api.saveServerUrl(url);
      if (deviceId != null) {
        await api.saveTokens(
          accessToken: '', refreshToken: '',
          deviceId: deviceId, businessId: businessId ?? '', depotId: depotId ?? '',
        );
      }
      if (context.mounted) context.go('/login');
    }
  }
}
