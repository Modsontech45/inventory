import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../core/theme/app_theme.dart';
import '../../data/sync/api_client.dart';
import '../../core/constants/api.dart';

final _productsProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  final api = ref.watch(_apiProvP);
  final res = await api.get(Api.products);
  return res.data as List<dynamic>;
});

final _categoriesProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  final api = ref.watch(_apiProvP);
  final res = await api.get('${Api.products}/categories');
  return res.data as List<dynamic>;
});

final _unitNamesProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final api = ref.watch(_apiProvP);
  final res = await api.get(Api.units);
  return (res.data as List).cast<Map<String, dynamic>>();
});

final _apiProvP = Provider<ApiClient>((ref) => ApiClient());

// ── Root screen (tabs: Articles | Catalogue prix) ─────────────────────────────

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Articles'),
          actions: [
            IconButton(
              icon: const Icon(Icons.straighten),
              tooltip: 'Gérer les unités',
              onPressed: () => _showUnitsManager(context, ref),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                ref.invalidate(_productsProvider);
                ref.invalidate(_categoriesProvider);
                ref.invalidate(_unitNamesProvider);
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.list_alt), text: 'Articles'),
              Tab(icon: Icon(Icons.price_check), text: 'Catalogue prix'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _ArticlesTab(onAdd: () => _showForm(context, ref)),
            const _CatalogueTab(),
          ],
        ),
        floatingActionButton: _FabForTab(onAdd: () => _showForm(context, ref)),
      ),
    );
  }

  static Future<void> _showForm(BuildContext context, WidgetRef ref,
      {Map<String, dynamic>? product}) async {
    final categories =
        await ref.read(_categoriesProvider.future).catchError((_) => <dynamic>[]);
    final units =
        await ref.read(_unitNamesProvider.future).catchError((_) => <Map<String, dynamic>>[]);
    if (!context.mounted) return;
    final changed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ProductFormSheet(
        product: product,
        categories: categories.cast<Map<String, dynamic>>(),
        existingUnits: units,
      ),
    );
    if (changed == true) {
      ref.invalidate(_productsProvider);
      ref.invalidate(_categoriesProvider);
      ref.invalidate(_unitNamesProvider);
    }
  }

  Future<void> _showUnitsManager(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _UnitsManagerSheet(onChanged: () => ref.invalidate(_unitNamesProvider)),
    );
  }
}

// Shows FAB only on tab 0 (Articles), hides on Catalogue tab
class _FabForTab extends StatefulWidget {
  final VoidCallback onAdd;
  const _FabForTab({required this.onAdd});

  @override
  State<_FabForTab> createState() => _FabForTabState();
}

class _FabForTabState extends State<_FabForTab> {
  @override
  Widget build(BuildContext context) {
    final tab = DefaultTabController.of(context);
    return AnimatedBuilder(
      animation: tab,
      builder: (_, __) => tab.index == 0
          ? FloatingActionButton.extended(
              onPressed: widget.onAdd,
              icon: const Icon(Icons.add),
              label: const Text('Nouvel article'),
              backgroundColor: kPrimary,
              foregroundColor: Colors.white,
            )
          : const SizedBox.shrink(),
    );
  }
}

// ── Tab 0 : Articles list ─────────────────────────────────────────────────────

class _ArticlesTab extends ConsumerWidget {
  final VoidCallback onAdd;
  const _ArticlesTab({required this.onAdd});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(_productsProvider).when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => _ErrorRetry(
        error: e.toString(),
        onRetry: () => ref.invalidate(_productsProvider),
      ),
      data: (products) => products.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined, size: 64, color: kTextSecondary),
                  SizedBox(height: 12),
                  Text('Aucun article', style: TextStyle(fontSize: 16, color: kTextSecondary)),
                  SizedBox(height: 4),
                  Text('Appuyez sur + pour ajouter votre premier article',
                      style: TextStyle(fontSize: 13, color: kTextSecondary)),
                ],
              ),
            )
          : _ProductsList(products: products.cast<Map<String, dynamic>>()),
    );
  }
}

// ── Tab 1 : Catalogue prix ────────────────────────────────────────────────────

class _CatalogueTab extends ConsumerStatefulWidget {
  const _CatalogueTab();

  @override
  ConsumerState<_CatalogueTab> createState() => _CatalogueTabState();
}

