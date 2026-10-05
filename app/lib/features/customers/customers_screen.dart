import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../data/sync/api_client.dart';
import '../../core/constants/api.dart';

final _customersProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  final api = ref.watch(_apiProvC);
  final res = await api.get(Api.customers);
  return res.data as List<dynamic>;
});

final _debtorsProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  final api = ref.watch(_apiProvC);
  final res = await api.get('${Api.customers}/debtors');
  return res.data as List<dynamic>;
});

final _apiProvC = Provider<ApiClient>((ref) => ApiClient());

class CustomersScreen extends ConsumerStatefulWidget {
  const CustomersScreen({super.key});

  @override
  ConsumerState<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends ConsumerState<CustomersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clients'),
        bottom: TabBar(
          controller: _tabs,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [Tab(text: 'Tous'), Tab(text: 'Dettes')],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _CustomerList(provider: _customersProvider),
          _DebtorList(provider: _debtorsProvider),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddCustomer(context),
        icon: const Icon(Icons.person_add),
        label: const Text('Nouveau client'),
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
      ),
    );
  }

  Future<void> _showAddCustomer(BuildContext context) async {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nouveau client'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nom')),
            const SizedBox(height: 12),
            TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Téléphone'), keyboardType: TextInputType.phone),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
          FilledButton(
            onPressed: () async {
              final api = ref.read(_apiProvC);
              await api.post(Api.customers, data: {'name': nameCtrl.text, 'phone': phoneCtrl.text});
              if (ctx.mounted) Navigator.pop(ctx);
              ref.invalidate(_customersProvider);
            },
            child: const Text('Créer'),
          ),
        ],
      ),
    );
  }
}

class _CustomerList extends ConsumerWidget {
  final ProviderBase<AsyncValue<List<dynamic>>> provider;
  const _CustomerList({required this.provider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(provider).when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (customers) => ListView.builder(
        itemCount: customers.length,
        itemBuilder: (_, i) {
          final c = customers[i] as Map<String, dynamic>;
          return ListTile(
            leading: CircleAvatar(backgroundColor: kPrimary, child: Text((c['name'] as String? ?? '?')[0].toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700))),
            title: Text(c['name'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(c['phone'] as String? ?? ''),
            trailing: const Icon(Icons.chevron_right),
          );
        },
      ),
    );
  }
}

class _DebtorList extends ConsumerWidget {
  final ProviderBase<AsyncValue<List<dynamic>>> provider;
  const _DebtorList({required this.provider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(provider).when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (debtors) => debtors.isEmpty
          ? const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.check_circle_outline, size: 64, color: kSuccess),
              SizedBox(height: 12),
              Text('Aucune dette en cours', style: TextStyle(fontSize: 16, color: kTextSecondary)),
            ]))
          : ListView.builder(
              itemCount: debtors.length,
              itemBuilder: (_, i) {
                final c = debtors[i] as Map<String, dynamic>;
                final balance = c['balance'] as int? ?? 0;
                return ListTile(
                  leading: CircleAvatar(backgroundColor: kWarning.withValues(alpha: 0.15), child: Text((c['name'] as String? ?? '?')[0].toUpperCase(), style: const TextStyle(color: kWarning, fontWeight: FontWeight.w700))),
                  title: Text(c['name'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(c['phone'] as String? ?? ''),
                  trailing: Text(formatFcfa(balance), style: const TextStyle(color: kWarning, fontWeight: FontWeight.w800, fontSize: 14)),
                );
              },
            ),
    );
  }
}
