import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../core/theme/app_theme.dart';
import '../../data/sync/api_client.dart';
import '../../core/constants/api.dart';

// ── Providers ──────────────────────────────────────────────────────────────────

final _apiProvSales = Provider<ApiClient>((ref) => ApiClient());

final _saleProductsProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final api = ref.watch(_apiProvSales);
  final res = await api.get(Api.products);
  return (res.data as List).cast<Map<String, dynamic>>();
});

final _saleCustomersProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final api = ref.watch(_apiProvSales);
  final res = await api.get(Api.customers);
  return (res.data as List).cast<Map<String, dynamic>>();
});

// ── Cart item ─────────────────────────────────────────────────────────────────

class _CartItem {
  final String productId;
  final String productName;
  final String unitId;
  final String unitName;
  final int factor;
  int qty;
  int unitPrice;

  _CartItem({
    required this.productId,
    required this.productName,
    required this.unitId,
    required this.unitName,
    this.factor = 1,
    required this.qty,
    required this.unitPrice,
  });

  int get lineTotal => qty * unitPrice;
  int get baseUnitsUsed => qty * factor;
}

// ── Screen ────────────────────────────────────────────────────────────────────

class SalesScreen extends ConsumerStatefulWidget {
  const SalesScreen({super.key});

  @override
  ConsumerState<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends ConsumerState<SalesScreen> {
  final List<_CartItem> _cart = [];
  String _query = '';
  String? _selectedCatId;
  String? _customerId;
  String? _customerName;

  int get _total => _cart.fold(0, (s, i) => s + i.lineTotal);
  int get _itemCount => _cart.fold(0, (s, i) => s + i.qty);

  int _qtyInCart(String productId, String unitId) => _cart
      .where((c) => c.productId == productId && c.unitId == unitId)
      .fold(0, (s, c) => s + c.qty);

  void _addToCart(Map<String, dynamic> product, Map<String, dynamic> unit, int qty,
      {int? overridePrice}) {
    setState(() {
      final price = overridePrice ?? (unit['retailPrice'] as int? ?? 0);
      final existing = _cart
          .where((c) =>
              c.productId == (product['id'] as String) &&
              c.unitId == (unit['id'] as String) &&
              c.unitPrice == price)
          .firstOrNull;
      if (existing != null) {
        existing.qty += qty;
      } else {
        _cart.add(_CartItem(
          productId: product['id'] as String,
          productName: product['name'] as String? ?? '',
          unitId: unit['id'] as String,
          unitName: unit['name'] as String? ?? '',
          factor: unit['factor'] as int? ?? 1,
          qty: qty,
          unitPrice: price,
        ));
      }
    });
  }

  void _removeCartItem(int index) => setState(() => _cart.removeAt(index));

  void _updateQty(int index, int qty) {
    if (qty <= 0) {
      _removeCartItem(index);
    } else {
      setState(() => _cart[index].qty = qty);
    }
  }

  void _clearCart() => setState(() {
        _cart.clear();
        _customerId = null;
        _customerName = null;
      });

  Future<void> _openCart() async {
    if (_cart.isEmpty) return;
    final result = await showModalBottomSheet<_SaleResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CartSheet(
        cart: _cart,
        customerId: _customerId,
        customerName: _customerName,
        onQtyChanged: _updateQty,
        onRemove: _removeCartItem,
        onCustomerChanged: (id, name) =>
            setState(() { _customerId = id; _customerName = name; }),
        onPay: _submitSale,
      ),
    );
    if (result != null && result.success) {
      _showReceipt(result);
    }
  }

  Future<_SaleResult?> _submitSale({
    required Map<String, int> payments,
    required int discount,
    String? customerId,
  }) async {
    final api = ref.read(_apiProvSales);
    final deviceId = await api.getDeviceId() ?? '';
    final depotId = await api.getDepotId() ?? '';
    const uuid = Uuid();

    final saleId = uuid.v4();
    final lines = _cart
        .map((c) => {
              'id': uuid.v4(),
              'productId': c.productId,
              'unitId': c.unitId,
              'qty': c.qty,
              'unitPrice': c.unitPrice,
              'lineTotal': c.lineTotal,
            })
        .toList();

    await api.post(Api.sales, data: {
      'id': saleId,
      if (customerId != null) 'customerId': customerId,
      'discount': discount,
      'lines': lines,
      'payments': payments.entries
          .where((e) => e.value > 0)
          .map((e) => {'id': uuid.v4(), 'method': e.key, 'amount': e.value})
          .toList(),
      'depotId': depotId,
      'deviceId': deviceId,
    });

    final result = _SaleResult(
      saleId: saleId,
      lines: List.from(_cart),
      total: _total - discount,
      discount: discount,
      payments: Map.from(payments),
      customerName: _customerName,
      success: true,
    );

    _clearCart();
    ref.invalidate(_saleProductsProvider);
    return result;
  }

