import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../data/sync/api_client.dart';
import '../../core/constants/api.dart';

final _apiProvC = Provider<ApiClient>((ref) => ApiClient());

final _customersProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final api = ref.watch(_apiProvC);
  final res = await api.get(Api.customers);
  return (res.data as List).cast<Map<String, dynamic>>();
});

final _debtorsProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final api = ref.watch(_apiProvC);
  final res = await api.get('${Api.customers}/debtors');
  return (res.data as List).cast<Map<String, dynamic>>();
});

// ── Screen ────────────────────────────────────────────────────────────────────

class CustomersScreen extends ConsumerStatefulWidget {
  const CustomersScreen({super.key});

  @override
  ConsumerState<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends ConsumerState<CustomersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clients'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(_customersProvider);
              ref.invalidate(_debtorsProvider);
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabs,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.people, size: 18), text: 'Tous'),
            Tab(icon: Icon(Icons.account_balance_wallet, size: 18), text: 'Dettes'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _ClientsTab(onRefresh: () => ref.invalidate(_customersProvider)),
          _DettesTab(onRefresh: () {
            ref.invalidate(_customersProvider);
            ref.invalidate(_debtorsProvider);
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddCustomer(context),
        icon: const Icon(Icons.person_add),
        label: const Text('Nouveau client'),
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
      ),
    );
  }

  Future<void> _showAddCustomer(BuildContext context) async {
    final changed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AddCustomerSheet(),
    );
    if (changed == true) {
      ref.invalidate(_customersProvider);
      ref.invalidate(_debtorsProvider);
    }
  }
}

// ── Tab 0 : All clients ───────────────────────────────────────────────────────

class _ClientsTab extends ConsumerStatefulWidget {
  final VoidCallback onRefresh;
  const _ClientsTab({required this.onRefresh});

  @override
  ConsumerState<_ClientsTab> createState() => _ClientsTabState();
}

