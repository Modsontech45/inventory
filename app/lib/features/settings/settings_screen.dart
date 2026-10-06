import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/api.dart';
import '../../data/sync/api_client.dart';

final _apiProvSettings = Provider<ApiClient>((ref) => ApiClient());

final _profileProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final api = ref.watch(_apiProvSettings);
  final res = await api.get('${Api.users}/me');
  return res.data as Map<String, dynamic>;
});

final _employeesProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final api = ref.watch(_apiProvSettings);
  final res = await api.get(Api.users);
  return (res.data as List).cast<Map<String, dynamic>>();
});

final _depotsProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final api = ref.watch(_apiProvSettings);
  final res = await api.get(Api.depots);
  return (res.data as List).cast<Map<String, dynamic>>();
});

// ── Screen ────────────────────────────────────────────────────────────────────

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(_profileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres')),
      body: ListView(
        children: [
          // ── Profile card ───────────────────────────────────────
          profileAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(16),
              child: LinearProgressIndicator(),
            ),
            error: (_, __) => const SizedBox.shrink(),
            data: (profile) => _ProfileCard(profile: profile),
          ),

          const _SectionHeader('GESTION'),

          _SettingsTile(
            icon: Icons.store,
            title: 'Dépôts',
            subtitle: 'Voir les dépôts / boutiques',
            onTap: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => _DepotsSheet(
                  depotsAsync: ref.watch(_depotsProvider)),
            ),
          ),

          _SettingsTile(
            icon: Icons.people,
            title: 'Employés',
            subtitle: 'Gérer les utilisateurs et rôles',
            onTap: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => _EmployeesSheet(
                  employeesAsync: ref.watch(_employeesProvider)),
            ),
          ),

          const _SectionHeader('APPAREILS'),

          _SettingsTile(
            icon: Icons.add_to_photos,
            title: 'Jumeler un nouvel appareil',
            subtitle: 'Générer un code à 6 chiffres',
            onTap: () => _generateCode(context),
          ),

          _SettingsTile(
            icon: Icons.link_off,
            color: kWarning,
            title: 'Re-jumeler cet appareil',
            subtitle: 'Dissocier et jumeler à nouveau',
            onTap: () => _repairDevice(context),
          ),

          const _SectionHeader('COMPTE'),

          _SettingsTile(
            icon: Icons.dns,
            title: 'Adresse du serveur',
            subtitle: 'Modifier l\'URL du serveur ENVentory',
            onTap: () => context.go('/setup'),
          ),

          _SettingsTile(
            icon: Icons.logout,
            color: kDanger,
            title: 'Déconnexion',
            onTap: () => _logout(context),
          ),

          const SizedBox(height: 40),

          Center(
            child: Text(
              'ENVentory · Depot Pro',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
            ),
          ),
          const SizedBox(height: 20),
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
              const Text(
                  'Entrez ce code sur le nouvel appareil. Il expire dans 15 minutes.',
                  style: TextStyle(color: kTextSecondary)),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: code));
                  ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
                    content: Text('Code copié'),
                    duration: Duration(seconds: 1),
                  ));
                },
                child: Text(code,
                    style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 14,
                        color: kPrimary)),
              ),
              const SizedBox(height: 8),
              const Text('Appuyez pour copier',
                  style: TextStyle(fontSize: 11, color: kTextSecondary)),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Fermer'))
          ],
        ),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impossible de générer un code')));
    }
  }

  Future<void> _repairDevice(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Re-jumeler l\'appareil ?'),
        content: const Text(
            'Vous serez déconnecté et devrez entrer un nouveau code de jumelage.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Annuler')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Continuer')),
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
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Annuler')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: FilledButton.styleFrom(backgroundColor: kDanger),
              child: const Text('Déconnexion')),
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
          accessToken: '',
          refreshToken: '',
          deviceId: deviceId,
          businessId: businessId ?? '',
          depotId: depotId ?? '',
        );
      }
      if (context.mounted) context.go('/login');
    }
  }
}

// ── Profile card ──────────────────────────────────────────────────────────────

class _ProfileCard extends StatelessWidget {
  final Map<String, dynamic> profile;
  const _ProfileCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    final name = profile['name'] as String? ?? '';
    final email = profile['email'] as String? ?? '';
    final role = profile['role'] as String? ?? '';
    final business = (profile['business'] as Map?)?['name'] as String? ?? '';
    final depot = (profile['depot'] as Map?)?['name'] as String? ?? '';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [kPrimary, kPrimary.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.white.withValues(alpha: 0.2),
          child: Text(initial,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 24)),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800)),
              if (email.isNotEmpty)
                Text(email,
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 12)),
              const SizedBox(height: 4),
              Wrap(
                spacing: 6,
                children: [
                  if (role.isNotEmpty) _Chip(text: _roleLabel(role)),
                  if (business.isNotEmpty) _Chip(text: business),
                  if (depot.isNotEmpty) _Chip(text: depot, icon: Icons.store),
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }

  String _roleLabel(String role) {
    const map = {
      'OWNER': 'Propriétaire',
      'MANAGER': 'Gérant',
      'CASHIER': 'Caissier',
      'STOCK_MANAGER': 'Magasinier',
    };
    return map[role] ?? role;
  }
}