  void _showReceipt(_SaleResult result) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ReceiptSheet(result: result),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vente'),
        actions: [
          if (_cart.isNotEmpty)
            TextButton.icon(
              onPressed: _clearCart,
              icon: const Icon(Icons.delete_outline, color: Colors.white70),
              label: const Text('Vider', style: TextStyle(color: Colors.white70)),
            ),
          if (_cart.isNotEmpty)
            IconButton(
              tooltip: 'Panier',
              onPressed: _openCart,
              icon: Badge(
                label: Text('$_itemCount'),
                backgroundColor: Colors.amber,
                textColor: Colors.black87,
                child: const Icon(Icons.shopping_cart_outlined),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(_saleProductsProvider),
          ),
        ],
      ),
      body: ref.watch(_saleProductsProvider).when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrWidget(
            onRetry: () => ref.invalidate(_saleProductsProvider)),
        data: (products) => Column(
          children: [
            Expanded(
              child: _ProductBrowser(
                products: products,
                query: _query,
                selectedCatId: _selectedCatId,
                onQueryChanged: (q) => setState(() => _query = q),
                onCatChanged: (id) => setState(() => _selectedCatId = id),
                onAddToCart: _addToCart,
                qtyInCart: _qtyInCart,
              ),
            ),
            if (_cart.isNotEmpty)
              _CartBar(
                itemCount: _itemCount,
                total: _total,
                customerName: _customerName,
                onTap: _openCart,
              ),
          ],
        ),
      ),
    );
  }
}

// ── Sale result (for receipt) ─────────────────────────────────────────────────

class _SaleResult {
  final String saleId;
  final List<_CartItem> lines;
  final int total;
  final int discount;
  final Map<String, int> payments;
  final String? customerName;
  final bool success;
  _SaleResult({
    required this.saleId,
    required this.lines,
    required this.total,
    required this.discount,
    required this.payments,
    this.customerName,
    this.success = false,
  });
}

// ── Product browser ───────────────────────────────────────────────────────────

class _ProductBrowser extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final String query;
  final String? selectedCatId;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<String?> onCatChanged;
  final void Function(Map<String, dynamic>, Map<String, dynamic>, int,
      {int? overridePrice}) onAddToCart;
  final int Function(String, String) qtyInCart;

  const _ProductBrowser({
    required this.products,
    required this.query,
    required this.selectedCatId,
    required this.onQueryChanged,
    required this.onCatChanged,
    required this.onAddToCart,
    required this.qtyInCart,
  });

  List<Map<String, dynamic>> _categories() {
    final seen = <String>{};
    final cats = <Map<String, dynamic>>[];
    for (final p in products) {
      final cat = p['category'] as Map?;
      final id = cat?['id'] as String?;
      if (id != null && seen.add(id)) {
        cats.add({'id': id, 'name': cat!['name'] as String? ?? ''});
      }
    }
    cats.sort((a, b) =>
        (a['name'] as String).compareTo(b['name'] as String));
    return cats;
  }

  @override
  Widget build(BuildContext context) {
    final cats = _categories();
    final q = query.toLowerCase();

    final displayed = products.where((p) {
      final name = (p['name'] as String? ?? '').toLowerCase();
      final brand = (p['brand'] as String? ?? '').toLowerCase();
      final catName =
          ((p['category'] as Map?)?['name'] as String? ?? '').toLowerCase();
      if (q.isNotEmpty &&
          !name.contains(q) &&
          !brand.contains(q) &&
          !catName.contains(q)) {
        return false;
      }
      if (selectedCatId != null &&
          (p['category'] as Map?)?['id'] != selectedCatId) {
        return false;
      }
      return true;
    }).toList();

    return Column(
      children: [
        // Search
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Nom, catégorie, marque…',
              suffixIcon: query.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () => onQueryChanged(''),
                    )
                  : null,
            ),
            onChanged: onQueryChanged,
          ),
        ),

        // Category chips
        if (cats.isNotEmpty)
          SizedBox(
            height: 42,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              children: [
                _SaleCatChip(
                  label: 'Tout',
                  selected: selectedCatId == null,
                  onTap: () => onCatChanged(null),
                ),
                ...cats.map((c) => _SaleCatChip(
                      label: c['name'] as String,
                      selected: selectedCatId == c['id'],
                      onTap: () => onCatChanged(c['id'] as String),
                    )),
              ],
            ),
          ),

        const Divider(height: 1),

        // Grid
        Expanded(
          child: displayed.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.search_off,
                          size: 48, color: kTextSecondary),
                      const SizedBox(height: 8),
                      Text(
                        q.isNotEmpty
                            ? 'Aucun résultat pour "$query"'
                            : 'Aucun article dans cette catégorie',
                        style:
                            const TextStyle(color: kTextSecondary),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.9,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: displayed.length,
                  itemBuilder: (_, i) => _ProductCard(
                    product: displayed[i],
                    qtyInCart: qtyInCart,
                    onAddToCart: onAddToCart,
                  ),
                ),
        ),
      ],
    );
  }
}