class _CatalogueTabState extends ConsumerState<_CatalogueTab>
    with AutomaticKeepAliveClientMixin {
  String _query = '';
  String? _selectedCatId; // null = Tout

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final productsAsync = ref.watch(_productsProvider);
    final categoriesAsync = ref.watch(_categoriesProvider);

    return productsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => _ErrorRetry(
        error: e.toString(),
        onRetry: () => ref.invalidate(_productsProvider),
      ),
      data: (rawProducts) {
        final products = rawProducts.cast<Map<String, dynamic>>();
        final categories =
            categoriesAsync.valueOrNull?.cast<Map<String, dynamic>>() ?? [];

        // Apply search
        final q = _query.toLowerCase();
        final filtered = q.isEmpty
            ? products
            : products.where((p) {
                final name = (p['name'] as String? ?? '').toLowerCase();
                final brand = (p['brand'] as String? ?? '').toLowerCase();
                final cat = ((p['category'] as Map?)?['name'] as String? ?? '')
                    .toLowerCase();
                return name.contains(q) || brand.contains(q) || cat.contains(q);
              }).toList();

        // Apply category filter
        final displayed = _selectedCatId == null
            ? filtered
            : filtered
                .where((p) =>
                    (p['category'] as Map?)?['id'] == _selectedCatId)
                .toList();

        // Group by category
        final groups = <String, List<Map<String, dynamic>>>{};
        final groupNames = <String, String>{};
        for (final p in displayed) {
          final cat = p['category'] as Map?;
          final catId = cat?['id'] as String? ?? '__none__';
          final catName = cat?['name'] as String? ?? 'Sans catégorie';
          groups.putIfAbsent(catId, () => []).add(p);
          groupNames[catId] = catName;
        }
        // Sort groups: named categories alphabetically, then uncategorised last
        final sortedGroupIds = groups.keys.toList()
          ..sort((a, b) {
            if (a == '__none__') return 1;
            if (b == '__none__') return -1;
            return (groupNames[a] ?? '').compareTo(groupNames[b] ?? '');
          });

        return Column(
          children: [
            // Search
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
              child: TextField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Rechercher (fer, PVC, ciment…)',
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
            ),

            // Category filter chips
            if (categories.isNotEmpty)
              SizedBox(
                height: 44,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  scrollDirection: Axis.horizontal,
                  children: [
                    _CatChip(
                      label: 'Tout',
                      selected: _selectedCatId == null,
                      onTap: () => setState(() => _selectedCatId = null),
                    ),
                    ...categories.map((c) => _CatChip(
                          label: c['name'] as String,
                          selected: _selectedCatId == c['id'],
                          onTap: () => setState(
                              () => _selectedCatId = c['id'] as String),
                        )),
                  ],
                ),
              ),

            const Divider(height: 1),

            // Product groups
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
                            _query.isNotEmpty
                                ? 'Aucun résultat pour "$_query"'
                                : 'Aucun article dans cette catégorie',
                            style: const TextStyle(color: kTextSecondary),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: sortedGroupIds.length,
                      itemBuilder: (_, gi) {
                        final catId = sortedGroupIds[gi];
                        final catName = groupNames[catId] ?? 'Sans catégorie';
                        final catProducts = groups[catId]!
                          ..sort((a, b) => (a['name'] as String? ?? '')
                              .compareTo(b['name'] as String? ?? ''));

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Category header
                            Container(
                              width: double.infinity,
                              color: kPrimary.withValues(alpha: 0.07),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Text(
                                catName.toUpperCase(),
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: kPrimary,
                                    letterSpacing: 0.8),
                              ),
                            ),
                            // Products in this category
                            ...catProducts.map((p) =>
                                _CatalogueProductRow(product: p)),
                          ],
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _CatChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _CatChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, top: 6, bottom: 6),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
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
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : kTextSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _CatalogueProductRow extends StatelessWidget {
  final Map<String, dynamic> product;
  const _CatalogueProductRow({required this.product});

  @override
  Widget build(BuildContext context) {
    final units = (product['units'] as List?)?.cast<Map>() ?? [];
    final base =
        units.where((u) => u['isBase'] == true).firstOrNull ??
        (units.isNotEmpty ? units.first : null);
    final bulk = units.where((u) => u['isBase'] != true).toList();

    final baseName = base?['name'] as String? ?? 'u';
    final retailPrice = base?['retailPrice'] as int? ?? 0;
    final purchasePrice = base?['purchasePrice'] as int? ?? 0;

    final stockLevels =
        (product['stockLevels'] as List?)?.cast<Map>() ?? [];
    final totalQty =
        stockLevels.fold<int>(0, (s, l) => s + (l['cachedQty'] as int? ?? 0));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product name + stock badge
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      product['name'] as String? ?? '',
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: totalQty > 0
                          ? kSuccess.withValues(alpha: 0.12)
                          : kDanger.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '$totalQty $baseName en stock',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: totalQty > 0 ? kSuccess : kDanger),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              // Base unit price row
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  _PriceTag(
                    icon: Icons.sell_outlined,
                    label: '1 $baseName',
                    price: retailPrice,
                    color: kPrimary,
                  ),
                  if (purchasePrice > 0 && purchasePrice != retailPrice)
                    _PriceTag(
                      icon: Icons.shopping_cart_outlined,
                      label: 'Achat',
                      price: purchasePrice,
                      color: kTextSecondary,
                      small: true,
                    ),
                ],
              ),

              // Bulk conditioning rows
              if (bulk.isNotEmpty) ...[
                const SizedBox(height: 6),
                ...bulk.map((u) {
                  final factor = u['factor'] as int? ?? 1;
                  final name = u['name'] as String? ?? '';
                  final uSell = u['retailPrice'] as int? ?? 0;
                  final uBuy = u['purchasePrice'] as int? ?? 0;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(children: [
                      const Icon(Icons.subdirectory_arrow_right,
                          size: 14, color: kTextSecondary),
                      const SizedBox(width: 4),
                      Text(
                        '$name ($factor $baseName)',
                        style: const TextStyle(
                            fontSize: 12,
                            color: kTextSecondary,
                            fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      if (uBuy > 0 && uBuy != uSell)
                        Text(
                          '${formatFcfa(uBuy)}  →  ',
                          style: const TextStyle(
                              fontSize: 11,
                              color: kTextSecondary,
                              decoration: TextDecoration.lineThrough),
                        ),
                      Text(
                        formatFcfa(uSell),
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: kSuccess),
                      ),
                    ]),
                  );
                }),
              ],
            ],
          ),
        ),
        const Divider(height: 1, indent: 16),
      ],
    );
  }
}

