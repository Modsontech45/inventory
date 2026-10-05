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
          IconButton(icon: const Icon(Icons.warning_amber, color: Colors.amber), onPressed: () => _showLowStock(context, ref)),
          IconButton(icon: const Icon(Icons.refresh), onPressed: () => ref.invalidate(_stockProvider)),
        ],
      ),
      body: ref.watch(_stockProvider).when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur: $e')),
        data: (items) => _StockList(items: items.cast<Map<String, dynamic>>()),
      ),
    );
  }

  void _showLowStock(BuildContext context, WidgetRef ref) {
    ref.read(_stockProvider).whenData((items) {
      final low = items.cast<Map<String, dynamic>>().where((i) => (i['isLowStock'] as bool? ?? false) || (i['isOutOfStock'] as bool? ?? false)).toList();
      showModalBottomSheet(
        context: context,
        builder: (ctx) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Stock faible / rupture (${low.length})', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            ...low.map((i) => ListTile(
              leading: Icon(i['isOutOfStock'] as bool? ?? false ? Icons.close : Icons.warning_amber, color: i['isOutOfStock'] as bool? ?? false ? kDanger : kWarning),
              title: Text(i['name'] as String? ?? ''),
              subtitle: Text(i['brand'] as String? ?? ''),
              trailing: Text('${i['qtyInBase']} ${i['baseUnitName'] ?? 'u'}', style: TextStyle(fontWeight: FontWeight.w700, color: (i['isOutOfStock'] as bool? ?? false) ? kDanger : kWarning)),
            )),
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
        : widget.items.where((i) => (i['name'] as String? ?? '').toLowerCase().contains(_query.toLowerCase())).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Rechercher…'),
            onChanged: (v) => setState(() => _query = v),
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: filtered.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final item = filtered[i];
              final isLow = item['isLowStock'] as bool? ?? false;
              final isOut = item['isOutOfStock'] as bool? ?? false;
              final isNeg = item['isNegative'] as bool? ?? false;

              Color statusColor = kSuccess;
              if (isNeg) { statusColor = kDanger; }
              else if (isOut) { statusColor = kDanger; }
              else if (isLow) { statusColor = kWarning; }

              return ListTile(
                leading: Container(
                  width: 8,
                  height: 40,
                  decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(4)),
                ),
                title: Text(item['name'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text('${item['category'] ?? ''} ${item['brand'] != null ? '· ${item['brand']}' : ''}'),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${item['qtyInBase']} ${item['baseUnitName'] ?? 'u'}',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: statusColor),
                    ),
                    Text(formatFcfa(item['costValue'] as int? ?? 0), style: const TextStyle(fontSize: 11, color: kTextSecondary)),
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