class _SaleCatChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _SaleCatChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, top: 6, bottom: 6),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: selected ? kPrimary : Colors.white,
            border: Border.all(
                color: selected ? kPrimary : Colors.grey.shade300),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : kTextSecondary),
          ),
        ),
      ),
    );
  }
}

// ── Product card ──────────────────────────────────────────────────────────────

class _ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final int Function(String, String) qtyInCart;
  final void Function(Map<String, dynamic>, Map<String, dynamic>, int,
      {int? overridePrice}) onAddToCart;

  const _ProductCard({
    required this.product,
    required this.qtyInCart,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final units =
        (product['units'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final base = units.where((u) => u['isBase'] == true).firstOrNull ??
        (units.isNotEmpty ? units.first : null);

    final stockLevels =
        (product['stockLevels'] as List?)?.cast<Map>() ?? [];
    final totalQty = stockLevels.fold<int>(
        0, (s, l) => s + (l['cachedQty'] as int? ?? 0));

    final inCartQty = base != null
        ? units.fold<int>(
            0, (s, u) => s + qtyInCart(product['id'] as String, u['id'] as String))
        : 0;

    // Stock indicator color
    Color stockColor = kSuccess;
    if (totalQty <= 0) stockColor = kDanger;
    else if (totalQty < 10) stockColor = kWarning;

    final baseName = base?['name'] as String? ?? 'u';
    final retailPrice = base?['retailPrice'] as int? ?? 0;

    return Card(
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.07),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () => _showAddSheet(context, units),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row: category + stock dot
                  Row(children: [
                    Expanded(
                      child: Text(
                        ((product['category'] as Map?)?['name'] as String? ??
                            (product['brand'] as String? ?? '')),
                        style: const TextStyle(
                            fontSize: 10,
                            color: kTextSecondary,
                            fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: stockColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ]),
                  const SizedBox(height: 6),

                  // Product name
                  Text(
                    product['name'] as String? ?? '',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w800),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const Spacer(),

                  // Price + unit
                  Text(
                    formatFcfa(retailPrice),
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: kPrimary),
                  ),
                  Text(
                    '/ $baseName  ·  $totalQty en stock',
                    style: const TextStyle(
                        fontSize: 10, color: kTextSecondary),
                  ),

                  // Bulk prices
                  ...units
                      .where((u) => u['isBase'] != true &&
                          (u['factor'] as int? ?? 0) > 1)
                      .take(2)
                      .map((u) => Text(
                            '${u['name']}: ${formatFcfa(u['retailPrice'] as int? ?? 0)}',
                            style: const TextStyle(
                                fontSize: 10, color: kTextSecondary),
                          )),
                ],
              ),
            ),

            // Cart quantity badge
            if (inCartQty > 0)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: kSuccess,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '+$inCartQty',
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showAddSheet(BuildContext context, List<Map<String, dynamic>> units) {
    if (units.isEmpty) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddToCartSheet(
        product: product,
        units: units,
        onAdd: onAddToCart,
      ),
    );
  }
}

// ── Add to cart sheet ─────────────────────────────────────────────────────────

class _AddToCartSheet extends StatefulWidget {
  final Map<String, dynamic> product;
  final List<Map<String, dynamic>> units;
  final void Function(Map<String, dynamic>, Map<String, dynamic>, int,
      {int? overridePrice}) onAdd;

  const _AddToCartSheet(
      {required this.product, required this.units, required this.onAdd});

  @override
  State<_AddToCartSheet> createState() => _AddToCartSheetState();
}

class _AddToCartSheetState extends State<_AddToCartSheet> {
  late Map<String, dynamic> _selectedUnit;
  int _qty = 1;
  late TextEditingController _priceCtrl;
  bool _priceEdited = false;

  @override
  void initState() {
    super.initState();
    _selectedUnit = widget.units.first;
    _priceCtrl = TextEditingController(
        text: (_selectedUnit['retailPrice'] as int? ?? 0).toString());
  }

  @override
  void dispose() {
    _priceCtrl.dispose();
    super.dispose();
  }

  void _selectUnit(Map<String, dynamic> u) {
    setState(() {
      _selectedUnit = u;
      if (!_priceEdited) {
        _priceCtrl.text =
            (u['retailPrice'] as int? ?? 0).toString();
      }
    });
  }

  int get _lineTotal =>
      _qty * (int.tryParse(_priceCtrl.text) ?? 0);

  @override
  Widget build(BuildContext context) {
    final stockLevels =
        (widget.product['stockLevels'] as List?)?.cast<Map>() ?? [];
    final totalQtyBase = stockLevels.fold<int>(
        0, (s, l) => s + (l['cachedQty'] as int? ?? 0));
    final factor = _selectedUnit['factor'] as int? ?? 1;
    final availableInUnit = factor > 0 ? totalQtyBase ~/ factor : 0;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        left: 20, right: 20, top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Product name
          Text(
            widget.product['name'] as String? ?? '',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          if (widget.product['brand'] != null)
            Text(widget.product['brand'] as String,
                style: const TextStyle(color: kTextSecondary, fontSize: 13)),
          const SizedBox(height: 16),

          // Unit selector (ChoiceChip)
          if (widget.units.length > 1) ...[
            const Text('UNITÉ',
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: kTextSecondary,
                    letterSpacing: 0.8)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: widget.units.map((u) {
                final isSelected = u['id'] == _selectedUnit['id'];
                final uFactor = u['factor'] as int? ?? 1;
                final uName = u['name'] as String? ?? '';
                final uPrice = u['retailPrice'] as int? ?? 0;
                final label = uFactor > 1
                    ? '$uName ($uFactor ${(widget.units.firstWhere((b) => b['isBase'] == true, orElse: () => u))['name']})\n${formatFcfa(uPrice)}'
                    : '$uName\n${formatFcfa(uPrice)}';
                return ChoiceChip(
                  label: Text(label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isSelected ? Colors.white : kTextPrimary)),
                  selected: isSelected,
                  selectedColor: kPrimary,
                  onSelected: (_) => _selectUnit(u),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),
          ],

          // Stock availability
          Row(children: [
            Icon(
              availableInUnit > 0 ? Icons.inventory_2_outlined : Icons.warning_amber,
              size: 16,
              color: availableInUnit > 0 ? kSuccess : kDanger,
            ),
            const SizedBox(width: 6),
            Text(
              availableInUnit > 0
                  ? '$availableInUnit ${_selectedUnit['name']} disponible(s)'
                  : 'Stock insuffisant',
              style: TextStyle(
                  fontSize: 12,
                  color: availableInUnit > 0 ? kSuccess : kDanger,
                  fontWeight: FontWeight.w600),
            ),
          ]),
          const SizedBox(height: 14),

          // Price field (editable for negotiation)
          TextFormField(
            controller: _priceCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: 'Prix / ${_selectedUnit['name']}',
              suffixText: 'F',
              helperText: 'Prix négocié possible',
              helperStyle: const TextStyle(fontSize: 11),
            ),
            onChanged: (_) => setState(() => _priceEdited = true),
          ),
          const SizedBox(height: 14),

          // Qty stepper
          Row(children: [
            const Text('QUANTITÉ',
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: kTextSecondary,
                    letterSpacing: 0.8)),
            const Spacer(),
            _QtyButton(
              icon: Icons.remove,
              onTap: () { if (_qty > 1) setState(() => _qty--); },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () async {
                  final ctrl =
                      TextEditingController(text: _qty.toString());
                  final result = await showDialog<int>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Quantité'),
                      content: TextField(
                        controller: ctrl,
                        keyboardType: TextInputType.number,
                        autofocus: true,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onSubmitted: (_) =>
                            Navigator.pop(ctx, int.tryParse(ctrl.text)),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Annuler')),
                        FilledButton(
                          onPressed: () =>
                              Navigator.pop(ctx, int.tryParse(ctrl.text)),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                  if (result != null && result > 0) {
                    setState(() => _qty = result);
                  }
                },
                child: Text(
                  '$_qty',
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.w900),
                ),
              ),
            ),
            _QtyButton(
              icon: Icons.add,
              onTap: () => setState(() => _qty++),
              primary: true,
            ),
          ]),
          const SizedBox(height: 16),

          // Total line
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: kPrimary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(children: [
              Expanded(
                child: Text(
                  '$_qty × ${formatFcfa(int.tryParse(_priceCtrl.text) ?? 0)}',
                  style: const TextStyle(
                      fontSize: 14, color: kTextSecondary),
                ),
              ),
              Text(
                formatFcfa(_lineTotal),
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: kPrimary),
              ),
            ]),
          ),
          const SizedBox(height: 16),

          // Add button
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                final price = int.tryParse(_priceCtrl.text) ??
                    (_selectedUnit['retailPrice'] as int? ?? 0);
                widget.onAdd(
                    widget.product, _selectedUnit, _qty,
                    overridePrice: price);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      '${_qty} ${_selectedUnit['name']} ajouté(s) au panier'),
                  duration: const Duration(seconds: 1),
                  backgroundColor: kSuccess,
                ));
              },
              icon: const Icon(Icons.add_shopping_cart),
              label: Text('Ajouter au panier · ${formatFcfa(_lineTotal)}'),
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool primary;
  const _QtyButton({required this.icon, required this.onTap, this.primary = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42, height: 42,
        decoration: BoxDecoration(
          color: primary
              ? kPrimary
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon,
            color: primary ? Colors.white : kTextPrimary, size: 22),
      ),
    );
  }
}

