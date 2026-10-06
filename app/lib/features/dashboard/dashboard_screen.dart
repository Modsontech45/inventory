import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../data/sync/api_client.dart';
import '../../core/constants/api.dart';
import 'package:intl/intl.dart';

// ── Providers ─────────────────────────────────────────────────────────────────

final _periodProvider = StateProvider<String>((ref) => 'today');
final _depotFilterProvider = StateProvider<String?>((ref) => null);

final _dashboardProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, (String, String?)>((ref, args) async {
  final (period, depotId) = args;
  final api = ref.read(_apiClientProvider);
  final params = <String, dynamic>{'period': period};
  if (depotId != null) params['depotId'] = depotId;
  final res = await api.get(Api.dashboard, params: params);
  return res.data as Map<String, dynamic>;
});

final _apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

// ── Screen ────────────────────────────────────────────────────────────────────

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period = ref.watch(_periodProvider);
    final depotId = ref.watch(_depotFilterProvider);
    final data = ref.watch(_dashboardProvider((period, depotId)));

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: const Text('Tableau de bord'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: () => ref.invalidate(_dashboardProvider)),
        ],
      ),
      body: Column(
        children: [
          _PeriodSelector(period: period, onChanged: (p) => ref.read(_periodProvider.notifier).state = p),
          Expanded(
            child: data.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: _ErrorRetry(error: e.toString(), onRetry: () => ref.invalidate(_dashboardProvider))),
              data: (d) => _DashboardBody(data: d),
            ),
          ),
        ],
      ),
    );
  }
}

class _PeriodSelector extends StatelessWidget {
  final String period;
  final ValueChanged<String> onChanged;

