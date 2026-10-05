import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart' as drift;
import '../database/app_database.dart';
import 'api_client.dart';
import '../../core/constants/api.dart';

enum SyncStatus { idle, syncing, ok, waiting, error }

class SyncService {
  final AppDatabase _db;
  final ApiClient _api;

  final _statusController = StreamController<SyncStatus>.broadcast();
  Stream<SyncStatus> get status => _statusController.stream;
  SyncStatus _current = SyncStatus.idle;
  SyncStatus get currentStatus => _current;

  Timer? _debounce;
  Timer? _periodic;
  bool _syncing = false;

  SyncService(this._db, this._api) {
    // Listen for connectivity changes
    Connectivity().onConnectivityChanged.listen((result) {
      if (result.isNotEmpty && result.first != ConnectivityResult.none) {
        _scheduleSync(delay: const Duration(seconds: 2));
      } else {
        _emit(SyncStatus.waiting);
      }
    });

    // Periodic sync every 2 minutes
    _periodic = Timer.periodic(const Duration(minutes: 2), (_) => _scheduleSync());
  }

  void triggerSync() => _scheduleSync(delay: Duration.zero);

  void onDataChanged() => _scheduleSync(delay: const Duration(seconds: 5));

  void _scheduleSync({Duration delay = const Duration(seconds: 5)}) {
    _debounce?.cancel();
    _debounce = Timer(delay, _doSync);
  }

  Future<void> _doSync() async {
    if (_syncing) return;
    _syncing = true;
    _emit(SyncStatus.syncing);

    try {
      final online = await _api.isOnline();
      if (!online) { _emit(SyncStatus.waiting); return; }

      await _push();
      await _pull();
      _emit(SyncStatus.ok);
    } catch (e) {
      _emit(SyncStatus.error);
    } finally {
      _syncing = false;
    }
  }

