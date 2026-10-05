import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../../data/sync/api_client.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  static const _tabs = [
    (path: '/dashboard', icon: Icons.dashboard_outlined, activeIcon: Icons.dashboard, label: 'Tableau de bord'),
    (path: '/sell', icon: Icons.point_of_sale_outlined, activeIcon: Icons.point_of_sale, label: 'Vendre'),
    (path: '/stock', icon: Icons.inventory_2_outlined, activeIcon: Icons.inventory_2, label: 'Stock'),
    (path: '/customers', icon: Icons.people_outline, activeIcon: Icons.people, label: 'Clients'),
    (path: '/products', icon: Icons.category_outlined, activeIcon: Icons.category, label: 'Articles'),
    (path: '/settings', icon: Icons.settings_outlined, activeIcon: Icons.settings, label: 'Paramètres'),
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final idx = _tabs.indexWhere((t) => location.startsWith(t.path));
    final selected = idx < 0 ? 0 : idx;
    final isWide = MediaQuery.sizeOf(context).width >= 720;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.inventory_2, color: Colors.white, size: 24),
            const SizedBox(width: 10),
            const Text('ENVentory',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20)),
          ],
        ),
        actions: [
          _SyncButton(),
          const SizedBox(width: 8),
          _ProfileMenu(),
          const SizedBox(width: 8),
        ],
      ),
      body: isWide
          ? Row(
              children: [
                NavigationRail(
                  selectedIndex: selected,
                  onDestinationSelected: (i) => context.go(_tabs[i].path),
                  backgroundColor: kSurface,
                  indicatorColor: kPrimary.withValues(alpha: 0.12),
                  extended: isWide && MediaQuery.sizeOf(context).width >= 1100,
                  labelType: isWide && MediaQuery.sizeOf(context).width >= 1100
                      ? NavigationRailLabelType.none
                      : NavigationRailLabelType.all,
                  destinations: _tabs.map((t) => NavigationRailDestination(
                    icon: Icon(t.icon),
                    selectedIcon: Icon(t.activeIcon, color: kPrimary),
                    label: Text(t.label),
                  )).toList(),
                ),
                const VerticalDivider(width: 1),
                Expanded(child: child),
              ],
            )
          : Column(
              children: [
                Expanded(child: child),
                NavigationBar(
                  selectedIndex: selected,
                  onDestinationSelected: (i) => context.go(_tabs[i].path),
                  backgroundColor: kSurface,
                  indicatorColor: kPrimary.withValues(alpha: 0.12),
                  labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                  destinations: _tabs.map((t) => NavigationDestination(
                    icon: Icon(t.icon),
                    selectedIcon: Icon(t.activeIcon, color: kPrimary),
                    label: t.label,
                  )).toList(),
                ),
              ],
            ),
    );
  }
}

class _SyncButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.sync, color: Colors.white),
      tooltip: 'Synchroniser',
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Synchronisation en cours…'), duration: Duration(seconds: 2)),
        );
      },
    );
  }
}

class _ProfileMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Profil',
      offset: const Offset(0, 40),
      child: const CircleAvatar(
        backgroundColor: Colors.white24,
        radius: 16,
        child: Icon(Icons.person, color: Colors.white, size: 20),
      ),
      onSelected: (value) async {
        if (value == 'settings') {
          context.go('/settings');
        } else if (value == 'logout') {
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
          if (confirm == true && context.mounted) {
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
      },
      itemBuilder: (_) => [
        const PopupMenuItem(value: 'settings', child: ListTile(leading: Icon(Icons.settings), title: Text('Paramètres'), dense: true)),
        const PopupMenuDivider(),
        const PopupMenuItem(value: 'logout', child: ListTile(leading: Icon(Icons.logout, color: kDanger), title: Text('Déconnexion', style: TextStyle(color: kDanger)), dense: true)),
      ],
    );
  }
}
