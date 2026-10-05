import 'dart:convert';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../core/theme/app_theme.dart';
import '../../data/database/app_database.dart';
import '../../data/sync/api_client.dart';


final _dbProv = Provider<AppDatabase>((ref) => AppDatabase());
final _apiProv = Provider<ApiClient>((ref) => ApiClient());

final _productsProvider = FutureProvider.autoDispose<List<LocalProduct>>((ref) async {
  final db = ref.watch(_dbProv);
  final api = ref.watch(_apiProv);
  final biz = await api.getBusinessId();
  return db.getProductsForBusiness(biz ?? '');
});

class _CartItem {
  final LocalProduct product;
  final LocalProductUnit unit;
  int qty;
  int unitPrice;

  _CartItem({required this.product, required this.unit, required this.qty, required this.unitPrice});

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
              onPressed: () => setState(() => _cart.clear()),
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
              decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Rechercher un produit…'),
              onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ref.watch(_productsProvider).when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Erreur: $e')),
              data: (products) {
                final filtered = _searchQuery.isEmpty
                    ? products
                    : products.where((p) =>
                        p.name.toLowerCase().contains(_searchQuery) ||
                        (p.brand?.toLowerCase().contains(_searchQuery) ?? false) ||
                        (p.barcode?.contains(_searchQuery) ?? false)).toList();
                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 1.5, crossAxisSpacing: 8, mainAxisSpacing: 8,
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
          if (_cart.isNotEmpty) _CartSummary(
            cart: _cart,
            total: _cartTotal,
            payments: _payments,
            onPaymentChanged: (method, amount) => setState(() => _payments[method] = amount),
            onPay: _pay,
            change: _change,
          ),
        ],
      ),
    );
  }

  void _addToCart(LocalProduct product, LocalProductUnit unit, int qty) {
    setState(() {
      final existing = _cart.where((c) => c.product.id == product.id && c.unit.id == unit.id).firstOrNull;
      if (existing != null) {
        existing.qty += qty;
      } else {
        _cart.add(_CartItem(product: product, unit: unit, qty: qty, unitPrice: unit.retailPrice));
      }
    });
  }

  Future<void> _pay() async {
    if (_cart.isEmpty || _totalPaid < _cartTotal) return;

    final db = ref.read(_dbProv);
    final api = ref.read(_apiProv);
    final deviceId = await api.getDeviceId() ?? '';
    final businessId = await api.getBusinessId() ?? '';
    final depotId = await api.getDepotId() ?? '';
    final state = await db.getSyncState();
    final userId = state?.deviceId ?? '';

    final saleId = const Uuid().v4();
    final saleNumber = 'OFFLINE-${DateTime.now().millisecondsSinceEpoch}';
    final now = DateTime.now();

    final saleData = {
      '_table': 'sales',
      'id': saleId,
      'businessId': businessId,
      'depotId': depotId,
      'userId': userId,
      'deviceId': deviceId,
      'number': saleNumber,
      'status': 'ACTIVE',
      'totalAmount': _cartTotal,
      'discountAmount': 0,
      'createdAt': now.toIso8601String(),
      'updatedAt': now.toIso8601String(),
    };

    await db.into(db.localSales).insert(LocalSalesCompanion.insert(
      id: saleId,
      businessId: businessId,
      depotId: depotId,
      userId: userId,
      deviceId: deviceId,
      number: saleNumber,
      totalAmount: Value(_cartTotal),
    ));

    await db.into(db.syncOutbox).insert(SyncOutboxCompanion.insert(
      id: saleId,
      tableRef: 'sales',
      data: jsonEncode(saleData),
    ));

    setState(() {
      _cart.clear();
      _payments.clear();
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Vente enregistrée ✓'), backgroundColor: kSuccess, duration: const Duration(seconds: 2)),
      );
    }
  }
}

class _ProductTile extends StatelessWidget {
  final LocalProduct product;
  final void Function(LocalProduct, LocalProductUnit, int) onAdd;

  const _ProductTile({required this.product, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showAddDialog(context),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Container(width: 36, height: 36,
                  decoration: BoxDecoration(color: kPrimary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.inventory_2, color: kPrimary, size: 20)),
                const Spacer(),
                Container(width: 6, height: 6, decoration: const BoxDecoration(color: kSuccess, shape: BoxShape.circle)),
              ]),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700), maxLines: 2, overflow: TextOverflow.ellipsis),
                  if (product.brand != null)
                    Text(product.brand!, style: const TextStyle(fontSize: 11, color: kTextSecondary)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showAddDialog(BuildContext context) async {
    final db = AppDatabase();
    final units = await db.getUnitsForProduct(product.id);
    if (units.isEmpty || !context.mounted) return;

    LocalProductUnit selectedUnit = units.first;
    int qty = 1;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom + 16, left: 20, right: 20, top: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              if (product.brand != null) Text(product.brand!, style: const TextStyle(color: kTextSecondary)),
              const SizedBox(height: 16),
              DropdownButtonFormField<LocalProductUnit>(
                initialValue: selectedUnit,
                decoration: const InputDecoration(labelText: 'Unité'),
                items: units.map((u) => DropdownMenuItem(value: u, child: Text('${u.name} — ${formatFcfa(u.retailPrice)}'))).toList(),
                onChanged: (u) { if (u != null) setS(() => selectedUnit = u); },
              ),
              const SizedBox(height: 12),
              Row(children: [
                IconButton(icon: const Icon(Icons.remove_circle_outline), iconSize: 36, onPressed: () { if (qty > 1) setS(() => qty--); }),
                Expanded(child: Center(child: Text('$qty', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)))),
                IconButton(icon: const Icon(Icons.add_circle_outline), iconSize: 36, color: kPrimary, onPressed: () => setS(() => qty++)),
              ]),
              const SizedBox(height: 8),
              Text('Total: ${formatFcfa(qty * selectedUnit.retailPrice)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: kPrimary)),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () { onAdd(product, selectedUnit, qty); Navigator.pop(ctx); },
                child: const Text('Ajouter au panier'),
              ),
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
  final void Function(String, int) onPaymentChanged;
  final VoidCallback onPay;
  final int change;

  const _CartSummary({required this.cart, required this.total, required this.payments, required this.onPaymentChanged, required this.onPay, required this.change});

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
            trailing: Text(formatFcfa(total), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: kPrimary)),
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
            child: ElevatedButton.icon(
              onPressed: paid >= total ? onPay : null,
              icon: const Icon(Icons.check),
              label: Text(paid >= total ? 'Enregistrer la vente' : 'Manque ${formatFcfa(total - paid)}'),
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
            content: TextField(controller: ctrl, keyboardType: TextInputType.number, decoration: const InputDecoration(suffix: Text('FCFA'))),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
              FilledButton(onPressed: () => Navigator.pop(ctx, int.tryParse(ctrl.text) ?? 0), child: const Text('OK')),
            ],
          ),
        );
        if (result != null) onChanged(result);
      },
      child: Chip(
        label: Text(value > 0 ? '$label: ${formatFcfaCompact(value)}' : label),
        backgroundColor: value > 0 ? color.withValues(alpha: 0.15) : Colors.grey.shade100,
        labelStyle: TextStyle(color: value > 0 ? color : kTextSecondary, fontWeight: FontWeight.w600, fontSize: 12),
        side: BorderSide(color: value > 0 ? color : Colors.transparent),
      ),
    );
  }
}