  Future<void> _push() async {
    final state = await _db.getSyncState();
    if (state == null) return;

    final rows = await _db.getPendingOutbox(limit: 500);
    if (rows.isEmpty) return;

    final payload = rows.map((r) {
      final data = jsonDecode(r.data) as Map<String, dynamic>;
      return data;
    }).toList();

    final res = await _api.post(Api.syncPush, data: {'rows': payload});
    final body = res.data as Map<String, dynamic>;

    final accepted = (body['accepted'] as List).cast<String>();
    final rejected = (body['rejected'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    await _db.deleteAcceptedOutbox(accepted);
    for (final r in rejected) {
      await _db.markOutboxRejected(r['id'] as String, r['reason'] as String? ?? 'ERROR');
    }

    // Save server time offset
    if (body['serverTime'] != null) {
      final serverTime = DateTime.parse(body['serverTime'] as String);
      final offsetMs = serverTime.difference(DateTime.now()).inMilliseconds;
      await _db.upsertSyncState(SyncStateCompanion(
        id: drift.Value(state.id),
        deviceId: drift.Value(state.deviceId),
        businessId: drift.Value(state.businessId),
        depotId: drift.Value(state.depotId),
        accessToken: drift.Value(state.accessToken),
        refreshToken: drift.Value(state.refreshToken),
        syncCursor: drift.Value(state.syncCursor),
        clockOffsetMs: drift.Value(offsetMs),
      ));
    }
  }

  Future<void> _pull() async {
    final state = await _db.getSyncState();
    if (state == null) return;

    int cursor = state.syncCursor;

    while (true) {
      final res = await _api.get(Api.syncPull, params: {'since': cursor, 'limit': 1000});
      final body = res.data as Map<String, dynamic>;
      final rows = (body['rows'] as List).cast<Map<String, dynamic>>();

      for (final row in rows) {
        await _applyRow(row, state.businessId);
      }

      final newCursor = int.tryParse(body['cursor']?.toString() ?? '0') ?? cursor;
      if (newCursor > cursor) {
        cursor = newCursor;
        await _db.upsertSyncState(SyncStateCompanion(
          id: drift.Value(state.id),
          deviceId: drift.Value(state.deviceId),
          businessId: drift.Value(state.businessId),
          depotId: drift.Value(state.depotId),
          accessToken: drift.Value(state.accessToken),
          refreshToken: drift.Value(state.refreshToken),
          syncCursor: drift.Value(cursor),
          clockOffsetMs: drift.Value(state.clockOffsetMs),
          lastSyncAt: drift.Value(DateTime.now()),
        ));
      }

      if (body['hasMore'] != true) break;
    }
  }

  Future<void> _applyRow(Map<String, dynamic> row, String businessId) async {
    final table = row['_table'] as String?;
    if (table == null) return;

    try {
      switch (table) {
        case 'products':
          await _db.into(_db.localProducts).insertOnConflictUpdate(LocalProductsCompanion(
            id: drift.Value(row['id'] as String),
            businessId: drift.Value(row['businessId'] as String? ?? businessId),
            categoryId: drift.Value(row['categoryId'] as String?),
            name: drift.Value(row['name'] as String? ?? ''),
            brand: drift.Value(row['brand'] as String?),
            photoUrl: drift.Value(row['photoUrl'] as String?),
            barcode: drift.Value(row['barcode'] as String?),
            internalCode: drift.Value(row['internalCode'] as String?),
            createdBy: drift.Value(row['createdBy'] as String?),
            archived: drift.Value(row['archived'] as bool? ?? false),
            deleted: drift.Value(row['deleted'] as bool? ?? false),
            serverSeq: drift.Value(row['serverSeq'] as int? ?? 0),
          ));
          break;
        case 'product_units':
          await _db.into(_db.localProductUnits).insertOnConflictUpdate(LocalProductUnitsCompanion(
            id: drift.Value(row['id'] as String),
            businessId: drift.Value(row['businessId'] as String? ?? businessId),
            productId: drift.Value(row['productId'] as String? ?? ''),
            name: drift.Value(row['name'] as String? ?? ''),
            isBase: drift.Value(row['isBase'] as bool? ?? false),
            factor: drift.Value(row['factor'] as int? ?? 1),
            purchasePrice: drift.Value(row['purchasePrice'] as int? ?? 0),
            retailPrice: drift.Value(row['retailPrice'] as int? ?? 0),
            wholesalePrice: drift.Value(row['wholesalePrice'] as int? ?? 0),
            wholesaleMinQty: drift.Value(row['wholesaleMinQty'] as int? ?? 1),
            deleted: drift.Value(row['deleted'] as bool? ?? false),
            serverSeq: drift.Value(row['serverSeq'] as int? ?? 0),
          ));
          break;
        case 'product_stock_levels':
          await _db.into(_db.localProductStockLevels).insertOnConflictUpdate(LocalProductStockLevelsCompanion(
            id: drift.Value(row['id'] as String),
            businessId: drift.Value(row['businessId'] as String? ?? businessId),
            productId: drift.Value(row['productId'] as String? ?? ''),
            depotId: drift.Value(row['depotId'] as String? ?? ''),
            minLevel: drift.Value(row['minLevel'] as int? ?? 0),
            cachedQty: drift.Value(row['cachedQty'] as int? ?? 0),
            serverSeq: drift.Value(row['serverSeq'] as int? ?? 0),
          ));
          break;
        case 'customers':
          await _db.into(_db.localCustomers).insertOnConflictUpdate(LocalCustomersCompanion(
            id: drift.Value(row['id'] as String),
            businessId: drift.Value(row['businessId'] as String? ?? businessId),
            name: drift.Value(row['name'] as String? ?? ''),
            phone: drift.Value(row['phone'] as String?),
            type: drift.Value(row['type'] as String? ?? 'INDIVIDUAL'),
            address: drift.Value(row['address'] as String?),
            creditLimit: drift.Value(row['creditLimit'] as int?),
            deleted: drift.Value(row['deleted'] as bool? ?? false),
            serverSeq: drift.Value(row['serverSeq'] as int? ?? 0),
          ));
          break;
        case 'sales':
          await _db.into(_db.localSales).insertOnConflictUpdate(LocalSalesCompanion(
            id: drift.Value(row['id'] as String),
            businessId: drift.Value(row['businessId'] as String? ?? businessId),
            depotId: drift.Value(row['depotId'] as String? ?? ''),
            customerId: drift.Value(row['customerId'] as String?),
            userId: drift.Value(row['userId'] as String? ?? ''),
            deviceId: drift.Value(row['deviceId'] as String? ?? ''),
            number: drift.Value(row['number'] as String? ?? ''),
            status: drift.Value(row['status'] as String? ?? 'ACTIVE'),
            totalAmount: drift.Value(row['totalAmount'] as int? ?? 0),
            discountAmount: drift.Value(row['discountAmount'] as int? ?? 0),
            deleted: drift.Value(row['deleted'] as bool? ?? false),
            serverSeq: drift.Value(row['serverSeq'] as int? ?? 0),
          ));
          break;
        case 'users':
          await _db.into(_db.localUsers).insertOnConflictUpdate(LocalUsersCompanion(
            id: drift.Value(row['id'] as String),
            businessId: drift.Value(row['businessId'] as String? ?? businessId),
            depotId: drift.Value(row['depotId'] as String?),
            name: drift.Value(row['name'] as String? ?? ''),
            phone: drift.Value(row['phone'] as String?),
            role: drift.Value(row['role'] as String? ?? 'CASHIER'),
            photoUrl: drift.Value(row['photoUrl'] as String?),
            active: drift.Value(row['active'] as bool? ?? true),
            deleted: drift.Value(row['deleted'] as bool? ?? false),
            serverSeq: drift.Value(row['serverSeq'] as int? ?? 0),
          ));
          break;
        case 'categories':
          await _db.into(_db.localCategories).insertOnConflictUpdate(LocalCategoriesCompanion(
            id: drift.Value(row['id'] as String),
            businessId: drift.Value(row['businessId'] as String? ?? businessId),
            name: drift.Value(row['name'] as String? ?? ''),
            deleted: drift.Value(row['deleted'] as bool? ?? false),
            serverSeq: drift.Value(row['serverSeq'] as int? ?? 0),
          ));
          break;
        case 'depots':
          await _db.into(_db.localDepots).insertOnConflictUpdate(LocalDepotsCompanion(
            id: drift.Value(row['id'] as String),
            businessId: drift.Value(row['businessId'] as String? ?? businessId),
            name: drift.Value(row['name'] as String? ?? ''),
            address: drift.Value(row['address'] as String?),
            phone: drift.Value(row['phone'] as String?),
            isDefault: drift.Value(row['isDefault'] as bool? ?? false),
            deleted: drift.Value(row['deleted'] as bool? ?? false),
            serverSeq: drift.Value(row['serverSeq'] as int? ?? 0),
          ));
          break;
        default:
          break; // Skip unknown tables gracefully
      }
    } catch (_) {
      // Don't crash sync on a single row failure
    }
  }

  void _emit(SyncStatus s) {
    _current = s;
    _statusController.add(s);
  }

  void dispose() {
    _debounce?.cancel();
    _periodic?.cancel();
    _statusController.close();
  }
}
