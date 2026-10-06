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

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
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
      ),
      body: ref.watch(_productsProvider).when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorRetry(
          error: e.toString(),
          onRetry: () => ref.invalidate(_productsProvider),
        ),
        data: (products) => products.isEmpty
            ? _emptyState()
            : _ProductsList(products: products.cast<Map<String, dynamic>>()),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddProduct(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Nouvel article'),
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _emptyState() => const Center(
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
  );

  void _showAddProduct(BuildContext context, WidgetRef ref) async {
    final categories = await ref.read(_categoriesProvider.future).catchError((_) => <dynamic>[]);
    final units = await ref.read(_unitNamesProvider.future).catchError((_) => <Map<String, dynamic>>[]);
    if (!context.mounted) return;
    final added = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddProductSheet(
        categories: categories.cast<Map<String, dynamic>>(),
        existingUnits: units,
      ),
    );
    if (added == true) {
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
              final units = (p['units'] as List?)?.cast<Map<String, dynamic>>() ?? [];
              final baseUnit = units.where((u) => u['isBase'] == true).firstOrNull;
              final stockLevels = (p['stockLevels'] as List?)?.cast<Map<String, dynamic>>() ?? [];
              final totalQty = stockLevels.fold<int>(0, (s, l) => s + (l['cachedQty'] as int? ?? 0));
              final cat = p['category'] as Map? ?? {};

              return ListTile(
                leading: Container(
                  width: 44, height: 44,
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
                ].join(' · ')),
                trailing: Column(
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

// ── Add Product Sheet ─────────────────────────────────────────────────────────

class _AddProductSheet extends StatefulWidget {
  final List<Map<String, dynamic>> categories;
  final List<Map<String, dynamic>> existingUnits; // [{id, name}]
  const _AddProductSheet({required this.categories, required this.existingUnits});

  @override
  State<_AddProductSheet> createState() => _AddProductSheetState();
}

class _AddProductSheetState extends State<_AddProductSheet> {
  final _formKey = GlobalKey<FormState>();
  final _api = ApiClient();

  final _nameCtrl = TextEditingController();
  final _brandCtrl = TextEditingController();
  final _unitNameCtrl = TextEditingController();
  final _purchasePriceCtrl = TextEditingController();
  final _retailPriceCtrl = TextEditingController();
  final _wholesalePriceCtrl = TextEditingController();
  final _wholesaleMinQtyCtrl = TextEditingController(text: '10');

  String? _categoryId;
  String? _selectedUnitName;
  List<Map<String, dynamic>> _localUnits = []; // kept in sync with the sheet's list
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _localUnits = List.from(widget.existingUnits);
  }

  @override
  void dispose() {
    _nameCtrl.dispose(); _brandCtrl.dispose(); _unitNameCtrl.dispose();
    _purchasePriceCtrl.dispose(); _retailPriceCtrl.dispose();
    _wholesalePriceCtrl.dispose(); _wholesaleMinQtyCtrl.dispose();
    super.dispose();
  }

  static const _kNewUnit = '__new__';

  Future<void> _promptNewUnit() async {
    final ctrl = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nouvelle unité'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(hintText: 'ex: Sac 50kg, Barre 12m…'),
          onSubmitted: (_) => Navigator.pop(ctx, ctrl.text.trim()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Annuler')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: const Text('Créer'),
          ),
        ],
      ),
    );
    if (name == null || name.isEmpty) return;
    try {
      final res = await _api.post(Api.units, data: {'name': name});
      final created = res.data as Map<String, dynamic>;
      setState(() {
        _localUnits = [..._localUnits, created];
        _selectedUnitName = created['name'] as String;
      });
    } catch (_) {
      // unit might already exist — just add it locally and select it
      setState(() {
        if (!_localUnits.any((u) => u['name'] == name)) {
          _localUnits = [..._localUnits, {'id': name, 'name': name}];
        }
        _selectedUnitName = name;
      });
    }
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final unitName = _selectedUnitName ?? '';
    if (unitName.isEmpty) {
      setState(() => _error = 'Sélectionnez ou créez une unité');
      return;
    }
    setState(() { _loading = true; _error = null; });
    try {
      const uuid = Uuid();
      await _api.post(Api.products, data: {
        'id': uuid.v4(),
        'name': _nameCtrl.text.trim(),
        if (_brandCtrl.text.trim().isNotEmpty) 'brand': _brandCtrl.text.trim(),
        if (_categoryId != null) 'categoryId': _categoryId,
        'units': [
          {
            'id': uuid.v4(),
            'name': unitName,
            'isBase': true,
            'factor': 1,
            'purchasePrice': int.tryParse(_purchasePriceCtrl.text) ?? 0,
            'retailPrice': int.tryParse(_retailPriceCtrl.text) ?? 0,
            'wholesalePrice': int.tryParse(_wholesalePriceCtrl.text.isEmpty
                ? _retailPriceCtrl.text : _wholesalePriceCtrl.text) ?? 0,
            'wholesaleMinQty': int.tryParse(_wholesaleMinQtyCtrl.text) ?? 10,
          }
        ],
      });
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      final msg = e.toString();
      String label;
      if (msg.contains('400')) {
        label = 'Données invalides (vérifiez les champs)';
      } else if (msg.contains('401')) {
        label = 'Session expirée — relancez l\'application';
      } else if (msg.contains('409')) {
        label = 'Cet article existe déjà';
      } else if (msg.contains('500')) {
        label = 'Erreur serveur (500) — réessayez dans quelques secondes';
      } else if (msg.contains('timeout') || msg.contains('SocketException')) {
        label = 'Serveur en démarrage, réessayez dans 30 secondes…';
      } else {
        label = 'Erreur: $msg';
      }
      setState(() => _error = label);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
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
        left: 20, right: 20, top: 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(children: [
                const Expanded(
                  child: Text('Nouvel article',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                ),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
              ]),
              const Divider(),
              const SizedBox(height: 8),

              // Product info
              const Text('Informations', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: kTextSecondary)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Nom de l\'article *', prefixIcon: Icon(Icons.inventory_2)),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Nom requis' : null,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _brandCtrl,
                decoration: const InputDecoration(labelText: 'Marque (optionnel)', prefixIcon: Icon(Icons.label_outline)),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 10),
              if (widget.categories.isNotEmpty)
                DropdownButtonFormField<String>(
                  initialValue: _categoryId,
                  decoration: const InputDecoration(labelText: 'Catégorie (optionnel)', prefixIcon: Icon(Icons.category)),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('— Aucune —')),
                    ...widget.categories.map((c) => DropdownMenuItem(
                      value: c['id'] as String,
                      child: Text(c['name'] as String? ?? ''),
                    )),
                  ],
                  onChanged: (v) => setState(() => _categoryId = v),
                ),
              const SizedBox(height: 16),

              // Unit selection
              const Text('Unité de base', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: kTextSecondary)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _selectedUnitName,
                decoration: const InputDecoration(
                  labelText: 'Unité *',
                  prefixIcon: Icon(Icons.scale),
                  hintText: 'Sélectionner ou créer une unité',
                ),
                items: [
                  ..._localUnits.map((u) => DropdownMenuItem(
                    value: u['name'] as String,
                    child: Text(u['name'] as String),
                  )),
                  const DropdownMenuItem(
                    value: _kNewUnit,
                    child: Row(children: [
                      Icon(Icons.add, size: 16, color: kSuccess),
                      SizedBox(width: 6),
                      Text('Nouvelle unité…', style: TextStyle(color: kSuccess, fontWeight: FontWeight.w600)),
                    ]),
                  ),
                ],
                onChanged: (v) async {
                  if (v == _kNewUnit) {
                    await _promptNewUnit();
                  } else {
                    setState(() => _selectedUnitName = v);
                  }
                },
                validator: (v) => (v == null || v.isEmpty || v == _kNewUnit) ? 'Requis' : null,
              ),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(
                  child: TextFormField(
                    controller: _purchasePriceCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(labelText: 'Prix achat *', suffixText: 'FCFA'),
                    validator: (v) => (v == null || v.isEmpty) ? 'Requis' : null,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _retailPriceCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(labelText: 'Prix vente *', suffixText: 'FCFA'),
                    validator: (v) => (v == null || v.isEmpty) ? 'Requis' : null,
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(
                  child: TextFormField(
                    controller: _wholesalePriceCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(labelText: 'Prix gros', suffixText: 'FCFA'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _wholesaleMinQtyCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(labelText: 'Qté min gros'),
                  ),
                ),
              ]),

              if (_error != null) ...[
                const SizedBox(height: 10),
                Text(_error!, style: const TextStyle(color: kDanger, fontSize: 13)),
              ],
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _loading ? null : _submit,
                  icon: _loading
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.check),
                  label: Text(_loading ? 'Enregistrement…' : 'Enregistrer l\'article'),
                ),
              ),
            ],
          ),
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
          const Text('Impossible de charger les articles', style: TextStyle(color: kTextSecondary)),
          const SizedBox(height: 8),
          TextButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh), label: const Text('Réessayer')),
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
    } catch (e) {
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
      setState(() => _error = e.toString().contains('409') ? '"$name" existe déjà' : 'Erreur lors de la création');
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
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
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
    final screenH = MediaQuery.of(context).size.height;
    return Container(
      height: screenH * 0.65,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 4),
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
            child: Row(children: [
              const Expanded(
                child: Text('Gérer les unités',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              ),
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(children: [
              Expanded(
                child: TextField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(
                    hintText: 'Nouvelle unité (ex: Sac 50kg)',
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
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Ajouter'),
              ),
            ]),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(_error!, style: const TextStyle(color: kDanger, fontSize: 13)),
            ),
          const Divider(height: 1),
          Expanded(
            child: _loadingUnits
                ? const Center(child: CircularProgressIndicator())
                : _units.isEmpty
                    ? const Center(
                        child: Text('Aucune unité créée.\nTapez un nom et appuyez sur Ajouter.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: kTextSecondary)),
                      )
                    : ListView.separated(
                        itemCount: _units.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (_, i) {
                          final u = _units[i];
                          return ListTile(
                            leading: Container(
                              width: 36, height: 36,
                              decoration: BoxDecoration(
                                color: kPrimary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.straighten, color: kPrimary, size: 18),
                            ),
                            title: Text(u['name'] as String,
                                style: const TextStyle(fontWeight: FontWeight.w600)),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline, color: kDanger),
                              onPressed: () => _delete(u['id'] as String, u['name'] as String),
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