class _PriceTag extends StatelessWidget {
  final IconData icon;
  final String label;
  final int price;
  final Color color;
  final bool small;
  const _PriceTag({
    required this.icon,
    required this.label,
    required this.price,
    required this.color,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: small ? 12 : 14, color: color),
        const SizedBox(width: 4),
        Text(
          '$label : ${formatFcfa(price)}',
          style: TextStyle(
              fontSize: small ? 11 : 13,
              fontWeight: FontWeight.w700,
              color: color),
        ),
      ]),
    );
  }
}

// ── Product List (Articles tab) ───────────────────────────────────────────────

class _ProductsList extends ConsumerStatefulWidget {
  final List<Map<String, dynamic>> products;
  const _ProductsList({required this.products});

  @override
  ConsumerState<_ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends ConsumerState<_ProductsList> {
  String _query = '';
  final _api = ApiClient();

  Future<void> _editProduct(BuildContext ctx, Map<String, dynamic> p) async {
    await ProductsScreen._showForm(ctx, ref, product: p);
  }

  Future<void> _deleteProduct(BuildContext ctx, Map<String, dynamic> p) async {
    final confirm = await showDialog<bool>(
      context: ctx,
      builder: (dctx) => AlertDialog(
        title: const Text('Supprimer l\'article'),
        content: Text('Supprimer "${p['name']}" ?\nCette action est irréversible.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dctx, false),
              child: const Text('Annuler')),
          TextButton(
            onPressed: () => Navigator.pop(dctx, true),
            child: const Text('Supprimer', style: TextStyle(color: kDanger)),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    try {
      await _api.delete('${Api.products}/${p['id']}');
      ref.invalidate(_productsProvider);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _query.isEmpty
        ? widget.products
        : widget.products.where((p) {
            final name = (p['name'] as String? ?? '').toLowerCase();
            final brand = (p['brand'] as String? ?? '').toLowerCase();
            return name.contains(_query.toLowerCase()) ||
                brand.contains(_query.toLowerCase());
          }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Rechercher un article…',
            ),
            onChanged: (v) => setState(() => _query = v),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (_, i) {
              final p = filtered[i];
              final units =
                  (p['units'] as List?)?.cast<Map<String, dynamic>>() ?? [];
              final baseUnit =
                  units.where((u) => u['isBase'] == true).firstOrNull;
              final bulkCount =
                  units.where((u) => u['isBase'] != true).length;
              final stockLevels =
                  (p['stockLevels'] as List?)?.cast<Map<String, dynamic>>() ??
                      [];
              final totalQty = stockLevels.fold<int>(
                  0, (s, l) => s + (l['cachedQty'] as int? ?? 0));
              final cat = p['category'] as Map? ?? {};

              return ListTile(
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: kPrimary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.inventory_2, color: kPrimary),
                ),
                title: Text(p['name'] as String? ?? '',
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                subtitle: Text([
                  if (p['brand'] != null) p['brand'] as String,
                  if (cat['name'] != null) cat['name'] as String,
                  if (bulkCount > 0) '$bulkCount conditionn.',
                ].join(' · ')),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$totalQty ${baseUnit?['name'] ?? 'u'}',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            color: totalQty > 0 ? kSuccess : kDanger,
                          ),
                        ),
                        if (baseUnit != null)
                          Text(
                            formatFcfa(baseUnit['retailPrice'] as int? ?? 0),
                            style: const TextStyle(
                                fontSize: 11, color: kTextSecondary),
                          ),
                      ],
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert,
                          size: 20, color: kTextSecondary),
                      onSelected: (action) {
                        if (action == 'edit') _editProduct(context, p);
                        if (action == 'delete') _deleteProduct(context, p);
                      },
                      itemBuilder: (_) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: ListTile(
                            leading: Icon(Icons.edit_outlined),
                            title: Text('Modifier'),
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: ListTile(
                            leading: Icon(Icons.delete_outline, color: kDanger),
                            title: Text('Supprimer',
                                style: TextStyle(color: kDanger)),
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                          ),
                        ),
                      ],
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

// ── Bulk conditioning entry ───────────────────────────────────────────────────

class _BulkEntry {
  String? id;
  String? name;
  final TextEditingController qtyCtrl;
  final TextEditingController buyCtrl;
  final TextEditingController sellCtrl;

  _BulkEntry({
    this.id,
    this.name,
    String qty = '',
    String buy = '',
    String sell = '',
  })  : qtyCtrl = TextEditingController(text: qty),
        buyCtrl = TextEditingController(text: buy),
        sellCtrl = TextEditingController(text: sell);

  void dispose() {
    qtyCtrl.dispose();
    buyCtrl.dispose();
    sellCtrl.dispose();
  }
}

// ── Product Form Sheet ────────────────────────────────────────────────────────

class _ProductFormSheet extends StatefulWidget {
  final Map<String, dynamic>? product;
  final List<Map<String, dynamic>> categories;
  final List<Map<String, dynamic>> existingUnits;

  const _ProductFormSheet({
    this.product,
    required this.categories,
    required this.existingUnits,
  });

  bool get isEdit => product != null;

  @override
  State<_ProductFormSheet> createState() => _ProductFormSheetState();
}

class _ProductFormSheetState extends State<_ProductFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _api = ApiClient();

  final _nameCtrl = TextEditingController();
  final _brandCtrl = TextEditingController();
  final _baseAchatCtrl = TextEditingController();
  final _baseVenteCtrl = TextEditingController();

  String? _categoryId;
  String? _baseUnitName;
  String? _baseUnitId;

  List<Map<String, dynamic>> _localCategories = [];
  List<Map<String, dynamic>> _localUnits = [];
  final List<_BulkEntry> _bulkEntries = [];

  bool _loading = false;
  String? _error;

  static const _kNewUnit = '__new__';
  static const _kNewCat = '__new_cat__';

  static const _kCommonBulk = [
    'Tonne',
    'Lot de 10',
    'Lot de 25',
    'Douzaine',
    'Palette',
    'Sac',
  ];

  @override
  void initState() {
    super.initState();
    _localCategories = List.from(widget.categories);
    _localUnits = List.from(widget.existingUnits);

    if (widget.isEdit) {
      final p = widget.product!;
      _nameCtrl.text = p['name'] as String? ?? '';
      _brandCtrl.text = p['brand'] as String? ?? '';
      final cat = p['category'] as Map?;
      _categoryId = cat?['id'] as String?;

      final rawUnits = (p['units'] as List?)?.cast<Map>() ?? [];
      final base = rawUnits.where((u) => u['isBase'] == true).firstOrNull;
      if (base != null) {
        _baseUnitId = base['id'] as String?;
        _baseUnitName = base['name'] as String?;
        _baseAchatCtrl.text = (base['purchasePrice'] as int? ?? 0).toString();
        _baseVenteCtrl.text = (base['retailPrice'] as int? ?? 0).toString();
        if (_baseUnitName != null &&
            !_localUnits.any((u) => u['name'] == _baseUnitName)) {
          _localUnits = [..._localUnits, {'id': _baseUnitName, 'name': _baseUnitName}];
        }
      }

      for (final u in rawUnits.where((u) => u['isBase'] != true)) {
        final uName = u['name'] as String?;
        if (uName != null && !_localUnits.any((l) => l['name'] == uName)) {
          _localUnits = [..._localUnits, {'id': u['id'], 'name': uName}];
        }
        _bulkEntries.add(_BulkEntry(
          id: u['id'] as String?,
          name: uName,
          qty: (u['factor'] as int? ?? 1).toString(),
          buy: (u['purchasePrice'] as int? ?? 0).toString(),
          sell: (u['retailPrice'] as int? ?? 0).toString(),
        ));
      }
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _brandCtrl.dispose();
    _baseAchatCtrl.dispose();
    _baseVenteCtrl.dispose();
    for (final e in _bulkEntries) {
      e.dispose();
    }
    super.dispose();
  }

  Future<String?> _askName(String title, String hint) async {
    final ctrl = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(hintText: hint),
          onSubmitted: (_) => Navigator.pop(ctx, ctrl.text.trim()),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
              child: const Text('Créer')),
        ],
      ),
    );
  }

  Future<void> _promptNewBaseUnit() async {
    final name =
        await _askName('Nouvelle unité', 'ex: Barre, Sac, Tube, Plaque…');
    if (name == null || name.isEmpty) return;
    try {
      final res = await _api.post(Api.units, data: {'name': name});
      final created = res.data as Map<String, dynamic>;
      setState(() {
        _localUnits = [..._localUnits, created];
        _baseUnitName = created['name'] as String;
      });
    } catch (_) {
      setState(() {
        if (!_localUnits.any((u) => u['name'] == name)) {
          _localUnits = [..._localUnits, {'id': name, 'name': name}];
        }
        _baseUnitName = name;
      });
    }
  }

  Future<void> _promptNewCategory() async {
    final name = await _askName(
        'Nouvelle catégorie', 'ex: Barres de fer, Tubes PVC, Ciment…');
    if (name == null || name.isEmpty) return;
    try {
      final res =
          await _api.post('${Api.products}/categories', data: {'name': name});
      final created = res.data as Map<String, dynamic>;
      setState(() {
        _localCategories = [..._localCategories, created];
        _categoryId = created['id'] as String;
      });
    } catch (_) {}
  }

  void _addBulk({String? presetName}) {
    setState(() => _bulkEntries.add(_BulkEntry(name: presetName)));
  }

  void _removeBulk(int idx) {
    setState(() {
      _bulkEntries[idx].dispose();
      _bulkEntries.removeAt(idx);
    });
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_baseUnitName == null || _baseUnitName!.isEmpty) {
      setState(() => _error = 'Sélectionnez une unité de base');
      return;
    }
    for (int i = 0; i < _bulkEntries.length; i++) {
      final e = _bulkEntries[i];
      if (e.name == null || e.name!.isEmpty) {
        setState(() => _error = 'Donnez un nom au conditionnement ${i + 1}');
        return;
      }
      if ((int.tryParse(e.qtyCtrl.text) ?? 0) < 2) {
        setState(() =>
            _error = '${e.name} : entrez le nombre d\'unités par lot (≥ 2)');
        return;
      }
    }

    setState(() { _loading = true; _error = null; });
    try {
      const uuid = Uuid();
      final units = <Map<String, dynamic>>[
        {
          'id': _baseUnitId ?? uuid.v4(),
          'name': _baseUnitName!,
          'isBase': true,
          'factor': 1,
          'purchasePrice': int.tryParse(_baseAchatCtrl.text) ?? 0,
          'retailPrice': int.tryParse(_baseVenteCtrl.text) ?? 0,
          'wholesalePrice': int.tryParse(_baseVenteCtrl.text) ?? 0,
          'wholesaleMinQty': 1,
        },
        ..._bulkEntries.map((e) => {
              'id': e.id ?? uuid.v4(),
              'name': e.name!,
              'isBase': false,
              'factor': int.tryParse(e.qtyCtrl.text) ?? 1,
              'purchasePrice': int.tryParse(e.buyCtrl.text) ?? 0,
              'retailPrice': int.tryParse(e.sellCtrl.text) ?? 0,
              'wholesalePrice': int.tryParse(e.sellCtrl.text) ?? 0,
              'wholesaleMinQty': 1,
            }),
      ];

      if (widget.isEdit) {
        await _api.put('${Api.products}/${widget.product!['id']}', data: {
          'name': _nameCtrl.text.trim(),
          if (_brandCtrl.text.trim().isNotEmpty) 'brand': _brandCtrl.text.trim(),
          if (_categoryId != null) 'categoryId': _categoryId,
          'units': units,
        });
      } else {
        await _api.post(Api.products, data: {
          'id': uuid.v4(),
          'name': _nameCtrl.text.trim(),
          if (_brandCtrl.text.trim().isNotEmpty) 'brand': _brandCtrl.text.trim(),
          if (_categoryId != null) 'categoryId': _categoryId,
          'units': units,
        });
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      final msg = e.toString();
      setState(() => _error = msg.contains('400')
          ? 'Données invalides'
          : msg.contains('409')
              ? 'Cet article existe déjà'
              : msg.contains('500')
                  ? 'Erreur serveur'
                  : msg.contains('timeout') || msg.contains('Socket')
                      ? 'Serveur en démarrage, réessayez…'
                      : 'Erreur: $msg');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _buildBulkRow(int idx) {
    final e = _bulkEntries[idx];
    final baseName = _baseUnitName ?? 'unité';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(12, 10, 8, 12),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: e.name,
                decoration: const InputDecoration(
                  labelText: 'Nom du lot *',
                  isDense: true,
                  prefixIcon: Icon(Icons.category_outlined, size: 18),
                ),
                items: [
                  ..._localUnits.map((u) => DropdownMenuItem(
                        value: u['name'] as String,
                        child: Text(u['name'] as String),
                      )),
                  const DropdownMenuItem(
                    value: _kNewUnit,
                    child: Row(children: [
                      Icon(Icons.add, size: 15, color: kSuccess),
                      SizedBox(width: 6),
                      Text('Nouveau nom…',
                          style: TextStyle(
                              color: kSuccess, fontWeight: FontWeight.w600)),
                    ]),
                  ),
                ],
                onChanged: (v) {
                  if (v == _kNewUnit) {
                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      final name = await _askName(
                          'Nouveau conditionnement',
                          'ex: Palette, Caisse, Rouleau…');
                      if (name == null || name.isEmpty) return;
                      setState(() {
                        if (!_localUnits.any((u) => u['name'] == name)) {
                          _localUnits = [
                            ..._localUnits,
                            {'id': name, 'name': name}
                          ];
                        }
                        _bulkEntries[idx].name = name;
                      });
                    });
                  } else {
                    setState(() => _bulkEntries[idx].name = v);
                  }
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 18, color: kDanger),
              onPressed: () => _removeBulk(idx),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ]),
          const SizedBox(height: 10),
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const Text('1 lot = ',
                style: TextStyle(color: kTextSecondary, fontSize: 13)),
            SizedBox(
              width: 72,
              child: TextFormField(
                controller: e.qtyCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(isDense: true),
                validator: (v) =>
                    (int.tryParse(v ?? '') ?? 0) < 2 ? 'Min 2' : null,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Text(baseName,
                  style: const TextStyle(
                      color: kTextSecondary, fontSize: 13)),
            ),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(
              child: TextFormField(
                controller: e.buyCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                    labelText: 'Prix achat / lot',
                    suffixText: 'F',
                    isDense: true),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: e.sellCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                    labelText: 'Prix vente / lot *',
                    suffixText: 'F',
                    isDense: true),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Requis' : null,
              ),
            ),
          ]),
          if (e.sellCtrl.text.isNotEmpty &&
              (int.tryParse(e.qtyCtrl.text) ?? 0) > 0)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Builder(builder: (_) {
                final qty = int.tryParse(e.qtyCtrl.text) ?? 1;
                final sell = int.tryParse(e.sellCtrl.text) ?? 0;
                final perUnit = qty > 0 ? sell ~/ qty : 0;
                return Text(
                  'soit ${formatFcfa(perUnit)} / $baseName dans ce lot',
                  style: const TextStyle(
                      fontSize: 11,
                      color: kTextSecondary,
                      fontStyle: FontStyle.italic),
                );
              }),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Expanded(
                  child: Text(
                    widget.isEdit ? 'Modifier l\'article' : 'Nouvel article',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                ),
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close)),
              ]),
              const Divider(),
              const SizedBox(height: 6),

              _sectionLabel('Informations'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                    labelText: 'Nom de l\'article *',
                    prefixIcon: Icon(Icons.inventory_2)),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Nom requis' : null,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _brandCtrl,
                decoration: const InputDecoration(
                    labelText: 'Marque / Référence (optionnel)',
                    prefixIcon: Icon(Icons.label_outline)),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _categoryId,
                decoration: const InputDecoration(
                    labelText: 'Catégorie',
                    prefixIcon: Icon(Icons.category)),
                items: [
                  const DropdownMenuItem(
                      value: null, child: Text('— Aucune —')),
                  ..._localCategories.map((c) => DropdownMenuItem(
                        value: c['id'] as String,
                        child: Text(c['name'] as String? ?? ''),
                      )),
                  const DropdownMenuItem(
                    value: _kNewCat,
                    child: Row(children: [
                      Icon(Icons.add, size: 15, color: kPrimary),
                      SizedBox(width: 6),
                      Text('Nouvelle catégorie…',
                          style: TextStyle(
                              color: kPrimary,
                              fontWeight: FontWeight.w600)),
                    ]),
                  ),
                ],
                onChanged: (v) {
                  if (v == _kNewCat) {
                    WidgetsBinding.instance
                        .addPostFrameCallback((_) => _promptNewCategory());
                  } else {
                    setState(() => _categoryId = v);
                  }
                },
              ),
              const SizedBox(height: 20),

              _sectionLabel('Vente à l\'unité'),
              const SizedBox(height: 4),
              const Text(
                'Prix pour vendre une seule pièce / un seul sac / une seule barre.',
                style: TextStyle(fontSize: 12, color: kTextSecondary),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _baseUnitName,
                decoration: const InputDecoration(
                  labelText: 'Unité de base *',
                  prefixIcon: Icon(Icons.straighten, size: 18),
                  helperText: 'Comment vous comptez ce produit (barre, sac, tube…)',
                ),
                items: [
                  ..._localUnits.map((u) => DropdownMenuItem(
                        value: u['name'] as String,
                        child: Text(u['name'] as String),
                      )),
                  const DropdownMenuItem(
                    value: _kNewUnit,
                    child: Row(children: [
                      Icon(Icons.add, size: 15, color: kSuccess),
                      SizedBox(width: 6),
                      Text('Nouvelle unité…',
                          style: TextStyle(
                              color: kSuccess,
                              fontWeight: FontWeight.w600)),
                    ]),
                  ),
                ],
                onChanged: (v) {
                  if (v == _kNewUnit) {
                    WidgetsBinding.instance
                        .addPostFrameCallback((_) => _promptNewBaseUnit());
                  } else {
                    setState(() => _baseUnitName = v);
                  }
                },
                validator: (v) =>
                    (v == null || v.isEmpty || v == _kNewUnit)
                        ? 'Requis'
                        : null,
              ),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(
                  child: TextFormField(
                    controller: _baseAchatCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                        labelText: 'Prix d\'achat *',
                        suffixText: 'F',
                        isDense: true),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Requis' : null,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _baseVenteCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                        labelText: 'Prix de vente *',
                        suffixText: 'F',
                        isDense: true),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Requis' : null,
                  ),
                ),
              ]),
              const SizedBox(height: 22),

              _sectionLabel('Conditionnements en gros (optionnel)'),
              const SizedBox(height: 4),
              const Text(
                'Lots, tonnes, douzaines… avec nombre d\'unités et prix du lot.',
                style: TextStyle(fontSize: 12, color: kTextSecondary),
              ),
              const SizedBox(height: 10),

              for (int i = 0; i < _bulkEntries.length; i++)
                _buildBulkRow(i),

              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  for (final name in _kCommonBulk)
                    ActionChip(
                      avatar: const Icon(Icons.add, size: 14),
                      label: Text(name),
                      onPressed: () => _addBulk(presetName: name),
                      backgroundColor: Colors.orange.shade50,
                      side: BorderSide(color: Colors.orange.shade200),
                      labelStyle: TextStyle(
                          color: Colors.orange.shade800,
                          fontWeight: FontWeight.w600,
                          fontSize: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ActionChip(
                    avatar: const Icon(Icons.add, size: 14),
                    label: const Text('Autre lot…'),
                    onPressed: _addBulk,
                    backgroundColor: Colors.grey.shade100,
                    side: BorderSide(color: Colors.grey.shade300),
                    labelStyle: const TextStyle(
                        color: kTextSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ),

              if (_error != null) ...[
                const SizedBox(height: 10),
                Text(_error!,
                    style: const TextStyle(color: kDanger, fontSize: 13)),
              ],
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _loading ? null : _submit,
                  icon: _loading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.check),
                  label: Text(_loading
                      ? 'Enregistrement…'
                      : (widget.isEdit
                          ? 'Enregistrer les modifications'
                          : 'Enregistrer l\'article')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) => Text(
        text,
        style: const TextStyle(
            fontSize: 13, fontWeight: FontWeight.w800, color: kPrimary),
      );
}

// ── Error / Retry ─────────────────────────────────────────────────────────────

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
          const Text('Impossible de charger',
              style: TextStyle(color: kTextSecondary)),
          const SizedBox(height: 8),
          Text(error,
              style: const TextStyle(fontSize: 11, color: kTextSecondary),
              textAlign: TextAlign.center),
          const SizedBox(height: 12),
          TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer')),
        ],
      ),
    );
  }
}

