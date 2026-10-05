import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../core/theme/app_theme.dart';
import '../../data/sync/api_client.dart';
import '../../core/constants/api.dart';

final _apiProvSales = Provider<ApiClient>((ref) => ApiClient());

final _productsProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final api = ref.watch(_apiProvSales);
  final res = await api.get(Api.products);
  return (res.data as List).cast<Map<String, dynamic>>();
});

class _CartItem {
  final String productId;
  final String productName;
  final String unitId;
  final String unitName;
  int qty;
  int unitPrice;

  _CartItem({
    required this.productId,
    required this.productName,
    required this.unitId,
    required this.unitName,
    required this.qty,
    required this.unitPrice,
  });

  int get lineTotal => qty * unitPrice;
}

class SalesScreen extends ConsumerStatefulWidget {
  const SalesScreen({super.key});

  @override
  ConsumerState<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends ConsumerState<SalesScreen> {
  final List<_CartItem> _cart = [];
  String _searchQuery = '';
  final _payments = <String, int>{};
  bool _paying = false;

  int get _cartTotal => _cart.fold(0, (s, i) => s + i.lineTotal);
  int get _totalPaid => _payments.values.fold(0, (s, v) => s + v);
  int get _change => _totalPaid - _cartTotal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvelle vente'),
        actions: [
          if (_cart.isNotEmpty)
            TextButton.icon(
              onPressed: () => setState(() { _cart.clear(); _payments.clear(); }),
              icon: const Icon(Icons.delete_outline, color: Colors.white70),
              label: const Text('Vider', style: TextStyle(color: Colors.white70)),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Rechercher un produit…',
              ),
              onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ref.watch(_productsProvider).when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off, size: 48, color: kTextSecondary),
                    const SizedBox(height: 8),
                    const Text('Impossible de charger les produits', style: TextStyle(color: kTextSecondary)),
                    TextButton.icon(
                      onPressed: () => ref.invalidate(_productsProvider),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),
              data: (products) {
                final filtered = _searchQuery.isEmpty
                    ? products
                    : products.where((p) =>
                        (p['name'] as String? ?? '').toLowerCase().contains(_searchQuery) ||
                        (p['brand'] as String? ?? '').toLowerCase().contains(_searchQuery)).toList();

                if (filtered.isEmpty) {
                  return const Center(
                    child: Text('Aucun produit trouvé', style: TextStyle(color: kTextSecondary)),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (_, i) => _ProductTile(
                    product: filtered[i],
                    onAdd: _addToCart,
                  ),
                );
              },
            ),
          ),
          if (_cart.isNotEmpty)
            _CartSummary(
              cart: _cart,
              total: _cartTotal,
              payments: _payments,
              change: _change,
              paying: _paying,
              onPaymentChanged: (method, amount) => setState(() => _payments[method] = amount),
              onPay: _pay,
            ),
        ],
      ),
    );
  }

  void _addToCart(String productId, String productName, String unitId, String unitName, int unitPrice) {
    setState(() {
      final existing = _cart.where((c) => c.productId == productId && c.unitId == unitId).firstOrNull;
      if (existing != null) {
        existing.qty++;
      } else {
        _cart.add(_CartItem(
          productId: productId, productName: productName,
          unitId: unitId, unitName: unitName,
          qty: 1, unitPrice: unitPrice,
        ));
      }
    });
  }

  Future<void> _pay() async {
    if (_cart.isEmpty || _totalPaid < _cartTotal) return;
    setState(() => _paying = true);

    try {
      final api = ref.read(_apiProvSales);
      final deviceId = await api.getDeviceId() ?? '';
      final depotId = await api.getDepotId() ?? '';
      const uuid = Uuid();
      final saleId = uuid.v4();

      await api.post(Api.sales, data: {
        'id': saleId,
        'lines': _cart.map((c) => {
          'id': uuid.v4(),
          'productId': c.productId,
          'unitId': c.unitId,
          'qty': c.qty,
          'unitPrice': c.unitPrice,
          'lineTotal': c.lineTotal,
        }).toList(),
        'payments': _payments.entries
            .where((e) => e.value > 0)
            .map((e) => {'id': uuid.v4(), 'method': e.key, 'amount': e.value})
            .toList(),
        'depotId': depotId,
        'deviceId': deviceId,
      });

      if (mounted) {
        setState(() { _cart.clear(); _payments.clear(); });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vente enregistrée ✓'),
            backgroundColor: kSuccess,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString().contains('400') ? 'Données invalides' : 'Connexion impossible'}'),
            backgroundColor: kDanger,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _paying = false);
    }
  }
}

class _ProductTile extends StatelessWidget {
  final Map<String, dynamic> product;
  final void Function(String, String, String, String, int) onAdd;

