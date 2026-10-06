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

// ── Helpers ───────────────────────────────────────────────────────────────────

/// Returns a list of "X UnitName" strings for every non-base unit
/// whose whole-unit count is ≥ 1 or whose remainder matters.
List<String> _unitBreakdown(int qtyBase, List<Map> units) {
  final nonBase = units.where((u) => u['isBase'] != true && (u['factor'] as int? ?? 0) > 1).toList();
  final out = <String>[];
  for (final u in nonBase) {
    final factor = u['factor'] as int? ?? 1;
    final whole = qtyBase ~/ factor;
    final rem = qtyBase % factor;
    final name = u['name'] as String? ?? '';
    if (whole > 0 && rem == 0) {
      out.add('$whole $name');
    } else if (whole > 0) {
      out.add('$whole $name + $rem');
    }
    // if whole == 0, skip
  }
  return out;
}

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
                final base = units.where((u) => u['isBase'] == true).firstOrNull
                    ?? (units.isNotEmpty ? units.first : null);
                final isOut = i['isOutOfStock'] as bool? ?? false;
                final qty = i['cachedQty'] as int? ?? 0;
                return ListTile(
                  leading: Icon(isOut ? Icons.close : Icons.warning_amber,
                      color: isOut ? kDanger : kWarning),
                  title: Text(prod['name'] as String? ?? ''),
                  subtitle: Text(prod['brand'] as String? ?? ''),
                  trailing: Text(
                    '$qty ${base?['name'] ?? 'u'}',
                    style: TextStyle(fontWeight: FontWeight.w700,
                        color: isOut ? kDanger : kWarning),
                  ),
                );
              }),
          ],
        ),
      );
    });
  }
}