// ── Units Manager Sheet ───────────────────────────────────────────────────────

class _UnitsManagerSheet extends StatefulWidget {
  final VoidCallback onChanged;
  const _UnitsManagerSheet({required this.onChanged});

  @override
  State<_UnitsManagerSheet> createState() => _UnitsManagerSheetState();
}

class _UnitsManagerSheetState extends State<_UnitsManagerSheet> {
  final _api = ApiClient();
  final _nameCtrl = TextEditingController();
  List<Map<String, dynamic>> _units = [];
  bool _loadingUnits = true;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() { _loadingUnits = true; _error = null; });
    try {
      final res = await _api.get(Api.units);
      setState(() {
        _units = (res.data as List).cast<Map<String, dynamic>>();
        _loadingUnits = false;
      });
    } catch (_) {
      setState(() { _error = 'Erreur de chargement'; _loadingUnits = false; });
    }
  }

  Future<void> _create() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;
    setState(() => _saving = true);
    try {
      await _api.post(Api.units, data: {'name': name});
      _nameCtrl.clear();
      widget.onChanged();
      await _load();
    } catch (e) {
      setState(() => _error = e.toString().contains('409')
          ? '"$name" existe déjà'
          : 'Erreur lors de la création');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete(String id, String name) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer l\'unité'),
        content: Text('Supprimer "$name" ?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Annuler')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Supprimer', style: TextStyle(color: kDanger)),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    try {
      await _api.delete('${Api.units}/$id');
      widget.onChanged();
      await _load();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
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
              margin: const EdgeInsets.only(top: 10, bottom: 4),
              width: 40, height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
            child: Row(children: [
              const Expanded(
                child: Text('Gérer les unités de base',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w800)),
              ),
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close)),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(children: [
              Expanded(
                child: TextField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(
                    hintText: 'Nouvelle unité (ex: Barre, Sac, Tube)',
                    prefixIcon: Icon(Icons.add),
                  ),
                  textCapitalization: TextCapitalization.words,
                  onSubmitted: (_) => _create(),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: _saving ? null : _create,
                child: _saving
                    ? const SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : const Text('Ajouter'),
              ),
            ]),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(_error!,
                  style: const TextStyle(color: kDanger, fontSize: 13)),
            ),
          const Divider(height: 1),
          Expanded(
            child: _loadingUnits
                ? const Center(child: CircularProgressIndicator())
                : _units.isEmpty
                    ? const Center(
                        child: Text(
                          'Aucune unité.\nTapez un nom et appuyez sur Ajouter.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: kTextSecondary),
                        ),
                      )
                    : ListView.separated(
                        itemCount: _units.length,
                        separatorBuilder: (_, __) =>
                            const Divider(height: 1),
                        itemBuilder: (_, i) {
                          final u = _units[i];
                          return ListTile(
                            leading: Container(
                              width: 36, height: 36,
                              decoration: BoxDecoration(
                                color: kPrimary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.straighten,
                                  color: kPrimary, size: 18),
                            ),
                            title: Text(u['name'] as String,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: kDanger),
                              onPressed: () => _delete(
                                  u['id'] as String,
                                  u['name'] as String),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