  const _PeriodSelector({required this.period, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final options = [
      ('today', "Aujourd'hui"),
      ('week', 'Cette semaine'),
      ('month', 'Ce mois'),
    ];

    return Container(
      color: kPrimary,
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Row(
        children: options.map((o) {
          final selected = period == o.$1;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: GestureDetector(
                onTap: () => onChanged(o.$1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: selected ? Colors.white : Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    o.$2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: selected ? kPrimary : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  final Map<String, dynamic> data;
  const _DashboardBody({required this.data});

  @override
  Widget build(BuildContext context) {
    final sales = data['sales'] as Map<String, dynamic>? ?? {};
    final profit = data['profit'] as Map<String, dynamic>? ?? {};
    final stock = data['stock'] as Map<String, dynamic>? ?? {};
    final debts = data['debts'] as Map<String, dynamic>? ?? {};
    final employees = (data['employees'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final recentSales = (data['recentSales'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final sparkChart = (data['sparkChart'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final byMethod = (sales['byPaymentMethod'] as Map<String, dynamic>?) ?? {};
    final topProducts = (data['topProducts'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final stockAlerts = (data['stockAlerts'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    final lowStockCount = stock['lowStockCount'] as int? ?? 0;
    final negativeCount = stock['negativeStockCount'] as int? ?? 0;

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        // ── KPI Row 1 ──
        _KpiRow(children: [
          _KpiCard(label: 'Ventes', value: formatFcfa(sales['totalAmount'] as int? ?? 0), icon: Icons.point_of_sale, color: kPrimary, sub: '${sales['saleCount'] ?? 0} ventes'),
          _KpiCard(label: 'Bénéfice brut', value: formatFcfa(profit['grossProfit'] as int? ?? 0), icon: Icons.trending_up, color: kSuccess, sub: '${profit['grossMarginPct'] ?? 0}% marge'),
        ]),
        const SizedBox(height: 8),
        _KpiRow(children: [
          _KpiCard(label: 'Stock (valeur)', value: formatFcfa(stock['costValue'] as int? ?? 0), icon: Icons.inventory_2, color: const Color(0xFF1565C0)),
          _KpiCard(label: 'Dettes clients', value: formatFcfa(debts['totalCustomerDebt'] as int? ?? 0), icon: Icons.account_balance_wallet, color: kWarning),
        ]),
        const SizedBox(height: 8),
        _KpiRow(children: [
          _KpiCard(label: 'Dépenses', value: formatFcfa(profit['expenses'] as int? ?? 0), icon: Icons.money_off, color: kDanger),
          _KpiCard(
            label: 'Stock faible',
            value: '$lowStockCount',
            icon: Icons.warning_amber,
            color: (lowStockCount + negativeCount) > 0 ? kDanger : kSuccess,
            sub: negativeCount > 0 ? '$negativeCount négatif(s)' : 'Tout est ok',
          ),
        ]),
        const SizedBox(height: 16),

        // ── Stock alerts ──
        if (stockAlerts.isNotEmpty) ...[
          Row(children: [
            const Expanded(child: _SectionTitle('Alertes stock')),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: kDanger.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('${stockAlerts.length}',
                  style: const TextStyle(color: kDanger, fontSize: 12, fontWeight: FontWeight.w800)),
            ),
          ]),
          const SizedBox(height: 8),
          _StockAlertsList(alerts: stockAlerts),
          const SizedBox(height: 16),
        ],

        // ── Top products ──
        if (topProducts.isNotEmpty) ...[
          _SectionTitle('Meilleures ventes'),
          const SizedBox(height: 8),
          _TopProductsList(products: topProducts),
          const SizedBox(height: 16),
        ],

        // ── Spark chart ──
        if (sparkChart.isNotEmpty) ...[
          _SectionTitle('Évolution 7 jours'),
          const SizedBox(height: 8),
          _SparkChart(points: sparkChart),
          const SizedBox(height: 16),
        ],

        // ── Payment method breakdown ──
        if (byMethod.isNotEmpty) ...[
          _SectionTitle('Par mode de paiement'),
          const SizedBox(height: 8),
          _PaymentMethodBreakdown(byMethod: byMethod),
          const SizedBox(height: 16),
        ],

        // ── Sales by employee ──
        if (employees.isNotEmpty) ...[
          _SectionTitle('Ventes par vendeur'),
          const SizedBox(height: 8),
          _EmployeeChart(employees: employees),
          const SizedBox(height: 16),
        ],

        // ── Recent sales ──
        if (recentSales.isNotEmpty) ...[
          _SectionTitle('Dernières ventes'),
          const SizedBox(height: 8),
          ...recentSales.map((s) => _RecentSaleCard(sale: s)),
          const SizedBox(height: 24),
        ],
      ],
    );
  }
}

class _KpiRow extends StatelessWidget {
  final List<Widget> children;
  const _KpiRow({required this.children});

  @override
  Widget build(BuildContext context) => Row(
    children: children.map((c) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: c))).toList(),
  );
}

class _KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String? sub;

  const _KpiCard({required this.label, required this.value, required this.icon, required this.color, this.sub});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 6),
              Expanded(child: Text(label, style: const TextStyle(fontSize: 12, color: kTextSecondary, fontWeight: FontWeight.w600))),
            ]),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color)),
            if (sub != null) ...[
              const SizedBox(height: 2),
              Text(sub!, style: const TextStyle(fontSize: 11, color: kTextSecondary)),
            ],
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) => Text(text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: kTextPrimary));
}

class _SparkChart extends StatelessWidget {
  final List<Map<String, dynamic>> points;
  const _SparkChart({required this.points});

  @override
  Widget build(BuildContext context) {
    final maxVal = points.map((p) => (p['total'] as int? ?? 0).toDouble()).fold(0.0, (a, b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
        child: SizedBox(
          height: 140,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: maxVal > 0 ? maxVal / 4 : 1,
                getDrawingHorizontalLine: (_) => FlLine(color: Colors.grey.shade200, strokeWidth: 1),
              ),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      final i = value.toInt();
                      if (i < 0 || i >= points.length) return const SizedBox.shrink();
                      final date = points[i]['date'] as String? ?? '';
                      final day = date.length >= 10 ? date.substring(8) : '';
                      return Text(day, style: const TextStyle(fontSize: 10, color: kTextSecondary));
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: points.asMap().entries.map((e) => FlSpot(e.key.toDouble(), (e.value['total'] as int? ?? 0).toDouble())).toList(),
                  isCurved: true,
                  color: kPrimary,
                  barWidth: 2.5,
                  belowBarData: BarAreaData(show: true, color: kPrimary.withValues(alpha: 0.08)),
                  dotData: const FlDotData(show: false),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PaymentMethodBreakdown extends StatelessWidget {
  final Map<String, dynamic> byMethod;
  const _PaymentMethodBreakdown({required this.byMethod});

  @override
  Widget build(BuildContext context) {
    final total = byMethod.values.fold<int>(0, (s, v) => s + (v as int? ?? 0));
    if (total == 0) return const SizedBox.shrink();

    final sections = byMethod.entries.where((e) => (e.value as int? ?? 0) > 0).map((e) {
      final pct = (e.value as int) / total;
      return MapEntry(e.key, pct);
    }).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            SizedBox(
              width: 110,
              height: 110,
              child: PieChart(PieChartData(
                sections: sections.map((s) => PieChartSectionData(
                  value: s.value,
                  color: paymentMethodColor(s.key),
                  radius: 38,
                  showTitle: false,
                )).toList(),
                centerSpaceRadius: 26,
                sectionsSpace: 2,
              )),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: byMethod.entries.where((e) => (e.value as int? ?? 0) > 0).map((e) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(children: [
                      Container(width: 10, height: 10, decoration: BoxDecoration(color: paymentMethodColor(e.key), borderRadius: BorderRadius.circular(2))),
                      const SizedBox(width: 8),
                      Expanded(child: Text(paymentMethodLabel(e.key), style: const TextStyle(fontSize: 13))),
                      Text(formatFcfa(e.value as int? ?? 0), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                    ]),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmployeeChart extends StatelessWidget {
  final List<Map<String, dynamic>> employees;
  const _EmployeeChart({required this.employees});

  @override
  Widget build(BuildContext context) {
    final top = employees.take(6).toList();
    final maxAmount = top.isEmpty ? 1.0 : top.map((e) => (e['totalAmount'] as int? ?? 0).toDouble()).reduce((a, b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: top.map((e) {
            final amount = (e['totalAmount'] as int? ?? 0).toDouble();
            final pct = maxAmount > 0 ? amount / maxAmount : 0.0;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(children: [
                SizedBox(
                  width: 110,
                  child: Text(
                    e['name'] as String? ?? '',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: pct,
                          minHeight: 10,
                          backgroundColor: Colors.grey.shade200,
                          color: kPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text('${e['saleCount'] ?? 0} vente(s)', style: const TextStyle(fontSize: 10, color: kTextSecondary)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 80,
                  child: Text(
                    formatFcfaCompact(e['totalAmount'] as int? ?? 0),
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: kPrimary),
                  ),
                ),
              ]),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _RecentSaleCard extends StatelessWidget {
  final Map<String, dynamic> sale;
  const _RecentSaleCard({required this.sale});

  @override
  Widget build(BuildContext context) {
    final payments = (sale['payments'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final methodColor = payments.isNotEmpty ? paymentMethodColor(payments.first['method'] as String? ?? '') : kTextSecondary;

    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(children: [
          Container(width: 4, height: 40, decoration: BoxDecoration(color: methodColor, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text(sale['number'] as String? ?? '', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: kPrimary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                    child: Text(sale['seller'] as String? ?? '', style: TextStyle(fontSize: 11, color: kPrimary, fontWeight: FontWeight.w600)),
                  ),
                ]),
                const SizedBox(height: 2),
                Text(
                  sale['customer'] != null ? 'Client: ${sale['customer']}' : 'Client anonyme',
                  style: const TextStyle(fontSize: 12, color: kTextSecondary),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(formatFcfa(sale['totalAmount'] as int? ?? 0), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: kPrimary)),
              Text(
                _formatTime(sale['createdAt'] as String?),
                style: const TextStyle(fontSize: 11, color: kTextSecondary),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  String _formatTime(String? iso) {
    if (iso == null) return '';
    try {
      final dt = DateTime.parse(iso).toLocal();
      return DateFormat('HH:mm').format(dt);
    } catch (_) {
      return '';
    }
  }
}

// ── Stock alerts list ─────────────────────────────────────────────────────────

class _StockAlertsList extends StatelessWidget {
  final List<Map<String, dynamic>> alerts;
  const _StockAlertsList({required this.alerts});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: alerts.asMap().entries.map((e) {
          final i = e.key;
          final a = e.value;
          final qty = a['qty'] as int? ?? 0;
          final minLevel = a['minLevel'] as int? ?? 0;
          final isNegative = qty < 0;
          final color = isNegative ? kDanger : kWarning;

          return Column(
            children: [
              if (i > 0) const Divider(height: 1),
              ListTile(
                dense: true,
                leading: CircleAvatar(
                  radius: 16,
                  backgroundColor: color.withValues(alpha: 0.1),
                  child: Icon(
                    isNegative ? Icons.remove_circle_outline : Icons.warning_amber,
                    color: color,
                    size: 16,
                  ),
                ),
                title: Text(
                  a['name'] as String? ?? '',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
                subtitle: Text(
                  minLevel > 0 ? 'Min: $minLevel' : 'Sans seuil min',
                  style: const TextStyle(fontSize: 11),
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    qty.toString(),
                    style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w900,
                        fontSize: 14),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// ── Top products list ─────────────────────────────────────────────────────────

class _TopProductsList extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  const _TopProductsList({required this.products});

  @override
  Widget build(BuildContext context) {
    final maxRevenue = products.isEmpty
        ? 1.0
        : products
            .map((p) => (p['totalRevenue'] as int? ?? 0).toDouble())
            .reduce((a, b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: products.asMap().entries.map((e) {
            final i = e.key;
            final p = e.value;
            final revenue = (p['totalRevenue'] as int? ?? 0).toDouble();
            final pct = maxRevenue > 0 ? revenue / maxRevenue : 0.0;
            final qty = p['totalQty'] as int? ?? 0;

            final barColor = i == 0
                ? kPrimary
                : i == 1
                    ? kPrimaryLight
                    : kPrimary.withValues(alpha: 0.5);

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(children: [
                SizedBox(
                  width: 26,
                  child: Text(
                    '${i + 1}',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: i == 0 ? kPrimary : kTextSecondary),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p['name'] as String? ?? '',
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w700),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: pct,
                          minHeight: 6,
                          backgroundColor: Colors.grey.shade100,
                          color: barColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formatFcfaCompact(revenue.toInt()),
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: kPrimary),
                    ),
                    Text(
                      '$qty vendus',
                      style: const TextStyle(
                          fontSize: 10, color: kTextSecondary),
                    ),
                  ],
                ),
              ]),
            );
          }).toList(),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.wifi_off, size: 48, color: kTextSecondary),
        const SizedBox(height: 12),
        const Text('Impossible de charger les données', style: TextStyle(fontSize: 15, color: kTextSecondary)),
        const SizedBox(height: 8),
        TextButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh), label: const Text('Réessayer')),
      ],
    );
  }
}
