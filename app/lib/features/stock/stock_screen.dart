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

class _StockList extends ConsumerStatefulWidget {
  final List<Map<String, dynamic>> items;
  const _StockList({required this.items});

  @override
  ConsumerState<_StockList> createState() => _StockListState();
}

class _StockListState extends ConsumerState<_StockList> {
  String _query = '';

  void _openAdjust(BuildContext ctx, Map<String, dynamic> item) async {
    final updated = await showModalBottomSheet<bool>(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AdjustStockSheet(item: item),
    );
    if (updated == true) ref.invalidate(_stockProvider);
  }

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
              if (isNeg || isOut) statusColor = kDanger;
              else if (isLow) statusColor = kWarning;

              final purchasePrice = base?['purchasePrice'] as int? ?? 0;
              final costValue = qty * purchasePrice;

              return ListTile(
                onTap: () => _openAdjust(context, item),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                leading: Container(
                  width: 8, height: 44,
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                title: Text(prod['name'] as String? ?? '',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text([
                  if (cat['name'] != null) cat['name'] as String,
                  if (prod['brand'] != null) prod['brand'] as String,
                ].join(' · '), style: const TextStyle(fontSize: 12)),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('$qty ${base?['name'] ?? 'u'}',
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: statusColor)),
                    Text(formatFcfa(costValue),
                        style: const TextStyle(fontSize: 11, color: kTextSecondary)),
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

// ── Adjust Stock Sheet ────────────────────────────────────────────────────────

class _AdjustStockSheet extends StatefulWidget {
  final Map<String, dynamic> item;
  const _AdjustStockSheet({required this.item});

  @override
  State<_AdjustStockSheet> createState() => _AdjustStockSheetState();
}

class _AdjustStockSheetState extends State<_AdjustStockSheet> {
  final _qtyCtrl = TextEditingController();
  final _reasonCtrl = TextEditingController();
  final _api = ApiClient();
  bool _isEntry = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _qtyCtrl.dispose();
    _reasonCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final qty = int.tryParse(_qtyCtrl.text.trim());
    if (qty == null || qty <= 0) {
      setState(() => _error = 'Entrez une quantité valide (> 0)');
      return;
    }
    final depotId = await _api.getDepotId();
    if (depotId == null) {
      setState(() => _error = 'Dépôt non configuré — reconnectez-vous');
      return;
    }
    final productId = widget.item['productId'] as String?;
    if (productId == null) {
      setState(() => _error = 'Article non identifié');
      return;
    }

    setState(() { _loading = true; _error = null; });
    try {
      final delta = _isEntry ? qty : -qty;
      final reason = _reasonCtrl.text.trim().isNotEmpty
          ? _reasonCtrl.text.trim()
          : (_isEntry ? 'Entrée stock manuelle' : 'Sortie stock manuelle');
      await _api.post('${Api.stock}/adjustment', data: {
        'depotId': depotId,
        'productId': productId,
        'qtyInBase': delta,
        'reason': reason,
      });
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      final msg = e.toString();
      setState(() => _error = msg.contains('500') ? 'Erreur serveur' : 'Erreur: $msg');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final prod = widget.item['product'] as Map? ?? {};
    final units = (prod['units'] as List?)?.cast<Map>() ?? [];
    final base = units.where((u) => u['isBase'] == true).firstOrNull ?? (units.isNotEmpty ? units.first : null);
    final currentQty = widget.item['cachedQty'] as int? ?? 0;
    final unitName = base?['name'] as String? ?? 'u';

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 20, right: 20, top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(prod['name'] as String? ?? '',
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                Text('Stock actuel : $currentQty $unitName',
                    style: const TextStyle(fontSize: 13, color: kTextSecondary)),
              ]),
            ),
            IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
          ]),
          const Divider(height: 24),

          // Entry / Exit toggle
          Row(children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _isEntry = true),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _isEntry ? kSuccess : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.add_circle_outline,
                        color: _isEntry ? Colors.white : kTextSecondary, size: 18),
                    const SizedBox(width: 6),
                    Text('Entrée', style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: _isEntry ? Colors.white : kTextSecondary)),
                  ]),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _isEntry = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: !_isEntry ? kDanger : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.remove_circle_outline,
                        color: !_isEntry ? Colors.white : kTextSecondary, size: 18),
                    const SizedBox(width: 6),
                    Text('Sortie', style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: !_isEntry ? Colors.white : kTextSecondary)),
                  ]),
                ),
              ),
            ),
          ]),
          const SizedBox(height: 16),

          TextField(
            controller: _qtyCtrl,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Quantité ($unitName) *',
              prefixIcon: Icon(_isEntry ? Icons.add : Icons.remove,
                  color: _isEntry ? kSuccess : kDanger),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _reasonCtrl,
            decoration: const InputDecoration(
              labelText: 'Motif (optionnel)',
              hintText: 'ex: Réception commande, Inventaire…',
              prefixIcon: Icon(Icons.note_outlined),
            ),
            textCapitalization: TextCapitalization.sentences,
          ),

          if (_error != null) ...[
            const SizedBox(height: 10),
            Text(_error!, style: const TextStyle(color: kDanger, fontSize: 13)),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: _isEntry ? kSuccess : kDanger,
              ),
              onPressed: _loading ? null : _submit,
              icon: _loading
                  ? const SizedBox(width: 18, height: 18,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Icon(_isEntry ? Icons.add_circle_outline : Icons.remove_circle_outline),
              label: Text(_loading
                  ? 'Enregistrement…'
                  : (_isEntry ? 'Valider l\'entrée' : 'Valider la sortie')),
            ),
          ),
        ],
      ),
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