class _ClientsTabState extends ConsumerState<_ClientsTab>
    with AutomaticKeepAliveClientMixin {
  String _query = '';

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ref.watch(_customersProvider).when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => _ErrWidget(
          msg: e.toString(),
          onRetry: () => ref.invalidate(_customersProvider)),
      data: (customers) {
        final q = _query.toLowerCase();
        final filtered = q.isEmpty
            ? customers
            : customers.where((c) {
                final name = (c['name'] as String? ?? '').toLowerCase();
                final phone = (c['phone'] as String? ?? '').toLowerCase();
                return name.contains(q) || phone.contains(q);
              }).toList();

        // Stats
        final totalDebt = customers.fold<int>(
            0, (s, c) => s + (c['totalDebt'] as int? ?? 0));
        final withDebt = customers.where((c) => (c['totalDebt'] as int? ?? 0) > 0).length;

        return Column(
          children: [
            // Stats banner
            if (customers.isNotEmpty)
              Container(
                color: kPrimary.withValues(alpha: 0.05),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                child: Row(children: [
                  _Stat(
                      label: 'Clients',
                      value: '${customers.length}',
                      icon: Icons.people,
                      color: kPrimary),
                  const SizedBox(width: 16),
                  _Stat(
                      label: 'Avec dette',
                      value: '$withDebt',
                      icon: Icons.warning_amber,
                      color: kWarning),
                  const SizedBox(width: 16),
                  _Stat(
                      label: 'Total dettes',
                      value: formatFcfaCompact(totalDebt),
                      icon: Icons.account_balance_wallet,
                      color: kDanger),
                ]),
              ),

            // Search
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Nom ou téléphone…',
                  suffixIcon: _query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () => setState(() => _query = ''),
                        )
                      : null,
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
            ),

            // List
            Expanded(
              child: filtered.isEmpty
                  ? _EmptySearch(query: _query)
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (_, i) => _CustomerCard(
                        customer: filtered[i],
                        onTap: () => _openDetail(context, filtered[i]),
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  void _openDetail(BuildContext ctx, Map<String, dynamic> c) async {
    await showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CustomerDetailSheet(
        customer: c,
        onChanged: widget.onRefresh,
      ),
    );
  }
}

// ── Tab 1 : Debts ─────────────────────────────────────────────────────────────

class _DettesTab extends ConsumerStatefulWidget {
  final VoidCallback onRefresh;
  const _DettesTab({required this.onRefresh});

  @override
  ConsumerState<_DettesTab> createState() => _DettesTabState();
}

class _DettesTabState extends ConsumerState<_DettesTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ref.watch(_debtorsProvider).when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => _ErrWidget(
          msg: e.toString(),
          onRetry: () => ref.invalidate(_debtorsProvider)),
      data: (debtors) {
        if (debtors.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline,
                    size: 64, color: kSuccess),
                SizedBox(height: 12),
                Text('Aucune dette en cours',
                    style: TextStyle(
                        fontSize: 16, color: kTextSecondary)),
                SizedBox(height: 4),
                Text('Tous les clients sont à jour',
                    style: TextStyle(color: kTextSecondary)),
              ],
            ),
          );
        }

        final total = debtors.fold<int>(
            0, (s, d) => s + (d['balance'] as int? ?? 0));

        return Column(
          children: [
            // Total debt banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kDanger.withValues(alpha: 0.08),
                border: Border(
                    bottom: BorderSide(
                        color: kDanger.withValues(alpha: 0.2))),
              ),
              child: Row(children: [
                const Icon(Icons.account_balance_wallet,
                    color: kDanger, size: 20),
                const SizedBox(width: 10),
                Text(
                  '${debtors.length} clients doivent',
                  style: const TextStyle(
                      color: kDanger, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Text(
                  formatFcfa(total),
                  style: const TextStyle(
                      color: kDanger,
                      fontSize: 18,
                      fontWeight: FontWeight.w900),
                ),
              ]),
            ),

            // Debtors sorted by amount
            Expanded(
              child: ListView.builder(
                itemCount: debtors.length,
                itemBuilder: (_, i) {
                  final c = debtors[i];
                  final balance =
                      c['balance'] as int? ?? c['totalDebt'] as int? ?? 0;
                  return _DebtorCard(
                    customer: c,
                    balance: balance,
                    onPayment: () => _recordPayment(context, c, balance),
                    onTap: () => _openDetail(context, c),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _openDetail(BuildContext ctx, Map<String, dynamic> c) async {
    await showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CustomerDetailSheet(
        customer: c,
        onChanged: widget.onRefresh,
      ),
    );
  }

  void _recordPayment(
      BuildContext ctx, Map<String, dynamic> c, int balance) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _PaymentSheet(
        customer: c,
        outstandingBalance: balance,
        onPaid: widget.onRefresh,
      ),
    );
  }
}

// ── Customer card ─────────────────────────────────────────────────────────────

class _CustomerCard extends StatelessWidget {
  final Map<String, dynamic> customer;
  final VoidCallback onTap;
  const _CustomerCard({required this.customer, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final name = customer['name'] as String? ?? '';
    final phone = customer['phone'] as String? ?? '';
    final totalDebt = customer['totalDebt'] as int? ?? 0;
    final totalPurchased = customer['totalPurchased'] as int? ?? 0;
    final initial =
        name.isNotEmpty ? name[0].toUpperCase() : '?';

    return ListTile(
      onTap: onTap,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: CircleAvatar(
        backgroundColor: totalDebt > 0
            ? kWarning.withValues(alpha: 0.15)
            : kPrimary.withValues(alpha: 0.1),
        child: Text(
          initial,
          style: TextStyle(
              color: totalDebt > 0 ? kWarning : kPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 18),
        ),
      ),
      title: Text(name,
          style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(
        [
          if (phone.isNotEmpty) phone,
          if (totalPurchased > 0) 'Achats: ${formatFcfaCompact(totalPurchased)}',
        ].join('  ·  '),
        style: const TextStyle(fontSize: 12),
      ),
      trailing: totalDebt > 0
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: kWarning.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    formatFcfa(totalDebt),
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: kWarning),
                  ),
                ),
                const Text('doit',
                    style:
                        TextStyle(fontSize: 10, color: kWarning)),
              ],
            )
          : const Icon(Icons.chevron_right, color: kTextSecondary),
    );
  }
}