// ── Cart bottom bar ───────────────────────────────────────────────────────────

class _CartBar extends StatelessWidget {
  final int itemCount;
  final int total;
  final String? customerName;
  final VoidCallback onTap;
  const _CartBar({
    required this.itemCount,
    required this.total,
    required this.customerName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: kPrimary,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, -3))
          ],
        ),
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$itemCount article${itemCount > 1 ? 's' : ''}',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700),
            ),
          ),
          if (customerName != null) ...[
            const SizedBox(width: 8),
            Icon(Icons.person, size: 14, color: Colors.white70),
            const SizedBox(width: 4),
            Text(customerName!,
                style: const TextStyle(
                    color: Colors.white70, fontSize: 12)),
          ],
          const Spacer(),
          Text(
            formatFcfa(total),
            style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Encaisser',
              style: TextStyle(
                  color: kPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 14),
            ),
          ),
        ]),
      ),
    );
  }
}

// ── Cart sheet ────────────────────────────────────────────────────────────────

class _CartSheet extends ConsumerStatefulWidget {
  final List<_CartItem> cart;
  final String? customerId;
  final String? customerName;
  final void Function(int, int) onQtyChanged;
  final void Function(int) onRemove;
  final void Function(String?, String?) onCustomerChanged;
  final Future<_SaleResult?> Function({
    required Map<String, int> payments,
    required int discount,
    String? customerId,
  }) onPay;