// ── Stock List ────────────────────────────────────────────────────────────────

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
            return name.contains(_query.toLowerCase()) ||
                brand.contains(_query.toLowerCase());
          }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
          child: TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Rechercher…',
            ),
            onChanged: (v) => setState(() => _query = v),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 80),
            itemCount: filtered.length,
            itemBuilder: (_, i) => _StockCard(
              item: filtered[i],
              onTap: () => _openAdjust(context, filtered[i]),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Stock Card ────────────────────────────────────────────────────────────────

class _StockCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onTap;
  const _StockCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final prod = item['product'] as Map? ?? {};
    final cat = prod['category'] as Map? ?? {};
    final units = (prod['units'] as List?)?.cast<Map>() ?? [];
    final base = units.where((u) => u['isBase'] == true).firstOrNull ??
        (units.isNotEmpty ? units.first : null);
    final bulk = units.where((u) => u['isBase'] != true).toList();

    final qty = item['cachedQty'] as int? ?? 0;
    final isLow = item['isLowStock'] as bool? ?? false;
    final isOut = item['isOutOfStock'] as bool? ?? false;
    final isNeg = qty < 0;

    Color statusColor = kSuccess;
    String statusLabel = 'En stock';
    IconData statusIcon = Icons.check_circle_outline;
    if (isNeg || isOut) {
      statusColor = kDanger;
      statusLabel = 'Rupture';
      statusIcon = Icons.cancel_outlined;
    } else if (isLow) {
      statusColor = kWarning;
      statusLabel = 'Stock faible';
      statusIcon = Icons.warning_amber_outlined;
    }

    final baseName = base?['name'] as String? ?? 'u';
    final retailPrice = base?['retailPrice'] as int? ?? 0;
    final purchasePrice = base?['purchasePrice'] as int? ?? 0;
    final costValue = qty * purchasePrice;

    // Build bulk equivalents
    final equivalents = <Map<String, String>>[];
    for (final u in bulk) {
      final factor = u['factor'] as int? ?? 1;
      if (factor < 2) continue;
      final whole = qty ~/ factor;
      final rem = qty % factor;
      final name = u['name'] as String? ?? '';
      final uRetail = u['retailPrice'] as int? ?? 0;
      equivalents.add({
        'label': rem == 0 ? '$whole $name' : '$whole $name + $rem',
        'price': uRetail > 0 ? formatFcfa(uRetail) : '',
        'factor': '$factor $baseName = 1 $name',
      });
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Status bar (left edge)
              Container(width: 6, color: statusColor),

              // Main content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Header ──────────────────────────────────────────
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              prod['name'] as String? ?? '',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w800),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(statusIcon,
                                    size: 12, color: statusColor),
                                const SizedBox(width: 4),
                                Text(statusLabel,
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: statusColor)),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Category / brand
                      if (cat['name'] != null || prod['brand'] != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2, bottom: 8),
                          child: Text(
                            [
                              if (cat['name'] != null) cat['name'] as String,
                              if (prod['brand'] != null) prod['brand'] as String,
                            ].join(' · '),
                            style: const TextStyle(
                                fontSize: 12, color: kTextSecondary),
                          ),
                        )
                      else
                        const SizedBox(height: 8),

                      // ── Quantity block ───────────────────────────────────
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Base qty (prominent)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$qty',
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w900,
                                  color: statusColor,
                                  height: 1,
                                ),
                              ),
                              Text(
                                baseName,
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: kTextSecondary),
                              ),
                            ],
                          ),

                          // Equivalents (bulk units)
                          if (equivalents.isNotEmpty) ...[
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: equivalents
                                    .map((e) => Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 4),
                                          child: Row(children: [
                                            const Icon(
                                                Icons.subdirectory_arrow_right,
                                                size: 14,
                                                color: kTextSecondary),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                e['label']!,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            if (e['price']!.isNotEmpty)
                                              Text(
                                                e['price']!,
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: kTextSecondary),
                                              ),
                                          ]),
                                        ))
                                    .toList(),
                              ),
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: 10),
                      const Divider(height: 1),
                      const SizedBox(height: 8),

                      // ── Footer : prices + adjust hint ────────────────────
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (retailPrice > 0)
                                  Text(
                                    '${formatFcfa(retailPrice)} / $baseName',
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: kPrimary),
                                  ),
                                if (costValue > 0)
                                  Text(
                                    'Valeur : ${formatFcfa(costValue)}',
                                    style: const TextStyle(
                                        fontSize: 11, color: kTextSecondary),
                                  ),
                              ],
                            ),
                          ),
                          // Adjust button
                          TextButton.icon(
                            onPressed: onTap,
                            icon: const Icon(Icons.tune, size: 16),
                            label: const Text('Ajuster'),
                            style: TextButton.styleFrom(
                              foregroundColor: kPrimary,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              textStyle: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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

  // Selected unit for qty entry (defaults to base unit)
  Map? _selectedUnit;
  List<Map> _units = [];

  @override
  void initState() {
    super.initState();
    final prod = widget.item['product'] as Map? ?? {};
    _units = (prod['units'] as List?)?.cast<Map>() ?? [];
    _selectedUnit = _units.where((u) => u['isBase'] == true).firstOrNull
        ?? (_units.isNotEmpty ? _units.first : null);
  }

  @override
  void dispose() {
    _qtyCtrl.dispose();
    _reasonCtrl.dispose();
    super.dispose();
  }

  int get _factor => (_selectedUnit?['factor'] as int? ?? 1);

  /// Qty entered by user, converted to base units
  int get _deltaInBase {
    final entered = int.tryParse(_qtyCtrl.text.trim()) ?? 0;
    return entered * _factor;
  }

  Future<void> _submit() async {
    final entered = int.tryParse(_qtyCtrl.text.trim());
    if (entered == null || entered <= 0) {
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
      final deltaBase = _isEntry ? _deltaInBase : -_deltaInBase;
      final reason = _reasonCtrl.text.trim().isNotEmpty
          ? _reasonCtrl.text.trim()
          : (_isEntry ? 'Entrée stock manuelle' : 'Sortie stock manuelle');
      await _api.post('${Api.stock}/adjustment', data: {
        'depotId': depotId,
        'productId': productId,
        'qtyInBase': deltaBase,
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

  Widget _buildQtyColumn(String label, int qtyBase, {bool highlight = false}) {
    final base = _units.where((u) => u['isBase'] == true).firstOrNull
        ?? (_units.isNotEmpty ? _units.first : null);
    final baseName = base?['name'] as String? ?? 'u';

    final color = qtyBase > 0 ? kSuccess : (qtyBase < 0 ? kDanger : Colors.grey.shade400);

    return Expanded(
      child: Column(
        children: [
          Text(label,
              style: const TextStyle(fontSize: 11, color: kTextSecondary, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          // Base unit qty (large)
          Text(
            highlight && _deltaInBase == 0 ? '—' : '$qtyBase',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: color),
          ),
          Text(baseName, style: const TextStyle(fontSize: 11, color: kTextSecondary)),
          // Non-base equivalents
          ..._units.where((u) => u['isBase'] != true && (u['factor'] as int? ?? 0) > 1).map((u) {
            final factor = u['factor'] as int? ?? 1;
            final whole = qtyBase ~/ factor;
            final rem = qtyBase % factor;
            final name = u['name'] as String? ?? '';
            final str = whole > 0 && rem == 0
                ? '$whole $name'
                : whole > 0
                    ? '$whole $name + $rem'
                    : '0 $name';
            return Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(str,
                  style: const TextStyle(fontSize: 12, color: kTextSecondary)),
            );
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prod = widget.item['product'] as Map? ?? {};
    final currentQty = widget.item['cachedQty'] as int? ?? 0;
    final selectedName = _selectedUnit?['name'] as String? ?? 'u';

    final newQty = _isEntry ? currentQty + _deltaInBase : currentQty - _deltaInBase;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 20, right: 20, top: 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Expanded(
                child: Text(prod['name'] as String? ?? '',
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
              ),
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
            ]),
            const SizedBox(height: 8),

            // ── Multi-unit preview card ─────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildQtyColumn('ACTUEL', currentQty),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Icon(
                      Icons.arrow_forward,
                      color: _deltaInBase > 0
                          ? (_isEntry ? kSuccess : kDanger)
                          : Colors.grey.shade400,
                    ),
                  ),
                  _buildQtyColumn('APRÈS', newQty, highlight: true),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ── Entry / Exit toggle ─────────────────────────────────────────
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
            const SizedBox(height: 14),

            // ── Unit selector (only shown when product has multiple units) ──
            if (_units.length > 1) ...[
              const Text('Saisir la quantité en :',
                  style: TextStyle(fontSize: 12, color: kTextSecondary, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _units.map((u) {
                  final isSelected = _selectedUnit?['id'] == u['id'];
                  final uName = u['name'] as String? ?? '';
                  final factor = u['factor'] as int? ?? 1;
                  final base = _units.firstWhere((x) => x['isBase'] == true,
                      orElse: () => _units.first);
                  final baseName = base['name'] as String? ?? '';
                  return ChoiceChip(
                    label: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(uName, style: const TextStyle(fontWeight: FontWeight.w700)),
                        if (u['isBase'] != true)
                          Text('1 $uName = $factor $baseName',
                              style: const TextStyle(fontSize: 10)),
                      ],
                    ),
                    selected: isSelected,
                    onSelected: (_) => setState(() {
                      _selectedUnit = u;
                      _qtyCtrl.clear();
                    }),
                    selectedColor: kPrimary,
                    labelStyle: TextStyle(
                        color: isSelected ? Colors.white : kTextSecondary),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
            ],

            // ── Quantity field ──────────────────────────────────────────────
            TextField(
              controller: _qtyCtrl,
              keyboardType: TextInputType.number,
              autofocus: true,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: 'Quantité ($selectedName) *',
                prefixIcon: Icon(
                  _isEntry ? Icons.add : Icons.remove,
                  color: _isEntry ? kSuccess : kDanger,
                ),
                suffixText: selectedName,
                helperText: _factor > 1
                    ? '1 $selectedName = $_factor ${(_units.firstWhere((u) => u['isBase'] == true, orElse: () => _units.first))['name']}'
                    : null,
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