// ── Debtor card ───────────────────────────────────────────────────────────────

class _DebtorCard extends StatelessWidget {
  final Map<String, dynamic> customer;
  final int balance;
  final VoidCallback onPayment;
  final VoidCallback onTap;
  const _DebtorCard({
    required this.customer,
    required this.balance,
    required this.onPayment,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final name = customer['name'] as String? ?? '';
    final phone = customer['phone'] as String? ?? '';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Card(
      margin: const EdgeInsets.fromLTRB(12, 6, 12, 0),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: kWarning.withValues(alpha: 0.25)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: kWarning.withValues(alpha: 0.12),
              child: Text(initial,
                  style: const TextStyle(
                      color: kWarning,
                      fontWeight: FontWeight.w800,
                      fontSize: 20)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800)),
                  if (phone.isNotEmpty)
                    Text(phone,
                        style: const TextStyle(
                            fontSize: 12, color: kTextSecondary)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatFcfa(balance),
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: kDanger),
                ),
                const Text('à payer',
                    style: TextStyle(
                        fontSize: 10, color: kTextSecondary)),
              ],
            ),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: onPayment,
              style: FilledButton.styleFrom(
                backgroundColor: kSuccess,
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('Payer',
                  style: TextStyle(fontSize: 12)),
            ),
          ]),
        ),
      ),
    );
  }
}

// ── Customer detail sheet ─────────────────────────────────────────────────────

class _CustomerDetailSheet extends ConsumerStatefulWidget {
  final Map<String, dynamic> customer;
  final VoidCallback onChanged;
  const _CustomerDetailSheet(
      {required this.customer, required this.onChanged});

  @override
  ConsumerState<_CustomerDetailSheet> createState() =>
      _CustomerDetailSheetState();
}

class _CustomerDetailSheetState
    extends ConsumerState<_CustomerDetailSheet> {
  Map<String, dynamic>? _detail;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    setState(() { _loading = true; _error = null; });
    try {
      final api = ref.read(_apiProvC);
      final id = widget.customer['id'] as String?;
      if (id == null) { setState(() { _loading = false; _detail = widget.customer; }); return; }
      final res = await api.get('${Api.customers}/$id');
      setState(() { _detail = res.data as Map<String, dynamic>; _loading = false; });
    } catch (_) {
      setState(() { _detail = widget.customer; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = _detail ?? widget.customer;
    final name = c['name'] as String? ?? '';
    final phone = c['phone'] as String? ?? '';
    final totalDebt = c['totalDebt'] as int? ?? 0;
    final totalPurchased = c['totalPurchased'] as int? ?? 0;
    final transactions =
        (c['recentTransactions'] as List?)?.cast<Map>() ??
        (c['sales'] as List?)?.cast<Map>() ?? [];

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
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

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 12, 0),
            child: Row(children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: kPrimary.withValues(alpha: 0.12),
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: const TextStyle(
                      color: kPrimary,
                      fontWeight: FontWeight.w900,
                      fontSize: 22),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900)),
                    if (phone.isNotEmpty)
                      Text(phone,
                          style: const TextStyle(
                              color: kTextSecondary, fontSize: 13)),
                  ],
                ),
              ),
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close)),
            ]),
          ),

          const SizedBox(height: 12),

          // Stats row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: [
              _StatBox(
                  label: 'Total achats',
                  value: formatFcfa(totalPurchased),
                  color: kPrimary),
              const SizedBox(width: 8),
              _StatBox(
                  label: 'Solde dû',
                  value: formatFcfa(totalDebt),
                  color: totalDebt > 0 ? kDanger : kSuccess),
            ]),
          ),

          const SizedBox(height: 12),

          // Actions
          if (totalDebt > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => _PaymentSheet(
                        customer: c,
                        outstandingBalance: totalDebt,
                        onPaid: () {
                          widget.onChanged();
                          _loadDetail();
                        },
                      ),
                    );
                  },
                  icon: const Icon(Icons.payments_outlined),
                  label: Text(
                      'Enregistrer un paiement · ${formatFcfa(totalDebt)}'),
                  style: FilledButton.styleFrom(
                      backgroundColor: kSuccess),
                ),
              ),
            ),

          const SizedBox(height: 8),
          const Divider(height: 1),

          // Transaction history
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
            child: Row(children: [
              const Expanded(
                child: Text('Historique',
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700)),
              ),
              if (_loading)
                const SizedBox(
                    width: 14,
                    height: 14,
                    child:
                        CircularProgressIndicator(strokeWidth: 2)),
            ]),
          ),

          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : transactions.isEmpty
                    ? const Center(
                        child: Text('Aucune transaction',
                            style:
                                TextStyle(color: kTextSecondary)))
                    : ListView.separated(
                        padding:
                            const EdgeInsets.fromLTRB(16, 0, 16, 20),
                        itemCount: transactions.length,
                        separatorBuilder: (_, __) =>
                            const Divider(height: 1),
                        itemBuilder: (_, i) =>
                            _TxRow(tx: transactions[i]),
                      ),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatBox(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: 11,
                    color: color,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(value,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: color)),
          ],
        ),
      ),
    );
  }
}

