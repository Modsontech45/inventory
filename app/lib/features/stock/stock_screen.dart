import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../data/sync/api_client.dart';
import '../../core/constants/api.dart';

final _stockProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  final api = ref.watch(_apiProv);
  final depotId = await api.getDepotId();
  final res = await api.get(Api.stock, params: depotId != null ? {'depotId': depotId} : null);
  return res.data as List<dynamic>;
});

final _apiProv = Provider<ApiClient>((ref) => ApiClient());

class StockScreen extends ConsumerWidget {
  const StockScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock'),
        actions: [
          IconButton(
            icon: const Icon(Icons.warning_amber, color: Colors.amber),
            tooltip: 'Stock faible',
            onPressed: () => _showLowStock(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(_stockProvider),
          ),
        ],
      ),
      body: ref.watch(_stockProvider).when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorRetry(error: e.toString(), onRetry: () => ref.invalidate(_stockProvider)),
        data: (items) => items.isEmpty
            ? _emptyState()
            : _StockList(items: items.cast<Map<String, dynamic>>()),
      ),
    );
  }

  Widget _emptyState() => const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.inventory_2_outlined, size: 64, color: kTextSecondary),
        SizedBox(height: 12),
        Text('Aucun stock disponible', style: TextStyle(fontSize: 16, color: kTextSecondary)),
        SizedBox(height: 4),
        Text('Ajoutez des articles dans l\'onglet Articles', style: TextStyle(fontSize: 13, color: kTextSecondary)),
      ],
    ),
  );

  void _showLowStock(BuildContext context, WidgetRef ref) {
    ref.read(_stockProvider).whenData((items) {
      final all = items.cast<Map<String, dynamic>>();
      final low = all.where((i) => (i['isLowStock'] as bool? ?? false) || (i['isOutOfStock'] as bool? ?? false)).toList();
      showModalBottomSheet(
        context: context,
        builder: (ctx) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Stock faible / rupture (${low.length})',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            if (low.isEmpty)
              const Text('Aucun article en rupture ou stock faible', style: TextStyle(color: kTextSecondary))
            else
              ...low.map((i) {
                final prod = i['product'] as Map? ?? {};
                final units = (prod['units'] as List?)?.cast<Map>() ?? [];
                final base = units.where((u) => u['isBase'] == true).firstOrNull ?? (units.isNotEmpty ? units.first : null);
                final isOut = i['isOutOfStock'] as bool? ?? false;
                return ListTile(
                  leading: Icon(
                    isOut ? Icons.close : Icons.warning_amber,
                    color: isOut ? kDanger : kWarning,
                  ),
                  title: Text(prod['name'] as String? ?? ''),
                  subtitle: Text(prod['brand'] as String? ?? ''),
                  trailing: Text(
                    '${i['cachedQty']} ${base?['name'] ?? 'u'}',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: isOut ? kDanger : kWarning,
                    ),
                  ),
                );
              }),
          ],
        ),
      );
    });
  }
}

class _StockList extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  const _StockList({required this.items});

  @override
  State<_StockList> createState() => _StockListState();
}

class _StockListState extends State<_StockList> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = _query.isEmpty
        ? widget.items
        : widget.items.where((i) {
            final prod = i['product'] as Map? ?? {};
            final name = (prod['name'] as String? ?? '').toLowerCase();
            final brand = (prod['brand'] as String? ?? '').toLowerCase();
            return name.contains(_query.toLowerCase()) || brand.contains(_query.toLowerCase());
          }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Rechercher…',
            ),
            onChanged: (v) => setState(() => _query = v),
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: filtered.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final item = filtered[i];
              final prod = item['product'] as Map? ?? {};
              final cat = prod['category'] as Map? ?? {};
              final units = (prod['units'] as List?)?.cast<Map>() ?? [];
              final base = units.where((u) => u['isBase'] == true).firstOrNull ?? (units.isNotEmpty ? units.first : null);

              final qty = item['cachedQty'] as int? ?? 0;
              final isLow = item['isLowStock'] as bool? ?? false;
              final isOut = item['isOutOfStock'] as bool? ?? false;
              final isNeg = qty < 0;

              Color statusColor = kSuccess;
              if (isNeg || isOut) {
                statusColor = kDanger;
              } else if (isLow) {
                statusColor = kWarning;
              }

              final purchasePrice = base?['purchasePrice'] as int? ?? 0;
              final costValue = qty * purchasePrice;

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                leading: Container(
                  width: 8,
                  height: 44,
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                title: Text(
                  prod['name'] as String? ?? '',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text([
                  if (cat['name'] != null) cat['name'] as String,
                  if (prod['brand'] != null) prod['brand'] as String,
                ].join(' · '), style: const TextStyle(fontSize: 12)),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$qty ${base?['name'] ?? 'u'}',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: statusColor,
                      ),
                    ),
                    Text(
                      formatFcfa(costValue),
                      style: const TextStyle(fontSize: 11, color: kTextSecondary),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ErrorRetry extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;
  const _ErrorRetry({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off, size: 48, color: kTextSecondary),
          const SizedBox(height: 12),
          const Text('Impossible de charger le stock', style: TextStyle(color: kTextSecondary)),
          const SizedBox(height: 4),
          Text(error, style: const TextStyle(fontSize: 11, color: kTextSecondary), textAlign: TextAlign.center),
          const SizedBox(height: 12),
          TextButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh), label: const Text('Réessayer')),
        ],
      ),
    );
  }
}