  const _ProductTile({required this.product, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final units = (product['units'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final baseUnit = units.where((u) => u['isBase'] == true).firstOrNull ?? (units.isNotEmpty ? units.first : null);

    return GestureDetector(
      onTap: () => _showAddDialog(context, units),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: kPrimary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.inventory_2, color: kPrimary, size: 20),
                ),
                const Spacer(),
                if (baseUnit != null)
                  Text(
                    formatFcfa(baseUnit['retailPrice'] as int? ?? 0),
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: kPrimary),
                  ),
              ]),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'] as String? ?? '',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                    maxLines: 2, overflow: TextOverflow.ellipsis,
                  ),
                  if (product['brand'] != null)
                    Text(product['brand'] as String, style: const TextStyle(fontSize: 11, color: kTextSecondary)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showAddDialog(BuildContext context, List<Map<String, dynamic>> units) async {
    if (units.isEmpty || !context.mounted) return;

    Map<String, dynamic> selectedUnit = units.first;
    int qty = 1;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
            left: 20, right: 20, top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product['name'] as String? ?? '',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              if (product['brand'] != null)
                Text(product['brand'] as String, style: const TextStyle(color: kTextSecondary)),
              const SizedBox(height: 16),
              if (units.length > 1)
                DropdownButtonFormField<Map<String, dynamic>>(
                  initialValue: selectedUnit,
                  decoration: const InputDecoration(labelText: 'Unité'),
                  items: units.map((u) => DropdownMenuItem(
                    value: u,
                    child: Text('${u['name']} — ${formatFcfa(u['retailPrice'] as int? ?? 0)}'),
                  )).toList(),
                  onChanged: (u) { if (u != null) setS(() => selectedUnit = u); },
                )
              else
                Text('Unité: ${selectedUnit['name']} — ${formatFcfa(selectedUnit['retailPrice'] as int? ?? 0)}',
                    style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 16),
              Row(children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  iconSize: 36,
                  onPressed: () { if (qty > 1) setS(() => qty--); },
                ),
                Expanded(
                  child: Center(
                    child: Text('$qty', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  iconSize: 36,
                  color: kPrimary,
                  onPressed: () => setS(() => qty++),
                ),
              ]),
              const SizedBox(height: 8),
              Text(
                'Total: ${formatFcfa(qty * (selectedUnit['retailPrice'] as int? ?? 0))}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: kPrimary),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    onAdd(
                      product['id'] as String,
                      product['name'] as String,
                      selectedUnit['id'] as String,
                      selectedUnit['name'] as String,
                      selectedUnit['retailPrice'] as int? ?? 0,
                    );
                    Navigator.pop(ctx);
                  },
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Ajouter au panier'),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  final List<_CartItem> cart;
  final int total;
  final Map<String, int> payments;
  final int change;
  final bool paying;
  final void Function(String, int) onPaymentChanged;
  final VoidCallback onPay;

  const _CartSummary({
    required this.cart,
    required this.total,
    required this.payments,
    required this.change,
    required this.paying,
    required this.onPaymentChanged,
    required this.onPay,
  });

  @override
  Widget build(BuildContext context) {
    final paid = payments.values.fold(0, (s, v) => s + v);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, -4))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            dense: true,
            title: Text('${cart.length} article(s)', style: const TextStyle(fontWeight: FontWeight.w600)),
            trailing: Text(formatFcfa(total),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: kPrimary)),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Wrap(
              spacing: 8,
              children: ['CASH', 'FLOOZ', 'MIXX', 'CREDIT'].map((method) {
                return _PaymentChip(
                  label: paymentMethodLabel(method),
                  color: paymentMethodColor(method),
                  value: payments[method] ?? 0,
                  onChanged: (v) => onPaymentChanged(method, v),
                );
              }).toList(),
            ),
          ),
          if (change > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(children: [
                const Text('Monnaie à rendre: ', style: TextStyle(color: kSuccess, fontWeight: FontWeight.w600)),
                Text(formatFcfa(change), style: const TextStyle(color: kSuccess, fontWeight: FontWeight.w800, fontSize: 16)),
              ]),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: (paid >= total && !paying) ? onPay : null,
                icon: paying
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.check),
                label: Text(paying
                    ? 'Enregistrement…'
                    : paid >= total
                        ? 'Enregistrer la vente'
                        : 'Manque ${formatFcfa(total - paid)}'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentChip extends StatelessWidget {
  final String label;
  final Color color;
  final int value;
  final ValueChanged<int> onChanged;

  const _PaymentChip({required this.label, required this.color, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final ctrl = TextEditingController(text: value > 0 ? value.toString() : '');
        final result = await showDialog<int>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Paiement $label'),
            content: TextField(
              controller: ctrl,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: const InputDecoration(suffixText: 'FCFA'),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, int.tryParse(ctrl.text) ?? 0),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        if (result != null) onChanged(result);
      },
      child: Chip(
        label: Text(value > 0 ? '$label: ${formatFcfaCompact(value)}' : label),
        backgroundColor: value > 0 ? color.withValues(alpha: 0.15) : Colors.grey.shade100,
        labelStyle: TextStyle(
          color: value > 0 ? color : kTextSecondary,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        side: BorderSide(color: value > 0 ? color : Colors.transparent),
      ),
    );
  }
}