class _TxRow extends StatelessWidget {
  final Map tx;
  const _TxRow({required this.tx});

  @override
  Widget build(BuildContext context) {
    final amount = tx['totalAmount'] as int? ?? tx['amount'] as int? ?? 0;
    final type = tx['type'] as String? ?? 'SALE';
    final isPayment = type == 'PAYMENT';
    final createdAt = tx['createdAt'] as String?;
    final number = tx['number'] as String? ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: isPayment
                ? kSuccess.withValues(alpha: 0.1)
                : kPrimary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            isPayment ? Icons.payments : Icons.shopping_bag_outlined,
            size: 18,
            color: isPayment ? kSuccess : kPrimary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isPayment ? 'Paiement reçu' : (number.isNotEmpty ? 'Vente $number' : 'Vente'),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              if (createdAt != null)
                Text(_fmtDate(createdAt),
                    style: const TextStyle(
                        fontSize: 11, color: kTextSecondary)),
            ],
          ),
        ),
        Text(
          isPayment ? '+${formatFcfa(amount)}' : formatFcfa(amount),
          style: TextStyle(
              fontWeight: FontWeight.w800,
              color: isPayment ? kSuccess : kPrimary,
              fontSize: 14),
        ),
      ]),
    );
  }

  String _fmtDate(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      return DateFormat('dd/MM/yyyy HH:mm').format(dt);
    } catch (_) {
      return '';
    }
  }
}

// ── Payment recording sheet ───────────────────────────────────────────────────

class _PaymentSheet extends ConsumerStatefulWidget {
  final Map<String, dynamic> customer;
  final int outstandingBalance;
  final VoidCallback onPaid;
  const _PaymentSheet({
    required this.customer,
    required this.outstandingBalance,
    required this.onPaid,
  });

  @override
  ConsumerState<_PaymentSheet> createState() => _PaymentSheetState();
}

