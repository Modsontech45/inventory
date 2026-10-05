import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../data/sync/api_client.dart';
import '../../core/constants/api.dart';

final _productsApiProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  final api = ref.watch(_apiProvP);
  final res = await api.get(Api.products);
  return res.data as List<dynamic>;
});

final _apiProvP = Provider<ApiClient>((ref) => ApiClient());

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Articles'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: () => ref.invalidate(_productsApiProvider)),
        ],
      ),
      body: ref.watch(_productsApiProvider).when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (products) => _ProductsList(products: products.cast<Map<String, dynamic>>()),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('Nouvel article'),
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
      ),
    );
  }
}

class _ProductsList extends StatefulWidget {
  final List<Map<String, dynamic>> products;
  const _ProductsList({required this.products});

  @override
  State<_ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<_ProductsList> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = _query.isEmpty
        ? widget.products
        : widget.products.where((p) =>
            (p['name'] as String? ?? '').toLowerCase().contains(_query.toLowerCase()) ||
            (p['brand'] as String? ?? '').toLowerCase().contains(_query.toLowerCase())).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Rechercher un article…'),
            onChanged: (v) => setState(() => _query = v),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (_, i) {
              final p = filtered[i];
              final units = (p['units'] as List?)?.cast<Map<String, dynamic>>() ?? [];
              final baseUnit = units.where((u) => u['isBase'] == true).firstOrNull;
              final stockLevels = (p['stockLevels'] as List?)?.cast<Map<String, dynamic>>() ?? [];
              final totalQty = stockLevels.fold<int>(0, (s, l) => s + (l['cachedQty'] as int? ?? 0));

              return ListTile(
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(color: kPrimary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.inventory_2, color: kPrimary),
                ),
                title: Text(p['name'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w700)),
                subtitle: Text([
                  if (p['brand'] != null) p['brand'] as String,
                  if (p['category'] != null && (p['category'] as Map)['name'] != null) (p['category'] as Map)['name'] as String,
                ].join(' · ')),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$totalQty ${baseUnit?['name'] ?? 'u'}',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: totalQty > 0 ? kSuccess : kDanger),
                    ),
                    if (baseUnit != null)
                      Text(formatFcfa(baseUnit['retailPrice'] as int? ?? 0), style: const TextStyle(fontSize: 11, color: kTextSecondary)),
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
