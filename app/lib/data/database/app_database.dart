import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

// ── Sync outbox ───────────────────────────────────────────────────────────────

class SyncOutbox extends Table {
  TextColumn get id => text()();
  TextColumn get tableRef => text()();
  TextColumn get data => text()(); // JSON
  BoolColumn get rejected => boolean().withDefault(const Constant(false))();
  TextColumn get rejectReason => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class SyncState extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get deviceId => text()();
  TextColumn get businessId => text()();
  TextColumn get depotId => text()();
  TextColumn get accessToken => text()();
  TextColumn get refreshToken => text()();
  IntColumn get syncCursor => integer().withDefault(const Constant(0))();
  IntColumn get clockOffsetMs => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastSyncAt => dateTime().nullable()();
}

// ── Master data ───────────────────────────────────────────────────────────────

class LocalBusinesses extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get logoUrl => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get nif => text().nullable()();
  TextColumn get rccm => text().nullable()();
  BoolColumn get taxEnabled => boolean().withDefault(const Constant(false))();
  IntColumn get taxRate => integer().withDefault(const Constant(18))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalDepots extends Table {
  TextColumn get id => text()();
  TextColumn get businessId => text()();
  TextColumn get name => text()();
  TextColumn get address => text().nullable()();
  TextColumn get phone => text().nullable()();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get serverSeq => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalUsers extends Table {
  TextColumn get id => text()();
  TextColumn get businessId => text()();
  TextColumn get depotId => text().nullable()();
  TextColumn get name => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get role => text()();
  TextColumn get photoUrl => text().nullable()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get serverSeq => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalCategories extends Table {
  TextColumn get id => text()();
  TextColumn get businessId => text()();
  TextColumn get name => text()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get serverSeq => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalProducts extends Table {
  TextColumn get id => text()();
  TextColumn get businessId => text()();
  TextColumn get categoryId => text().nullable()();
  TextColumn get name => text()();
  TextColumn get brand => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get photoUrl => text().nullable()();
  TextColumn get barcode => text().nullable()();
  TextColumn get internalCode => text().nullable()();
  TextColumn get createdBy => text().nullable()();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get serverSeq => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalProductUnits extends Table {
  TextColumn get id => text()();
  TextColumn get businessId => text()();
  TextColumn get productId => text()();
  TextColumn get name => text()();
  BoolColumn get isBase => boolean().withDefault(const Constant(false))();
  IntColumn get factor => integer().withDefault(const Constant(1))();
  IntColumn get purchasePrice => integer().withDefault(const Constant(0))();
  IntColumn get retailPrice => integer().withDefault(const Constant(0))();
  IntColumn get wholesalePrice => integer().withDefault(const Constant(0))();
  IntColumn get wholesaleMinQty => integer().withDefault(const Constant(1))();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get serverSeq => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalProductStockLevels extends Table {
  TextColumn get id => text()();
  TextColumn get businessId => text()();
  TextColumn get productId => text()();
  TextColumn get depotId => text()();
  IntColumn get minLevel => integer().withDefault(const Constant(0))();
  IntColumn get cachedQty => integer().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get serverSeq => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalCustomers extends Table {
  TextColumn get id => text()();
  TextColumn get businessId => text()();
  TextColumn get name => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get type => text().withDefault(const Constant('INDIVIDUAL'))();
  TextColumn get address => text().nullable()();
  TextColumn get notes => text().nullable()();
  IntColumn get creditLimit => integer().nullable()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get serverSeq => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

// ── Transactions (append-only) ────────────────────────────────────────────────

class LocalSales extends Table {
  TextColumn get id => text()();
  TextColumn get businessId => text()();
  TextColumn get depotId => text()();
  TextColumn get customerId => text().nullable()();
  TextColumn get userId => text()();
  TextColumn get deviceId => text()();
  TextColumn get number => text()();
  TextColumn get status => text().withDefault(const Constant('ACTIVE'))();
  IntColumn get totalAmount => integer().withDefault(const Constant(0))();
  IntColumn get discountAmount => integer().withDefault(const Constant(0))();
  TextColumn get notes => text().nullable()();
  TextColumn get cancelReason => text().nullable()();
  TextColumn get cancelledBy => text().nullable()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get serverSeq => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalSaleLines extends Table {
  TextColumn get id => text()();
  TextColumn get businessId => text()();
  TextColumn get saleId => text()();
  TextColumn get productId => text()();
  TextColumn get unitId => text()();
  IntColumn get qty => integer()();
  IntColumn get unitPrice => integer()();
  IntColumn get discount => integer().withDefault(const Constant(0))();
  IntColumn get lineTotal => integer()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get serverSeq => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalSalePayments extends Table {
  TextColumn get id => text()();
  TextColumn get businessId => text()();
  TextColumn get depotId => text()();
  TextColumn get saleId => text()();
  TextColumn get deviceId => text()();
  TextColumn get method => text()();
  IntColumn get amount => integer()();
  TextColumn get reference => text().nullable()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get serverSeq => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalStockMovements extends Table {
  TextColumn get id => text()();
  TextColumn get businessId => text()();
  TextColumn get depotId => text()();
  TextColumn get productId => text()();
  TextColumn get userId => text()();
  TextColumn get deviceId => text()();
  TextColumn get type => text()();
  IntColumn get qtyInBase => integer()();
  TextColumn get reason => text().nullable()();
  TextColumn get refDocId => text().nullable()();
  TextColumn get refDocType => text().nullable()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get serverSeq => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalCustomerPayments extends Table {
  TextColumn get id => text()();
  TextColumn get businessId => text()();
  TextColumn get depotId => text()();
  TextColumn get customerId => text()();
  TextColumn get userId => text()();
  TextColumn get deviceId => text()();
  IntColumn get amount => integer()();
  TextColumn get method => text()();
  TextColumn get reference => text().nullable()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get serverSeq => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

// ── Database ──────────────────────────────────────────────────────────────────

@DriftDatabase(tables: [
  SyncOutbox,
  SyncState,
  LocalBusinesses,
  LocalDepots,
  LocalUsers,
  LocalCategories,
  LocalProducts,
  LocalProductUnits,
  LocalProductStockLevels,
  LocalCustomers,
  LocalSales,
  LocalSaleLines,
  LocalSalePayments,
  LocalStockMovements,
  LocalCustomerPayments,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'envventory_db');
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  Future<LocalSale?> getSaleById(String id) =>
      (select(localSales)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<LocalProduct>> getProductsForBusiness(String businessId) =>
      (select(localProducts)
        ..where((t) => t.businessId.equals(businessId) & t.archived.equals(false) & t.deleted.equals(false))
        ..orderBy([(t) => OrderingTerm.asc(t.name)]))
          .get();

  Future<List<LocalProductUnit>> getUnitsForProduct(String productId) =>
      (select(localProductUnits)
        ..where((t) => t.productId.equals(productId) & t.deleted.equals(false)))
          .get();

  Future<LocalProductStockLevel?> getStockLevel(String productId, String depotId) =>
      (select(localProductStockLevels)
        ..where((t) => t.productId.equals(productId) & t.depotId.equals(depotId)))
          .getSingleOrNull();

  Future<List<LocalSale>> getSalesForDepot(String depotId, {int limit = 50}) =>
      (select(localSales)
        ..where((t) => t.depotId.equals(depotId) & t.deleted.equals(false))
        ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
        ..limit(limit))
          .get();

  Future<List<LocalCustomer>> getCustomers(String businessId) =>
      (select(localCustomers)
        ..where((t) => t.businessId.equals(businessId) & t.deleted.equals(false))
        ..orderBy([(t) => OrderingTerm.asc(t.name)]))
          .get();

  Future<List<SyncOutboxData>> getPendingOutbox({int limit = 500}) =>
      (select(syncOutbox)
        ..where((t) => t.rejected.equals(false))
        ..limit(limit))
          .get();

  Future<void> markOutboxRejected(String id, String reason) =>
      (update(syncOutbox)..where((t) => t.id.equals(id)))
          .write(SyncOutboxCompanion(rejected: const Value(true), rejectReason: Value(reason)));

  Future<void> deleteAcceptedOutbox(List<String> ids) =>
      (delete(syncOutbox)..where((t) => t.id.isIn(ids))).go();

  Future<SyncStateData?> getSyncState() =>
      (select(syncState)).getSingleOrNull();

  Future<void> upsertSyncState(SyncStateCompanion state) =>
      into(syncState).insertOnConflictUpdate(state);
}