  const _CartSheet({
    required this.cart,
    required this.customerId,
    required this.customerName,
    required this.onQtyChanged,
    required this.onRemove,
    required this.onCustomerChanged,
    required this.onPay,
  });

  @override
  ConsumerState<_CartSheet> createState() => _CartSheetState();
}

class _CartSheetState extends ConsumerState<_CartSheet> {
  late String? _customerId;
  late String? _customerName;
  final Map<String, int> _payments = {
    'CASH': 0, 'FLOOZ': 0, 'MIXX': 0, 'CREDIT': 0,
  };
  int _discount = 0;
  bool _paying = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _customerId = widget.customerId;
    _customerName = widget.customerName;
  }

  int get _subtotal =>
      widget.cart.fold(0, (s, i) => s + i.lineTotal);
  int get _total => (_subtotal - _discount).clamp(0, 999999999);
  int get _totalPaid =>
      _payments.values.fold(0, (s, v) => s + v);
  int get _change => (_totalPaid - _total).clamp(0, 999999999);
  bool get _canPay => _totalPaid >= _total && widget.cart.isNotEmpty;

  Future<void> _pay() async {
    if (!_canPay) return;
    if (_payments['CREDIT']! > 0 && _customerId == null) {
      setState(() =>
          _error = 'Sélectionnez un client pour une vente à crédit');
      return;
    }
    setState(() { _paying = true; _error = null; });
    try {
      final result = await widget.onPay(
        payments: Map.from(_payments),
        discount: _discount,
        customerId: _customerId,
      );
      if (mounted) {
        Navigator.pop(context, result);
      }
    } catch (e) {
      setState(() {
        _error = e.toString().contains('400')
            ? 'Données invalides — vérifiez le panier'
            : e.toString().contains('timeout') ||
                    e.toString().contains('Socket')
                ? 'Hors ligne — réessayez'
                : 'Erreur: ${e.toString().split(':').last.trim()}';
        _paying = false;
      });
    }
  }

  void _quickFill() {
    // Fill CASH with exact total
    setState(() {
      _payments['CASH'] = _total;
      _payments['FLOOZ'] = 0;
      _payments['MIXX'] = 0;
      _payments['CREDIT'] = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.92,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Center(
            child: Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(top: 10, bottom: 4),
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
            child: Row(children: [
              Expanded(
                child: Text(
                  'Panier (${widget.cart.length} article${widget.cart.length > 1 ? 's' : ''})',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ),
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close)),
            ]),
          ),
          const Divider(height: 1),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Cart items ─────────────────────────────────────
                  ...widget.cart.asMap().entries.map((entry) {
                    final i = entry.key;
                    final item = entry.value;
                    return Dismissible(
                      key: Key('${item.productId}-${item.unitId}-$i'),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        color: kDanger,
                        child: const Icon(Icons.delete,
                            color: Colors.white),
                      ),
                      onDismissed: (_) => widget.onRemove(i),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Colors.grey.shade200),
                        ),
                        child: Row(children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(item.productName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14)),
                                Text(
                                  '${item.unitName}  ·  ${formatFcfa(item.unitPrice)} / u',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: kTextSecondary),
                                ),
                              ],
                            ),
                          ),
                          // Qty stepper
                          Row(children: [
                            _SmallQtyBtn(
                              icon: Icons.remove,
                              onTap: () =>
                                  widget.onQtyChanged(i, item.qty - 1),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12),
                              child: Text('${item.qty}',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800)),
                            ),
                            _SmallQtyBtn(
                              icon: Icons.add,
                              onTap: () =>
                                  widget.onQtyChanged(i, item.qty + 1),
                              primary: true,
                            ),
                          ]),
                          const SizedBox(width: 10),
                          Text(
                            formatFcfa(item.lineTotal),
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: kPrimary),
                          ),
                        ]),
                      ),
                    );
                  }),

                  const SizedBox(height: 8),
                  // Subtotal
                  if (_discount > 0)
                    _TotalRow('Sous-total', _subtotal,
                        style: const TextStyle(color: kTextSecondary)),

                  // Discount
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(children: [
                      const Icon(Icons.discount_outlined,
                          size: 16, color: kTextSecondary),
                      const SizedBox(width: 8),
                      const Expanded(
                          child: Text('Remise',
                              style: TextStyle(
                                  color: kTextSecondary,
                                  fontSize: 13))),
                      GestureDetector(
                        onTap: () async {
                          final ctrl = TextEditingController(
                              text: _discount > 0
                                  ? _discount.toString()
                                  : '');
                          final result = await showDialog<int>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Remise (en FCFA)'),
                              content: TextField(
                                controller: ctrl,
                                keyboardType: TextInputType.number,
                                autofocus: true,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: const InputDecoration(
                                    suffixText: 'F'),
                                onSubmitted: (_) => Navigator.pop(
                                    ctx, int.tryParse(ctrl.text) ?? 0),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.pop(ctx, 0),
                                    child: const Text('Aucune')),
                                FilledButton(
                                  onPressed: () => Navigator.pop(
                                      ctx,
                                      int.tryParse(ctrl.text) ?? 0),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                          if (result != null) {
                            setState(() => _discount = result);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: _discount > 0
                                ? kDanger.withValues(alpha: 0.1)
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _discount > 0
                                ? '- ${formatFcfa(_discount)}'
                                : 'Ajouter',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: _discount > 0
                                    ? kDanger
                                    : kTextSecondary),
                          ),
                        ),
                      ),
                    ]),
                  ),

                  _TotalRow('TOTAL', _total,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: kPrimary)),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),

                  // ── Customer ───────────────────────────────────────
                  _SectionLabel('Client (optionnel)'),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      final customers = await ref
                          .read(_saleCustomersProvider.future)
                          .catchError((_) =>
                              <Map<String, dynamic>>[]);
                      if (!context.mounted) return;
                      final picked = await showModalBottomSheet<
                          Map<String, dynamic>?>(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => _CustomerPickerSheet(
                            customers: customers),
                      );
                      if (picked != null) {
                        setState(() {
                          _customerId = picked['id'] as String?;
                          _customerName = picked['name'] as String?;
                        });
                        widget.onCustomerChanged(
                            _customerId, _customerName);
                      } else if (picked == null &&
                          context.mounted) {
                        // null = clear
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: _customerId != null
                            ? kPrimary.withValues(alpha: 0.06)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: _customerId != null
                                ? kPrimary.withValues(alpha: 0.3)
                                : Colors.transparent),
                      ),
                      child: Row(children: [
                        Icon(
                          _customerId != null
                              ? Icons.person
                              : Icons.person_add_outlined,
                          color: _customerId != null
                              ? kPrimary
                              : kTextSecondary,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _customerName ?? 'Client anonyme',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: _customerId != null
                                    ? kPrimary
                                    : kTextSecondary),
                          ),
                        ),
                        if (_customerId != null)
                          GestureDetector(
                            onTap: () => setState(() {
                              _customerId = null;
                              _customerName = null;
                              widget.onCustomerChanged(null, null);
                            }),
                            child: const Icon(Icons.close,
                                size: 18, color: kTextSecondary),
                          )
                        else
                          const Icon(Icons.chevron_right,
                              color: kTextSecondary),
                      ]),
                    ),
                  ),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),

                  // ── Payment ────────────────────────────────────────
                  Row(children: [
                    const Expanded(
                        child: _SectionLabel('Paiement')),
                    TextButton.icon(
                      onPressed: _quickFill,
                      icon: const Icon(Icons.bolt, size: 16),
                      label: const Text('Montant exact',
                          style: TextStyle(fontSize: 12)),
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          tapTargetSize:
                              MaterialTapTargetSize.shrinkWrap),
                    ),
                  ]),
                  const SizedBox(height: 8),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _PayBtn(
                          label: 'Espèces',
                          icon: Icons.payments_outlined,
                          color: kSuccess,
                          value: _payments['CASH']!,
                          onChanged: (v) =>
                              setState(() => _payments['CASH'] = v)),
                      _PayBtn(
                          label: 'Flooz',
                          icon: Icons.phone_android,
                          color: const Color(0xFFE65100),
                          value: _payments['FLOOZ']!,
                          onChanged: (v) =>
                              setState(() => _payments['FLOOZ'] = v)),
                      _PayBtn(
                          label: 'Mixx',
                          icon: Icons.phone_android,
                          color: const Color(0xFF1B5E20),
                          value: _payments['MIXX']!,
                          onChanged: (v) =>
                              setState(() => _payments['MIXX'] = v)),
                      _PayBtn(
                          label: 'À crédit',
                          icon: Icons.account_balance_wallet_outlined,
                          color: kWarning,
                          value: _payments['CREDIT']!,
                          onChanged: (v) =>
                              setState(() => _payments['CREDIT'] = v)),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Payment summary
                  if (_totalPaid > 0) ...[
                    _TotalRow('Payé', _totalPaid,
                        style: const TextStyle(
                            fontSize: 13, color: kTextSecondary)),
                    if (_change > 0)
                      _TotalRow('Monnaie à rendre', _change,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: kSuccess)),
                    if (_totalPaid < _total)
                      _TotalRow(
                          'Reste à payer', _total - _totalPaid,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: kDanger)),
                  ],

                  if (_error != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: kDanger.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(children: [
                        const Icon(Icons.error_outline,
                            color: kDanger, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                            child: Text(_error!,
                                style: const TextStyle(
                                    color: kDanger, fontSize: 13))),
                      ]),
                    ),
                  ],

                  const SizedBox(height: 20),

                  // Encaisser button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _canPay && !_paying ? _pay : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kSuccess,
                        foregroundColor: Colors.white,
                        padding:
                            const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      icon: _paying
                          ? const SizedBox(
                              width: 18, height: 18,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : const Icon(Icons.check_circle_outline,
                              size: 22),
                      label: Text(
                        _paying
                            ? 'Enregistrement…'
                            : _canPay
                                ? 'Encaisser ${formatFcfa(_total)}'
                                : 'Manque ${formatFcfa(_total - _totalPaid)}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallQtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool primary;
  const _SmallQtyBtn(
      {required this.icon, required this.onTap, this.primary = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32, height: 32,
        decoration: BoxDecoration(
          color: primary ? kPrimary.withValues(alpha: 0.1) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18,
            color: primary ? kPrimary : kTextSecondary),
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final int amount;
  final TextStyle? style;
  const _TotalRow(this.label, this.amount, {this.style});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(children: [
        Expanded(
            child: Text(label,
                style: style ?? const TextStyle(fontSize: 14))),
        Text(formatFcfa(amount), style: style ?? const TextStyle(fontSize: 14)),
      ]),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: kTextSecondary,
          letterSpacing: 0.8));
}

class _PayBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final int value;
  final ValueChanged<int> onChanged;
  const _PayBtn({
    required this.label,
    required this.icon,
    required this.color,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final active = value > 0;
    return GestureDetector(
      onTap: () async {
        final ctrl =
            TextEditingController(text: value > 0 ? value.toString() : '');
        final result = await showDialog<int>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Row(children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text('Paiement $label'),
            ]),
            content: TextField(
              controller: ctrl,
              keyboardType: TextInputType.number,
              autofocus: true,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(suffixText: 'F'),
              onSubmitted: (_) =>
                  Navigator.pop(ctx, int.tryParse(ctrl.text) ?? 0),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, 0),
                  child: const Text('Effacer')),
              FilledButton(
                onPressed: () =>
                    Navigator.pop(ctx, int.tryParse(ctrl.text) ?? 0),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        if (result != null) onChanged(result);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: active ? color : Colors.white,
          border: Border.all(color: active ? color : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                color: active ? Colors.white : color, size: 20),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: active ? Colors.white : color)),
            if (active)
              Text(
                formatFcfaCompact(value),
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Customer picker ────────────────────────────────────────────────────────────

class _CustomerPickerSheet extends StatefulWidget {
  final List<Map<String, dynamic>> customers;
  const _CustomerPickerSheet({required this.customers});

  @override
  State<_CustomerPickerSheet> createState() => _CustomerPickerSheetState();
}

class _CustomerPickerSheetState extends State<_CustomerPickerSheet> {
  String _q = '';

  @override
  Widget build(BuildContext context) {
    final filtered = _q.isEmpty
        ? widget.customers
        : widget.customers.where((c) {
            final name = (c['name'] as String? ?? '').toLowerCase();
            final phone = (c['phone'] as String? ?? '').toLowerCase();
            return name.contains(_q.toLowerCase()) ||
                phone.contains(_q.toLowerCase());
          }).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(top: 10, bottom: 4),
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Nom ou téléphone…',
              ),
              autofocus: true,
              onChanged: (v) => setState(() => _q = v),
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20)),
              child: const Icon(Icons.person_off_outlined,
                  color: kTextSecondary),
            ),
            title: const Text('Client anonyme',
                style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: const Text('Vente sans enregistrement'),
            onTap: () => Navigator.pop(context,
                const {'id': null, 'name': null}),
          ),
          const Divider(height: 1),
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text('Aucun client trouvé',
                        style: TextStyle(color: kTextSecondary)))
                : ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final c = filtered[i];
                      final debt = c['totalDebt'] as int? ?? 0;
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              kPrimary.withValues(alpha: 0.1),
                          child: Text(
                            (c['name'] as String? ?? '?')
                                .substring(0, 1)
                                .toUpperCase(),
                            style: const TextStyle(
                                color: kPrimary,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                        title: Text(c['name'] as String? ?? '',
                            style: const TextStyle(
                                fontWeight: FontWeight.w700)),
                        subtitle: Text(
                            [
                              if (c['phone'] != null)
                                c['phone'] as String,
                              if (debt > 0)
                                'Doit: ${formatFcfa(debt)}',
                            ].join('  ·  ')),
                        trailing: debt > 0
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                    color: kWarning.withValues(
                                        alpha: 0.1),
                                    borderRadius:
                                        BorderRadius.circular(8)),
                                child: Text(formatFcfa(debt),
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: kWarning)),
                              )
                            : null,
                        onTap: () => Navigator.pop(context, c),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Receipt sheet ─────────────────────────────────────────────────────────────