class _Chip extends StatelessWidget {
  final String text;
  final IconData? icon;
  const _Chip({required this.text, this.icon});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 10, color: Colors.white),
              const SizedBox(width: 3),
            ],
            Text(text,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700)),
          ],
        ),
      );
}

// ── Section header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Text(title,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: kTextSecondary,
                letterSpacing: 0.8)),
      );
}

// ── Settings tile ─────────────────────────────────────────────────────────────

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Color? color;
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? kPrimary;
    return ListTile(
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: c.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: c, size: 20),
      ),
      title: Text(title,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: color)),
      subtitle: subtitle != null
          ? Text(subtitle!,
              style: const TextStyle(fontSize: 12, color: kTextSecondary))
          : null,
      trailing: onTap != null
          ? Icon(Icons.chevron_right,
              color: Colors.grey.shade400, size: 20)
          : null,
      onTap: onTap,
    );
  }
}

// ── Employees sheet ───────────────────────────────────────────────────────────

class _EmployeesSheet extends StatelessWidget {
  final AsyncValue<List<Map<String, dynamic>>> employeesAsync;
  const _EmployeesSheet({required this.employeesAsync});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(top: 10, bottom: 6),
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
            child: Row(children: [
              const Expanded(
                child: Text('Équipe',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w800)),
              ),
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close)),
            ]),
          ),
          const Divider(height: 1),
          Expanded(
            child: employeesAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text('Erreur: $e',
                    style: const TextStyle(color: kTextSecondary)),
              ),
              data: (employees) => employees.isEmpty
                  ? const Center(
                      child: Text('Aucun employé',
                          style: TextStyle(color: kTextSecondary)))
                  : ListView.separated(
                      itemCount: employees.length,
                      separatorBuilder: (_, __) =>
                          const Divider(height: 1),
                      itemBuilder: (_, i) {
                        final emp = employees[i];
                        final name = emp['name'] as String? ?? '';
                        final role = emp['role'] as String? ?? '';
                        final email = emp['email'] as String? ?? '';
                        final active =
                            emp['isActive'] as bool? ?? true;
                        final initial = name.isNotEmpty
                            ? name[0].toUpperCase()
                            : '?';

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: kPrimary
                                .withValues(alpha: 0.1),
                            child: Text(initial,
                                style: const TextStyle(
                                    color: kPrimary,
                                    fontWeight: FontWeight.w800)),
                          ),
                          title: Text(name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700)),
                          subtitle: Text(
                            [
                              _roleLabel(role),
                              if (email.isNotEmpty) email,
                            ].join('  ·  '),
                            style:
                                const TextStyle(fontSize: 12),
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: active
                                  ? kSuccess.withValues(alpha: 0.1)
                                  : Colors.grey.shade200,
                              borderRadius:
                                  BorderRadius.circular(8),
                            ),
                            child: Text(
                              active ? 'Actif' : 'Inactif',
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: active
                                      ? kSuccess
                                      : kTextSecondary),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  String _roleLabel(String role) {
    const map = {
      'OWNER': 'Propriétaire',
      'MANAGER': 'Gérant',
      'CASHIER': 'Caissier',
      'STOCK_MANAGER': 'Magasinier',
    };
    return map[role] ?? role;
  }
}

// ── Depots sheet ──────────────────────────────────────────────────────────────

class _DepotsSheet extends StatelessWidget {
  final AsyncValue<List<Map<String, dynamic>>> depotsAsync;
  const _DepotsSheet({required this.depotsAsync});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(top: 10, bottom: 6),
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
            child: Row(children: [
              const Expanded(
                child: Text('Dépôts',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w800)),
              ),
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close)),
            ]),
          ),
          const Divider(height: 1),
          Expanded(
            child: depotsAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text('Erreur: $e',
                    style: const TextStyle(color: kTextSecondary)),
              ),
              data: (depots) => depots.isEmpty
                  ? const Center(
                      child: Text('Aucun dépôt',
                          style: TextStyle(color: kTextSecondary)))
                  : ListView.separated(
                      itemCount: depots.length,
                      separatorBuilder: (_, __) =>
                          const Divider(height: 1),
                      itemBuilder: (_, i) {
                        final depot = depots[i];
                        final name =
                            depot['name'] as String? ?? '';
                        final address =
                            depot['address'] as String? ?? '';
                        final type =
                            depot['type'] as String? ?? 'DEPOT';

                        return ListTile(
                          leading: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: kPrimary.withValues(alpha: 0.1),
                              borderRadius:
                                  BorderRadius.circular(10),
                            ),
                            child: Icon(
                              type == 'SHOP'
                                  ? Icons.storefront
                                  : Icons.warehouse,
                              color: kPrimary,
                              size: 20,
                            ),
                          ),
                          title: Text(name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700)),
                          subtitle: address.isNotEmpty
                              ? Text(address,
                                  style:
                                      const TextStyle(fontSize: 12))
                              : null,
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color:
                                  kPrimary.withValues(alpha: 0.08),
                              borderRadius:
                                  BorderRadius.circular(8),
                            ),
                            child: Text(
                              type == 'SHOP'
                                  ? 'Boutique'
                                  : 'Dépôt',
                              style: const TextStyle(
                                  fontSize: 11,
                                  color: kPrimary,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