class _PaymentSheetState extends ConsumerState<_PaymentSheet> {
  final _amtCtrl = TextEditingController();
  String _method = 'CASH';
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _amtCtrl.text = widget.outstandingBalance.toString();
  }

  @override
  void dispose() {
    _amtCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final amount = int.tryParse(_amtCtrl.text) ?? 0;
    if (amount <= 0) {
      setState(() => _error = 'Entrez un montant valide');
      return;
    }
    setState(() { _saving = true; _error = null; });
    try {
      final api = ref.read(_apiProvC);
      final id = widget.customer['id'] as String;
      await api.post('${Api.customers}/$id/payments', data: {
        'amount': amount,
        'method': _method,
      });
      if (mounted) {
        widget.onPaid();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Paiement de ${formatFcfa(amount)} enregistré pour ${widget.customer['name']}'),
          backgroundColor: kSuccess,
        ));
      }
    } catch (e) {
      setState(() {
        _error = e.toString().contains('404')
            ? 'Endpoint non disponible — contactez le support'
            : 'Erreur: ${e.toString().split(':').last.trim()}';
        _saving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.customer['name'] as String? ?? '';
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          left: 20, right: 20, top: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          Text('Paiement de $name',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w800)),
          Text(
            'Solde dû: ${formatFcfa(widget.outstandingBalance)}',
            style: const TextStyle(color: kDanger, fontSize: 13),
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _amtCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
                labelText: 'Montant reçu *', suffixText: 'F'),
            autofocus: true,
          ),
          const SizedBox(height: 14),

          const Text('MODE DE PAIEMENT',
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: kTextSecondary,
                  letterSpacing: 0.8)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final m in ['CASH', 'FLOOZ', 'MIXX'])
                ChoiceChip(
                  label: Text(paymentMethodLabel(m)),
                  selected: _method == m,
                  selectedColor: kPrimary,
                  onSelected: (_) => setState(() => _method = m),
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: _method == m
                          ? Colors.white
                          : kTextPrimary),
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
              onPressed: _saving ? null : _save,
              style: FilledButton.styleFrom(
                  backgroundColor: kSuccess,
                  padding: const EdgeInsets.symmetric(vertical: 14)),
              icon: _saving
                  ? const SizedBox(
                      width: 18, height: 18,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.check),
              label: Text(
                _saving
                    ? 'Enregistrement…'
                    : 'Enregistrer le paiement',
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Add customer sheet ────────────────────────────────────────────────────────

class _AddCustomerSheet extends ConsumerStatefulWidget {
  const _AddCustomerSheet();

  @override
  ConsumerState<_AddCustomerSheet> createState() =>
      _AddCustomerSheetState();
}

class _AddCustomerSheetState extends ConsumerState<_AddCustomerSheet> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty) {
      setState(() => _error = 'Le nom est requis');
      return;
    }
    setState(() { _saving = true; _error = null; });
    try {
      final api = ref.read(_apiProvC);
      await api.post(Api.customers, data: {
        'name': _nameCtrl.text.trim(),
        if (_phoneCtrl.text.trim().isNotEmpty)
          'phone': _phoneCtrl.text.trim(),
        if (_addressCtrl.text.trim().isNotEmpty)
          'address': _addressCtrl.text.trim(),
      });
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      setState(() {
        _error = e.toString().contains('409')
            ? 'Ce client existe déjà'
            : 'Erreur: ${e.toString().split(':').last.trim()}';
        _saving = false;
      });
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
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          left: 20, right: 20, top: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          Row(children: [
            const Expanded(
              child: Text('Nouveau client',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w800)),
            ),
            IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close)),
          ]),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nameCtrl,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
                labelText: 'Nom complet *',
                prefixIcon: Icon(Icons.person)),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _phoneCtrl,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
                labelText: 'Téléphone',
                prefixIcon: Icon(Icons.phone)),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _addressCtrl,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
                labelText: 'Adresse / Quartier',
                prefixIcon: Icon(Icons.location_on_outlined)),
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(_error!,
                style: const TextStyle(color: kDanger, fontSize: 13)),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox(
                      width: 16, height: 16,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.person_add),
              label:
                  Text(_saving ? 'Enregistrement…' : 'Créer le client'),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

class _EmptySearch extends StatelessWidget {
  final String query;
  const _EmptySearch({required this.query});

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 48, color: kTextSecondary),
            const SizedBox(height: 8),
            Text(
              query.isNotEmpty
                  ? 'Aucun résultat pour "$query"'
                  : 'Aucun client',
              style: const TextStyle(color: kTextSecondary),
            ),
          ],
        ),
      );
}

class _ErrWidget extends StatelessWidget {
  final String msg;
  final VoidCallback onRetry;
  const _ErrWidget({required this.msg, required this.onRetry});

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 48, color: kTextSecondary),
            const SizedBox(height: 8),
            const Text('Impossible de charger',
                style: TextStyle(color: kTextSecondary)),
            TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Réessayer')),
          ],
        ),
      );
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _Stat(
      {required this.label,
      required this.value,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
            Text(label,
                style: TextStyle(
                    fontSize: 10,
                    color: color,
                    fontWeight: FontWeight.w600)),
          ]),
          Text(value,
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w900, color: color)),
        ],
      ),
    );
  }
}