class _ReceiptSheet extends StatelessWidget {
  final _SaleResult result;
  const _ReceiptSheet({required this.result});

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
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              Container(
                width: 64, height: 64,
                decoration: BoxDecoration(
                  color: kSuccess.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle,
                    color: kSuccess, size: 40),
              ),
              const SizedBox(height: 10),
              const Text('Vente enregistrée !',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w900)),
              if (result.customerName != null)
                Text('Client: ${result.customerName}',
                    style: const TextStyle(
                        fontSize: 14, color: kTextSecondary)),
            ]),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ...result.lines.map((l) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(children: [
                        Expanded(
                            child: Text(
                                '${l.qty}× ${l.productName} (${l.unitName})',
                                style: const TextStyle(fontSize: 14))),
                        Text(formatFcfa(l.lineTotal),
                            style: const TextStyle(
                                fontWeight: FontWeight.w700)),
                      ]),
                    )),
                const Divider(),
                if (result.discount > 0)
                  _TotalRow('Remise', result.discount,
                      style: const TextStyle(
                          color: kDanger,
                          fontWeight: FontWeight.w600)),
                _TotalRow('TOTAL', result.total,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: kPrimary)),
                const SizedBox(height: 8),
                ...result.payments.entries
                    .where((e) => e.value > 0)
                    .map((e) => Padding(
                          padding:
                              const EdgeInsets.symmetric(vertical: 2),
                          child: Row(children: [
                            Container(
                              width: 10, height: 10,
                              decoration: BoxDecoration(
                                color: paymentMethodColor(e.key),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                                child:
                                    Text(paymentMethodLabel(e.key))),
                            Text(formatFcfa(e.value),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)),
                          ]),
                        )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Nouvelle vente'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Error widget ──────────────────────────────────────────────────────────────

class _ErrWidget extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrWidget({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off, size: 48, color: kTextSecondary),
          const SizedBox(height: 12),
          const Text('Impossible de charger les articles',
              style: TextStyle(color: kTextSecondary)),
          const SizedBox(height: 8),
          TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer')),
        ],
      ),
    );
  }
}
