// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SyncOutboxTable extends SyncOutbox
    with TableInfo<$SyncOutboxTable, SyncOutboxData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncOutboxTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tableRefMeta =
      const VerificationMeta('tableRef');
  @override
  late final GeneratedColumn<String> tableRef = GeneratedColumn<String>(
      'table_ref', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
      'data', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _rejectedMeta =
      const VerificationMeta('rejected');
  @override
  late final GeneratedColumn<bool> rejected = GeneratedColumn<bool>(
      'rejected', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("rejected" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _rejectReasonMeta =
      const VerificationMeta('rejectReason');
  @override
  late final GeneratedColumn<String> rejectReason = GeneratedColumn<String>(
      'reject_reason', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, tableRef, data, rejected, rejectReason, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_outbox';
  @override
  VerificationContext validateIntegrity(Insertable<SyncOutboxData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('table_ref')) {
      context.handle(_tableRefMeta,
          tableRef.isAcceptableOrUnknown(data['table_ref']!, _tableRefMeta));
    } else if (isInserting) {
      context.missing(_tableRefMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
          _dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    if (data.containsKey('rejected')) {
      context.handle(_rejectedMeta,
          rejected.isAcceptableOrUnknown(data['rejected']!, _rejectedMeta));
    }
    if (data.containsKey('reject_reason')) {
      context.handle(
          _rejectReasonMeta,
          rejectReason.isAcceptableOrUnknown(
              data['reject_reason']!, _rejectReasonMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncOutboxData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncOutboxData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      tableRef: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}table_ref'])!,
      data: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data'])!,
      rejected: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}rejected'])!,
      rejectReason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reject_reason']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SyncOutboxTable createAlias(String alias) {
    return $SyncOutboxTable(attachedDatabase, alias);
  }
}

class SyncOutboxData extends DataClass implements Insertable<SyncOutboxData> {
  final String id;
  final String tableRef;
  final String data;
  final bool rejected;
  final String? rejectReason;
  final DateTime createdAt;
  const SyncOutboxData(
      {required this.id,
      required this.tableRef,
      required this.data,
      required this.rejected,
      this.rejectReason,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['table_ref'] = Variable<String>(tableRef);
    map['data'] = Variable<String>(data);
    map['rejected'] = Variable<bool>(rejected);
    if (!nullToAbsent || rejectReason != null) {
      map['reject_reason'] = Variable<String>(rejectReason);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SyncOutboxCompanion toCompanion(bool nullToAbsent) {
    return SyncOutboxCompanion(
      id: Value(id),
      tableRef: Value(tableRef),
      data: Value(data),
      rejected: Value(rejected),
      rejectReason: rejectReason == null && nullToAbsent
          ? const Value.absent()
          : Value(rejectReason),
      createdAt: Value(createdAt),
    );
  }

  factory SyncOutboxData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncOutboxData(
      id: serializer.fromJson<String>(json['id']),
      tableRef: serializer.fromJson<String>(json['tableRef']),
      data: serializer.fromJson<String>(json['data']),
      rejected: serializer.fromJson<bool>(json['rejected']),
      rejectReason: serializer.fromJson<String?>(json['rejectReason']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tableRef': serializer.toJson<String>(tableRef),
      'data': serializer.toJson<String>(data),
      'rejected': serializer.toJson<bool>(rejected),
      'rejectReason': serializer.toJson<String?>(rejectReason),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SyncOutboxData copyWith(
          {String? id,
          String? tableRef,
          String? data,
          bool? rejected,
          Value<String?> rejectReason = const Value.absent(),
          DateTime? createdAt}) =>
      SyncOutboxData(
        id: id ?? this.id,
        tableRef: tableRef ?? this.tableRef,
        data: data ?? this.data,
        rejected: rejected ?? this.rejected,
        rejectReason:
            rejectReason.present ? rejectReason.value : this.rejectReason,
        createdAt: createdAt ?? this.createdAt,
      );
  SyncOutboxData copyWithCompanion(SyncOutboxCompanion data) {
    return SyncOutboxData(
      id: data.id.present ? data.id.value : this.id,
      tableRef: data.tableRef.present ? data.tableRef.value : this.tableRef,
      data: data.data.present ? data.data.value : this.data,
      rejected: data.rejected.present ? data.rejected.value : this.rejected,
      rejectReason: data.rejectReason.present
          ? data.rejectReason.value
          : this.rejectReason,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncOutboxData(')
          ..write('id: $id, ')
          ..write('tableRef: $tableRef, ')
          ..write('data: $data, ')
          ..write('rejected: $rejected, ')
          ..write('rejectReason: $rejectReason, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, tableRef, data, rejected, rejectReason, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncOutboxData &&
          other.id == this.id &&
          other.tableRef == this.tableRef &&
          other.data == this.data &&
          other.rejected == this.rejected &&
          other.rejectReason == this.rejectReason &&
          other.createdAt == this.createdAt);
}

class SyncOutboxCompanion extends UpdateCompanion<SyncOutboxData> {
  final Value<String> id;
  final Value<String> tableRef;
  final Value<String> data;
  final Value<bool> rejected;
  final Value<String?> rejectReason;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SyncOutboxCompanion({
    this.id = const Value.absent(),
    this.tableRef = const Value.absent(),
    this.data = const Value.absent(),
    this.rejected = const Value.absent(),
    this.rejectReason = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncOutboxCompanion.insert({
    required String id,
    required String tableRef,
    required String data,
    this.rejected = const Value.absent(),
    this.rejectReason = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        tableRef = Value(tableRef),
        data = Value(data);
  static Insertable<SyncOutboxData> custom({
    Expression<String>? id,
    Expression<String>? tableRef,
    Expression<String>? data,
    Expression<bool>? rejected,
    Expression<String>? rejectReason,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tableRef != null) 'table_ref': tableRef,
      if (data != null) 'data': data,
      if (rejected != null) 'rejected': rejected,
      if (rejectReason != null) 'reject_reason': rejectReason,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncOutboxCompanion copyWith(
      {Value<String>? id,
      Value<String>? tableRef,
      Value<String>? data,
      Value<bool>? rejected,
      Value<String?>? rejectReason,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return SyncOutboxCompanion(
      id: id ?? this.id,
      tableRef: tableRef ?? this.tableRef,
      data: data ?? this.data,
      rejected: rejected ?? this.rejected,
      rejectReason: rejectReason ?? this.rejectReason,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tableRef.present) {
      map['table_ref'] = Variable<String>(tableRef.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (rejected.present) {
      map['rejected'] = Variable<bool>(rejected.value);
    }
    if (rejectReason.present) {
      map['reject_reason'] = Variable<String>(rejectReason.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncOutboxCompanion(')
          ..write('id: $id, ')
          ..write('tableRef: $tableRef, ')
          ..write('data: $data, ')
          ..write('rejected: $rejected, ')
          ..write('rejectReason: $rejectReason, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncStateTable extends SyncState
    with TableInfo<$SyncStateTable, SyncStateData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncStateTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _businessIdMeta =
      const VerificationMeta('businessId');
  @override
  late final GeneratedColumn<String> businessId = GeneratedColumn<String>(
      'business_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _depotIdMeta =
      const VerificationMeta('depotId');
  @override
  late final GeneratedColumn<String> depotId = GeneratedColumn<String>(
      'depot_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _accessTokenMeta =
      const VerificationMeta('accessToken');
  @override
  late final GeneratedColumn<String> accessToken = GeneratedColumn<String>(
      'access_token', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _refreshTokenMeta =
      const VerificationMeta('refreshToken');
  @override
  late final GeneratedColumn<String> refreshToken = GeneratedColumn<String>(
      'refresh_token', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _syncCursorMeta =
      const VerificationMeta('syncCursor');
  @override
  late final GeneratedColumn<int> syncCursor = GeneratedColumn<int>(
      'sync_cursor', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _clockOffsetMsMeta =
      const VerificationMeta('clockOffsetMs');
  @override
  late final GeneratedColumn<int> clockOffsetMs = GeneratedColumn<int>(
      'clock_offset_ms', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastSyncAtMeta =
      const VerificationMeta('lastSyncAt');
  @override
  late final GeneratedColumn<DateTime> lastSyncAt = GeneratedColumn<DateTime>(
      'last_sync_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        deviceId,
        businessId,
        depotId,
        accessToken,
        refreshToken,
        syncCursor,
        clockOffsetMs,
        lastSyncAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_state';
  @override
  VerificationContext validateIntegrity(Insertable<SyncStateData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('business_id')) {
      context.handle(
          _businessIdMeta,
          businessId.isAcceptableOrUnknown(
              data['business_id']!, _businessIdMeta));
    } else if (isInserting) {
      context.missing(_businessIdMeta);
    }
    if (data.containsKey('depot_id')) {
      context.handle(_depotIdMeta,
          depotId.isAcceptableOrUnknown(data['depot_id']!, _depotIdMeta));
    } else if (isInserting) {
      context.missing(_depotIdMeta);
    }
    if (data.containsKey('access_token')) {
      context.handle(
          _accessTokenMeta,
          accessToken.isAcceptableOrUnknown(
              data['access_token']!, _accessTokenMeta));
    } else if (isInserting) {
      context.missing(_accessTokenMeta);
    }
    if (data.containsKey('refresh_token')) {
      context.handle(
          _refreshTokenMeta,
          refreshToken.isAcceptableOrUnknown(
              data['refresh_token']!, _refreshTokenMeta));
    } else if (isInserting) {
      context.missing(_refreshTokenMeta);
    }
    if (data.containsKey('sync_cursor')) {
      context.handle(
          _syncCursorMeta,
          syncCursor.isAcceptableOrUnknown(
              data['sync_cursor']!, _syncCursorMeta));
    }
    if (data.containsKey('clock_offset_ms')) {
      context.handle(
          _clockOffsetMsMeta,
          clockOffsetMs.isAcceptableOrUnknown(
              data['clock_offset_ms']!, _clockOffsetMsMeta));
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
          _lastSyncAtMeta,
          lastSyncAt.isAcceptableOrUnknown(
              data['last_sync_at']!, _lastSyncAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncStateData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncStateData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id'])!,
      businessId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}business_id'])!,
      depotId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}depot_id'])!,
      accessToken: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}access_token'])!,
      refreshToken: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}refresh_token'])!,
      syncCursor: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sync_cursor'])!,
      clockOffsetMs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}clock_offset_ms'])!,
      lastSyncAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_sync_at']),
    );
  }

  @override
  $SyncStateTable createAlias(String alias) {
    return $SyncStateTable(attachedDatabase, alias);
  }
}

class SyncStateData extends DataClass implements Insertable<SyncStateData> {
  final int id;
  final String deviceId;
  final String businessId;
  final String depotId;
  final String accessToken;
  final String refreshToken;
  final int syncCursor;
  final int clockOffsetMs;
  final DateTime? lastSyncAt;
  const SyncStateData(
      {required this.id,
      required this.deviceId,
      required this.businessId,
      required this.depotId,
      required this.accessToken,
      required this.refreshToken,
      required this.syncCursor,
      required this.clockOffsetMs,
      this.lastSyncAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['device_id'] = Variable<String>(deviceId);
    map['business_id'] = Variable<String>(businessId);
    map['depot_id'] = Variable<String>(depotId);
    map['access_token'] = Variable<String>(accessToken);
    map['refresh_token'] = Variable<String>(refreshToken);
    map['sync_cursor'] = Variable<int>(syncCursor);
    map['clock_offset_ms'] = Variable<int>(clockOffsetMs);
    if (!nullToAbsent || lastSyncAt != null) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt);
    }
    return map;
  }

  SyncStateCompanion toCompanion(bool nullToAbsent) {
    return SyncStateCompanion(
      id: Value(id),
      deviceId: Value(deviceId),
      businessId: Value(businessId),
      depotId: Value(depotId),
      accessToken: Value(accessToken),
      refreshToken: Value(refreshToken),
      syncCursor: Value(syncCursor),
      clockOffsetMs: Value(clockOffsetMs),
      lastSyncAt: lastSyncAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncAt),
    );
  }

  factory SyncStateData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncStateData(
      id: serializer.fromJson<int>(json['id']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      businessId: serializer.fromJson<String>(json['businessId']),
      depotId: serializer.fromJson<String>(json['depotId']),
      accessToken: serializer.fromJson<String>(json['accessToken']),
      refreshToken: serializer.fromJson<String>(json['refreshToken']),
      syncCursor: serializer.fromJson<int>(json['syncCursor']),
      clockOffsetMs: serializer.fromJson<int>(json['clockOffsetMs']),
      lastSyncAt: serializer.fromJson<DateTime?>(json['lastSyncAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'deviceId': serializer.toJson<String>(deviceId),
      'businessId': serializer.toJson<String>(businessId),
      'depotId': serializer.toJson<String>(depotId),
      'accessToken': serializer.toJson<String>(accessToken),
      'refreshToken': serializer.toJson<String>(refreshToken),
      'syncCursor': serializer.toJson<int>(syncCursor),
      'clockOffsetMs': serializer.toJson<int>(clockOffsetMs),
      'lastSyncAt': serializer.toJson<DateTime?>(lastSyncAt),
    };
  }

  SyncStateData copyWith(
          {int? id,
          String? deviceId,
          String? businessId,
          String? depotId,
          String? accessToken,
          String? refreshToken,
          int? syncCursor,
          int? clockOffsetMs,
          Value<DateTime?> lastSyncAt = const Value.absent()}) =>
      SyncStateData(
        id: id ?? this.id,
        deviceId: deviceId ?? this.deviceId,
        businessId: businessId ?? this.businessId,
        depotId: depotId ?? this.depotId,
        accessToken: accessToken ?? this.accessToken,
        refreshToken: refreshToken ?? this.refreshToken,
        syncCursor: syncCursor ?? this.syncCursor,
        clockOffsetMs: clockOffsetMs ?? this.clockOffsetMs,
        lastSyncAt: lastSyncAt.present ? lastSyncAt.value : this.lastSyncAt,
      );
  SyncStateData copyWithCompanion(SyncStateCompanion data) {
    return SyncStateData(
      id: data.id.present ? data.id.value : this.id,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      businessId:
          data.businessId.present ? data.businessId.value : this.businessId,
      depotId: data.depotId.present ? data.depotId.value : this.depotId,
      accessToken:
          data.accessToken.present ? data.accessToken.value : this.accessToken,
      refreshToken: data.refreshToken.present
          ? data.refreshToken.value
          : this.refreshToken,
      syncCursor:
          data.syncCursor.present ? data.syncCursor.value : this.syncCursor,
      clockOffsetMs: data.clockOffsetMs.present
          ? data.clockOffsetMs.value
          : this.clockOffsetMs,
      lastSyncAt:
          data.lastSyncAt.present ? data.lastSyncAt.value : this.lastSyncAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncStateData(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('businessId: $businessId, ')
          ..write('depotId: $depotId, ')
          ..write('accessToken: $accessToken, ')
          ..write('refreshToken: $refreshToken, ')
          ..write('syncCursor: $syncCursor, ')
          ..write('clockOffsetMs: $clockOffsetMs, ')
          ..write('lastSyncAt: $lastSyncAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, deviceId, businessId, depotId,
      accessToken, refreshToken, syncCursor, clockOffsetMs, lastSyncAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncStateData &&
          other.id == this.id &&
          other.deviceId == this.deviceId &&
          other.businessId == this.businessId &&
          other.depotId == this.depotId &&
          other.accessToken == this.accessToken &&
          other.refreshToken == this.refreshToken &&
          other.syncCursor == this.syncCursor &&
          other.clockOffsetMs == this.clockOffsetMs &&
          other.lastSyncAt == this.lastSyncAt);
}

class SyncStateCompanion extends UpdateCompanion<SyncStateData> {
  final Value<int> id;
  final Value<String> deviceId;
  final Value<String> businessId;
  final Value<String> depotId;
  final Value<String> accessToken;
  final Value<String> refreshToken;
  final Value<int> syncCursor;
  final Value<int> clockOffsetMs;
  final Value<DateTime?> lastSyncAt;
  const SyncStateCompanion({
    this.id = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.businessId = const Value.absent(),
    this.depotId = const Value.absent(),
    this.accessToken = const Value.absent(),
    this.refreshToken = const Value.absent(),
    this.syncCursor = const Value.absent(),
    this.clockOffsetMs = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
  });
  SyncStateCompanion.insert({
    this.id = const Value.absent(),
    required String deviceId,
    required String businessId,
    required String depotId,
    required String accessToken,
    required String refreshToken,
    this.syncCursor = const Value.absent(),
    this.clockOffsetMs = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
  })  : deviceId = Value(deviceId),
        businessId = Value(businessId),
        depotId = Value(depotId),
        accessToken = Value(accessToken),
        refreshToken = Value(refreshToken);
  static Insertable<SyncStateData> custom({
    Expression<int>? id,
    Expression<String>? deviceId,
    Expression<String>? businessId,
    Expression<String>? depotId,
    Expression<String>? accessToken,
    Expression<String>? refreshToken,
    Expression<int>? syncCursor,
    Expression<int>? clockOffsetMs,
    Expression<DateTime>? lastSyncAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deviceId != null) 'device_id': deviceId,
      if (businessId != null) 'business_id': businessId,
      if (depotId != null) 'depot_id': depotId,
      if (accessToken != null) 'access_token': accessToken,
      if (refreshToken != null) 'refresh_token': refreshToken,
      if (syncCursor != null) 'sync_cursor': syncCursor,
      if (clockOffsetMs != null) 'clock_offset_ms': clockOffsetMs,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
    });
  }

  SyncStateCompanion copyWith(
      {Value<int>? id,
      Value<String>? deviceId,
      Value<String>? businessId,
      Value<String>? depotId,
      Value<String>? accessToken,
      Value<String>? refreshToken,
      Value<int>? syncCursor,
      Value<int>? clockOffsetMs,
      Value<DateTime?>? lastSyncAt}) {
    return SyncStateCompanion(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      businessId: businessId ?? this.businessId,
      depotId: depotId ?? this.depotId,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      syncCursor: syncCursor ?? this.syncCursor,
      clockOffsetMs: clockOffsetMs ?? this.clockOffsetMs,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (businessId.present) {
      map['business_id'] = Variable<String>(businessId.value);
    }
    if (depotId.present) {
      map['depot_id'] = Variable<String>(depotId.value);
    }
    if (accessToken.present) {
      map['access_token'] = Variable<String>(accessToken.value);
    }
    if (refreshToken.present) {
      map['refresh_token'] = Variable<String>(refreshToken.value);
    }
    if (syncCursor.present) {
      map['sync_cursor'] = Variable<int>(syncCursor.value);
    }
    if (clockOffsetMs.present) {
      map['clock_offset_ms'] = Variable<int>(clockOffsetMs.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncStateCompanion(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('businessId: $businessId, ')
          ..write('depotId: $depotId, ')
          ..write('accessToken: $accessToken, ')
          ..write('refreshToken: $refreshToken, ')
          ..write('syncCursor: $syncCursor, ')
          ..write('clockOffsetMs: $clockOffsetMs, ')
          ..write('lastSyncAt: $lastSyncAt')
          ..write(')'))
        .toString();
  }
}

class $LocalBusinessesTable extends LocalBusinesses
    with TableInfo<$LocalBusinessesTable, LocalBusinessesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalBusinessesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _logoUrlMeta =
      const VerificationMeta('logoUrl');
  @override
  late final GeneratedColumn<String> logoUrl = GeneratedColumn<String>(
      'logo_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nifMeta = const VerificationMeta('nif');
  @override
  late final GeneratedColumn<String> nif = GeneratedColumn<String>(
      'nif', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _rccmMeta = const VerificationMeta('rccm');
  @override
  late final GeneratedColumn<String> rccm = GeneratedColumn<String>(
      'rccm', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _taxEnabledMeta =
      const VerificationMeta('taxEnabled');
  @override
  late final GeneratedColumn<bool> taxEnabled = GeneratedColumn<bool>(
      'tax_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("tax_enabled" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _taxRateMeta =
      const VerificationMeta('taxRate');
  @override
  late final GeneratedColumn<int> taxRate = GeneratedColumn<int>(
      'tax_rate', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(18));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        logoUrl,
        address,
        phone,
        nif,
        rccm,
        taxEnabled,
        taxRate,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_businesses';
  @override
  VerificationContext validateIntegrity(
      Insertable<LocalBusinessesData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('logo_url')) {
      context.handle(_logoUrlMeta,
          logoUrl.isAcceptableOrUnknown(data['logo_url']!, _logoUrlMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('nif')) {
      context.handle(
          _nifMeta, nif.isAcceptableOrUnknown(data['nif']!, _nifMeta));
    }
    if (data.containsKey('rccm')) {
      context.handle(
          _rccmMeta, rccm.isAcceptableOrUnknown(data['rccm']!, _rccmMeta));
    }
    if (data.containsKey('tax_enabled')) {
      context.handle(
          _taxEnabledMeta,
          taxEnabled.isAcceptableOrUnknown(
              data['tax_enabled']!, _taxEnabledMeta));
    }
    if (data.containsKey('tax_rate')) {
      context.handle(_taxRateMeta,
          taxRate.isAcceptableOrUnknown(data['tax_rate']!, _taxRateMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalBusinessesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalBusinessesData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      logoUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}logo_url']),
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      nif: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nif']),
      rccm: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rccm']),
      taxEnabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}tax_enabled'])!,
      taxRate: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tax_rate'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $LocalBusinessesTable createAlias(String alias) {
    return $LocalBusinessesTable(attachedDatabase, alias);
  }
}

class LocalBusinessesData extends DataClass
    implements Insertable<LocalBusinessesData> {
  final String id;
  final String name;
  final String? logoUrl;
  final String? address;
  final String? phone;
  final String? nif;
  final String? rccm;
  final bool taxEnabled;
  final int taxRate;
  final DateTime updatedAt;
  const LocalBusinessesData(
      {required this.id,
      required this.name,
      this.logoUrl,
      this.address,
      this.phone,
      this.nif,
      this.rccm,
      required this.taxEnabled,
      required this.taxRate,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || logoUrl != null) {
      map['logo_url'] = Variable<String>(logoUrl);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || nif != null) {
      map['nif'] = Variable<String>(nif);
    }
    if (!nullToAbsent || rccm != null) {
      map['rccm'] = Variable<String>(rccm);
    }
    map['tax_enabled'] = Variable<bool>(taxEnabled);
    map['tax_rate'] = Variable<int>(taxRate);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LocalBusinessesCompanion toCompanion(bool nullToAbsent) {
    return LocalBusinessesCompanion(
      id: Value(id),
      name: Value(name),
      logoUrl: logoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(logoUrl),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      nif: nif == null && nullToAbsent ? const Value.absent() : Value(nif),
      rccm: rccm == null && nullToAbsent ? const Value.absent() : Value(rccm),
      taxEnabled: Value(taxEnabled),
      taxRate: Value(taxRate),
      updatedAt: Value(updatedAt),
    );
  }

  factory LocalBusinessesData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalBusinessesData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      logoUrl: serializer.fromJson<String?>(json['logoUrl']),
      address: serializer.fromJson<String?>(json['address']),
      phone: serializer.fromJson<String?>(json['phone']),
      nif: serializer.fromJson<String?>(json['nif']),
      rccm: serializer.fromJson<String?>(json['rccm']),
      taxEnabled: serializer.fromJson<bool>(json['taxEnabled']),
      taxRate: serializer.fromJson<int>(json['taxRate']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'logoUrl': serializer.toJson<String?>(logoUrl),
      'address': serializer.toJson<String?>(address),
      'phone': serializer.toJson<String?>(phone),
      'nif': serializer.toJson<String?>(nif),
      'rccm': serializer.toJson<String?>(rccm),
      'taxEnabled': serializer.toJson<bool>(taxEnabled),
      'taxRate': serializer.toJson<int>(taxRate),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LocalBusinessesData copyWith(
          {String? id,
          String? name,
          Value<String?> logoUrl = const Value.absent(),
          Value<String?> address = const Value.absent(),
          Value<String?> phone = const Value.absent(),
          Value<String?> nif = const Value.absent(),
          Value<String?> rccm = const Value.absent(),
          bool? taxEnabled,
          int? taxRate,
          DateTime? updatedAt}) =>
      LocalBusinessesData(
        id: id ?? this.id,
        name: name ?? this.name,
        logoUrl: logoUrl.present ? logoUrl.value : this.logoUrl,
        address: address.present ? address.value : this.address,
        phone: phone.present ? phone.value : this.phone,
        nif: nif.present ? nif.value : this.nif,
        rccm: rccm.present ? rccm.value : this.rccm,
        taxEnabled: taxEnabled ?? this.taxEnabled,
        taxRate: taxRate ?? this.taxRate,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  LocalBusinessesData copyWithCompanion(LocalBusinessesCompanion data) {
    return LocalBusinessesData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      logoUrl: data.logoUrl.present ? data.logoUrl.value : this.logoUrl,
      address: data.address.present ? data.address.value : this.address,
      phone: data.phone.present ? data.phone.value : this.phone,
      nif: data.nif.present ? data.nif.value : this.nif,
      rccm: data.rccm.present ? data.rccm.value : this.rccm,
      taxEnabled:
          data.taxEnabled.present ? data.taxEnabled.value : this.taxEnabled,
      taxRate: data.taxRate.present ? data.taxRate.value : this.taxRate,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalBusinessesData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('logoUrl: $logoUrl, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('nif: $nif, ')
          ..write('rccm: $rccm, ')
          ..write('taxEnabled: $taxEnabled, ')
          ..write('taxRate: $taxRate, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, logoUrl, address, phone, nif, rccm,
      taxEnabled, taxRate, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalBusinessesData &&
          other.id == this.id &&
          other.name == this.name &&
          other.logoUrl == this.logoUrl &&
          other.address == this.address &&
          other.phone == this.phone &&
          other.nif == this.nif &&
          other.rccm == this.rccm &&
          other.taxEnabled == this.taxEnabled &&
          other.taxRate == this.taxRate &&
          other.updatedAt == this.updatedAt);
}

class LocalBusinessesCompanion extends UpdateCompanion<LocalBusinessesData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> logoUrl;
  final Value<String?> address;
  final Value<String?> phone;
  final Value<String?> nif;
  final Value<String?> rccm;
  final Value<bool> taxEnabled;
  final Value<int> taxRate;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LocalBusinessesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.logoUrl = const Value.absent(),
    this.address = const Value.absent(),
    this.phone = const Value.absent(),
    this.nif = const Value.absent(),
    this.rccm = const Value.absent(),
    this.taxEnabled = const Value.absent(),
    this.taxRate = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalBusinessesCompanion.insert({
    required String id,
    required String name,
    this.logoUrl = const Value.absent(),
    this.address = const Value.absent(),
    this.phone = const Value.absent(),
    this.nif = const Value.absent(),
    this.rccm = const Value.absent(),
    this.taxEnabled = const Value.absent(),
    this.taxRate = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name);
  static Insertable<LocalBusinessesData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? logoUrl,
    Expression<String>? address,
    Expression<String>? phone,
    Expression<String>? nif,
    Expression<String>? rccm,
    Expression<bool>? taxEnabled,
    Expression<int>? taxRate,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (logoUrl != null) 'logo_url': logoUrl,
      if (address != null) 'address': address,
      if (phone != null) 'phone': phone,
      if (nif != null) 'nif': nif,
      if (rccm != null) 'rccm': rccm,
      if (taxEnabled != null) 'tax_enabled': taxEnabled,
      if (taxRate != null) 'tax_rate': taxRate,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalBusinessesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? logoUrl,
      Value<String?>? address,
      Value<String?>? phone,
      Value<String?>? nif,
      Value<String?>? rccm,
      Value<bool>? taxEnabled,
      Value<int>? taxRate,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return LocalBusinessesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      nif: nif ?? this.nif,
      rccm: rccm ?? this.rccm,
      taxEnabled: taxEnabled ?? this.taxEnabled,
      taxRate: taxRate ?? this.taxRate,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (logoUrl.present) {
      map['logo_url'] = Variable<String>(logoUrl.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (nif.present) {
      map['nif'] = Variable<String>(nif.value);
    }
    if (rccm.present) {
      map['rccm'] = Variable<String>(rccm.value);
    }
    if (taxEnabled.present) {
      map['tax_enabled'] = Variable<bool>(taxEnabled.value);
    }
    if (taxRate.present) {
      map['tax_rate'] = Variable<int>(taxRate.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalBusinessesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('logoUrl: $logoUrl, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('nif: $nif, ')
          ..write('rccm: $rccm, ')
          ..write('taxEnabled: $taxEnabled, ')
          ..write('taxRate: $taxRate, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalDepotsTable extends LocalDepots
    with TableInfo<$LocalDepotsTable, LocalDepot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalDepotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _businessIdMeta =
      const VerificationMeta('businessId');
  @override
  late final GeneratedColumn<String> businessId = GeneratedColumn<String>(
      'business_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isDefaultMeta =
      const VerificationMeta('isDefault');
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
      'is_default', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_default" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _deletedMeta =
      const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _serverSeqMeta =
      const VerificationMeta('serverSeq');
  @override
  late final GeneratedColumn<int> serverSeq = GeneratedColumn<int>(
      'server_seq', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        businessId,
        name,
        address,
        phone,
        isDefault,
        deleted,
        updatedAt,
        serverSeq
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_depots';
  @override
  VerificationContext validateIntegrity(Insertable<LocalDepot> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('business_id')) {
      context.handle(
          _businessIdMeta,
          businessId.isAcceptableOrUnknown(
              data['business_id']!, _businessIdMeta));
    } else if (isInserting) {
      context.missing(_businessIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('is_default')) {
      context.handle(_isDefaultMeta,
          isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('server_seq')) {
      context.handle(_serverSeqMeta,
          serverSeq.isAcceptableOrUnknown(data['server_seq']!, _serverSeqMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalDepot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalDepot(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      businessId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}business_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      isDefault: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_default'])!,
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      serverSeq: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}server_seq'])!,
    );
  }

  @override
  $LocalDepotsTable createAlias(String alias) {
    return $LocalDepotsTable(attachedDatabase, alias);
  }
}

class LocalDepot extends DataClass implements Insertable<LocalDepot> {
  final String id;
  final String businessId;
  final String name;
  final String? address;
  final String? phone;
  final bool isDefault;
  final bool deleted;
  final DateTime updatedAt;
  final int serverSeq;
  const LocalDepot(
      {required this.id,
      required this.businessId,
      required this.name,
      this.address,
      this.phone,
      required this.isDefault,
      required this.deleted,
      required this.updatedAt,
      required this.serverSeq});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['business_id'] = Variable<String>(businessId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    map['is_default'] = Variable<bool>(isDefault);
    map['deleted'] = Variable<bool>(deleted);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['server_seq'] = Variable<int>(serverSeq);
    return map;
  }

  LocalDepotsCompanion toCompanion(bool nullToAbsent) {
    return LocalDepotsCompanion(
      id: Value(id),
      businessId: Value(businessId),
      name: Value(name),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      isDefault: Value(isDefault),
      deleted: Value(deleted),
      updatedAt: Value(updatedAt),
      serverSeq: Value(serverSeq),
    );
  }

  factory LocalDepot.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalDepot(
      id: serializer.fromJson<String>(json['id']),
      businessId: serializer.fromJson<String>(json['businessId']),
      name: serializer.fromJson<String>(json['name']),
      address: serializer.fromJson<String?>(json['address']),
      phone: serializer.fromJson<String?>(json['phone']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      serverSeq: serializer.fromJson<int>(json['serverSeq']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'businessId': serializer.toJson<String>(businessId),
      'name': serializer.toJson<String>(name),
      'address': serializer.toJson<String?>(address),
      'phone': serializer.toJson<String?>(phone),
      'isDefault': serializer.toJson<bool>(isDefault),
      'deleted': serializer.toJson<bool>(deleted),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'serverSeq': serializer.toJson<int>(serverSeq),
    };
  }

  LocalDepot copyWith(
          {String? id,
          String? businessId,
          String? name,
          Value<String?> address = const Value.absent(),
          Value<String?> phone = const Value.absent(),
          bool? isDefault,
          bool? deleted,
          DateTime? updatedAt,
          int? serverSeq}) =>
      LocalDepot(
        id: id ?? this.id,
        businessId: businessId ?? this.businessId,
        name: name ?? this.name,
        address: address.present ? address.value : this.address,
        phone: phone.present ? phone.value : this.phone,
        isDefault: isDefault ?? this.isDefault,
        deleted: deleted ?? this.deleted,
        updatedAt: updatedAt ?? this.updatedAt,
        serverSeq: serverSeq ?? this.serverSeq,
      );
  LocalDepot copyWithCompanion(LocalDepotsCompanion data) {
    return LocalDepot(
      id: data.id.present ? data.id.value : this.id,
      businessId:
          data.businessId.present ? data.businessId.value : this.businessId,
      name: data.name.present ? data.name.value : this.name,
      address: data.address.present ? data.address.value : this.address,
      phone: data.phone.present ? data.phone.value : this.phone,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      serverSeq: data.serverSeq.present ? data.serverSeq.value : this.serverSeq,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalDepot(')
          ..write('id: $id, ')
          ..write('businessId: $businessId, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('isDefault: $isDefault, ')
          ..write('deleted: $deleted, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverSeq: $serverSeq')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, businessId, name, address, phone,
      isDefault, deleted, updatedAt, serverSeq);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalDepot &&
          other.id == this.id &&
          other.businessId == this.businessId &&
          other.name == this.name &&
          other.address == this.address &&
          other.phone == this.phone &&
          other.isDefault == this.isDefault &&
          other.deleted == this.deleted &&
          other.updatedAt == this.updatedAt &&
          other.serverSeq == this.serverSeq);
}

class LocalDepotsCompanion extends UpdateCompanion<LocalDepot> {
  final Value<String> id;
  final Value<String> businessId;
  final Value<String> name;
  final Value<String?> address;
  final Value<String?> phone;
  final Value<bool> isDefault;
  final Value<bool> deleted;
  final Value<DateTime> updatedAt;
  final Value<int> serverSeq;
  final Value<int> rowid;
  const LocalDepotsCompanion({
    this.id = const Value.absent(),
    this.businessId = const Value.absent(),
    this.name = const Value.absent(),
    this.address = const Value.absent(),
    this.phone = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.deleted = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverSeq = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalDepotsCompanion.insert({
    required String id,
    required String businessId,
    required String name,
    this.address = const Value.absent(),
    this.phone = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.deleted = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverSeq = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        businessId = Value(businessId),
        name = Value(name);
  static Insertable<LocalDepot> custom({
    Expression<String>? id,
    Expression<String>? businessId,
    Expression<String>? name,
    Expression<String>? address,
    Expression<String>? phone,
    Expression<bool>? isDefault,
    Expression<bool>? deleted,
    Expression<DateTime>? updatedAt,
    Expression<int>? serverSeq,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (businessId != null) 'business_id': businessId,
      if (name != null) 'name': name,
      if (address != null) 'address': address,
      if (phone != null) 'phone': phone,
      if (isDefault != null) 'is_default': isDefault,
      if (deleted != null) 'deleted': deleted,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (serverSeq != null) 'server_seq': serverSeq,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalDepotsCompanion copyWith(
      {Value<String>? id,
      Value<String>? businessId,
      Value<String>? name,
      Value<String?>? address,
      Value<String?>? phone,
      Value<bool>? isDefault,
      Value<bool>? deleted,
      Value<DateTime>? updatedAt,
      Value<int>? serverSeq,
      Value<int>? rowid}) {
    return LocalDepotsCompanion(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      isDefault: isDefault ?? this.isDefault,
      deleted: deleted ?? this.deleted,
      updatedAt: updatedAt ?? this.updatedAt,
      serverSeq: serverSeq ?? this.serverSeq,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (businessId.present) {
      map['business_id'] = Variable<String>(businessId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (serverSeq.present) {
      map['server_seq'] = Variable<int>(serverSeq.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalDepotsCompanion(')
          ..write('id: $id, ')
          ..write('businessId: $businessId, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('phone: $phone, ')
          ..write('isDefault: $isDefault, ')
          ..write('deleted: $deleted, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverSeq: $serverSeq, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalUsersTable extends LocalUsers
    with TableInfo<$LocalUsersTable, LocalUser> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalUsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _businessIdMeta =
      const VerificationMeta('businessId');
  @override
  late final GeneratedColumn<String> businessId = GeneratedColumn<String>(
      'business_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _depotIdMeta =
      const VerificationMeta('depotId');
  @override
  late final GeneratedColumn<String> depotId = GeneratedColumn<String>(
      'depot_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _photoUrlMeta =
      const VerificationMeta('photoUrl');
  @override
  late final GeneratedColumn<String> photoUrl = GeneratedColumn<String>(
      'photo_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
      'active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _deletedMeta =
      const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _serverSeqMeta =
      const VerificationMeta('serverSeq');
  @override
  late final GeneratedColumn<int> serverSeq = GeneratedColumn<int>(
      'server_seq', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        businessId,
        depotId,
        name,
        phone,
        role,
        photoUrl,
        active,
        deleted,
        updatedAt,
        serverSeq
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_users';
  @override
  VerificationContext validateIntegrity(Insertable<LocalUser> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('business_id')) {
      context.handle(
          _businessIdMeta,
          businessId.isAcceptableOrUnknown(
              data['business_id']!, _businessIdMeta));
    } else if (isInserting) {
      context.missing(_businessIdMeta);
    }
    if (data.containsKey('depot_id')) {
      context.handle(_depotIdMeta,
          depotId.isAcceptableOrUnknown(data['depot_id']!, _depotIdMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('photo_url')) {
      context.handle(_photoUrlMeta,
          photoUrl.isAcceptableOrUnknown(data['photo_url']!, _photoUrlMeta));
    }
    if (data.containsKey('active')) {
      context.handle(_activeMeta,
          active.isAcceptableOrUnknown(data['active']!, _activeMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('server_seq')) {
      context.handle(_serverSeqMeta,
          serverSeq.isAcceptableOrUnknown(data['server_seq']!, _serverSeqMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalUser map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalUser(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      businessId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}business_id'])!,
      depotId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}depot_id']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      photoUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photo_url']),
      active: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}active'])!,
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      serverSeq: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}server_seq'])!,
    );
  }

  @override
  $LocalUsersTable createAlias(String alias) {
    return $LocalUsersTable(attachedDatabase, alias);
  }
}

class LocalUser extends DataClass implements Insertable<LocalUser> {
  final String id;
  final String businessId;
  final String? depotId;
  final String name;
  final String? phone;
  final String role;
  final String? photoUrl;
  final bool active;
  final bool deleted;
  final DateTime updatedAt;
  final int serverSeq;
  const LocalUser(
      {required this.id,
      required this.businessId,
      this.depotId,
      required this.name,
      this.phone,
      required this.role,
      this.photoUrl,
      required this.active,
      required this.deleted,
      required this.updatedAt,
      required this.serverSeq});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['business_id'] = Variable<String>(businessId);
    if (!nullToAbsent || depotId != null) {
      map['depot_id'] = Variable<String>(depotId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    map['role'] = Variable<String>(role);
    if (!nullToAbsent || photoUrl != null) {
      map['photo_url'] = Variable<String>(photoUrl);
    }
    map['active'] = Variable<bool>(active);
    map['deleted'] = Variable<bool>(deleted);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['server_seq'] = Variable<int>(serverSeq);
    return map;
  }

  LocalUsersCompanion toCompanion(bool nullToAbsent) {
    return LocalUsersCompanion(
      id: Value(id),
      businessId: Value(businessId),
      depotId: depotId == null && nullToAbsent
          ? const Value.absent()
          : Value(depotId),
      name: Value(name),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      role: Value(role),
      photoUrl: photoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(photoUrl),
      active: Value(active),
      deleted: Value(deleted),
      updatedAt: Value(updatedAt),
      serverSeq: Value(serverSeq),
    );
  }

  factory LocalUser.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalUser(
      id: serializer.fromJson<String>(json['id']),
      businessId: serializer.fromJson<String>(json['businessId']),
      depotId: serializer.fromJson<String?>(json['depotId']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      role: serializer.fromJson<String>(json['role']),
      photoUrl: serializer.fromJson<String?>(json['photoUrl']),
      active: serializer.fromJson<bool>(json['active']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      serverSeq: serializer.fromJson<int>(json['serverSeq']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'businessId': serializer.toJson<String>(businessId),
      'depotId': serializer.toJson<String?>(depotId),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'role': serializer.toJson<String>(role),
      'photoUrl': serializer.toJson<String?>(photoUrl),
      'active': serializer.toJson<bool>(active),
      'deleted': serializer.toJson<bool>(deleted),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'serverSeq': serializer.toJson<int>(serverSeq),
    };
  }

  LocalUser copyWith(
          {String? id,
          String? businessId,
          Value<String?> depotId = const Value.absent(),
          String? name,
          Value<String?> phone = const Value.absent(),
          String? role,
          Value<String?> photoUrl = const Value.absent(),
          bool? active,
          bool? deleted,
          DateTime? updatedAt,
          int? serverSeq}) =>
      LocalUser(
        id: id ?? this.id,
        businessId: businessId ?? this.businessId,
        depotId: depotId.present ? depotId.value : this.depotId,
        name: name ?? this.name,
        phone: phone.present ? phone.value : this.phone,
        role: role ?? this.role,
        photoUrl: photoUrl.present ? photoUrl.value : this.photoUrl,
        active: active ?? this.active,
        deleted: deleted ?? this.deleted,
        updatedAt: updatedAt ?? this.updatedAt,
        serverSeq: serverSeq ?? this.serverSeq,
      );
  LocalUser copyWithCompanion(LocalUsersCompanion data) {
    return LocalUser(
      id: data.id.present ? data.id.value : this.id,
      businessId:
          data.businessId.present ? data.businessId.value : this.businessId,
      depotId: data.depotId.present ? data.depotId.value : this.depotId,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      role: data.role.present ? data.role.value : this.role,
      photoUrl: data.photoUrl.present ? data.photoUrl.value : this.photoUrl,
      active: data.active.present ? data.active.value : this.active,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      serverSeq: data.serverSeq.present ? data.serverSeq.value : this.serverSeq,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalUser(')
          ..write('id: $id, ')
          ..write('businessId: $businessId, ')
          ..write('depotId: $depotId, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('role: $role, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('active: $active, ')
          ..write('deleted: $deleted, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverSeq: $serverSeq')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, businessId, depotId, name, phone, role,
      photoUrl, active, deleted, updatedAt, serverSeq);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalUser &&
          other.id == this.id &&
          other.businessId == this.businessId &&
          other.depotId == this.depotId &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.role == this.role &&
          other.photoUrl == this.photoUrl &&
          other.active == this.active &&
          other.deleted == this.deleted &&
          other.updatedAt == this.updatedAt &&
          other.serverSeq == this.serverSeq);
}

class LocalUsersCompanion extends UpdateCompanion<LocalUser> {
  final Value<String> id;
  final Value<String> businessId;
  final Value<String?> depotId;
  final Value<String> name;
  final Value<String?> phone;
  final Value<String> role;
  final Value<String?> photoUrl;
  final Value<bool> active;
  final Value<bool> deleted;
  final Value<DateTime> updatedAt;
  final Value<int> serverSeq;
  final Value<int> rowid;
  const LocalUsersCompanion({
    this.id = const Value.absent(),
    this.businessId = const Value.absent(),
    this.depotId = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.role = const Value.absent(),
    this.photoUrl = const Value.absent(),
    this.active = const Value.absent(),
    this.deleted = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverSeq = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalUsersCompanion.insert({
    required String id,
    required String businessId,
    this.depotId = const Value.absent(),
    required String name,
    this.phone = const Value.absent(),
    required String role,
    this.photoUrl = const Value.absent(),
    this.active = const Value.absent(),
    this.deleted = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverSeq = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        businessId = Value(businessId),
        name = Value(name),
        role = Value(role);
  static Insertable<LocalUser> custom({
    Expression<String>? id,
    Expression<String>? businessId,
    Expression<String>? depotId,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? role,
    Expression<String>? photoUrl,
    Expression<bool>? active,
    Expression<bool>? deleted,
    Expression<DateTime>? updatedAt,
    Expression<int>? serverSeq,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (businessId != null) 'business_id': businessId,
      if (depotId != null) 'depot_id': depotId,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (role != null) 'role': role,
      if (photoUrl != null) 'photo_url': photoUrl,
      if (active != null) 'active': active,
      if (deleted != null) 'deleted': deleted,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (serverSeq != null) 'server_seq': serverSeq,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalUsersCompanion copyWith(
      {Value<String>? id,
      Value<String>? businessId,
      Value<String?>? depotId,
      Value<String>? name,
      Value<String?>? phone,
      Value<String>? role,
      Value<String?>? photoUrl,
      Value<bool>? active,
      Value<bool>? deleted,
      Value<DateTime>? updatedAt,
      Value<int>? serverSeq,
      Value<int>? rowid}) {
    return LocalUsersCompanion(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      depotId: depotId ?? this.depotId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      photoUrl: photoUrl ?? this.photoUrl,
      active: active ?? this.active,
      deleted: deleted ?? this.deleted,
      updatedAt: updatedAt ?? this.updatedAt,
      serverSeq: serverSeq ?? this.serverSeq,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (businessId.present) {
      map['business_id'] = Variable<String>(businessId.value);
    }
    if (depotId.present) {
      map['depot_id'] = Variable<String>(depotId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (photoUrl.present) {
      map['photo_url'] = Variable<String>(photoUrl.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (serverSeq.present) {
      map['server_seq'] = Variable<int>(serverSeq.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalUsersCompanion(')
          ..write('id: $id, ')
          ..write('businessId: $businessId, ')
          ..write('depotId: $depotId, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('role: $role, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('active: $active, ')
          ..write('deleted: $deleted, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverSeq: $serverSeq, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalCategoriesTable extends LocalCategories
    with TableInfo<$LocalCategoriesTable, LocalCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _businessIdMeta =
      const VerificationMeta('businessId');
  @override
  late final GeneratedColumn<String> businessId = GeneratedColumn<String>(
      'business_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _deletedMeta =
      const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _serverSeqMeta =
      const VerificationMeta('serverSeq');
  @override
  late final GeneratedColumn<int> serverSeq = GeneratedColumn<int>(
      'server_seq', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, businessId, name, deleted, updatedAt, serverSeq];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_categories';
  @override
  VerificationContext validateIntegrity(Insertable<LocalCategory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('business_id')) {
      context.handle(
          _businessIdMeta,
          businessId.isAcceptableOrUnknown(
              data['business_id']!, _businessIdMeta));
    } else if (isInserting) {
      context.missing(_businessIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('server_seq')) {
      context.handle(_serverSeqMeta,
          serverSeq.isAcceptableOrUnknown(data['server_seq']!, _serverSeqMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalCategory(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      businessId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}business_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      serverSeq: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}server_seq'])!,
    );
  }

  @override
  $LocalCategoriesTable createAlias(String alias) {
    return $LocalCategoriesTable(attachedDatabase, alias);
  }
}

class LocalCategory extends DataClass implements Insertable<LocalCategory> {
  final String id;
  final String businessId;
  final String name;
  final bool deleted;
  final DateTime updatedAt;
  final int serverSeq;
  const LocalCategory(
      {required this.id,
      required this.businessId,
      required this.name,
      required this.deleted,
      required this.updatedAt,
      required this.serverSeq});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['business_id'] = Variable<String>(businessId);
    map['name'] = Variable<String>(name);
    map['deleted'] = Variable<bool>(deleted);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['server_seq'] = Variable<int>(serverSeq);
    return map;
  }

  LocalCategoriesCompanion toCompanion(bool nullToAbsent) {
    return LocalCategoriesCompanion(
      id: Value(id),
      businessId: Value(businessId),
      name: Value(name),
      deleted: Value(deleted),
      updatedAt: Value(updatedAt),
      serverSeq: Value(serverSeq),
    );
  }

  factory LocalCategory.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalCategory(
      id: serializer.fromJson<String>(json['id']),
      businessId: serializer.fromJson<String>(json['businessId']),
      name: serializer.fromJson<String>(json['name']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      serverSeq: serializer.fromJson<int>(json['serverSeq']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'businessId': serializer.toJson<String>(businessId),
      'name': serializer.toJson<String>(name),
      'deleted': serializer.toJson<bool>(deleted),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'serverSeq': serializer.toJson<int>(serverSeq),
    };
  }

  LocalCategory copyWith(
          {String? id,
          String? businessId,
          String? name,
          bool? deleted,
          DateTime? updatedAt,
          int? serverSeq}) =>
      LocalCategory(
        id: id ?? this.id,
        businessId: businessId ?? this.businessId,
        name: name ?? this.name,
        deleted: deleted ?? this.deleted,
        updatedAt: updatedAt ?? this.updatedAt,
        serverSeq: serverSeq ?? this.serverSeq,
      );
  LocalCategory copyWithCompanion(LocalCategoriesCompanion data) {
    return LocalCategory(
      id: data.id.present ? data.id.value : this.id,
      businessId:
          data.businessId.present ? data.businessId.value : this.businessId,
      name: data.name.present ? data.name.value : this.name,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      serverSeq: data.serverSeq.present ? data.serverSeq.value : this.serverSeq,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalCategory(')
          ..write('id: $id, ')
          ..write('businessId: $businessId, ')
          ..write('name: $name, ')
          ..write('deleted: $deleted, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverSeq: $serverSeq')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, businessId, name, deleted, updatedAt, serverSeq);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalCategory &&
          other.id == this.id &&
          other.businessId == this.businessId &&
          other.name == this.name &&
          other.deleted == this.deleted &&
          other.updatedAt == this.updatedAt &&
          other.serverSeq == this.serverSeq);
}

class LocalCategoriesCompanion extends UpdateCompanion<LocalCategory> {
  final Value<String> id;
  final Value<String> businessId;
  final Value<String> name;
  final Value<bool> deleted;
  final Value<DateTime> updatedAt;
  final Value<int> serverSeq;
  final Value<int> rowid;
  const LocalCategoriesCompanion({
    this.id = const Value.absent(),
    this.businessId = const Value.absent(),
    this.name = const Value.absent(),
    this.deleted = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverSeq = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalCategoriesCompanion.insert({
    required String id,
    required String businessId,
    required String name,
    this.deleted = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverSeq = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        businessId = Value(businessId),
        name = Value(name);
  static Insertable<LocalCategory> custom({
    Expression<String>? id,
    Expression<String>? businessId,
    Expression<String>? name,
    Expression<bool>? deleted,
    Expression<DateTime>? updatedAt,
    Expression<int>? serverSeq,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (businessId != null) 'business_id': businessId,
      if (name != null) 'name': name,
      if (deleted != null) 'deleted': deleted,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (serverSeq != null) 'server_seq': serverSeq,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalCategoriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? businessId,
      Value<String>? name,
      Value<bool>? deleted,
      Value<DateTime>? updatedAt,
      Value<int>? serverSeq,
      Value<int>? rowid}) {
    return LocalCategoriesCompanion(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      name: name ?? this.name,
      deleted: deleted ?? this.deleted,
      updatedAt: updatedAt ?? this.updatedAt,
      serverSeq: serverSeq ?? this.serverSeq,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (businessId.present) {
      map['business_id'] = Variable<String>(businessId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (serverSeq.present) {
      map['server_seq'] = Variable<int>(serverSeq.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('businessId: $businessId, ')
          ..write('name: $name, ')
          ..write('deleted: $deleted, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverSeq: $serverSeq, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalProductsTable extends LocalProducts
    with TableInfo<$LocalProductsTable, LocalProduct> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _businessIdMeta =
      const VerificationMeta('businessId');
  @override
  late final GeneratedColumn<String> businessId = GeneratedColumn<String>(
      'business_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
      'category_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
      'brand', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _photoUrlMeta =
      const VerificationMeta('photoUrl');
  @override
  late final GeneratedColumn<String> photoUrl = GeneratedColumn<String>(
      'photo_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _barcodeMeta =
      const VerificationMeta('barcode');
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
      'barcode', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _internalCodeMeta =
      const VerificationMeta('internalCode');
  @override
  late final GeneratedColumn<String> internalCode = GeneratedColumn<String>(
      'internal_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdByMeta =
      const VerificationMeta('createdBy');
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
      'created_by', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _archivedMeta =
      const VerificationMeta('archived');
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
      'archived', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("archived" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _deletedMeta =
      const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _serverSeqMeta =
      const VerificationMeta('serverSeq');
  @override
  late final GeneratedColumn<int> serverSeq = GeneratedColumn<int>(
      'server_seq', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        businessId,
        categoryId,
        name,
        brand,
        description,
        photoUrl,
        barcode,
        internalCode,
        createdBy,
        archived,
        deleted,
        createdAt,
        updatedAt,
        serverSeq
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_products';
  @override
  VerificationContext validateIntegrity(Insertable<LocalProduct> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('business_id')) {
      context.handle(
          _businessIdMeta,
          businessId.isAcceptableOrUnknown(
              data['business_id']!, _businessIdMeta));
    } else if (isInserting) {
      context.missing(_businessIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
          _brandMeta, brand.isAcceptableOrUnknown(data['brand']!, _brandMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('photo_url')) {
      context.handle(_photoUrlMeta,
          photoUrl.isAcceptableOrUnknown(data['photo_url']!, _photoUrlMeta));
    }
    if (data.containsKey('barcode')) {
      context.handle(_barcodeMeta,
          barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta));
    }
    if (data.containsKey('internal_code')) {
      context.handle(
          _internalCodeMeta,
          internalCode.isAcceptableOrUnknown(
              data['internal_code']!, _internalCodeMeta));
    }
    if (data.containsKey('created_by')) {
      context.handle(_createdByMeta,
          createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta));
    }
    if (data.containsKey('archived')) {
      context.handle(_archivedMeta,
          archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('server_seq')) {
      context.handle(_serverSeqMeta,
          serverSeq.isAcceptableOrUnknown(data['server_seq']!, _serverSeqMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalProduct map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalProduct(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      businessId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}business_id'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_id']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      brand: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}brand']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      photoUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photo_url']),
      barcode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}barcode']),
      internalCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}internal_code']),
      createdBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_by']),
      archived: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}archived'])!,
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      serverSeq: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}server_seq'])!,
    );
  }

  @override
  $LocalProductsTable createAlias(String alias) {
    return $LocalProductsTable(attachedDatabase, alias);
  }
}

class LocalProduct extends DataClass implements Insertable<LocalProduct> {
  final String id;
  final String businessId;
  final String? categoryId;
  final String name;
  final String? brand;
  final String? description;
  final String? photoUrl;
  final String? barcode;
  final String? internalCode;
  final String? createdBy;
  final bool archived;
  final bool deleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int serverSeq;
  const LocalProduct(
      {required this.id,
      required this.businessId,
      this.categoryId,
      required this.name,
      this.brand,
      this.description,
      this.photoUrl,
      this.barcode,
      this.internalCode,
      this.createdBy,
      required this.archived,
      required this.deleted,
      required this.createdAt,
      required this.updatedAt,
      required this.serverSeq});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['business_id'] = Variable<String>(businessId);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || brand != null) {
      map['brand'] = Variable<String>(brand);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || photoUrl != null) {
      map['photo_url'] = Variable<String>(photoUrl);
    }
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    if (!nullToAbsent || internalCode != null) {
      map['internal_code'] = Variable<String>(internalCode);
    }
    if (!nullToAbsent || createdBy != null) {
      map['created_by'] = Variable<String>(createdBy);
    }
    map['archived'] = Variable<bool>(archived);
    map['deleted'] = Variable<bool>(deleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['server_seq'] = Variable<int>(serverSeq);
    return map;
  }

  LocalProductsCompanion toCompanion(bool nullToAbsent) {
    return LocalProductsCompanion(
      id: Value(id),
      businessId: Value(businessId),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      name: Value(name),
      brand:
          brand == null && nullToAbsent ? const Value.absent() : Value(brand),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      photoUrl: photoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(photoUrl),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      internalCode: internalCode == null && nullToAbsent
          ? const Value.absent()
          : Value(internalCode),
      createdBy: createdBy == null && nullToAbsent
          ? const Value.absent()
          : Value(createdBy),
      archived: Value(archived),
      deleted: Value(deleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      serverSeq: Value(serverSeq),
    );
  }

  factory LocalProduct.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalProduct(
      id: serializer.fromJson<String>(json['id']),
      businessId: serializer.fromJson<String>(json['businessId']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      name: serializer.fromJson<String>(json['name']),
      brand: serializer.fromJson<String?>(json['brand']),
      description: serializer.fromJson<String?>(json['description']),
      photoUrl: serializer.fromJson<String?>(json['photoUrl']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      internalCode: serializer.fromJson<String?>(json['internalCode']),
      createdBy: serializer.fromJson<String?>(json['createdBy']),
      archived: serializer.fromJson<bool>(json['archived']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      serverSeq: serializer.fromJson<int>(json['serverSeq']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'businessId': serializer.toJson<String>(businessId),
      'categoryId': serializer.toJson<String?>(categoryId),
      'name': serializer.toJson<String>(name),
      'brand': serializer.toJson<String?>(brand),
      'description': serializer.toJson<String?>(description),
      'photoUrl': serializer.toJson<String?>(photoUrl),
      'barcode': serializer.toJson<String?>(barcode),
      'internalCode': serializer.toJson<String?>(internalCode),
      'createdBy': serializer.toJson<String?>(createdBy),
      'archived': serializer.toJson<bool>(archived),
      'deleted': serializer.toJson<bool>(deleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'serverSeq': serializer.toJson<int>(serverSeq),
    };
  }

  LocalProduct copyWith(
          {String? id,
          String? businessId,
          Value<String?> categoryId = const Value.absent(),
          String? name,
          Value<String?> brand = const Value.absent(),
          Value<String?> description = const Value.absent(),
          Value<String?> photoUrl = const Value.absent(),
          Value<String?> barcode = const Value.absent(),
          Value<String?> internalCode = const Value.absent(),
          Value<String?> createdBy = const Value.absent(),
          bool? archived,
          bool? deleted,
          DateTime? createdAt,
          DateTime? updatedAt,
          int? serverSeq}) =>
      LocalProduct(
        id: id ?? this.id,
        businessId: businessId ?? this.businessId,
        categoryId: categoryId.present ? categoryId.value : this.categoryId,
        name: name ?? this.name,
        brand: brand.present ? brand.value : this.brand,
        description: description.present ? description.value : this.description,
        photoUrl: photoUrl.present ? photoUrl.value : this.photoUrl,
        barcode: barcode.present ? barcode.value : this.barcode,
        internalCode:
            internalCode.present ? internalCode.value : this.internalCode,
        createdBy: createdBy.present ? createdBy.value : this.createdBy,
        archived: archived ?? this.archived,
        deleted: deleted ?? this.deleted,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        serverSeq: serverSeq ?? this.serverSeq,
      );
  LocalProduct copyWithCompanion(LocalProductsCompanion data) {
    return LocalProduct(
      id: data.id.present ? data.id.value : this.id,
      businessId:
          data.businessId.present ? data.businessId.value : this.businessId,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      name: data.name.present ? data.name.value : this.name,
      brand: data.brand.present ? data.brand.value : this.brand,
      description:
          data.description.present ? data.description.value : this.description,
      photoUrl: data.photoUrl.present ? data.photoUrl.value : this.photoUrl,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      internalCode: data.internalCode.present
          ? data.internalCode.value
          : this.internalCode,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      archived: data.archived.present ? data.archived.value : this.archived,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      serverSeq: data.serverSeq.present ? data.serverSeq.value : this.serverSeq,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalProduct(')
          ..write('id: $id, ')
          ..write('businessId: $businessId, ')
          ..write('categoryId: $categoryId, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('description: $description, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('barcode: $barcode, ')
          ..write('internalCode: $internalCode, ')
          ..write('createdBy: $createdBy, ')
          ..write('archived: $archived, ')
          ..write('deleted: $deleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverSeq: $serverSeq')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      businessId,
      categoryId,
      name,
      brand,
      description,
      photoUrl,
      barcode,
      internalCode,
      createdBy,
      archived,
      deleted,
      createdAt,
      updatedAt,
      serverSeq);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalProduct &&
          other.id == this.id &&
          other.businessId == this.businessId &&
          other.categoryId == this.categoryId &&
          other.name == this.name &&
          other.brand == this.brand &&
          other.description == this.description &&
          other.photoUrl == this.photoUrl &&
          other.barcode == this.barcode &&
          other.internalCode == this.internalCode &&
          other.createdBy == this.createdBy &&
          other.archived == this.archived &&
          other.deleted == this.deleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.serverSeq == this.serverSeq);
}

class LocalProductsCompanion extends UpdateCompanion<LocalProduct> {
  final Value<String> id;
  final Value<String> businessId;
  final Value<String?> categoryId;
  final Value<String> name;
  final Value<String?> brand;
  final Value<String?> description;
  final Value<String?> photoUrl;
  final Value<String?> barcode;
  final Value<String?> internalCode;
  final Value<String?> createdBy;
  final Value<bool> archived;
  final Value<bool> deleted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> serverSeq;
  final Value<int> rowid;
  const LocalProductsCompanion({
    this.id = const Value.absent(),
    this.businessId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.name = const Value.absent(),
    this.brand = const Value.absent(),
    this.description = const Value.absent(),
    this.photoUrl = const Value.absent(),
    this.barcode = const Value.absent(),
    this.internalCode = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.archived = const Value.absent(),
    this.deleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverSeq = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalProductsCompanion.insert({
    required String id,
    required String businessId,
    this.categoryId = const Value.absent(),
    required String name,
    this.brand = const Value.absent(),
    this.description = const Value.absent(),
    this.photoUrl = const Value.absent(),
    this.barcode = const Value.absent(),
    this.internalCode = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.archived = const Value.absent(),
    this.deleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverSeq = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        businessId = Value(businessId),
        name = Value(name);
  static Insertable<LocalProduct> custom({
    Expression<String>? id,
    Expression<String>? businessId,
    Expression<String>? categoryId,
    Expression<String>? name,
    Expression<String>? brand,
    Expression<String>? description,
    Expression<String>? photoUrl,
    Expression<String>? barcode,
    Expression<String>? internalCode,
    Expression<String>? createdBy,
    Expression<bool>? archived,
    Expression<bool>? deleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? serverSeq,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (businessId != null) 'business_id': businessId,
      if (categoryId != null) 'category_id': categoryId,
      if (name != null) 'name': name,
      if (brand != null) 'brand': brand,
      if (description != null) 'description': description,
      if (photoUrl != null) 'photo_url': photoUrl,
      if (barcode != null) 'barcode': barcode,
      if (internalCode != null) 'internal_code': internalCode,
      if (createdBy != null) 'created_by': createdBy,
      if (archived != null) 'archived': archived,
      if (deleted != null) 'deleted': deleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (serverSeq != null) 'server_seq': serverSeq,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalProductsCompanion copyWith(
      {Value<String>? id,
      Value<String>? businessId,
      Value<String?>? categoryId,
      Value<String>? name,
      Value<String?>? brand,
      Value<String?>? description,
      Value<String?>? photoUrl,
      Value<String?>? barcode,
      Value<String?>? internalCode,
      Value<String?>? createdBy,
      Value<bool>? archived,
      Value<bool>? deleted,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? serverSeq,
      Value<int>? rowid}) {
    return LocalProductsCompanion(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      description: description ?? this.description,
      photoUrl: photoUrl ?? this.photoUrl,
      barcode: barcode ?? this.barcode,
      internalCode: internalCode ?? this.internalCode,
      createdBy: createdBy ?? this.createdBy,
      archived: archived ?? this.archived,
      deleted: deleted ?? this.deleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      serverSeq: serverSeq ?? this.serverSeq,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (businessId.present) {
      map['business_id'] = Variable<String>(businessId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (photoUrl.present) {
      map['photo_url'] = Variable<String>(photoUrl.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (internalCode.present) {
      map['internal_code'] = Variable<String>(internalCode.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (serverSeq.present) {
      map['server_seq'] = Variable<int>(serverSeq.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalProductsCompanion(')
          ..write('id: $id, ')
          ..write('businessId: $businessId, ')
          ..write('categoryId: $categoryId, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('description: $description, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('barcode: $barcode, ')
          ..write('internalCode: $internalCode, ')
          ..write('createdBy: $createdBy, ')
          ..write('archived: $archived, ')
          ..write('deleted: $deleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverSeq: $serverSeq, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalProductUnitsTable extends LocalProductUnits
    with TableInfo<$LocalProductUnitsTable, LocalProductUnit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalProductUnitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _businessIdMeta =
      const VerificationMeta('businessId');
  @override
  late final GeneratedColumn<String> businessId = GeneratedColumn<String>(
      'business_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
      'product_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isBaseMeta = const VerificationMeta('isBase');
  @override
  late final GeneratedColumn<bool> isBase = GeneratedColumn<bool>(
      'is_base', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_base" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _factorMeta = const VerificationMeta('factor');
  @override
  late final GeneratedColumn<int> factor = GeneratedColumn<int>(
      'factor', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _purchasePriceMeta =
      const VerificationMeta('purchasePrice');
  @override
  late final GeneratedColumn<int> purchasePrice = GeneratedColumn<int>(
      'purchase_price', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _retailPriceMeta =
      const VerificationMeta('retailPrice');
  @override
  late final GeneratedColumn<int> retailPrice = GeneratedColumn<int>(
      'retail_price', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _wholesalePriceMeta =
      const VerificationMeta('wholesalePrice');
  @override
  late final GeneratedColumn<int> wholesalePrice = GeneratedColumn<int>(
      'wholesale_price', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _wholesaleMinQtyMeta =
      const VerificationMeta('wholesaleMinQty');
  @override
  late final GeneratedColumn<int> wholesaleMinQty = GeneratedColumn<int>(
      'wholesale_min_qty', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _deletedMeta =
      const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _serverSeqMeta =
      const VerificationMeta('serverSeq');
  @override
  late final GeneratedColumn<int> serverSeq = GeneratedColumn<int>(
      'server_seq', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        businessId,
        productId,
        name,
        isBase,
        factor,
        purchasePrice,
        retailPrice,
        wholesalePrice,
        wholesaleMinQty,
        deleted,
        updatedAt,
        serverSeq
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_product_units';
  @override
  VerificationContext validateIntegrity(Insertable<LocalProductUnit> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('business_id')) {
      context.handle(
          _businessIdMeta,
          businessId.isAcceptableOrUnknown(
              data['business_id']!, _businessIdMeta));
    } else if (isInserting) {
      context.missing(_businessIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_base')) {
      context.handle(_isBaseMeta,
          isBase.isAcceptableOrUnknown(data['is_base']!, _isBaseMeta));
    }
    if (data.containsKey('factor')) {
      context.handle(_factorMeta,
          factor.isAcceptableOrUnknown(data['factor']!, _factorMeta));
    }
    if (data.containsKey('purchase_price')) {
      context.handle(
          _purchasePriceMeta,
          purchasePrice.isAcceptableOrUnknown(
              data['purchase_price']!, _purchasePriceMeta));
    }
    if (data.containsKey('retail_price')) {
      context.handle(
          _retailPriceMeta,
          retailPrice.isAcceptableOrUnknown(
              data['retail_price']!, _retailPriceMeta));
    }
    if (data.containsKey('wholesale_price')) {
      context.handle(
          _wholesalePriceMeta,
          wholesalePrice.isAcceptableOrUnknown(
              data['wholesale_price']!, _wholesalePriceMeta));
    }
    if (data.containsKey('wholesale_min_qty')) {
      context.handle(
          _wholesaleMinQtyMeta,
          wholesaleMinQty.isAcceptableOrUnknown(
              data['wholesale_min_qty']!, _wholesaleMinQtyMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('server_seq')) {
      context.handle(_serverSeqMeta,
          serverSeq.isAcceptableOrUnknown(data['server_seq']!, _serverSeqMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalProductUnit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalProductUnit(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      businessId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}business_id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      isBase: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_base'])!,
      factor: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}factor'])!,
      purchasePrice: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}purchase_price'])!,
      retailPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}retail_price'])!,
      wholesalePrice: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}wholesale_price'])!,
      wholesaleMinQty: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}wholesale_min_qty'])!,
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      serverSeq: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}server_seq'])!,
    );
  }

  @override
  $LocalProductUnitsTable createAlias(String alias) {
    return $LocalProductUnitsTable(attachedDatabase, alias);
  }
}

class LocalProductUnit extends DataClass
    implements Insertable<LocalProductUnit> {
  final String id;
  final String businessId;
  final String productId;
  final String name;
  final bool isBase;
  final int factor;
  final int purchasePrice;
  final int retailPrice;
  final int wholesalePrice;
  final int wholesaleMinQty;
  final bool deleted;
  final DateTime updatedAt;
  final int serverSeq;
  const LocalProductUnit(
      {required this.id,
      required this.businessId,
      required this.productId,
      required this.name,
      required this.isBase,
      required this.factor,
      required this.purchasePrice,
      required this.retailPrice,
      required this.wholesalePrice,
      required this.wholesaleMinQty,
      required this.deleted,
      required this.updatedAt,
      required this.serverSeq});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['business_id'] = Variable<String>(businessId);
    map['product_id'] = Variable<String>(productId);
    map['name'] = Variable<String>(name);
    map['is_base'] = Variable<bool>(isBase);
    map['factor'] = Variable<int>(factor);
    map['purchase_price'] = Variable<int>(purchasePrice);
    map['retail_price'] = Variable<int>(retailPrice);
    map['wholesale_price'] = Variable<int>(wholesalePrice);
    map['wholesale_min_qty'] = Variable<int>(wholesaleMinQty);
    map['deleted'] = Variable<bool>(deleted);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['server_seq'] = Variable<int>(serverSeq);
    return map;
  }

  LocalProductUnitsCompanion toCompanion(bool nullToAbsent) {
    return LocalProductUnitsCompanion(
      id: Value(id),
      businessId: Value(businessId),
      productId: Value(productId),
      name: Value(name),
      isBase: Value(isBase),
      factor: Value(factor),
      purchasePrice: Value(purchasePrice),
      retailPrice: Value(retailPrice),
      wholesalePrice: Value(wholesalePrice),
      wholesaleMinQty: Value(wholesaleMinQty),
      deleted: Value(deleted),
      updatedAt: Value(updatedAt),
      serverSeq: Value(serverSeq),
    );
  }

  factory LocalProductUnit.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalProductUnit(
      id: serializer.fromJson<String>(json['id']),
      businessId: serializer.fromJson<String>(json['businessId']),
      productId: serializer.fromJson<String>(json['productId']),
      name: serializer.fromJson<String>(json['name']),
      isBase: serializer.fromJson<bool>(json['isBase']),
      factor: serializer.fromJson<int>(json['factor']),
      purchasePrice: serializer.fromJson<int>(json['purchasePrice']),
      retailPrice: serializer.fromJson<int>(json['retailPrice']),
      wholesalePrice: serializer.fromJson<int>(json['wholesalePrice']),
      wholesaleMinQty: serializer.fromJson<int>(json['wholesaleMinQty']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      serverSeq: serializer.fromJson<int>(json['serverSeq']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'businessId': serializer.toJson<String>(businessId),
      'productId': serializer.toJson<String>(productId),
      'name': serializer.toJson<String>(name),
      'isBase': serializer.toJson<bool>(isBase),
      'factor': serializer.toJson<int>(factor),
      'purchasePrice': serializer.toJson<int>(purchasePrice),
      'retailPrice': serializer.toJson<int>(retailPrice),
      'wholesalePrice': serializer.toJson<int>(wholesalePrice),
      'wholesaleMinQty': serializer.toJson<int>(wholesaleMinQty),
      'deleted': serializer.toJson<bool>(deleted),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'serverSeq': serializer.toJson<int>(serverSeq),
    };
  }

  LocalProductUnit copyWith(
          {String? id,
          String? businessId,
          String? productId,
          String? name,
          bool? isBase,
          int? factor,
          int? purchasePrice,
          int? retailPrice,
          int? wholesalePrice,
          int? wholesaleMinQty,
          bool? deleted,
          DateTime? updatedAt,
          int? serverSeq}) =>
      LocalProductUnit(
        id: id ?? this.id,
        businessId: businessId ?? this.businessId,
        productId: productId ?? this.productId,
        name: name ?? this.name,
        isBase: isBase ?? this.isBase,
        factor: factor ?? this.factor,
        purchasePrice: purchasePrice ?? this.purchasePrice,
        retailPrice: retailPrice ?? this.retailPrice,
        wholesalePrice: wholesalePrice ?? this.wholesalePrice,
        wholesaleMinQty: wholesaleMinQty ?? this.wholesaleMinQty,
        deleted: deleted ?? this.deleted,
        updatedAt: updatedAt ?? this.updatedAt,
        serverSeq: serverSeq ?? this.serverSeq,
      );
  LocalProductUnit copyWithCompanion(LocalProductUnitsCompanion data) {
    return LocalProductUnit(
      id: data.id.present ? data.id.value : this.id,
      businessId:
          data.businessId.present ? data.businessId.value : this.businessId,
      productId: data.productId.present ? data.productId.value : this.productId,
      name: data.name.present ? data.name.value : this.name,
      isBase: data.isBase.present ? data.isBase.value : this.isBase,
      factor: data.factor.present ? data.factor.value : this.factor,
      purchasePrice: data.purchasePrice.present
          ? data.purchasePrice.value
          : this.purchasePrice,
      retailPrice:
          data.retailPrice.present ? data.retailPrice.value : this.retailPrice,
      wholesalePrice: data.wholesalePrice.present
          ? data.wholesalePrice.value
          : this.wholesalePrice,
      wholesaleMinQty: data.wholesaleMinQty.present
          ? data.wholesaleMinQty.value
          : this.wholesaleMinQty,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      serverSeq: data.serverSeq.present ? data.serverSeq.value : this.serverSeq,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalProductUnit(')
          ..write('id: $id, ')
          ..write('businessId: $businessId, ')
          ..write('productId: $productId, ')
          ..write('name: $name, ')
          ..write('isBase: $isBase, ')
          ..write('factor: $factor, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('retailPrice: $retailPrice, ')
          ..write('wholesalePrice: $wholesalePrice, ')
          ..write('wholesaleMinQty: $wholesaleMinQty, ')
          ..write('deleted: $deleted, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverSeq: $serverSeq')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      businessId,
      productId,
      name,
      isBase,
      factor,
      purchasePrice,
      retailPrice,
      wholesalePrice,
      wholesaleMinQty,
      deleted,
      updatedAt,
      serverSeq);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalProductUnit &&
          other.id == this.id &&
          other.businessId == this.businessId &&
          other.productId == this.productId &&
          other.name == this.name &&
          other.isBase == this.isBase &&
          other.factor == this.factor &&
          other.purchasePrice == this.purchasePrice &&
          other.retailPrice == this.retailPrice &&
          other.wholesalePrice == this.wholesalePrice &&
          other.wholesaleMinQty == this.wholesaleMinQty &&
          other.deleted == this.deleted &&
          other.updatedAt == this.updatedAt &&
          other.serverSeq == this.serverSeq);
}

class LocalProductUnitsCompanion extends UpdateCompanion<LocalProductUnit> {
  final Value<String> id;
  final Value<String> businessId;
  final Value<String> productId;
  final Value<String> name;
  final Value<bool> isBase;
  final Value<int> factor;
  final Value<int> purchasePrice;
  final Value<int> retailPrice;
  final Value<int> wholesalePrice;
  final Value<int> wholesaleMinQty;
  final Value<bool> deleted;
  final Value<DateTime> updatedAt;
  final Value<int> serverSeq;
  final Value<int> rowid;
  const LocalProductUnitsCompanion({
    this.id = const Value.absent(),
    this.businessId = const Value.absent(),
    this.productId = const Value.absent(),
    this.name = const Value.absent(),
    this.isBase = const Value.absent(),
    this.factor = const Value.absent(),
    this.purchasePrice = const Value.absent(),
    this.retailPrice = const Value.absent(),
    this.wholesalePrice = const Value.absent(),
    this.wholesaleMinQty = const Value.absent(),
    this.deleted = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverSeq = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalProductUnitsCompanion.insert({
    required String id,
    required String businessId,
    required String productId,
    required String name,
    this.isBase = const Value.absent(),
    this.factor = const Value.absent(),
    this.purchasePrice = const Value.absent(),
    this.retailPrice = const Value.absent(),
    this.wholesalePrice = const Value.absent(),
    this.wholesaleMinQty = const Value.absent(),
    this.deleted = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverSeq = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        businessId = Value(businessId),
        productId = Value(productId),
        name = Value(name);
  static Insertable<LocalProductUnit> custom({
    Expression<String>? id,
    Expression<String>? businessId,
    Expression<String>? productId,
    Expression<String>? name,
    Expression<bool>? isBase,
    Expression<int>? factor,
    Expression<int>? purchasePrice,
    Expression<int>? retailPrice,
    Expression<int>? wholesalePrice,
    Expression<int>? wholesaleMinQty,
    Expression<bool>? deleted,
    Expression<DateTime>? updatedAt,
    Expression<int>? serverSeq,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (businessId != null) 'business_id': businessId,
      if (productId != null) 'product_id': productId,
      if (name != null) 'name': name,
      if (isBase != null) 'is_base': isBase,
      if (factor != null) 'factor': factor,
      if (purchasePrice != null) 'purchase_price': purchasePrice,
      if (retailPrice != null) 'retail_price': retailPrice,
      if (wholesalePrice != null) 'wholesale_price': wholesalePrice,
      if (wholesaleMinQty != null) 'wholesale_min_qty': wholesaleMinQty,
      if (deleted != null) 'deleted': deleted,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (serverSeq != null) 'server_seq': serverSeq,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalProductUnitsCompanion copyWith(
      {Value<String>? id,
      Value<String>? businessId,
      Value<String>? productId,
      Value<String>? name,
      Value<bool>? isBase,
      Value<int>? factor,
      Value<int>? purchasePrice,
      Value<int>? retailPrice,
      Value<int>? wholesalePrice,
      Value<int>? wholesaleMinQty,
      Value<bool>? deleted,
      Value<DateTime>? updatedAt,
      Value<int>? serverSeq,
      Value<int>? rowid}) {
    return LocalProductUnitsCompanion(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      isBase: isBase ?? this.isBase,
      factor: factor ?? this.factor,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      retailPrice: retailPrice ?? this.retailPrice,
      wholesalePrice: wholesalePrice ?? this.wholesalePrice,
      wholesaleMinQty: wholesaleMinQty ?? this.wholesaleMinQty,
      deleted: deleted ?? this.deleted,
      updatedAt: updatedAt ?? this.updatedAt,
      serverSeq: serverSeq ?? this.serverSeq,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (businessId.present) {
      map['business_id'] = Variable<String>(businessId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isBase.present) {
      map['is_base'] = Variable<bool>(isBase.value);
    }
    if (factor.present) {
      map['factor'] = Variable<int>(factor.value);
    }
    if (purchasePrice.present) {
      map['purchase_price'] = Variable<int>(purchasePrice.value);
    }
    if (retailPrice.present) {
      map['retail_price'] = Variable<int>(retailPrice.value);
    }
    if (wholesalePrice.present) {
      map['wholesale_price'] = Variable<int>(wholesalePrice.value);
    }
    if (wholesaleMinQty.present) {
      map['wholesale_min_qty'] = Variable<int>(wholesaleMinQty.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (serverSeq.present) {
      map['server_seq'] = Variable<int>(serverSeq.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalProductUnitsCompanion(')
          ..write('id: $id, ')
          ..write('businessId: $businessId, ')
          ..write('productId: $productId, ')
          ..write('name: $name, ')
          ..write('isBase: $isBase, ')
          ..write('factor: $factor, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('retailPrice: $retailPrice, ')
          ..write('wholesalePrice: $wholesalePrice, ')
          ..write('wholesaleMinQty: $wholesaleMinQty, ')
          ..write('deleted: $deleted, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverSeq: $serverSeq, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalProductStockLevelsTable extends LocalProductStockLevels
    with TableInfo<$LocalProductStockLevelsTable, LocalProductStockLevel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalProductStockLevelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _businessIdMeta =
      const VerificationMeta('businessId');
  @override
  late final GeneratedColumn<String> businessId = GeneratedColumn<String>(
      'business_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
      'product_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _depotIdMeta =
      const VerificationMeta('depotId');
  @override
  late final GeneratedColumn<String> depotId = GeneratedColumn<String>(
      'depot_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _minLevelMeta =
      const VerificationMeta('minLevel');
  @override
  late final GeneratedColumn<int> minLevel = GeneratedColumn<int>(
      'min_level', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _cachedQtyMeta =
      const VerificationMeta('cachedQty');
  @override
  late final GeneratedColumn<int> cachedQty = GeneratedColumn<int>(
      'cached_qty', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _serverSeqMeta =
      const VerificationMeta('serverSeq');
  @override
  late final GeneratedColumn<int> serverSeq = GeneratedColumn<int>(
      'server_seq', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        businessId,
        productId,
        depotId,
        minLevel,
        cachedQty,
        updatedAt,
        serverSeq
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_product_stock_levels';
  @override
  VerificationContext validateIntegrity(
      Insertable<LocalProductStockLevel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('business_id')) {
      context.handle(
          _businessIdMeta,
          businessId.isAcceptableOrUnknown(
              data['business_id']!, _businessIdMeta));
    } else if (isInserting) {
      context.missing(_businessIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('depot_id')) {
      context.handle(_depotIdMeta,
          depotId.isAcceptableOrUnknown(data['depot_id']!, _depotIdMeta));
    } else if (isInserting) {
      context.missing(_depotIdMeta);
    }
    if (data.containsKey('min_level')) {
      context.handle(_minLevelMeta,
          minLevel.isAcceptableOrUnknown(data['min_level']!, _minLevelMeta));
    }
    if (data.containsKey('cached_qty')) {
      context.handle(_cachedQtyMeta,
          cachedQty.isAcceptableOrUnknown(data['cached_qty']!, _cachedQtyMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('server_seq')) {
      context.handle(_serverSeqMeta,
          serverSeq.isAcceptableOrUnknown(data['server_seq']!, _serverSeqMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalProductStockLevel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalProductStockLevel(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      businessId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}business_id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_id'])!,
      depotId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}depot_id'])!,
      minLevel: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}min_level'])!,
      cachedQty: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cached_qty'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      serverSeq: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}server_seq'])!,
    );
  }

  @override
  $LocalProductStockLevelsTable createAlias(String alias) {
    return $LocalProductStockLevelsTable(attachedDatabase, alias);
  }
}

class LocalProductStockLevel extends DataClass
    implements Insertable<LocalProductStockLevel> {
  final String id;
  final String businessId;
  final String productId;
  final String depotId;
  final int minLevel;
  final int cachedQty;
  final DateTime updatedAt;
  final int serverSeq;
  const LocalProductStockLevel(
      {required this.id,
      required this.businessId,
      required this.productId,
      required this.depotId,
      required this.minLevel,
      required this.cachedQty,
      required this.updatedAt,
      required this.serverSeq});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['business_id'] = Variable<String>(businessId);
    map['product_id'] = Variable<String>(productId);
    map['depot_id'] = Variable<String>(depotId);
    map['min_level'] = Variable<int>(minLevel);
    map['cached_qty'] = Variable<int>(cachedQty);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['server_seq'] = Variable<int>(serverSeq);
    return map;
  }

  LocalProductStockLevelsCompanion toCompanion(bool nullToAbsent) {
    return LocalProductStockLevelsCompanion(
      id: Value(id),
      businessId: Value(businessId),
      productId: Value(productId),
      depotId: Value(depotId),
      minLevel: Value(minLevel),
      cachedQty: Value(cachedQty),
      updatedAt: Value(updatedAt),
      serverSeq: Value(serverSeq),
    );
  }

  factory LocalProductStockLevel.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalProductStockLevel(
      id: serializer.fromJson<String>(json['id']),
      businessId: serializer.fromJson<String>(json['businessId']),
      productId: serializer.fromJson<String>(json['productId']),
      depotId: serializer.fromJson<String>(json['depotId']),
      minLevel: serializer.fromJson<int>(json['minLevel']),
      cachedQty: serializer.fromJson<int>(json['cachedQty']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      serverSeq: serializer.fromJson<int>(json['serverSeq']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'businessId': serializer.toJson<String>(businessId),
      'productId': serializer.toJson<String>(productId),
      'depotId': serializer.toJson<String>(depotId),
      'minLevel': serializer.toJson<int>(minLevel),
      'cachedQty': serializer.toJson<int>(cachedQty),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'serverSeq': serializer.toJson<int>(serverSeq),
    };
  }

  LocalProductStockLevel copyWith(
          {String? id,
          String? businessId,
          String? productId,
          String? depotId,
          int? minLevel,
          int? cachedQty,
          DateTime? updatedAt,
          int? serverSeq}) =>
      LocalProductStockLevel(
        id: id ?? this.id,
        businessId: businessId ?? this.businessId,
        productId: productId ?? this.productId,
        depotId: depotId ?? this.depotId,
        minLevel: minLevel ?? this.minLevel,
        cachedQty: cachedQty ?? this.cachedQty,
        updatedAt: updatedAt ?? this.updatedAt,
        serverSeq: serverSeq ?? this.serverSeq,
      );
  LocalProductStockLevel copyWithCompanion(
      LocalProductStockLevelsCompanion data) {
    return LocalProductStockLevel(
      id: data.id.present ? data.id.value : this.id,
      businessId:
          data.businessId.present ? data.businessId.value : this.businessId,
      productId: data.productId.present ? data.productId.value : this.productId,
      depotId: data.depotId.present ? data.depotId.value : this.depotId,
      minLevel: data.minLevel.present ? data.minLevel.value : this.minLevel,
      cachedQty: data.cachedQty.present ? data.cachedQty.value : this.cachedQty,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      serverSeq: data.serverSeq.present ? data.serverSeq.value : this.serverSeq,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalProductStockLevel(')
          ..write('id: $id, ')
          ..write('businessId: $businessId, ')
          ..write('productId: $productId, ')
          ..write('depotId: $depotId, ')
          ..write('minLevel: $minLevel, ')
          ..write('cachedQty: $cachedQty, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverSeq: $serverSeq')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, businessId, productId, depotId, minLevel,
      cachedQty, updatedAt, serverSeq);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalProductStockLevel &&
          other.id == this.id &&
          other.businessId == this.businessId &&
          other.productId == this.productId &&
          other.depotId == this.depotId &&
          other.minLevel == this.minLevel &&
          other.cachedQty == this.cachedQty &&
          other.updatedAt == this.updatedAt &&
          other.serverSeq == this.serverSeq);
}

class LocalProductStockLevelsCompanion
    extends UpdateCompanion<LocalProductStockLevel> {
  final Value<String> id;
  final Value<String> businessId;
  final Value<String> productId;
  final Value<String> depotId;
  final Value<int> minLevel;
  final Value<int> cachedQty;
  final Value<DateTime> updatedAt;
  final Value<int> serverSeq;
  final Value<int> rowid;
  const LocalProductStockLevelsCompanion({
    this.id = const Value.absent(),
    this.businessId = const Value.absent(),
    this.productId = const Value.absent(),
    this.depotId = const Value.absent(),
    this.minLevel = const Value.absent(),
    this.cachedQty = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverSeq = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalProductStockLevelsCompanion.insert({
    required String id,
    required String businessId,
    required String productId,
    required String depotId,
    this.minLevel = const Value.absent(),
    this.cachedQty = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverSeq = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        businessId = Value(businessId),
        productId = Value(productId),
        depotId = Value(depotId);
  static Insertable<LocalProductStockLevel> custom({
    Expression<String>? id,
    Expression<String>? businessId,
    Expression<String>? productId,
    Expression<String>? depotId,
    Expression<int>? minLevel,
    Expression<int>? cachedQty,
    Expression<DateTime>? updatedAt,
    Expression<int>? serverSeq,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (businessId != null) 'business_id': businessId,
      if (productId != null) 'product_id': productId,
      if (depotId != null) 'depot_id': depotId,
      if (minLevel != null) 'min_level': minLevel,
      if (cachedQty != null) 'cached_qty': cachedQty,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (serverSeq != null) 'server_seq': serverSeq,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalProductStockLevelsCompanion copyWith(
      {Value<String>? id,
      Value<String>? businessId,
      Value<String>? productId,
      Value<String>? depotId,
      Value<int>? minLevel,
      Value<int>? cachedQty,
      Value<DateTime>? updatedAt,
      Value<int>? serverSeq,
      Value<int>? rowid}) {
    return LocalProductStockLevelsCompanion(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      productId: productId ?? this.productId,
      depotId: depotId ?? this.depotId,
      minLevel: minLevel ?? this.minLevel,
      cachedQty: cachedQty ?? this.cachedQty,
      updatedAt: updatedAt ?? this.updatedAt,
      serverSeq: serverSeq ?? this.serverSeq,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (businessId.present) {
      map['business_id'] = Variable<String>(businessId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (depotId.present) {
      map['depot_id'] = Variable<String>(depotId.value);
    }
    if (minLevel.present) {
      map['min_level'] = Variable<int>(minLevel.value);
    }
    if (cachedQty.present) {
      map['cached_qty'] = Variable<int>(cachedQty.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (serverSeq.present) {
      map['server_seq'] = Variable<int>(serverSeq.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalProductStockLevelsCompanion(')
          ..write('id: $id, ')
          ..write('businessId: $businessId, ')
          ..write('productId: $productId, ')
          ..write('depotId: $depotId, ')
          ..write('minLevel: $minLevel, ')
          ..write('cachedQty: $cachedQty, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverSeq: $serverSeq, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalCustomersTable extends LocalCustomers
    with TableInfo<$LocalCustomersTable, LocalCustomer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalCustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _businessIdMeta =
      const VerificationMeta('businessId');
  @override
  late final GeneratedColumn<String> businessId = GeneratedColumn<String>(
      'business_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('INDIVIDUAL'));
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _creditLimitMeta =
      const VerificationMeta('creditLimit');
  @override
  late final GeneratedColumn<int> creditLimit = GeneratedColumn<int>(
      'credit_limit', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _deletedMeta =
      const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _serverSeqMeta =
      const VerificationMeta('serverSeq');
  @override
  late final GeneratedColumn<int> serverSeq = GeneratedColumn<int>(
      'server_seq', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        businessId,
        name,
        phone,
        type,
        address,
        notes,
        creditLimit,
        deleted,
        createdAt,
        updatedAt,
        serverSeq
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_customers';
  @override
  VerificationContext validateIntegrity(Insertable<LocalCustomer> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('business_id')) {
      context.handle(
          _businessIdMeta,
          businessId.isAcceptableOrUnknown(
              data['business_id']!, _businessIdMeta));
    } else if (isInserting) {
      context.missing(_businessIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('credit_limit')) {
      context.handle(
          _creditLimitMeta,
          creditLimit.isAcceptableOrUnknown(
              data['credit_limit']!, _creditLimitMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('server_seq')) {
      context.handle(_serverSeqMeta,
          serverSeq.isAcceptableOrUnknown(data['server_seq']!, _serverSeqMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalCustomer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalCustomer(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      businessId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}business_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      creditLimit: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}credit_limit']),
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      serverSeq: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}server_seq'])!,
    );
  }

  @override
  $LocalCustomersTable createAlias(String alias) {
    return $LocalCustomersTable(attachedDatabase, alias);
  }
}

class LocalCustomer extends DataClass implements Insertable<LocalCustomer> {
  final String id;
  final String businessId;
  final String name;
  final String? phone;
  final String type;
  final String? address;
  final String? notes;
  final int? creditLimit;
  final bool deleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int serverSeq;
  const LocalCustomer(
      {required this.id,
      required this.businessId,
      required this.name,
      this.phone,
      required this.type,
      this.address,
      this.notes,
      this.creditLimit,
      required this.deleted,
      required this.createdAt,
      required this.updatedAt,
      required this.serverSeq});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['business_id'] = Variable<String>(businessId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || creditLimit != null) {
      map['credit_limit'] = Variable<int>(creditLimit);
    }
    map['deleted'] = Variable<bool>(deleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['server_seq'] = Variable<int>(serverSeq);
    return map;
  }

  LocalCustomersCompanion toCompanion(bool nullToAbsent) {
    return LocalCustomersCompanion(
      id: Value(id),
      businessId: Value(businessId),
      name: Value(name),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      type: Value(type),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      creditLimit: creditLimit == null && nullToAbsent
          ? const Value.absent()
          : Value(creditLimit),
      deleted: Value(deleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      serverSeq: Value(serverSeq),
    );
  }

  factory LocalCustomer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalCustomer(
      id: serializer.fromJson<String>(json['id']),
      businessId: serializer.fromJson<String>(json['businessId']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      type: serializer.fromJson<String>(json['type']),
      address: serializer.fromJson<String?>(json['address']),
      notes: serializer.fromJson<String?>(json['notes']),
      creditLimit: serializer.fromJson<int?>(json['creditLimit']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      serverSeq: serializer.fromJson<int>(json['serverSeq']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'businessId': serializer.toJson<String>(businessId),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'type': serializer.toJson<String>(type),
      'address': serializer.toJson<String?>(address),
      'notes': serializer.toJson<String?>(notes),
      'creditLimit': serializer.toJson<int?>(creditLimit),
      'deleted': serializer.toJson<bool>(deleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'serverSeq': serializer.toJson<int>(serverSeq),
    };
  }

  LocalCustomer copyWith(
          {String? id,
          String? businessId,
          String? name,
          Value<String?> phone = const Value.absent(),
          String? type,
          Value<String?> address = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          Value<int?> creditLimit = const Value.absent(),
          bool? deleted,
          DateTime? createdAt,
          DateTime? updatedAt,
          int? serverSeq}) =>
      LocalCustomer(
        id: id ?? this.id,
        businessId: businessId ?? this.businessId,
        name: name ?? this.name,
        phone: phone.present ? phone.value : this.phone,
        type: type ?? this.type,
        address: address.present ? address.value : this.address,
        notes: notes.present ? notes.value : this.notes,
        creditLimit: creditLimit.present ? creditLimit.value : this.creditLimit,
        deleted: deleted ?? this.deleted,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        serverSeq: serverSeq ?? this.serverSeq,
      );
  LocalCustomer copyWithCompanion(LocalCustomersCompanion data) {
    return LocalCustomer(
      id: data.id.present ? data.id.value : this.id,
      businessId:
          data.businessId.present ? data.businessId.value : this.businessId,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      type: data.type.present ? data.type.value : this.type,
      address: data.address.present ? data.address.value : this.address,
      notes: data.notes.present ? data.notes.value : this.notes,
      creditLimit:
          data.creditLimit.present ? data.creditLimit.value : this.creditLimit,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      serverSeq: data.serverSeq.present ? data.serverSeq.value : this.serverSeq,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalCustomer(')
          ..write('id: $id, ')
          ..write('businessId: $businessId, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('type: $type, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('creditLimit: $creditLimit, ')
          ..write('deleted: $deleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverSeq: $serverSeq')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, businessId, name, phone, type, address,
      notes, creditLimit, deleted, createdAt, updatedAt, serverSeq);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalCustomer &&
          other.id == this.id &&
          other.businessId == this.businessId &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.type == this.type &&
          other.address == this.address &&
          other.notes == this.notes &&
          other.creditLimit == this.creditLimit &&
          other.deleted == this.deleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.serverSeq == this.serverSeq);
}

class LocalCustomersCompanion extends UpdateCompanion<LocalCustomer> {
  final Value<String> id;
  final Value<String> businessId;
  final Value<String> name;
  final Value<String?> phone;
  final Value<String> type;
  final Value<String?> address;
  final Value<String?> notes;
  final Value<int?> creditLimit;
  final Value<bool> deleted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> serverSeq;
  final Value<int> rowid;
  const LocalCustomersCompanion({
    this.id = const Value.absent(),
    this.businessId = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.type = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    this.creditLimit = const Value.absent(),
    this.deleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverSeq = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalCustomersCompanion.insert({
    required String id,
    required String businessId,
    required String name,
    this.phone = const Value.absent(),
    this.type = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    this.creditLimit = const Value.absent(),
    this.deleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverSeq = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        businessId = Value(businessId),
        name = Value(name);
  static Insertable<LocalCustomer> custom({
    Expression<String>? id,
    Expression<String>? businessId,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? type,
    Expression<String>? address,
    Expression<String>? notes,
    Expression<int>? creditLimit,
    Expression<bool>? deleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? serverSeq,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (businessId != null) 'business_id': businessId,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (type != null) 'type': type,
      if (address != null) 'address': address,
      if (notes != null) 'notes': notes,
      if (creditLimit != null) 'credit_limit': creditLimit,
      if (deleted != null) 'deleted': deleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (serverSeq != null) 'server_seq': serverSeq,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalCustomersCompanion copyWith(
      {Value<String>? id,
      Value<String>? businessId,
      Value<String>? name,
      Value<String?>? phone,
      Value<String>? type,
      Value<String?>? address,
      Value<String?>? notes,
      Value<int?>? creditLimit,
      Value<bool>? deleted,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? serverSeq,
      Value<int>? rowid}) {
    return LocalCustomersCompanion(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      type: type ?? this.type,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      creditLimit: creditLimit ?? this.creditLimit,
      deleted: deleted ?? this.deleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      serverSeq: serverSeq ?? this.serverSeq,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (businessId.present) {
      map['business_id'] = Variable<String>(businessId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (creditLimit.present) {
      map['credit_limit'] = Variable<int>(creditLimit.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (serverSeq.present) {
      map['server_seq'] = Variable<int>(serverSeq.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalCustomersCompanion(')
          ..write('id: $id, ')
          ..write('businessId: $businessId, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('type: $type, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('creditLimit: $creditLimit, ')
          ..write('deleted: $deleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverSeq: $serverSeq, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalSalesTable extends LocalSales
    with TableInfo<$LocalSalesTable, LocalSale> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalSalesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _businessIdMeta =
      const VerificationMeta('businessId');
  @override
  late final GeneratedColumn<String> businessId = GeneratedColumn<String>(
      'business_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _depotIdMeta =
      const VerificationMeta('depotId');
  @override
  late final GeneratedColumn<String> depotId = GeneratedColumn<String>(
      'depot_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _customerIdMeta =
      const VerificationMeta('customerId');
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
      'customer_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<String> number = GeneratedColumn<String>(
      'number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('ACTIVE'));
  static const VerificationMeta _totalAmountMeta =
      const VerificationMeta('totalAmount');
  @override
  late final GeneratedColumn<int> totalAmount = GeneratedColumn<int>(
      'total_amount', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _discountAmountMeta =
      const VerificationMeta('discountAmount');
  @override
  late final GeneratedColumn<int> discountAmount = GeneratedColumn<int>(
      'discount_amount', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cancelReasonMeta =
      const VerificationMeta('cancelReason');
  @override
  late final GeneratedColumn<String> cancelReason = GeneratedColumn<String>(
      'cancel_reason', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cancelledByMeta =
      const VerificationMeta('cancelledBy');
  @override
  late final GeneratedColumn<String> cancelledBy = GeneratedColumn<String>(
      'cancelled_by', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _deletedMeta =
      const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _serverSeqMeta =
      const VerificationMeta('serverSeq');
  @override
  late final GeneratedColumn<int> serverSeq = GeneratedColumn<int>(
      'server_seq', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        businessId,
        depotId,
        customerId,
        userId,
        deviceId,
        number,
        status,
        totalAmount,
        discountAmount,
        notes,
        cancelReason,
        cancelledBy,
        deleted,
        createdAt,
        updatedAt,
        serverSeq
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_sales';
  @override
  VerificationContext validateIntegrity(Insertable<LocalSale> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('business_id')) {
      context.handle(
          _businessIdMeta,
          businessId.isAcceptableOrUnknown(
              data['business_id']!, _businessIdMeta));
    } else if (isInserting) {
      context.missing(_businessIdMeta);
    }
    if (data.containsKey('depot_id')) {
      context.handle(_depotIdMeta,
          depotId.isAcceptableOrUnknown(data['depot_id']!, _depotIdMeta));
    } else if (isInserting) {
      context.missing(_depotIdMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
          _customerIdMeta,
          customerId.isAcceptableOrUnknown(
              data['customer_id']!, _customerIdMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('number')) {
      context.handle(_numberMeta,
          number.isAcceptableOrUnknown(data['number']!, _numberMeta));
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('total_amount')) {
      context.handle(
          _totalAmountMeta,
          totalAmount.isAcceptableOrUnknown(
              data['total_amount']!, _totalAmountMeta));
    }
    if (data.containsKey('discount_amount')) {
      context.handle(
          _discountAmountMeta,
          discountAmount.isAcceptableOrUnknown(
              data['discount_amount']!, _discountAmountMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('cancel_reason')) {
      context.handle(
          _cancelReasonMeta,
          cancelReason.isAcceptableOrUnknown(
              data['cancel_reason']!, _cancelReasonMeta));
    }
    if (data.containsKey('cancelled_by')) {
      context.handle(
          _cancelledByMeta,
          cancelledBy.isAcceptableOrUnknown(
              data['cancelled_by']!, _cancelledByMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('server_seq')) {
      context.handle(_serverSeqMeta,
          serverSeq.isAcceptableOrUnknown(data['server_seq']!, _serverSeqMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalSale map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalSale(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      businessId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}business_id'])!,
      depotId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}depot_id'])!,
      customerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_id']),
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id'])!,
      number: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}number'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      totalAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_amount'])!,
      discountAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}discount_amount'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      cancelReason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cancel_reason']),
      cancelledBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cancelled_by']),
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      serverSeq: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}server_seq'])!,
    );
  }

  @override
  $LocalSalesTable createAlias(String alias) {
    return $LocalSalesTable(attachedDatabase, alias);
  }
}

class LocalSale extends DataClass implements Insertable<LocalSale> {
  final String id;
  final String businessId;
  final String depotId;
  final String? customerId;
  final String userId;
  final String deviceId;
  final String number;
  final String status;
  final int totalAmount;
  final int discountAmount;
  final String? notes;
  final String? cancelReason;
  final String? cancelledBy;
  final bool deleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int serverSeq;
  const LocalSale(
      {required this.id,
      required this.businessId,
      required this.depotId,
      this.customerId,
      required this.userId,
      required this.deviceId,
      required this.number,
      required this.status,
      required this.totalAmount,
      required this.discountAmount,
      this.notes,
      this.cancelReason,
      this.cancelledBy,
      required this.deleted,
      required this.createdAt,
      required this.updatedAt,
      required this.serverSeq});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['business_id'] = Variable<String>(businessId);
    map['depot_id'] = Variable<String>(depotId);
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<String>(customerId);
    }
    map['user_id'] = Variable<String>(userId);
    map['device_id'] = Variable<String>(deviceId);
    map['number'] = Variable<String>(number);
    map['status'] = Variable<String>(status);
    map['total_amount'] = Variable<int>(totalAmount);
    map['discount_amount'] = Variable<int>(discountAmount);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || cancelReason != null) {
      map['cancel_reason'] = Variable<String>(cancelReason);
    }
    if (!nullToAbsent || cancelledBy != null) {
      map['cancelled_by'] = Variable<String>(cancelledBy);
    }
    map['deleted'] = Variable<bool>(deleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['server_seq'] = Variable<int>(serverSeq);
    return map;
  }

  LocalSalesCompanion toCompanion(bool nullToAbsent) {
    return LocalSalesCompanion(
      id: Value(id),
      businessId: Value(businessId),
      depotId: Value(depotId),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      userId: Value(userId),
      deviceId: Value(deviceId),
      number: Value(number),
      status: Value(status),
      totalAmount: Value(totalAmount),
      discountAmount: Value(discountAmount),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      cancelReason: cancelReason == null && nullToAbsent
          ? const Value.absent()
          : Value(cancelReason),
      cancelledBy: cancelledBy == null && nullToAbsent
          ? const Value.absent()
          : Value(cancelledBy),
      deleted: Value(deleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      serverSeq: Value(serverSeq),
    );
  }

  factory LocalSale.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalSale(
      id: serializer.fromJson<String>(json['id']),
      businessId: serializer.fromJson<String>(json['businessId']),
      depotId: serializer.fromJson<String>(json['depotId']),
      customerId: serializer.fromJson<String?>(json['customerId']),
      userId: serializer.fromJson<String>(json['userId']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      number: serializer.fromJson<String>(json['number']),
      status: serializer.fromJson<String>(json['status']),
      totalAmount: serializer.fromJson<int>(json['totalAmount']),
      discountAmount: serializer.fromJson<int>(json['discountAmount']),
      notes: serializer.fromJson<String?>(json['notes']),
      cancelReason: serializer.fromJson<String?>(json['cancelReason']),
      cancelledBy: serializer.fromJson<String?>(json['cancelledBy']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      serverSeq: serializer.fromJson<int>(json['serverSeq']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'businessId': serializer.toJson<String>(businessId),
      'depotId': serializer.toJson<String>(depotId),
      'customerId': serializer.toJson<String?>(customerId),
      'userId': serializer.toJson<String>(userId),
      'deviceId': serializer.toJson<String>(deviceId),
      'number': serializer.toJson<String>(number),
      'status': serializer.toJson<String>(status),
      'totalAmount': serializer.toJson<int>(totalAmount),
      'discountAmount': serializer.toJson<int>(discountAmount),
      'notes': serializer.toJson<String?>(notes),
      'cancelReason': serializer.toJson<String?>(cancelReason),
      'cancelledBy': serializer.toJson<String?>(cancelledBy),
      'deleted': serializer.toJson<bool>(deleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'serverSeq': serializer.toJson<int>(serverSeq),
    };
  }

  LocalSale copyWith(
          {String? id,
          String? businessId,
          String? depotId,
          Value<String?> customerId = const Value.absent(),
          String? userId,
          String? deviceId,
          String? number,
          String? status,
          int? totalAmount,
          int? discountAmount,
          Value<String?> notes = const Value.absent(),
          Value<String?> cancelReason = const Value.absent(),
          Value<String?> cancelledBy = const Value.absent(),
          bool? deleted,
          DateTime? createdAt,
          DateTime? updatedAt,
          int? serverSeq}) =>
      LocalSale(
        id: id ?? this.id,
        businessId: businessId ?? this.businessId,
        depotId: depotId ?? this.depotId,
        customerId: customerId.present ? customerId.value : this.customerId,
        userId: userId ?? this.userId,
        deviceId: deviceId ?? this.deviceId,
        number: number ?? this.number,
        status: status ?? this.status,
        totalAmount: totalAmount ?? this.totalAmount,
        discountAmount: discountAmount ?? this.discountAmount,
        notes: notes.present ? notes.value : this.notes,
        cancelReason:
            cancelReason.present ? cancelReason.value : this.cancelReason,
        cancelledBy: cancelledBy.present ? cancelledBy.value : this.cancelledBy,
        deleted: deleted ?? this.deleted,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        serverSeq: serverSeq ?? this.serverSeq,
      );
  LocalSale copyWithCompanion(LocalSalesCompanion data) {
    return LocalSale(
      id: data.id.present ? data.id.value : this.id,
      businessId:
          data.businessId.present ? data.businessId.value : this.businessId,
      depotId: data.depotId.present ? data.depotId.value : this.depotId,
      customerId:
          data.customerId.present ? data.customerId.value : this.customerId,
      userId: data.userId.present ? data.userId.value : this.userId,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      number: data.number.present ? data.number.value : this.number,
      status: data.status.present ? data.status.value : this.status,
      totalAmount:
          data.totalAmount.present ? data.totalAmount.value : this.totalAmount,
      discountAmount: data.discountAmount.present
          ? data.discountAmount.value
          : this.discountAmount,
      notes: data.notes.present ? data.notes.value : this.notes,
      cancelReason: data.cancelReason.present
          ? data.cancelReason.value
          : this.cancelReason,
      cancelledBy:
          data.cancelledBy.present ? data.cancelledBy.value : this.cancelledBy,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      serverSeq: data.serverSeq.present ? data.serverSeq.value : this.serverSeq,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalSale(')
          ..write('id: $id, ')
          ..write('businessId: $businessId, ')
          ..write('depotId: $depotId, ')
          ..write('customerId: $customerId, ')
          ..write('userId: $userId, ')
          ..write('deviceId: $deviceId, ')
          ..write('number: $number, ')
          ..write('status: $status, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('notes: $notes, ')
          ..write('cancelReason: $cancelReason, ')
          ..write('cancelledBy: $cancelledBy, ')
          ..write('deleted: $deleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverSeq: $serverSeq')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      businessId,
      depotId,
      customerId,
      userId,
      deviceId,
      number,
      status,
      totalAmount,
      discountAmount,
      notes,
      cancelReason,
      cancelledBy,
      deleted,
      createdAt,
      updatedAt,
      serverSeq);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalSale &&
          other.id == this.id &&
          other.businessId == this.businessId &&
          other.depotId == this.depotId &&
          other.customerId == this.customerId &&
          other.userId == this.userId &&
          other.deviceId == this.deviceId &&
          other.number == this.number &&
          other.status == this.status &&
          other.totalAmount == this.totalAmount &&
          other.discountAmount == this.discountAmount &&
          other.notes == this.notes &&
          other.cancelReason == this.cancelReason &&
          other.cancelledBy == this.cancelledBy &&
          other.deleted == this.deleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.serverSeq == this.serverSeq);
}

class LocalSalesCompanion extends UpdateCompanion<LocalSale> {
  final Value<String> id;
  final Value<String> businessId;
  final Value<String> depotId;
  final Value<String?> customerId;
  final Value<String> userId;
  final Value<String> deviceId;
  final Value<String> number;
  final Value<String> status;
  final Value<int> totalAmount;
  final Value<int> discountAmount;
  final Value<String?> notes;
  final Value<String?> cancelReason;
  final Value<String?> cancelledBy;
  final Value<bool> deleted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> serverSeq;
  final Value<int> rowid;
  const LocalSalesCompanion({
    this.id = const Value.absent(),
    this.businessId = const Value.absent(),
    this.depotId = const Value.absent(),
    this.customerId = const Value.absent(),
    this.userId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.number = const Value.absent(),
    this.status = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.discountAmount = const Value.absent(),
    this.notes = const Value.absent(),
    this.cancelReason = const Value.absent(),
    this.cancelledBy = const Value.absent(),
    this.deleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverSeq = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalSalesCompanion.insert({
    required String id,
    required String businessId,
    required String depotId,
    this.customerId = const Value.absent(),
    required String userId,
    required String deviceId,
    required String number,
    this.status = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.discountAmount = const Value.absent(),
    this.notes = const Value.absent(),
    this.cancelReason = const Value.absent(),
    this.cancelledBy = const Value.absent(),
    this.deleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverSeq = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        businessId = Value(businessId),
        depotId = Value(depotId),
        userId = Value(userId),
        deviceId = Value(deviceId),
        number = Value(number);
  static Insertable<LocalSale> custom({
    Expression<String>? id,
    Expression<String>? businessId,
    Expression<String>? depotId,
    Expression<String>? customerId,
    Expression<String>? userId,
    Expression<String>? deviceId,
    Expression<String>? number,
    Expression<String>? status,
    Expression<int>? totalAmount,
    Expression<int>? discountAmount,
    Expression<String>? notes,
    Expression<String>? cancelReason,
    Expression<String>? cancelledBy,
    Expression<bool>? deleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? serverSeq,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (businessId != null) 'business_id': businessId,
      if (depotId != null) 'depot_id': depotId,
      if (customerId != null) 'customer_id': customerId,
      if (userId != null) 'user_id': userId,
      if (deviceId != null) 'device_id': deviceId,
      if (number != null) 'number': number,
      if (status != null) 'status': status,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (discountAmount != null) 'discount_amount': discountAmount,
      if (notes != null) 'notes': notes,
      if (cancelReason != null) 'cancel_reason': cancelReason,
      if (cancelledBy != null) 'cancelled_by': cancelledBy,
      if (deleted != null) 'deleted': deleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (serverSeq != null) 'server_seq': serverSeq,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalSalesCompanion copyWith(
      {Value<String>? id,
      Value<String>? businessId,
      Value<String>? depotId,
      Value<String?>? customerId,
      Value<String>? userId,
      Value<String>? deviceId,
      Value<String>? number,
      Value<String>? status,
      Value<int>? totalAmount,
      Value<int>? discountAmount,
      Value<String?>? notes,
      Value<String?>? cancelReason,
      Value<String?>? cancelledBy,
      Value<bool>? deleted,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? serverSeq,
      Value<int>? rowid}) {
    return LocalSalesCompanion(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      depotId: depotId ?? this.depotId,
      customerId: customerId ?? this.customerId,
      userId: userId ?? this.userId,
      deviceId: deviceId ?? this.deviceId,
      number: number ?? this.number,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      notes: notes ?? this.notes,
      cancelReason: cancelReason ?? this.cancelReason,
      cancelledBy: cancelledBy ?? this.cancelledBy,
      deleted: deleted ?? this.deleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      serverSeq: serverSeq ?? this.serverSeq,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (businessId.present) {
      map['business_id'] = Variable<String>(businessId.value);
    }
    if (depotId.present) {
      map['depot_id'] = Variable<String>(depotId.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (number.present) {
      map['number'] = Variable<String>(number.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<int>(totalAmount.value);
    }
    if (discountAmount.present) {
      map['discount_amount'] = Variable<int>(discountAmount.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (cancelReason.present) {
      map['cancel_reason'] = Variable<String>(cancelReason.value);
    }
    if (cancelledBy.present) {
      map['cancelled_by'] = Variable<String>(cancelledBy.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (serverSeq.present) {
      map['server_seq'] = Variable<int>(serverSeq.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalSalesCompanion(')
          ..write('id: $id, ')
          ..write('businessId: $businessId, ')
          ..write('depotId: $depotId, ')
          ..write('customerId: $customerId, ')
          ..write('userId: $userId, ')
          ..write('deviceId: $deviceId, ')
          ..write('number: $number, ')
          ..write('status: $status, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('notes: $notes, ')
          ..write('cancelReason: $cancelReason, ')
          ..write('cancelledBy: $cancelledBy, ')
          ..write('deleted: $deleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverSeq: $serverSeq, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalSaleLinesTable extends LocalSaleLines
    with TableInfo<$LocalSaleLinesTable, LocalSaleLine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalSaleLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _businessIdMeta =
      const VerificationMeta('businessId');
  @override
  late final GeneratedColumn<String> businessId = GeneratedColumn<String>(
      'business_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _saleIdMeta = const VerificationMeta('saleId');
  @override
  late final GeneratedColumn<String> saleId = GeneratedColumn<String>(
      'sale_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
      'product_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unitIdMeta = const VerificationMeta('unitId');
  @override
  late final GeneratedColumn<String> unitId = GeneratedColumn<String>(
      'unit_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _qtyMeta = const VerificationMeta('qty');
  @override
  late final GeneratedColumn<int> qty = GeneratedColumn<int>(
      'qty', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _unitPriceMeta =
      const VerificationMeta('unitPrice');
  @override
  late final GeneratedColumn<int> unitPrice = GeneratedColumn<int>(
      'unit_price', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _discountMeta =
      const VerificationMeta('discount');
  @override
  late final GeneratedColumn<int> discount = GeneratedColumn<int>(
      'discount', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lineTotalMeta =
      const VerificationMeta('lineTotal');
  @override
  late final GeneratedColumn<int> lineTotal = GeneratedColumn<int>(
      'line_total', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _deletedMeta =
      const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _serverSeqMeta =
      const VerificationMeta('serverSeq');
  @override
  late final GeneratedColumn<int> serverSeq = GeneratedColumn<int>(
      'server_seq', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        businessId,
        saleId,
        productId,
        unitId,
        qty,
        unitPrice,
        discount,
        lineTotal,
        deleted,
        createdAt,
        updatedAt,
        serverSeq
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_sale_lines';
  @override
  VerificationContext validateIntegrity(Insertable<LocalSaleLine> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('business_id')) {
      context.handle(
          _businessIdMeta,
          businessId.isAcceptableOrUnknown(
              data['business_id']!, _businessIdMeta));
    } else if (isInserting) {
      context.missing(_businessIdMeta);
    }
    if (data.containsKey('sale_id')) {
      context.handle(_saleIdMeta,
          saleId.isAcceptableOrUnknown(data['sale_id']!, _saleIdMeta));
    } else if (isInserting) {
      context.missing(_saleIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('unit_id')) {
      context.handle(_unitIdMeta,
          unitId.isAcceptableOrUnknown(data['unit_id']!, _unitIdMeta));
    } else if (isInserting) {
      context.missing(_unitIdMeta);
    }
    if (data.containsKey('qty')) {
      context.handle(
          _qtyMeta, qty.isAcceptableOrUnknown(data['qty']!, _qtyMeta));
    } else if (isInserting) {
      context.missing(_qtyMeta);
    }
    if (data.containsKey('unit_price')) {
      context.handle(_unitPriceMeta,
          unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta));
    } else if (isInserting) {
      context.missing(_unitPriceMeta);
    }
    if (data.containsKey('discount')) {
      context.handle(_discountMeta,
          discount.isAcceptableOrUnknown(data['discount']!, _discountMeta));
    }
    if (data.containsKey('line_total')) {
      context.handle(_lineTotalMeta,
          lineTotal.isAcceptableOrUnknown(data['line_total']!, _lineTotalMeta));
    } else if (isInserting) {
      context.missing(_lineTotalMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('server_seq')) {
      context.handle(_serverSeqMeta,
          serverSeq.isAcceptableOrUnknown(data['server_seq']!, _serverSeqMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalSaleLine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalSaleLine(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      businessId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}business_id'])!,
      saleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sale_id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_id'])!,
      unitId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit_id'])!,
      qty: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}qty'])!,
      unitPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}unit_price'])!,
      discount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}discount'])!,
      lineTotal: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}line_total'])!,
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      serverSeq: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}server_seq'])!,
    );
  }

  @override
  $LocalSaleLinesTable createAlias(String alias) {
    return $LocalSaleLinesTable(attachedDatabase, alias);
  }
}

class LocalSaleLine extends DataClass implements Insertable<LocalSaleLine> {
  final String id;
  final String businessId;
  final String saleId;
  final String productId;
  final String unitId;
  final int qty;
  final int unitPrice;
  final int discount;
  final int lineTotal;
  final bool deleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int serverSeq;
  const LocalSaleLine(
      {required this.id,
      required this.businessId,
      required this.saleId,
      required this.productId,
      required this.unitId,
      required this.qty,
      required this.unitPrice,
      required this.discount,
      required this.lineTotal,
      required this.deleted,
      required this.createdAt,
      required this.updatedAt,
      required this.serverSeq});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['business_id'] = Variable<String>(businessId);
    map['sale_id'] = Variable<String>(saleId);
    map['product_id'] = Variable<String>(productId);
    map['unit_id'] = Variable<String>(unitId);
    map['qty'] = Variable<int>(qty);
    map['unit_price'] = Variable<int>(unitPrice);
    map['discount'] = Variable<int>(discount);
    map['line_total'] = Variable<int>(lineTotal);
    map['deleted'] = Variable<bool>(deleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['server_seq'] = Variable<int>(serverSeq);
    return map;
  }

  LocalSaleLinesCompanion toCompanion(bool nullToAbsent) {
    return LocalSaleLinesCompanion(
      id: Value(id),
      businessId: Value(businessId),
      saleId: Value(saleId),
      productId: Value(productId),
      unitId: Value(unitId),
      qty: Value(qty),
      unitPrice: Value(unitPrice),
      discount: Value(discount),
      lineTotal: Value(lineTotal),
      deleted: Value(deleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      serverSeq: Value(serverSeq),
    );
  }

  factory LocalSaleLine.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalSaleLine(
      id: serializer.fromJson<String>(json['id']),
      businessId: serializer.fromJson<String>(json['businessId']),
      saleId: serializer.fromJson<String>(json['saleId']),
      productId: serializer.fromJson<String>(json['productId']),
      unitId: serializer.fromJson<String>(json['unitId']),
      qty: serializer.fromJson<int>(json['qty']),
      unitPrice: serializer.fromJson<int>(json['unitPrice']),
      discount: serializer.fromJson<int>(json['discount']),
      lineTotal: serializer.fromJson<int>(json['lineTotal']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      serverSeq: serializer.fromJson<int>(json['serverSeq']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'businessId': serializer.toJson<String>(businessId),
      'saleId': serializer.toJson<String>(saleId),
      'productId': serializer.toJson<String>(productId),
      'unitId': serializer.toJson<String>(unitId),
      'qty': serializer.toJson<int>(qty),
      'unitPrice': serializer.toJson<int>(unitPrice),
      'discount': serializer.toJson<int>(discount),
      'lineTotal': serializer.toJson<int>(lineTotal),
      'deleted': serializer.toJson<bool>(deleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'serverSeq': serializer.toJson<int>(serverSeq),
    };
  }

  LocalSaleLine copyWith(
          {String? id,
          String? businessId,
          String? saleId,
          String? productId,
          String? unitId,
          int? qty,
          int? unitPrice,
          int? discount,
          int? lineTotal,
          bool? deleted,
          DateTime? createdAt,
          DateTime? updatedAt,
          int? serverSeq}) =>
      LocalSaleLine(
        id: id ?? this.id,
        businessId: businessId ?? this.businessId,
        saleId: saleId ?? this.saleId,
        productId: productId ?? this.productId,
        unitId: unitId ?? this.unitId,
        qty: qty ?? this.qty,
        unitPrice: unitPrice ?? this.unitPrice,
        discount: discount ?? this.discount,
        lineTotal: lineTotal ?? this.lineTotal,
        deleted: deleted ?? this.deleted,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        serverSeq: serverSeq ?? this.serverSeq,
      );
  LocalSaleLine copyWithCompanion(LocalSaleLinesCompanion data) {
    return LocalSaleLine(
      id: data.id.present ? data.id.value : this.id,
      businessId:
          data.businessId.present ? data.businessId.value : this.businessId,
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
      productId: data.productId.present ? data.productId.value : this.productId,
      unitId: data.unitId.present ? data.unitId.value : this.unitId,
      qty: data.qty.present ? data.qty.value : this.qty,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      discount: data.discount.present ? data.discount.value : this.discount,
      lineTotal: data.lineTotal.present ? data.lineTotal.value : this.lineTotal,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      serverSeq: data.serverSeq.present ? data.serverSeq.value : this.serverSeq,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalSaleLine(')
          ..write('id: $id, ')
          ..write('businessId: $businessId, ')
          ..write('saleId: $saleId, ')
          ..write('productId: $productId, ')
          ..write('unitId: $unitId, ')
          ..write('qty: $qty, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('discount: $discount, ')
          ..write('lineTotal: $lineTotal, ')
          ..write('deleted: $deleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverSeq: $serverSeq')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      businessId,
      saleId,
      productId,
      unitId,
      qty,
      unitPrice,
      discount,
      lineTotal,
      deleted,
      createdAt,
      updatedAt,
      serverSeq);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalSaleLine &&
          other.id == this.id &&
          other.businessId == this.businessId &&
          other.saleId == this.saleId &&
          other.productId == this.productId &&
          other.unitId == this.unitId &&
          other.qty == this.qty &&
          other.unitPrice == this.unitPrice &&
          other.discount == this.discount &&
          other.lineTotal == this.lineTotal &&
          other.deleted == this.deleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.serverSeq == this.serverSeq);
}

class LocalSaleLinesCompanion extends UpdateCompanion<LocalSaleLine> {
  final Value<String> id;
  final Value<String> businessId;
  final Value<String> saleId;
  final Value<String> productId;
  final Value<String> unitId;
  final Value<int> qty;
  final Value<int> unitPrice;
  final Value<int> discount;
  final Value<int> lineTotal;
  final Value<bool> deleted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> serverSeq;
  final Value<int> rowid;
  const LocalSaleLinesCompanion({
    this.id = const Value.absent(),
    this.businessId = const Value.absent(),
    this.saleId = const Value.absent(),
    this.productId = const Value.absent(),
    this.unitId = const Value.absent(),
    this.qty = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.discount = const Value.absent(),
    this.lineTotal = const Value.absent(),
    this.deleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverSeq = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalSaleLinesCompanion.insert({
    required String id,
    required String businessId,
    required String saleId,
    required String productId,
    required String unitId,
    required int qty,
    required int unitPrice,
    this.discount = const Value.absent(),
    required int lineTotal,
    this.deleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverSeq = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        businessId = Value(businessId),
        saleId = Value(saleId),
        productId = Value(productId),
        unitId = Value(unitId),
        qty = Value(qty),
        unitPrice = Value(unitPrice),
        lineTotal = Value(lineTotal);
  static Insertable<LocalSaleLine> custom({
    Expression<String>? id,
    Expression<String>? businessId,
    Expression<String>? saleId,
    Expression<String>? productId,
    Expression<String>? unitId,
    Expression<int>? qty,
    Expression<int>? unitPrice,
    Expression<int>? discount,
    Expression<int>? lineTotal,
    Expression<bool>? deleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? serverSeq,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (businessId != null) 'business_id': businessId,
      if (saleId != null) 'sale_id': saleId,
      if (productId != null) 'product_id': productId,
      if (unitId != null) 'unit_id': unitId,
      if (qty != null) 'qty': qty,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (discount != null) 'discount': discount,
      if (lineTotal != null) 'line_total': lineTotal,
      if (deleted != null) 'deleted': deleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (serverSeq != null) 'server_seq': serverSeq,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalSaleLinesCompanion copyWith(
      {Value<String>? id,
      Value<String>? businessId,
      Value<String>? saleId,
      Value<String>? productId,
      Value<String>? unitId,
      Value<int>? qty,
      Value<int>? unitPrice,
      Value<int>? discount,
      Value<int>? lineTotal,
      Value<bool>? deleted,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? serverSeq,
      Value<int>? rowid}) {
    return LocalSaleLinesCompanion(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      saleId: saleId ?? this.saleId,
      productId: productId ?? this.productId,
      unitId: unitId ?? this.unitId,
      qty: qty ?? this.qty,
      unitPrice: unitPrice ?? this.unitPrice,
      discount: discount ?? this.discount,
      lineTotal: lineTotal ?? this.lineTotal,
      deleted: deleted ?? this.deleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      serverSeq: serverSeq ?? this.serverSeq,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (businessId.present) {
      map['business_id'] = Variable<String>(businessId.value);
    }
    if (saleId.present) {
      map['sale_id'] = Variable<String>(saleId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (unitId.present) {
      map['unit_id'] = Variable<String>(unitId.value);
    }
    if (qty.present) {
      map['qty'] = Variable<int>(qty.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<int>(unitPrice.value);
    }
    if (discount.present) {
      map['discount'] = Variable<int>(discount.value);
    }
    if (lineTotal.present) {
      map['line_total'] = Variable<int>(lineTotal.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (serverSeq.present) {
      map['server_seq'] = Variable<int>(serverSeq.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalSaleLinesCompanion(')
          ..write('id: $id, ')
          ..write('businessId: $businessId, ')
          ..write('saleId: $saleId, ')
          ..write('productId: $productId, ')
          ..write('unitId: $unitId, ')
          ..write('qty: $qty, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('discount: $discount, ')
          ..write('lineTotal: $lineTotal, ')
          ..write('deleted: $deleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverSeq: $serverSeq, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalSalePaymentsTable extends LocalSalePayments
    with TableInfo<$LocalSalePaymentsTable, LocalSalePayment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalSalePaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _businessIdMeta =
      const VerificationMeta('businessId');
  @override
  late final GeneratedColumn<String> businessId = GeneratedColumn<String>(
      'business_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _depotIdMeta =
      const VerificationMeta('depotId');
  @override
  late final GeneratedColumn<String> depotId = GeneratedColumn<String>(
      'depot_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _saleIdMeta = const VerificationMeta('saleId');
  @override
  late final GeneratedColumn<String> saleId = GeneratedColumn<String>(
      'sale_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
      'method', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
      'amount', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _referenceMeta =
      const VerificationMeta('reference');
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
      'reference', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _deletedMeta =
      const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _serverSeqMeta =
      const VerificationMeta('serverSeq');
  @override
  late final GeneratedColumn<int> serverSeq = GeneratedColumn<int>(
      'server_seq', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        businessId,
        depotId,
        saleId,
        deviceId,
        method,
        amount,
        reference,
        deleted,
        createdAt,
        updatedAt,
        serverSeq
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_sale_payments';
  @override
  VerificationContext validateIntegrity(Insertable<LocalSalePayment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('business_id')) {
      context.handle(
          _businessIdMeta,
          businessId.isAcceptableOrUnknown(
              data['business_id']!, _businessIdMeta));
    } else if (isInserting) {
      context.missing(_businessIdMeta);
    }
    if (data.containsKey('depot_id')) {
      context.handle(_depotIdMeta,
          depotId.isAcceptableOrUnknown(data['depot_id']!, _depotIdMeta));
    } else if (isInserting) {
      context.missing(_depotIdMeta);
    }
    if (data.containsKey('sale_id')) {
      context.handle(_saleIdMeta,
          saleId.isAcceptableOrUnknown(data['sale_id']!, _saleIdMeta));
    } else if (isInserting) {
      context.missing(_saleIdMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('method')) {
      context.handle(_methodMeta,
          method.isAcceptableOrUnknown(data['method']!, _methodMeta));
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('reference')) {
      context.handle(_referenceMeta,
          reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('server_seq')) {
      context.handle(_serverSeqMeta,
          serverSeq.isAcceptableOrUnknown(data['server_seq']!, _serverSeqMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalSalePayment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalSalePayment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      businessId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}business_id'])!,
      depotId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}depot_id'])!,
      saleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sale_id'])!,
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id'])!,
      method: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}method'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount'])!,
      reference: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reference']),
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      serverSeq: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}server_seq'])!,
    );
  }

  @override
  $LocalSalePaymentsTable createAlias(String alias) {
    return $LocalSalePaymentsTable(attachedDatabase, alias);
  }
}

class LocalSalePayment extends DataClass
    implements Insertable<LocalSalePayment> {
  final String id;
  final String businessId;
  final String depotId;
  final String saleId;
  final String deviceId;
  final String method;
  final int amount;
  final String? reference;
  final bool deleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int serverSeq;
  const LocalSalePayment(
      {required this.id,
      required this.businessId,
      required this.depotId,
      required this.saleId,
      required this.deviceId,
      required this.method,
      required this.amount,
      this.reference,
      required this.deleted,
      required this.createdAt,
      required this.updatedAt,
      required this.serverSeq});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['business_id'] = Variable<String>(businessId);
    map['depot_id'] = Variable<String>(depotId);
    map['sale_id'] = Variable<String>(saleId);
    map['device_id'] = Variable<String>(deviceId);
    map['method'] = Variable<String>(method);
    map['amount'] = Variable<int>(amount);
    if (!nullToAbsent || reference != null) {
      map['reference'] = Variable<String>(reference);
    }
    map['deleted'] = Variable<bool>(deleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['server_seq'] = Variable<int>(serverSeq);
    return map;
  }

  LocalSalePaymentsCompanion toCompanion(bool nullToAbsent) {
    return LocalSalePaymentsCompanion(
      id: Value(id),
      businessId: Value(businessId),
      depotId: Value(depotId),
      saleId: Value(saleId),
      deviceId: Value(deviceId),
      method: Value(method),
      amount: Value(amount),
      reference: reference == null && nullToAbsent
          ? const Value.absent()
          : Value(reference),
      deleted: Value(deleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      serverSeq: Value(serverSeq),
    );
  }

  factory LocalSalePayment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalSalePayment(
      id: serializer.fromJson<String>(json['id']),
      businessId: serializer.fromJson<String>(json['businessId']),
      depotId: serializer.fromJson<String>(json['depotId']),
      saleId: serializer.fromJson<String>(json['saleId']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      method: serializer.fromJson<String>(json['method']),
      amount: serializer.fromJson<int>(json['amount']),
      reference: serializer.fromJson<String?>(json['reference']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      serverSeq: serializer.fromJson<int>(json['serverSeq']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'businessId': serializer.toJson<String>(businessId),
      'depotId': serializer.toJson<String>(depotId),
      'saleId': serializer.toJson<String>(saleId),
      'deviceId': serializer.toJson<String>(deviceId),
      'method': serializer.toJson<String>(method),
      'amount': serializer.toJson<int>(amount),
      'reference': serializer.toJson<String?>(reference),
      'deleted': serializer.toJson<bool>(deleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'serverSeq': serializer.toJson<int>(serverSeq),
    };
  }

  LocalSalePayment copyWith(
          {String? id,
          String? businessId,
          String? depotId,
          String? saleId,
          String? deviceId,
          String? method,
          int? amount,
          Value<String?> reference = const Value.absent(),
          bool? deleted,
          DateTime? createdAt,
          DateTime? updatedAt,
          int? serverSeq}) =>
      LocalSalePayment(
        id: id ?? this.id,
        businessId: businessId ?? this.businessId,
        depotId: depotId ?? this.depotId,
        saleId: saleId ?? this.saleId,
        deviceId: deviceId ?? this.deviceId,
        method: method ?? this.method,
        amount: amount ?? this.amount,
        reference: reference.present ? reference.value : this.reference,
        deleted: deleted ?? this.deleted,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        serverSeq: serverSeq ?? this.serverSeq,
      );
  LocalSalePayment copyWithCompanion(LocalSalePaymentsCompanion data) {
    return LocalSalePayment(
      id: data.id.present ? data.id.value : this.id,
      businessId:
          data.businessId.present ? data.businessId.value : this.businessId,
      depotId: data.depotId.present ? data.depotId.value : this.depotId,
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      method: data.method.present ? data.method.value : this.method,
      amount: data.amount.present ? data.amount.value : this.amount,
      reference: data.reference.present ? data.reference.value : this.reference,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      serverSeq: data.serverSeq.present ? data.serverSeq.value : this.serverSeq,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalSalePayment(')
          ..write('id: $id, ')
          ..write('businessId: $businessId, ')
          ..write('depotId: $depotId, ')
          ..write('saleId: $saleId, ')
          ..write('deviceId: $deviceId, ')
          ..write('method: $method, ')
          ..write('amount: $amount, ')
          ..write('reference: $reference, ')
          ..write('deleted: $deleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverSeq: $serverSeq')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, businessId, depotId, saleId, deviceId,
      method, amount, reference, deleted, createdAt, updatedAt, serverSeq);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalSalePayment &&
          other.id == this.id &&
          other.businessId == this.businessId &&
          other.depotId == this.depotId &&
          other.saleId == this.saleId &&
          other.deviceId == this.deviceId &&
          other.method == this.method &&
          other.amount == this.amount &&
          other.reference == this.reference &&
          other.deleted == this.deleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.serverSeq == this.serverSeq);
}

class LocalSalePaymentsCompanion extends UpdateCompanion<LocalSalePayment> {
  final Value<String> id;
  final Value<String> businessId;
  final Value<String> depotId;
  final Value<String> saleId;
  final Value<String> deviceId;
  final Value<String> method;
  final Value<int> amount;
  final Value<String?> reference;
  final Value<bool> deleted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> serverSeq;
  final Value<int> rowid;
  const LocalSalePaymentsCompanion({
    this.id = const Value.absent(),
    this.businessId = const Value.absent(),
    this.depotId = const Value.absent(),
    this.saleId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.method = const Value.absent(),
    this.amount = const Value.absent(),
    this.reference = const Value.absent(),
    this.deleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverSeq = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalSalePaymentsCompanion.insert({
    required String id,
    required String businessId,
    required String depotId,
    required String saleId,
    required String deviceId,
    required String method,
    required int amount,
    this.reference = const Value.absent(),
    this.deleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverSeq = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        businessId = Value(businessId),
        depotId = Value(depotId),
        saleId = Value(saleId),
        deviceId = Value(deviceId),
        method = Value(method),
        amount = Value(amount);
  static Insertable<LocalSalePayment> custom({
    Expression<String>? id,
    Expression<String>? businessId,
    Expression<String>? depotId,
    Expression<String>? saleId,
    Expression<String>? deviceId,
    Expression<String>? method,
    Expression<int>? amount,
    Expression<String>? reference,
    Expression<bool>? deleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? serverSeq,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (businessId != null) 'business_id': businessId,
      if (depotId != null) 'depot_id': depotId,
      if (saleId != null) 'sale_id': saleId,
      if (deviceId != null) 'device_id': deviceId,
      if (method != null) 'method': method,
      if (amount != null) 'amount': amount,
      if (reference != null) 'reference': reference,
      if (deleted != null) 'deleted': deleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (serverSeq != null) 'server_seq': serverSeq,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalSalePaymentsCompanion copyWith(
      {Value<String>? id,
      Value<String>? businessId,
      Value<String>? depotId,
      Value<String>? saleId,
      Value<String>? deviceId,
      Value<String>? method,
      Value<int>? amount,
      Value<String?>? reference,
      Value<bool>? deleted,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? serverSeq,
      Value<int>? rowid}) {
    return LocalSalePaymentsCompanion(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      depotId: depotId ?? this.depotId,
      saleId: saleId ?? this.saleId,
      deviceId: deviceId ?? this.deviceId,
      method: method ?? this.method,
      amount: amount ?? this.amount,
      reference: reference ?? this.reference,
      deleted: deleted ?? this.deleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      serverSeq: serverSeq ?? this.serverSeq,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (businessId.present) {
      map['business_id'] = Variable<String>(businessId.value);
    }
    if (depotId.present) {
      map['depot_id'] = Variable<String>(depotId.value);
    }
    if (saleId.present) {
      map['sale_id'] = Variable<String>(saleId.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (serverSeq.present) {
      map['server_seq'] = Variable<int>(serverSeq.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalSalePaymentsCompanion(')
          ..write('id: $id, ')
          ..write('businessId: $businessId, ')
          ..write('depotId: $depotId, ')
          ..write('saleId: $saleId, ')
          ..write('deviceId: $deviceId, ')
          ..write('method: $method, ')
          ..write('amount: $amount, ')
          ..write('reference: $reference, ')
          ..write('deleted: $deleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverSeq: $serverSeq, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalStockMovementsTable extends LocalStockMovements
    with TableInfo<$LocalStockMovementsTable, LocalStockMovement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalStockMovementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _businessIdMeta =
      const VerificationMeta('businessId');
  @override
  late final GeneratedColumn<String> businessId = GeneratedColumn<String>(
      'business_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _depotIdMeta =
      const VerificationMeta('depotId');
  @override
  late final GeneratedColumn<String> depotId = GeneratedColumn<String>(
      'depot_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
      'product_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _qtyInBaseMeta =
      const VerificationMeta('qtyInBase');
  @override
  late final GeneratedColumn<int> qtyInBase = GeneratedColumn<int>(
      'qty_in_base', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
      'reason', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _refDocIdMeta =
      const VerificationMeta('refDocId');
  @override
  late final GeneratedColumn<String> refDocId = GeneratedColumn<String>(
      'ref_doc_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _refDocTypeMeta =
      const VerificationMeta('refDocType');
  @override
  late final GeneratedColumn<String> refDocType = GeneratedColumn<String>(
      'ref_doc_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _deletedMeta =
      const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _serverSeqMeta =
      const VerificationMeta('serverSeq');
  @override
  late final GeneratedColumn<int> serverSeq = GeneratedColumn<int>(
      'server_seq', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        businessId,
        depotId,
        productId,
        userId,
        deviceId,
        type,
        qtyInBase,
        reason,
        refDocId,
        refDocType,
        deleted,
        createdAt,
        updatedAt,
        serverSeq
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_stock_movements';
  @override
  VerificationContext validateIntegrity(Insertable<LocalStockMovement> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('business_id')) {
      context.handle(
          _businessIdMeta,
          businessId.isAcceptableOrUnknown(
              data['business_id']!, _businessIdMeta));
    } else if (isInserting) {
      context.missing(_businessIdMeta);
    }
    if (data.containsKey('depot_id')) {
      context.handle(_depotIdMeta,
          depotId.isAcceptableOrUnknown(data['depot_id']!, _depotIdMeta));
    } else if (isInserting) {
      context.missing(_depotIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('qty_in_base')) {
      context.handle(
          _qtyInBaseMeta,
          qtyInBase.isAcceptableOrUnknown(
              data['qty_in_base']!, _qtyInBaseMeta));
    } else if (isInserting) {
      context.missing(_qtyInBaseMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(_reasonMeta,
          reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta));
    }
    if (data.containsKey('ref_doc_id')) {
      context.handle(_refDocIdMeta,
          refDocId.isAcceptableOrUnknown(data['ref_doc_id']!, _refDocIdMeta));
    }
    if (data.containsKey('ref_doc_type')) {
      context.handle(
          _refDocTypeMeta,
          refDocType.isAcceptableOrUnknown(
              data['ref_doc_type']!, _refDocTypeMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('server_seq')) {
      context.handle(_serverSeqMeta,
          serverSeq.isAcceptableOrUnknown(data['server_seq']!, _serverSeqMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalStockMovement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalStockMovement(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      businessId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}business_id'])!,
      depotId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}depot_id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      qtyInBase: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}qty_in_base'])!,
      reason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reason']),
      refDocId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ref_doc_id']),
      refDocType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ref_doc_type']),
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      serverSeq: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}server_seq'])!,
    );
  }

  @override
  $LocalStockMovementsTable createAlias(String alias) {
    return $LocalStockMovementsTable(attachedDatabase, alias);
  }
}

class LocalStockMovement extends DataClass
    implements Insertable<LocalStockMovement> {
  final String id;
  final String businessId;
  final String depotId;
  final String productId;
  final String userId;
  final String deviceId;
  final String type;
  final int qtyInBase;
  final String? reason;
  final String? refDocId;
  final String? refDocType;
  final bool deleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int serverSeq;
  const LocalStockMovement(
      {required this.id,
      required this.businessId,
      required this.depotId,
      required this.productId,
      required this.userId,
      required this.deviceId,
      required this.type,
      required this.qtyInBase,
      this.reason,
      this.refDocId,
      this.refDocType,
      required this.deleted,
      required this.createdAt,
      required this.updatedAt,
      required this.serverSeq});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['business_id'] = Variable<String>(businessId);
    map['depot_id'] = Variable<String>(depotId);
    map['product_id'] = Variable<String>(productId);
    map['user_id'] = Variable<String>(userId);
    map['device_id'] = Variable<String>(deviceId);
    map['type'] = Variable<String>(type);
    map['qty_in_base'] = Variable<int>(qtyInBase);
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    if (!nullToAbsent || refDocId != null) {
      map['ref_doc_id'] = Variable<String>(refDocId);
    }
    if (!nullToAbsent || refDocType != null) {
      map['ref_doc_type'] = Variable<String>(refDocType);
    }
    map['deleted'] = Variable<bool>(deleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['server_seq'] = Variable<int>(serverSeq);
    return map;
  }

  LocalStockMovementsCompanion toCompanion(bool nullToAbsent) {
    return LocalStockMovementsCompanion(
      id: Value(id),
      businessId: Value(businessId),
      depotId: Value(depotId),
      productId: Value(productId),
      userId: Value(userId),
      deviceId: Value(deviceId),
      type: Value(type),
      qtyInBase: Value(qtyInBase),
      reason:
          reason == null && nullToAbsent ? const Value.absent() : Value(reason),
      refDocId: refDocId == null && nullToAbsent
          ? const Value.absent()
          : Value(refDocId),
      refDocType: refDocType == null && nullToAbsent
          ? const Value.absent()
          : Value(refDocType),
      deleted: Value(deleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      serverSeq: Value(serverSeq),
    );
  }

  factory LocalStockMovement.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalStockMovement(
      id: serializer.fromJson<String>(json['id']),
      businessId: serializer.fromJson<String>(json['businessId']),
      depotId: serializer.fromJson<String>(json['depotId']),
      productId: serializer.fromJson<String>(json['productId']),
      userId: serializer.fromJson<String>(json['userId']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      type: serializer.fromJson<String>(json['type']),
      qtyInBase: serializer.fromJson<int>(json['qtyInBase']),
      reason: serializer.fromJson<String?>(json['reason']),
      refDocId: serializer.fromJson<String?>(json['refDocId']),
      refDocType: serializer.fromJson<String?>(json['refDocType']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      serverSeq: serializer.fromJson<int>(json['serverSeq']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'businessId': serializer.toJson<String>(businessId),
      'depotId': serializer.toJson<String>(depotId),
      'productId': serializer.toJson<String>(productId),
      'userId': serializer.toJson<String>(userId),
      'deviceId': serializer.toJson<String>(deviceId),
      'type': serializer.toJson<String>(type),
      'qtyInBase': serializer.toJson<int>(qtyInBase),
      'reason': serializer.toJson<String?>(reason),
      'refDocId': serializer.toJson<String?>(refDocId),
      'refDocType': serializer.toJson<String?>(refDocType),
      'deleted': serializer.toJson<bool>(deleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'serverSeq': serializer.toJson<int>(serverSeq),
    };
  }

  LocalStockMovement copyWith(
          {String? id,
          String? businessId,
          String? depotId,
          String? productId,
          String? userId,
          String? deviceId,
          String? type,
          int? qtyInBase,
          Value<String?> reason = const Value.absent(),
          Value<String?> refDocId = const Value.absent(),
          Value<String?> refDocType = const Value.absent(),
          bool? deleted,
          DateTime? createdAt,
          DateTime? updatedAt,
          int? serverSeq}) =>
      LocalStockMovement(
        id: id ?? this.id,
        businessId: businessId ?? this.businessId,
        depotId: depotId ?? this.depotId,
        productId: productId ?? this.productId,
        userId: userId ?? this.userId,
        deviceId: deviceId ?? this.deviceId,
        type: type ?? this.type,
        qtyInBase: qtyInBase ?? this.qtyInBase,
        reason: reason.present ? reason.value : this.reason,
        refDocId: refDocId.present ? refDocId.value : this.refDocId,
        refDocType: refDocType.present ? refDocType.value : this.refDocType,
        deleted: deleted ?? this.deleted,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        serverSeq: serverSeq ?? this.serverSeq,
      );
  LocalStockMovement copyWithCompanion(LocalStockMovementsCompanion data) {
    return LocalStockMovement(
      id: data.id.present ? data.id.value : this.id,
      businessId:
          data.businessId.present ? data.businessId.value : this.businessId,
      depotId: data.depotId.present ? data.depotId.value : this.depotId,
      productId: data.productId.present ? data.productId.value : this.productId,
      userId: data.userId.present ? data.userId.value : this.userId,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      type: data.type.present ? data.type.value : this.type,
      qtyInBase: data.qtyInBase.present ? data.qtyInBase.value : this.qtyInBase,
      reason: data.reason.present ? data.reason.value : this.reason,
      refDocId: data.refDocId.present ? data.refDocId.value : this.refDocId,
      refDocType:
          data.refDocType.present ? data.refDocType.value : this.refDocType,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      serverSeq: data.serverSeq.present ? data.serverSeq.value : this.serverSeq,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalStockMovement(')
          ..write('id: $id, ')
          ..write('businessId: $businessId, ')
          ..write('depotId: $depotId, ')
          ..write('productId: $productId, ')
          ..write('userId: $userId, ')
          ..write('deviceId: $deviceId, ')
          ..write('type: $type, ')
          ..write('qtyInBase: $qtyInBase, ')
          ..write('reason: $reason, ')
          ..write('refDocId: $refDocId, ')
          ..write('refDocType: $refDocType, ')
          ..write('deleted: $deleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverSeq: $serverSeq')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      businessId,
      depotId,
      productId,
      userId,
      deviceId,
      type,
      qtyInBase,
      reason,
      refDocId,
      refDocType,
      deleted,
      createdAt,
      updatedAt,
      serverSeq);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalStockMovement &&
          other.id == this.id &&
          other.businessId == this.businessId &&
          other.depotId == this.depotId &&
          other.productId == this.productId &&
          other.userId == this.userId &&
          other.deviceId == this.deviceId &&
          other.type == this.type &&
          other.qtyInBase == this.qtyInBase &&
          other.reason == this.reason &&
          other.refDocId == this.refDocId &&
          other.refDocType == this.refDocType &&
          other.deleted == this.deleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.serverSeq == this.serverSeq);
}

class LocalStockMovementsCompanion extends UpdateCompanion<LocalStockMovement> {
  final Value<String> id;
  final Value<String> businessId;
  final Value<String> depotId;
  final Value<String> productId;
  final Value<String> userId;
  final Value<String> deviceId;
  final Value<String> type;
  final Value<int> qtyInBase;
  final Value<String?> reason;
  final Value<String?> refDocId;
  final Value<String?> refDocType;
  final Value<bool> deleted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> serverSeq;
  final Value<int> rowid;
  const LocalStockMovementsCompanion({
    this.id = const Value.absent(),
    this.businessId = const Value.absent(),
    this.depotId = const Value.absent(),
    this.productId = const Value.absent(),
    this.userId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.type = const Value.absent(),
    this.qtyInBase = const Value.absent(),
    this.reason = const Value.absent(),
    this.refDocId = const Value.absent(),
    this.refDocType = const Value.absent(),
    this.deleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverSeq = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalStockMovementsCompanion.insert({
    required String id,
    required String businessId,
    required String depotId,
    required String productId,
    required String userId,
    required String deviceId,
    required String type,
    required int qtyInBase,
    this.reason = const Value.absent(),
    this.refDocId = const Value.absent(),
    this.refDocType = const Value.absent(),
    this.deleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverSeq = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        businessId = Value(businessId),
        depotId = Value(depotId),
        productId = Value(productId),
        userId = Value(userId),
        deviceId = Value(deviceId),
        type = Value(type),
        qtyInBase = Value(qtyInBase);
  static Insertable<LocalStockMovement> custom({
    Expression<String>? id,
    Expression<String>? businessId,
    Expression<String>? depotId,
    Expression<String>? productId,
    Expression<String>? userId,
    Expression<String>? deviceId,
    Expression<String>? type,
    Expression<int>? qtyInBase,
    Expression<String>? reason,
    Expression<String>? refDocId,
    Expression<String>? refDocType,
    Expression<bool>? deleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? serverSeq,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (businessId != null) 'business_id': businessId,
      if (depotId != null) 'depot_id': depotId,
      if (productId != null) 'product_id': productId,
      if (userId != null) 'user_id': userId,
      if (deviceId != null) 'device_id': deviceId,
      if (type != null) 'type': type,
      if (qtyInBase != null) 'qty_in_base': qtyInBase,
      if (reason != null) 'reason': reason,
      if (refDocId != null) 'ref_doc_id': refDocId,
      if (refDocType != null) 'ref_doc_type': refDocType,
      if (deleted != null) 'deleted': deleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (serverSeq != null) 'server_seq': serverSeq,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalStockMovementsCompanion copyWith(
      {Value<String>? id,
      Value<String>? businessId,
      Value<String>? depotId,
      Value<String>? productId,
      Value<String>? userId,
      Value<String>? deviceId,
      Value<String>? type,
      Value<int>? qtyInBase,
      Value<String?>? reason,
      Value<String?>? refDocId,
      Value<String?>? refDocType,
      Value<bool>? deleted,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? serverSeq,
      Value<int>? rowid}) {
    return LocalStockMovementsCompanion(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      depotId: depotId ?? this.depotId,
      productId: productId ?? this.productId,
      userId: userId ?? this.userId,
      deviceId: deviceId ?? this.deviceId,
      type: type ?? this.type,
      qtyInBase: qtyInBase ?? this.qtyInBase,
      reason: reason ?? this.reason,
      refDocId: refDocId ?? this.refDocId,
      refDocType: refDocType ?? this.refDocType,
      deleted: deleted ?? this.deleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      serverSeq: serverSeq ?? this.serverSeq,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (businessId.present) {
      map['business_id'] = Variable<String>(businessId.value);
    }
    if (depotId.present) {
      map['depot_id'] = Variable<String>(depotId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (qtyInBase.present) {
      map['qty_in_base'] = Variable<int>(qtyInBase.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (refDocId.present) {
      map['ref_doc_id'] = Variable<String>(refDocId.value);
    }
    if (refDocType.present) {
      map['ref_doc_type'] = Variable<String>(refDocType.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (serverSeq.present) {
      map['server_seq'] = Variable<int>(serverSeq.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalStockMovementsCompanion(')
          ..write('id: $id, ')
          ..write('businessId: $businessId, ')
          ..write('depotId: $depotId, ')
          ..write('productId: $productId, ')
          ..write('userId: $userId, ')
          ..write('deviceId: $deviceId, ')
          ..write('type: $type, ')
          ..write('qtyInBase: $qtyInBase, ')
          ..write('reason: $reason, ')
          ..write('refDocId: $refDocId, ')
          ..write('refDocType: $refDocType, ')
          ..write('deleted: $deleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverSeq: $serverSeq, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalCustomerPaymentsTable extends LocalCustomerPayments
    with TableInfo<$LocalCustomerPaymentsTable, LocalCustomerPayment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalCustomerPaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _businessIdMeta =
      const VerificationMeta('businessId');
  @override
  late final GeneratedColumn<String> businessId = GeneratedColumn<String>(
      'business_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _depotIdMeta =
      const VerificationMeta('depotId');
  @override
  late final GeneratedColumn<String> depotId = GeneratedColumn<String>(
      'depot_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _customerIdMeta =
      const VerificationMeta('customerId');
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
      'customer_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
      'amount', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
      'method', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _referenceMeta =
      const VerificationMeta('reference');
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
      'reference', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _deletedMeta =
      const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
      'deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _serverSeqMeta =
      const VerificationMeta('serverSeq');
  @override
  late final GeneratedColumn<int> serverSeq = GeneratedColumn<int>(
      'server_seq', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        businessId,
        depotId,
        customerId,
        userId,
        deviceId,
        amount,
        method,
        reference,
        deleted,
        createdAt,
        updatedAt,
        serverSeq
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_customer_payments';
  @override
  VerificationContext validateIntegrity(
      Insertable<LocalCustomerPayment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('business_id')) {
      context.handle(
          _businessIdMeta,
          businessId.isAcceptableOrUnknown(
              data['business_id']!, _businessIdMeta));
    } else if (isInserting) {
      context.missing(_businessIdMeta);
    }
    if (data.containsKey('depot_id')) {
      context.handle(_depotIdMeta,
          depotId.isAcceptableOrUnknown(data['depot_id']!, _depotIdMeta));
    } else if (isInserting) {
      context.missing(_depotIdMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
          _customerIdMeta,
          customerId.isAcceptableOrUnknown(
              data['customer_id']!, _customerIdMeta));
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('method')) {
      context.handle(_methodMeta,
          method.isAcceptableOrUnknown(data['method']!, _methodMeta));
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('reference')) {
      context.handle(_referenceMeta,
          reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta,
          deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('server_seq')) {
      context.handle(_serverSeqMeta,
          serverSeq.isAcceptableOrUnknown(data['server_seq']!, _serverSeqMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalCustomerPayment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalCustomerPayment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      businessId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}business_id'])!,
      depotId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}depot_id'])!,
      customerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount'])!,
      method: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}method'])!,
      reference: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reference']),
      deleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      serverSeq: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}server_seq'])!,
    );
  }

  @override
  $LocalCustomerPaymentsTable createAlias(String alias) {
    return $LocalCustomerPaymentsTable(attachedDatabase, alias);
  }
}

class LocalCustomerPayment extends DataClass
    implements Insertable<LocalCustomerPayment> {
  final String id;
  final String businessId;
  final String depotId;
  final String customerId;
  final String userId;
  final String deviceId;
  final int amount;
  final String method;
  final String? reference;
  final bool deleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int serverSeq;
  const LocalCustomerPayment(
      {required this.id,
      required this.businessId,
      required this.depotId,
      required this.customerId,
      required this.userId,
      required this.deviceId,
      required this.amount,
      required this.method,
      this.reference,
      required this.deleted,
      required this.createdAt,
      required this.updatedAt,
      required this.serverSeq});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['business_id'] = Variable<String>(businessId);
    map['depot_id'] = Variable<String>(depotId);
    map['customer_id'] = Variable<String>(customerId);
    map['user_id'] = Variable<String>(userId);
    map['device_id'] = Variable<String>(deviceId);
    map['amount'] = Variable<int>(amount);
    map['method'] = Variable<String>(method);
    if (!nullToAbsent || reference != null) {
      map['reference'] = Variable<String>(reference);
    }
    map['deleted'] = Variable<bool>(deleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['server_seq'] = Variable<int>(serverSeq);
    return map;
  }

  LocalCustomerPaymentsCompanion toCompanion(bool nullToAbsent) {
    return LocalCustomerPaymentsCompanion(
      id: Value(id),
      businessId: Value(businessId),
      depotId: Value(depotId),
      customerId: Value(customerId),
      userId: Value(userId),
      deviceId: Value(deviceId),
      amount: Value(amount),
      method: Value(method),
      reference: reference == null && nullToAbsent
          ? const Value.absent()
          : Value(reference),
      deleted: Value(deleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      serverSeq: Value(serverSeq),
    );
  }

  factory LocalCustomerPayment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalCustomerPayment(
      id: serializer.fromJson<String>(json['id']),
      businessId: serializer.fromJson<String>(json['businessId']),
      depotId: serializer.fromJson<String>(json['depotId']),
      customerId: serializer.fromJson<String>(json['customerId']),
      userId: serializer.fromJson<String>(json['userId']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      amount: serializer.fromJson<int>(json['amount']),
      method: serializer.fromJson<String>(json['method']),
      reference: serializer.fromJson<String?>(json['reference']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      serverSeq: serializer.fromJson<int>(json['serverSeq']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'businessId': serializer.toJson<String>(businessId),
      'depotId': serializer.toJson<String>(depotId),
      'customerId': serializer.toJson<String>(customerId),
      'userId': serializer.toJson<String>(userId),
      'deviceId': serializer.toJson<String>(deviceId),
      'amount': serializer.toJson<int>(amount),
      'method': serializer.toJson<String>(method),
      'reference': serializer.toJson<String?>(reference),
      'deleted': serializer.toJson<bool>(deleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'serverSeq': serializer.toJson<int>(serverSeq),
    };
  }

  LocalCustomerPayment copyWith(
          {String? id,
          String? businessId,
          String? depotId,
          String? customerId,
          String? userId,
          String? deviceId,
          int? amount,
          String? method,
          Value<String?> reference = const Value.absent(),
          bool? deleted,
          DateTime? createdAt,
          DateTime? updatedAt,
          int? serverSeq}) =>
      LocalCustomerPayment(
        id: id ?? this.id,
        businessId: businessId ?? this.businessId,
        depotId: depotId ?? this.depotId,
        customerId: customerId ?? this.customerId,
        userId: userId ?? this.userId,
        deviceId: deviceId ?? this.deviceId,
        amount: amount ?? this.amount,
        method: method ?? this.method,
        reference: reference.present ? reference.value : this.reference,
        deleted: deleted ?? this.deleted,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        serverSeq: serverSeq ?? this.serverSeq,
      );
  LocalCustomerPayment copyWithCompanion(LocalCustomerPaymentsCompanion data) {
    return LocalCustomerPayment(
      id: data.id.present ? data.id.value : this.id,
      businessId:
          data.businessId.present ? data.businessId.value : this.businessId,
      depotId: data.depotId.present ? data.depotId.value : this.depotId,
      customerId:
          data.customerId.present ? data.customerId.value : this.customerId,
      userId: data.userId.present ? data.userId.value : this.userId,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      amount: data.amount.present ? data.amount.value : this.amount,
      method: data.method.present ? data.method.value : this.method,
      reference: data.reference.present ? data.reference.value : this.reference,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      serverSeq: data.serverSeq.present ? data.serverSeq.value : this.serverSeq,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalCustomerPayment(')
          ..write('id: $id, ')
          ..write('businessId: $businessId, ')
          ..write('depotId: $depotId, ')
          ..write('customerId: $customerId, ')
          ..write('userId: $userId, ')
          ..write('deviceId: $deviceId, ')
          ..write('amount: $amount, ')
          ..write('method: $method, ')
          ..write('reference: $reference, ')
          ..write('deleted: $deleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverSeq: $serverSeq')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      businessId,
      depotId,
      customerId,
      userId,
      deviceId,
      amount,
      method,
      reference,
      deleted,
      createdAt,
      updatedAt,
      serverSeq);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalCustomerPayment &&
          other.id == this.id &&
          other.businessId == this.businessId &&
          other.depotId == this.depotId &&
          other.customerId == this.customerId &&
          other.userId == this.userId &&
          other.deviceId == this.deviceId &&
          other.amount == this.amount &&
          other.method == this.method &&
          other.reference == this.reference &&
          other.deleted == this.deleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.serverSeq == this.serverSeq);
}

class LocalCustomerPaymentsCompanion
    extends UpdateCompanion<LocalCustomerPayment> {
  final Value<String> id;
  final Value<String> businessId;
  final Value<String> depotId;
  final Value<String> customerId;
  final Value<String> userId;
  final Value<String> deviceId;
  final Value<int> amount;
  final Value<String> method;
  final Value<String?> reference;
  final Value<bool> deleted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> serverSeq;
  final Value<int> rowid;
  const LocalCustomerPaymentsCompanion({
    this.id = const Value.absent(),
    this.businessId = const Value.absent(),
    this.depotId = const Value.absent(),
    this.customerId = const Value.absent(),
    this.userId = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.amount = const Value.absent(),
    this.method = const Value.absent(),
    this.reference = const Value.absent(),
    this.deleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverSeq = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalCustomerPaymentsCompanion.insert({
    required String id,
    required String businessId,
    required String depotId,
    required String customerId,
    required String userId,
    required String deviceId,
    required int amount,
    required String method,
    this.reference = const Value.absent(),
    this.deleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.serverSeq = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        businessId = Value(businessId),
        depotId = Value(depotId),
        customerId = Value(customerId),
        userId = Value(userId),
        deviceId = Value(deviceId),
        amount = Value(amount),
        method = Value(method);
  static Insertable<LocalCustomerPayment> custom({
    Expression<String>? id,
    Expression<String>? businessId,
    Expression<String>? depotId,
    Expression<String>? customerId,
    Expression<String>? userId,
    Expression<String>? deviceId,
    Expression<int>? amount,
    Expression<String>? method,
    Expression<String>? reference,
    Expression<bool>? deleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? serverSeq,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (businessId != null) 'business_id': businessId,
      if (depotId != null) 'depot_id': depotId,
      if (customerId != null) 'customer_id': customerId,
      if (userId != null) 'user_id': userId,
      if (deviceId != null) 'device_id': deviceId,
      if (amount != null) 'amount': amount,
      if (method != null) 'method': method,
      if (reference != null) 'reference': reference,
      if (deleted != null) 'deleted': deleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (serverSeq != null) 'server_seq': serverSeq,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalCustomerPaymentsCompanion copyWith(
      {Value<String>? id,
      Value<String>? businessId,
      Value<String>? depotId,
      Value<String>? customerId,
      Value<String>? userId,
      Value<String>? deviceId,
      Value<int>? amount,
      Value<String>? method,
      Value<String?>? reference,
      Value<bool>? deleted,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? serverSeq,
      Value<int>? rowid}) {
    return LocalCustomerPaymentsCompanion(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      depotId: depotId ?? this.depotId,
      customerId: customerId ?? this.customerId,
      userId: userId ?? this.userId,
      deviceId: deviceId ?? this.deviceId,
      amount: amount ?? this.amount,
      method: method ?? this.method,
      reference: reference ?? this.reference,
      deleted: deleted ?? this.deleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      serverSeq: serverSeq ?? this.serverSeq,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (businessId.present) {
      map['business_id'] = Variable<String>(businessId.value);
    }
    if (depotId.present) {
      map['depot_id'] = Variable<String>(depotId.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (serverSeq.present) {
      map['server_seq'] = Variable<int>(serverSeq.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalCustomerPaymentsCompanion(')
          ..write('id: $id, ')
          ..write('businessId: $businessId, ')
          ..write('depotId: $depotId, ')
          ..write('customerId: $customerId, ')
          ..write('userId: $userId, ')
          ..write('deviceId: $deviceId, ')
          ..write('amount: $amount, ')
          ..write('method: $method, ')
          ..write('reference: $reference, ')
          ..write('deleted: $deleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('serverSeq: $serverSeq, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SyncOutboxTable syncOutbox = $SyncOutboxTable(this);
  late final $SyncStateTable syncState = $SyncStateTable(this);
  late final $LocalBusinessesTable localBusinesses =
      $LocalBusinessesTable(this);
  late final $LocalDepotsTable localDepots = $LocalDepotsTable(this);
  late final $LocalUsersTable localUsers = $LocalUsersTable(this);
  late final $LocalCategoriesTable localCategories =
      $LocalCategoriesTable(this);
  late final $LocalProductsTable localProducts = $LocalProductsTable(this);
  late final $LocalProductUnitsTable localProductUnits =
      $LocalProductUnitsTable(this);
  late final $LocalProductStockLevelsTable localProductStockLevels =
      $LocalProductStockLevelsTable(this);
  late final $LocalCustomersTable localCustomers = $LocalCustomersTable(this);
  late final $LocalSalesTable localSales = $LocalSalesTable(this);
  late final $LocalSaleLinesTable localSaleLines = $LocalSaleLinesTable(this);
  late final $LocalSalePaymentsTable localSalePayments =
      $LocalSalePaymentsTable(this);
  late final $LocalStockMovementsTable localStockMovements =
      $LocalStockMovementsTable(this);
  late final $LocalCustomerPaymentsTable localCustomerPayments =
      $LocalCustomerPaymentsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        syncOutbox,
        syncState,
        localBusinesses,
        localDepots,
        localUsers,
        localCategories,
        localProducts,
        localProductUnits,
        localProductStockLevels,
        localCustomers,
        localSales,
        localSaleLines,
        localSalePayments,
        localStockMovements,
        localCustomerPayments
      ];
}

typedef $$SyncOutboxTableCreateCompanionBuilder = SyncOutboxCompanion Function({
  required String id,
  required String tableRef,
  required String data,
  Value<bool> rejected,
  Value<String?> rejectReason,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$SyncOutboxTableUpdateCompanionBuilder = SyncOutboxCompanion Function({
  Value<String> id,
  Value<String> tableRef,
  Value<String> data,
  Value<bool> rejected,
  Value<String?> rejectReason,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$SyncOutboxTableFilterComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tableRef => $composableBuilder(
      column: $table.tableRef, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get rejected => $composableBuilder(
      column: $table.rejected, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rejectReason => $composableBuilder(
      column: $table.rejectReason, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$SyncOutboxTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tableRef => $composableBuilder(
      column: $table.tableRef, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get rejected => $composableBuilder(
      column: $table.rejected, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rejectReason => $composableBuilder(
      column: $table.rejectReason,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$SyncOutboxTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tableRef =>
      $composableBuilder(column: $table.tableRef, builder: (column) => column);

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<bool> get rejected =>
      $composableBuilder(column: $table.rejected, builder: (column) => column);

  GeneratedColumn<String> get rejectReason => $composableBuilder(
      column: $table.rejectReason, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SyncOutboxTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncOutboxTable,
    SyncOutboxData,
    $$SyncOutboxTableFilterComposer,
    $$SyncOutboxTableOrderingComposer,
    $$SyncOutboxTableAnnotationComposer,
    $$SyncOutboxTableCreateCompanionBuilder,
    $$SyncOutboxTableUpdateCompanionBuilder,
    (
      SyncOutboxData,
      BaseReferences<_$AppDatabase, $SyncOutboxTable, SyncOutboxData>
    ),
    SyncOutboxData,
    PrefetchHooks Function()> {
  $$SyncOutboxTableTableManager(_$AppDatabase db, $SyncOutboxTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncOutboxTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncOutboxTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncOutboxTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> tableRef = const Value.absent(),
            Value<String> data = const Value.absent(),
            Value<bool> rejected = const Value.absent(),
            Value<String?> rejectReason = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncOutboxCompanion(
            id: id,
            tableRef: tableRef,
            data: data,
            rejected: rejected,
            rejectReason: rejectReason,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String tableRef,
            required String data,
            Value<bool> rejected = const Value.absent(),
            Value<String?> rejectReason = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncOutboxCompanion.insert(
            id: id,
            tableRef: tableRef,
            data: data,
            rejected: rejected,
            rejectReason: rejectReason,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncOutboxTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncOutboxTable,
    SyncOutboxData,
    $$SyncOutboxTableFilterComposer,
    $$SyncOutboxTableOrderingComposer,
    $$SyncOutboxTableAnnotationComposer,
    $$SyncOutboxTableCreateCompanionBuilder,
    $$SyncOutboxTableUpdateCompanionBuilder,
    (
      SyncOutboxData,
      BaseReferences<_$AppDatabase, $SyncOutboxTable, SyncOutboxData>
    ),
    SyncOutboxData,
    PrefetchHooks Function()>;
typedef $$SyncStateTableCreateCompanionBuilder = SyncStateCompanion Function({
  Value<int> id,
  required String deviceId,
  required String businessId,
  required String depotId,
  required String accessToken,
  required String refreshToken,
  Value<int> syncCursor,
  Value<int> clockOffsetMs,
  Value<DateTime?> lastSyncAt,
});
typedef $$SyncStateTableUpdateCompanionBuilder = SyncStateCompanion Function({
  Value<int> id,
  Value<String> deviceId,
  Value<String> businessId,
  Value<String> depotId,
  Value<String> accessToken,
  Value<String> refreshToken,
  Value<int> syncCursor,
  Value<int> clockOffsetMs,
  Value<DateTime?> lastSyncAt,
});

class $$SyncStateTableFilterComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get businessId => $composableBuilder(
      column: $table.businessId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get depotId => $composableBuilder(
      column: $table.depotId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accessToken => $composableBuilder(
      column: $table.accessToken, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get refreshToken => $composableBuilder(
      column: $table.refreshToken, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get syncCursor => $composableBuilder(
      column: $table.syncCursor, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get clockOffsetMs => $composableBuilder(
      column: $table.clockOffsetMs, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSyncAt => $composableBuilder(
      column: $table.lastSyncAt, builder: (column) => ColumnFilters(column));
}

class $$SyncStateTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get businessId => $composableBuilder(
      column: $table.businessId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get depotId => $composableBuilder(
      column: $table.depotId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accessToken => $composableBuilder(
      column: $table.accessToken, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get refreshToken => $composableBuilder(
      column: $table.refreshToken,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get syncCursor => $composableBuilder(
      column: $table.syncCursor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get clockOffsetMs => $composableBuilder(
      column: $table.clockOffsetMs,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSyncAt => $composableBuilder(
      column: $table.lastSyncAt, builder: (column) => ColumnOrderings(column));
}

class $$SyncStateTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get businessId => $composableBuilder(
      column: $table.businessId, builder: (column) => column);

  GeneratedColumn<String> get depotId =>
      $composableBuilder(column: $table.depotId, builder: (column) => column);

  GeneratedColumn<String> get accessToken => $composableBuilder(
      column: $table.accessToken, builder: (column) => column);

  GeneratedColumn<String> get refreshToken => $composableBuilder(
      column: $table.refreshToken, builder: (column) => column);

  GeneratedColumn<int> get syncCursor => $composableBuilder(
      column: $table.syncCursor, builder: (column) => column);

  GeneratedColumn<int> get clockOffsetMs => $composableBuilder(
      column: $table.clockOffsetMs, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncAt => $composableBuilder(
      column: $table.lastSyncAt, builder: (column) => column);
}

class $$SyncStateTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncStateTable,
    SyncStateData,
    $$SyncStateTableFilterComposer,
    $$SyncStateTableOrderingComposer,
    $$SyncStateTableAnnotationComposer,
    $$SyncStateTableCreateCompanionBuilder,
    $$SyncStateTableUpdateCompanionBuilder,
    (
      SyncStateData,
      BaseReferences<_$AppDatabase, $SyncStateTable, SyncStateData>
    ),
    SyncStateData,
    PrefetchHooks Function()> {
  $$SyncStateTableTableManager(_$AppDatabase db, $SyncStateTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncStateTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncStateTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncStateTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> deviceId = const Value.absent(),
            Value<String> businessId = const Value.absent(),
            Value<String> depotId = const Value.absent(),
            Value<String> accessToken = const Value.absent(),
            Value<String> refreshToken = const Value.absent(),
            Value<int> syncCursor = const Value.absent(),
            Value<int> clockOffsetMs = const Value.absent(),
            Value<DateTime?> lastSyncAt = const Value.absent(),
          }) =>
              SyncStateCompanion(
            id: id,
            deviceId: deviceId,
            businessId: businessId,
            depotId: depotId,
            accessToken: accessToken,
            refreshToken: refreshToken,
            syncCursor: syncCursor,
            clockOffsetMs: clockOffsetMs,
            lastSyncAt: lastSyncAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String deviceId,
            required String businessId,
            required String depotId,
            required String accessToken,
            required String refreshToken,
            Value<int> syncCursor = const Value.absent(),
            Value<int> clockOffsetMs = const Value.absent(),
            Value<DateTime?> lastSyncAt = const Value.absent(),
          }) =>
              SyncStateCompanion.insert(
            id: id,
            deviceId: deviceId,
            businessId: businessId,
            depotId: depotId,
            accessToken: accessToken,
            refreshToken: refreshToken,
            syncCursor: syncCursor,
            clockOffsetMs: clockOffsetMs,
            lastSyncAt: lastSyncAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncStateTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncStateTable,
    SyncStateData,
    $$SyncStateTableFilterComposer,
    $$SyncStateTableOrderingComposer,
    $$SyncStateTableAnnotationComposer,
    $$SyncStateTableCreateCompanionBuilder,
    $$SyncStateTableUpdateCompanionBuilder,
    (
      SyncStateData,
      BaseReferences<_$AppDatabase, $SyncStateTable, SyncStateData>
    ),
    SyncStateData,
    PrefetchHooks Function()>;
typedef $$LocalBusinessesTableCreateCompanionBuilder = LocalBusinessesCompanion
    Function({
  required String id,
  required String name,
  Value<String?> logoUrl,
  Value<String?> address,
  Value<String?> phone,
  Value<String?> nif,
  Value<String?> rccm,
  Value<bool> taxEnabled,
  Value<int> taxRate,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$LocalBusinessesTableUpdateCompanionBuilder = LocalBusinessesCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String?> logoUrl,
  Value<String?> address,
  Value<String?> phone,
  Value<String?> nif,
  Value<String?> rccm,
  Value<bool> taxEnabled,
  Value<int> taxRate,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$LocalBusinessesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalBusinessesTable> {
  $$LocalBusinessesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get logoUrl => $composableBuilder(
      column: $table.logoUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nif => $composableBuilder(
      column: $table.nif, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rccm => $composableBuilder(
      column: $table.rccm, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get taxEnabled => $composableBuilder(
      column: $table.taxEnabled, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get taxRate => $composableBuilder(
      column: $table.taxRate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$LocalBusinessesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalBusinessesTable> {
  $$LocalBusinessesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get logoUrl => $composableBuilder(
      column: $table.logoUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nif => $composableBuilder(
      column: $table.nif, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rccm => $composableBuilder(
      column: $table.rccm, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get taxEnabled => $composableBuilder(
      column: $table.taxEnabled, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get taxRate => $composableBuilder(
      column: $table.taxRate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$LocalBusinessesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalBusinessesTable> {
  $$LocalBusinessesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get logoUrl =>
      $composableBuilder(column: $table.logoUrl, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get nif =>
      $composableBuilder(column: $table.nif, builder: (column) => column);

  GeneratedColumn<String> get rccm =>
      $composableBuilder(column: $table.rccm, builder: (column) => column);

  GeneratedColumn<bool> get taxEnabled => $composableBuilder(
      column: $table.taxEnabled, builder: (column) => column);

  GeneratedColumn<int> get taxRate =>
      $composableBuilder(column: $table.taxRate, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocalBusinessesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LocalBusinessesTable,
    LocalBusinessesData,
    $$LocalBusinessesTableFilterComposer,
    $$LocalBusinessesTableOrderingComposer,
    $$LocalBusinessesTableAnnotationComposer,
    $$LocalBusinessesTableCreateCompanionBuilder,
    $$LocalBusinessesTableUpdateCompanionBuilder,
    (
      LocalBusinessesData,
      BaseReferences<_$AppDatabase, $LocalBusinessesTable, LocalBusinessesData>
    ),
    LocalBusinessesData,
    PrefetchHooks Function()> {
  $$LocalBusinessesTableTableManager(
      _$AppDatabase db, $LocalBusinessesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalBusinessesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalBusinessesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalBusinessesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> logoUrl = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> nif = const Value.absent(),
            Value<String?> rccm = const Value.absent(),
            Value<bool> taxEnabled = const Value.absent(),
            Value<int> taxRate = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalBusinessesCompanion(
            id: id,
            name: name,
            logoUrl: logoUrl,
            address: address,
            phone: phone,
            nif: nif,
            rccm: rccm,
            taxEnabled: taxEnabled,
            taxRate: taxRate,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> logoUrl = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> nif = const Value.absent(),
            Value<String?> rccm = const Value.absent(),
            Value<bool> taxEnabled = const Value.absent(),
            Value<int> taxRate = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalBusinessesCompanion.insert(
            id: id,
            name: name,
            logoUrl: logoUrl,
            address: address,
            phone: phone,
            nif: nif,
            rccm: rccm,
            taxEnabled: taxEnabled,
            taxRate: taxRate,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LocalBusinessesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LocalBusinessesTable,
    LocalBusinessesData,
    $$LocalBusinessesTableFilterComposer,
    $$LocalBusinessesTableOrderingComposer,
    $$LocalBusinessesTableAnnotationComposer,
    $$LocalBusinessesTableCreateCompanionBuilder,
    $$LocalBusinessesTableUpdateCompanionBuilder,
    (
      LocalBusinessesData,
      BaseReferences<_$AppDatabase, $LocalBusinessesTable, LocalBusinessesData>
    ),
    LocalBusinessesData,
    PrefetchHooks Function()>;
typedef $$LocalDepotsTableCreateCompanionBuilder = LocalDepotsCompanion
    Function({
  required String id,
  required String businessId,
  required String name,
  Value<String?> address,
  Value<String?> phone,
  Value<bool> isDefault,
  Value<bool> deleted,
  Value<DateTime> updatedAt,
  Value<int> serverSeq,
  Value<int> rowid,
});
typedef $$LocalDepotsTableUpdateCompanionBuilder = LocalDepotsCompanion
    Function({
  Value<String> id,
  Value<String> businessId,
  Value<String> name,
  Value<String?> address,
  Value<String?> phone,
  Value<bool> isDefault,
  Value<bool> deleted,
  Value<DateTime> updatedAt,
  Value<int> serverSeq,
  Value<int> rowid,
});

class $$LocalDepotsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalDepotsTable> {
  $$LocalDepotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get businessId => $composableBuilder(
      column: $table.businessId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get serverSeq => $composableBuilder(
      column: $table.serverSeq, builder: (column) => ColumnFilters(column));
}

class $$LocalDepotsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalDepotsTable> {
  $$LocalDepotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get businessId => $composableBuilder(
      column: $table.businessId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get serverSeq => $composableBuilder(
      column: $table.serverSeq, builder: (column) => ColumnOrderings(column));
}

class $$LocalDepotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalDepotsTable> {
  $$LocalDepotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get businessId => $composableBuilder(
      column: $table.businessId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get serverSeq =>
      $composableBuilder(column: $table.serverSeq, builder: (column) => column);
}

class $$LocalDepotsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LocalDepotsTable,
    LocalDepot,
    $$LocalDepotsTableFilterComposer,
    $$LocalDepotsTableOrderingComposer,
    $$LocalDepotsTableAnnotationComposer,
    $$LocalDepotsTableCreateCompanionBuilder,
    $$LocalDepotsTableUpdateCompanionBuilder,
    (LocalDepot, BaseReferences<_$AppDatabase, $LocalDepotsTable, LocalDepot>),
    LocalDepot,
    PrefetchHooks Function()> {
  $$LocalDepotsTableTableManager(_$AppDatabase db, $LocalDepotsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalDepotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalDepotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalDepotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> businessId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> serverSeq = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalDepotsCompanion(
            id: id,
            businessId: businessId,
            name: name,
            address: address,
            phone: phone,
            isDefault: isDefault,
            deleted: deleted,
            updatedAt: updatedAt,
            serverSeq: serverSeq,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String businessId,
            required String name,
            Value<String?> address = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> serverSeq = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalDepotsCompanion.insert(
            id: id,
            businessId: businessId,
            name: name,
            address: address,
            phone: phone,
            isDefault: isDefault,
            deleted: deleted,
            updatedAt: updatedAt,
            serverSeq: serverSeq,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LocalDepotsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LocalDepotsTable,
    LocalDepot,
    $$LocalDepotsTableFilterComposer,
    $$LocalDepotsTableOrderingComposer,
    $$LocalDepotsTableAnnotationComposer,
    $$LocalDepotsTableCreateCompanionBuilder,
    $$LocalDepotsTableUpdateCompanionBuilder,
    (LocalDepot, BaseReferences<_$AppDatabase, $LocalDepotsTable, LocalDepot>),
    LocalDepot,
    PrefetchHooks Function()>;
typedef $$LocalUsersTableCreateCompanionBuilder = LocalUsersCompanion Function({
  required String id,
  required String businessId,
  Value<String?> depotId,
  required String name,
  Value<String?> phone,
  required String role,
  Value<String?> photoUrl,
  Value<bool> active,
  Value<bool> deleted,
  Value<DateTime> updatedAt,
  Value<int> serverSeq,
  Value<int> rowid,
});
typedef $$LocalUsersTableUpdateCompanionBuilder = LocalUsersCompanion Function({
  Value<String> id,
  Value<String> businessId,
  Value<String?> depotId,
  Value<String> name,
  Value<String?> phone,
  Value<String> role,
  Value<String?> photoUrl,
  Value<bool> active,
  Value<bool> deleted,
  Value<DateTime> updatedAt,
  Value<int> serverSeq,
  Value<int> rowid,
});

class $$LocalUsersTableFilterComposer
    extends Composer<_$AppDatabase, $LocalUsersTable> {
  $$LocalUsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get businessId => $composableBuilder(
      column: $table.businessId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get depotId => $composableBuilder(
      column: $table.depotId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get photoUrl => $composableBuilder(
      column: $table.photoUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get active => $composableBuilder(
      column: $table.active, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get serverSeq => $composableBuilder(
      column: $table.serverSeq, builder: (column) => ColumnFilters(column));
}

class $$LocalUsersTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalUsersTable> {
  $$LocalUsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get businessId => $composableBuilder(
      column: $table.businessId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get depotId => $composableBuilder(
      column: $table.depotId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get photoUrl => $composableBuilder(
      column: $table.photoUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get active => $composableBuilder(
      column: $table.active, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get serverSeq => $composableBuilder(
      column: $table.serverSeq, builder: (column) => ColumnOrderings(column));
}

class $$LocalUsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalUsersTable> {
  $$LocalUsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get businessId => $composableBuilder(
      column: $table.businessId, builder: (column) => column);

  GeneratedColumn<String> get depotId =>
      $composableBuilder(column: $table.depotId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get photoUrl =>
      $composableBuilder(column: $table.photoUrl, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get serverSeq =>
      $composableBuilder(column: $table.serverSeq, builder: (column) => column);
}

class $$LocalUsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LocalUsersTable,
    LocalUser,
    $$LocalUsersTableFilterComposer,
    $$LocalUsersTableOrderingComposer,
    $$LocalUsersTableAnnotationComposer,
    $$LocalUsersTableCreateCompanionBuilder,
    $$LocalUsersTableUpdateCompanionBuilder,
    (LocalUser, BaseReferences<_$AppDatabase, $LocalUsersTable, LocalUser>),
    LocalUser,
    PrefetchHooks Function()> {
  $$LocalUsersTableTableManager(_$AppDatabase db, $LocalUsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalUsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalUsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalUsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> businessId = const Value.absent(),
            Value<String?> depotId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<String?> photoUrl = const Value.absent(),
            Value<bool> active = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> serverSeq = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalUsersCompanion(
            id: id,
            businessId: businessId,
            depotId: depotId,
            name: name,
            phone: phone,
            role: role,
            photoUrl: photoUrl,
            active: active,
            deleted: deleted,
            updatedAt: updatedAt,
            serverSeq: serverSeq,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String businessId,
            Value<String?> depotId = const Value.absent(),
            required String name,
            Value<String?> phone = const Value.absent(),
            required String role,
            Value<String?> photoUrl = const Value.absent(),
            Value<bool> active = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> serverSeq = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalUsersCompanion.insert(
            id: id,
            businessId: businessId,
            depotId: depotId,
            name: name,
            phone: phone,
            role: role,
            photoUrl: photoUrl,
            active: active,
            deleted: deleted,
            updatedAt: updatedAt,
            serverSeq: serverSeq,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LocalUsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LocalUsersTable,
    LocalUser,
    $$LocalUsersTableFilterComposer,
    $$LocalUsersTableOrderingComposer,
    $$LocalUsersTableAnnotationComposer,
    $$LocalUsersTableCreateCompanionBuilder,
    $$LocalUsersTableUpdateCompanionBuilder,
    (LocalUser, BaseReferences<_$AppDatabase, $LocalUsersTable, LocalUser>),
    LocalUser,
    PrefetchHooks Function()>;
typedef $$LocalCategoriesTableCreateCompanionBuilder = LocalCategoriesCompanion
    Function({
  required String id,
  required String businessId,
  required String name,
  Value<bool> deleted,
  Value<DateTime> updatedAt,
  Value<int> serverSeq,
  Value<int> rowid,
});
typedef $$LocalCategoriesTableUpdateCompanionBuilder = LocalCategoriesCompanion
    Function({
  Value<String> id,
  Value<String> businessId,
  Value<String> name,
  Value<bool> deleted,
  Value<DateTime> updatedAt,
  Value<int> serverSeq,
  Value<int> rowid,
});

class $$LocalCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalCategoriesTable> {
  $$LocalCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get businessId => $composableBuilder(
      column: $table.businessId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get serverSeq => $composableBuilder(
      column: $table.serverSeq, builder: (column) => ColumnFilters(column));
}

class $$LocalCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalCategoriesTable> {
  $$LocalCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get businessId => $composableBuilder(
      column: $table.businessId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get serverSeq => $composableBuilder(
      column: $table.serverSeq, builder: (column) => ColumnOrderings(column));
}

class $$LocalCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalCategoriesTable> {
  $$LocalCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get businessId => $composableBuilder(
      column: $table.businessId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get serverSeq =>
      $composableBuilder(column: $table.serverSeq, builder: (column) => column);
}

class $$LocalCategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LocalCategoriesTable,
    LocalCategory,
    $$LocalCategoriesTableFilterComposer,
    $$LocalCategoriesTableOrderingComposer,
    $$LocalCategoriesTableAnnotationComposer,
    $$LocalCategoriesTableCreateCompanionBuilder,
    $$LocalCategoriesTableUpdateCompanionBuilder,
    (
      LocalCategory,
      BaseReferences<_$AppDatabase, $LocalCategoriesTable, LocalCategory>
    ),
    LocalCategory,
    PrefetchHooks Function()> {
  $$LocalCategoriesTableTableManager(
      _$AppDatabase db, $LocalCategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> businessId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> serverSeq = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalCategoriesCompanion(
            id: id,
            businessId: businessId,
            name: name,
            deleted: deleted,
            updatedAt: updatedAt,
            serverSeq: serverSeq,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String businessId,
            required String name,
            Value<bool> deleted = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> serverSeq = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalCategoriesCompanion.insert(
            id: id,
            businessId: businessId,
            name: name,
            deleted: deleted,
            updatedAt: updatedAt,
            serverSeq: serverSeq,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LocalCategoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LocalCategoriesTable,
    LocalCategory,
    $$LocalCategoriesTableFilterComposer,
    $$LocalCategoriesTableOrderingComposer,
    $$LocalCategoriesTableAnnotationComposer,
    $$LocalCategoriesTableCreateCompanionBuilder,
    $$LocalCategoriesTableUpdateCompanionBuilder,
    (
      LocalCategory,
      BaseReferences<_$AppDatabase, $LocalCategoriesTable, LocalCategory>
    ),
    LocalCategory,
    PrefetchHooks Function()>;
typedef $$LocalProductsTableCreateCompanionBuilder = LocalProductsCompanion
    Function({
  required String id,
  required String businessId,
  Value<String?> categoryId,
  required String name,
  Value<String?> brand,
  Value<String?> description,
  Value<String?> photoUrl,
  Value<String?> barcode,
  Value<String?> internalCode,
  Value<String?> createdBy,
  Value<bool> archived,
  Value<bool> deleted,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> serverSeq,
  Value<int> rowid,
});
typedef $$LocalProductsTableUpdateCompanionBuilder = LocalProductsCompanion
    Function({
  Value<String> id,
  Value<String> businessId,
  Value<String?> categoryId,
  Value<String> name,
  Value<String?> brand,
  Value<String?> description,
  Value<String?> photoUrl,
  Value<String?> barcode,
  Value<String?> internalCode,
  Value<String?> createdBy,
  Value<bool> archived,
  Value<bool> deleted,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> serverSeq,
  Value<int> rowid,
});

class $$LocalProductsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalProductsTable> {
  $$LocalProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get businessId => $composableBuilder(
      column: $table.businessId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get brand => $composableBuilder(
      column: $table.brand, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get photoUrl => $composableBuilder(
      column: $table.photoUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get barcode => $composableBuilder(
      column: $table.barcode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get internalCode => $composableBuilder(
      column: $table.internalCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get archived => $composableBuilder(
      column: $table.archived, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get serverSeq => $composableBuilder(
      column: $table.serverSeq, builder: (column) => ColumnFilters(column));
}

class $$LocalProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalProductsTable> {
  $$LocalProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get businessId => $composableBuilder(
      column: $table.businessId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get brand => $composableBuilder(
      column: $table.brand, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get photoUrl => $composableBuilder(
      column: $table.photoUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get barcode => $composableBuilder(
      column: $table.barcode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get internalCode => $composableBuilder(
      column: $table.internalCode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdBy => $composableBuilder(
      column: $table.createdBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get archived => $composableBuilder(
      column: $table.archived, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get serverSeq => $composableBuilder(
      column: $table.serverSeq, builder: (column) => ColumnOrderings(column));
}

class $$LocalProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalProductsTable> {
  $$LocalProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get businessId => $composableBuilder(
      column: $table.businessId, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
      column: $table.categoryId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get photoUrl =>
      $composableBuilder(column: $table.photoUrl, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get internalCode => $composableBuilder(
      column: $table.internalCode, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get serverSeq =>
      $composableBuilder(column: $table.serverSeq, builder: (column) => column);
}

class $$LocalProductsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LocalProductsTable,
    LocalProduct,
    $$LocalProductsTableFilterComposer,
    $$LocalProductsTableOrderingComposer,
    $$LocalProductsTableAnnotationComposer,
    $$LocalProductsTableCreateCompanionBuilder,
    $$LocalProductsTableUpdateCompanionBuilder,
    (
      LocalProduct,
      BaseReferences<_$AppDatabase, $LocalProductsTable, LocalProduct>
    ),
    LocalProduct,
    PrefetchHooks Function()> {
  $$LocalProductsTableTableManager(_$AppDatabase db, $LocalProductsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> businessId = const Value.absent(),
            Value<String?> categoryId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> brand = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> photoUrl = const Value.absent(),
            Value<String?> barcode = const Value.absent(),
            Value<String?> internalCode = const Value.absent(),
            Value<String?> createdBy = const Value.absent(),
            Value<bool> archived = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> serverSeq = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalProductsCompanion(
            id: id,
            businessId: businessId,
            categoryId: categoryId,
            name: name,
            brand: brand,
            description: description,
            photoUrl: photoUrl,
            barcode: barcode,
            internalCode: internalCode,
            createdBy: createdBy,
            archived: archived,
            deleted: deleted,
            createdAt: createdAt,
            updatedAt: updatedAt,
            serverSeq: serverSeq,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String businessId,
            Value<String?> categoryId = const Value.absent(),
            required String name,
            Value<String?> brand = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> photoUrl = const Value.absent(),
            Value<String?> barcode = const Value.absent(),
            Value<String?> internalCode = const Value.absent(),
            Value<String?> createdBy = const Value.absent(),
            Value<bool> archived = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> serverSeq = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalProductsCompanion.insert(
            id: id,
            businessId: businessId,
            categoryId: categoryId,
            name: name,
            brand: brand,
            description: description,
            photoUrl: photoUrl,
            barcode: barcode,
            internalCode: internalCode,
            createdBy: createdBy,
            archived: archived,
            deleted: deleted,
            createdAt: createdAt,
            updatedAt: updatedAt,
            serverSeq: serverSeq,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LocalProductsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LocalProductsTable,
    LocalProduct,
    $$LocalProductsTableFilterComposer,
    $$LocalProductsTableOrderingComposer,
    $$LocalProductsTableAnnotationComposer,
    $$LocalProductsTableCreateCompanionBuilder,
    $$LocalProductsTableUpdateCompanionBuilder,
    (
      LocalProduct,
      BaseReferences<_$AppDatabase, $LocalProductsTable, LocalProduct>
    ),
    LocalProduct,
    PrefetchHooks Function()>;
typedef $$LocalProductUnitsTableCreateCompanionBuilder
    = LocalProductUnitsCompanion Function({
  required String id,
  required String businessId,
  required String productId,
  required String name,
  Value<bool> isBase,
  Value<int> factor,
  Value<int> purchasePrice,
  Value<int> retailPrice,
  Value<int> wholesalePrice,
  Value<int> wholesaleMinQty,
  Value<bool> deleted,
  Value<DateTime> updatedAt,
  Value<int> serverSeq,
  Value<int> rowid,
});
typedef $$LocalProductUnitsTableUpdateCompanionBuilder
    = LocalProductUnitsCompanion Function({
  Value<String> id,
  Value<String> businessId,
  Value<String> productId,
  Value<String> name,
  Value<bool> isBase,
  Value<int> factor,
  Value<int> purchasePrice,
  Value<int> retailPrice,
  Value<int> wholesalePrice,
  Value<int> wholesaleMinQty,
  Value<bool> deleted,
  Value<DateTime> updatedAt,
  Value<int> serverSeq,
  Value<int> rowid,
});

class $$LocalProductUnitsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalProductUnitsTable> {
  $$LocalProductUnitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get businessId => $composableBuilder(
      column: $table.businessId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isBase => $composableBuilder(
      column: $table.isBase, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get factor => $composableBuilder(
      column: $table.factor, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get purchasePrice => $composableBuilder(
      column: $table.purchasePrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get retailPrice => $composableBuilder(
      column: $table.retailPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get wholesalePrice => $composableBuilder(
      column: $table.wholesalePrice,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get wholesaleMinQty => $composableBuilder(
      column: $table.wholesaleMinQty,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get serverSeq => $composableBuilder(
      column: $table.serverSeq, builder: (column) => ColumnFilters(column));
}

class $$LocalProductUnitsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalProductUnitsTable> {
  $$LocalProductUnitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get businessId => $composableBuilder(
      column: $table.businessId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isBase => $composableBuilder(
      column: $table.isBase, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get factor => $composableBuilder(
      column: $table.factor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get purchasePrice => $composableBuilder(
      column: $table.purchasePrice,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get retailPrice => $composableBuilder(
      column: $table.retailPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get wholesalePrice => $composableBuilder(
      column: $table.wholesalePrice,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get wholesaleMinQty => $composableBuilder(
      column: $table.wholesaleMinQty,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get serverSeq => $composableBuilder(
      column: $table.serverSeq, builder: (column) => ColumnOrderings(column));
}

class $$LocalProductUnitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalProductUnitsTable> {
  $$LocalProductUnitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get businessId => $composableBuilder(
      column: $table.businessId, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isBase =>
      $composableBuilder(column: $table.isBase, builder: (column) => column);

  GeneratedColumn<int> get factor =>
      $composableBuilder(column: $table.factor, builder: (column) => column);

  GeneratedColumn<int> get purchasePrice => $composableBuilder(
      column: $table.purchasePrice, builder: (column) => column);

  GeneratedColumn<int> get retailPrice => $composableBuilder(
      column: $table.retailPrice, builder: (column) => column);

  GeneratedColumn<int> get wholesalePrice => $composableBuilder(
      column: $table.wholesalePrice, builder: (column) => column);

  GeneratedColumn<int> get wholesaleMinQty => $composableBuilder(
      column: $table.wholesaleMinQty, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get serverSeq =>
      $composableBuilder(column: $table.serverSeq, builder: (column) => column);
}

class $$LocalProductUnitsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LocalProductUnitsTable,
    LocalProductUnit,
    $$LocalProductUnitsTableFilterComposer,
    $$LocalProductUnitsTableOrderingComposer,
    $$LocalProductUnitsTableAnnotationComposer,
    $$LocalProductUnitsTableCreateCompanionBuilder,
    $$LocalProductUnitsTableUpdateCompanionBuilder,
    (
      LocalProductUnit,
      BaseReferences<_$AppDatabase, $LocalProductUnitsTable, LocalProductUnit>
    ),
    LocalProductUnit,
    PrefetchHooks Function()> {
  $$LocalProductUnitsTableTableManager(
      _$AppDatabase db, $LocalProductUnitsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalProductUnitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalProductUnitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalProductUnitsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> businessId = const Value.absent(),
            Value<String> productId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<bool> isBase = const Value.absent(),
            Value<int> factor = const Value.absent(),
            Value<int> purchasePrice = const Value.absent(),
            Value<int> retailPrice = const Value.absent(),
            Value<int> wholesalePrice = const Value.absent(),
            Value<int> wholesaleMinQty = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> serverSeq = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalProductUnitsCompanion(
            id: id,
            businessId: businessId,
            productId: productId,
            name: name,
            isBase: isBase,
            factor: factor,
            purchasePrice: purchasePrice,
            retailPrice: retailPrice,
            wholesalePrice: wholesalePrice,
            wholesaleMinQty: wholesaleMinQty,
            deleted: deleted,
            updatedAt: updatedAt,
            serverSeq: serverSeq,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String businessId,
            required String productId,
            required String name,
            Value<bool> isBase = const Value.absent(),
            Value<int> factor = const Value.absent(),
            Value<int> purchasePrice = const Value.absent(),
            Value<int> retailPrice = const Value.absent(),
            Value<int> wholesalePrice = const Value.absent(),
            Value<int> wholesaleMinQty = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> serverSeq = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalProductUnitsCompanion.insert(
            id: id,
            businessId: businessId,
            productId: productId,
            name: name,
            isBase: isBase,
            factor: factor,
            purchasePrice: purchasePrice,
            retailPrice: retailPrice,
            wholesalePrice: wholesalePrice,
            wholesaleMinQty: wholesaleMinQty,
            deleted: deleted,
            updatedAt: updatedAt,
            serverSeq: serverSeq,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LocalProductUnitsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LocalProductUnitsTable,
    LocalProductUnit,
    $$LocalProductUnitsTableFilterComposer,
    $$LocalProductUnitsTableOrderingComposer,
    $$LocalProductUnitsTableAnnotationComposer,
    $$LocalProductUnitsTableCreateCompanionBuilder,
    $$LocalProductUnitsTableUpdateCompanionBuilder,
    (
      LocalProductUnit,
      BaseReferences<_$AppDatabase, $LocalProductUnitsTable, LocalProductUnit>
    ),
    LocalProductUnit,
    PrefetchHooks Function()>;
typedef $$LocalProductStockLevelsTableCreateCompanionBuilder
    = LocalProductStockLevelsCompanion Function({
  required String id,
  required String businessId,
  required String productId,
  required String depotId,
  Value<int> minLevel,
  Value<int> cachedQty,
  Value<DateTime> updatedAt,
  Value<int> serverSeq,
  Value<int> rowid,
});
typedef $$LocalProductStockLevelsTableUpdateCompanionBuilder
    = LocalProductStockLevelsCompanion Function({
  Value<String> id,
  Value<String> businessId,
  Value<String> productId,
  Value<String> depotId,
  Value<int> minLevel,
  Value<int> cachedQty,
  Value<DateTime> updatedAt,
  Value<int> serverSeq,
  Value<int> rowid,
});

class $$LocalProductStockLevelsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalProductStockLevelsTable> {
  $$LocalProductStockLevelsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get businessId => $composableBuilder(
      column: $table.businessId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get depotId => $composableBuilder(
      column: $table.depotId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get minLevel => $composableBuilder(
      column: $table.minLevel, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cachedQty => $composableBuilder(
      column: $table.cachedQty, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get serverSeq => $composableBuilder(
      column: $table.serverSeq, builder: (column) => ColumnFilters(column));
}

class $$LocalProductStockLevelsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalProductStockLevelsTable> {
  $$LocalProductStockLevelsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get businessId => $composableBuilder(
      column: $table.businessId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get depotId => $composableBuilder(
      column: $table.depotId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get minLevel => $composableBuilder(
      column: $table.minLevel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cachedQty => $composableBuilder(
      column: $table.cachedQty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get serverSeq => $composableBuilder(
      column: $table.serverSeq, builder: (column) => ColumnOrderings(column));
}

class $$LocalProductStockLevelsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalProductStockLevelsTable> {
  $$LocalProductStockLevelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get businessId => $composableBuilder(
      column: $table.businessId, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get depotId =>
      $composableBuilder(column: $table.depotId, builder: (column) => column);

  GeneratedColumn<int> get minLevel =>
      $composableBuilder(column: $table.minLevel, builder: (column) => column);

  GeneratedColumn<int> get cachedQty =>
      $composableBuilder(column: $table.cachedQty, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get serverSeq =>
      $composableBuilder(column: $table.serverSeq, builder: (column) => column);
}

class $$LocalProductStockLevelsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LocalProductStockLevelsTable,
    LocalProductStockLevel,
    $$LocalProductStockLevelsTableFilterComposer,
    $$LocalProductStockLevelsTableOrderingComposer,
    $$LocalProductStockLevelsTableAnnotationComposer,
    $$LocalProductStockLevelsTableCreateCompanionBuilder,
    $$LocalProductStockLevelsTableUpdateCompanionBuilder,
    (
      LocalProductStockLevel,
      BaseReferences<_$AppDatabase, $LocalProductStockLevelsTable,
          LocalProductStockLevel>
    ),
    LocalProductStockLevel,
    PrefetchHooks Function()> {
  $$LocalProductStockLevelsTableTableManager(
      _$AppDatabase db, $LocalProductStockLevelsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalProductStockLevelsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalProductStockLevelsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalProductStockLevelsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> businessId = const Value.absent(),
            Value<String> productId = const Value.absent(),
            Value<String> depotId = const Value.absent(),
            Value<int> minLevel = const Value.absent(),
            Value<int> cachedQty = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> serverSeq = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalProductStockLevelsCompanion(
            id: id,
            businessId: businessId,
            productId: productId,
            depotId: depotId,
            minLevel: minLevel,
            cachedQty: cachedQty,
            updatedAt: updatedAt,
            serverSeq: serverSeq,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String businessId,
            required String productId,
            required String depotId,
            Value<int> minLevel = const Value.absent(),
            Value<int> cachedQty = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> serverSeq = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalProductStockLevelsCompanion.insert(
            id: id,
            businessId: businessId,
            productId: productId,
            depotId: depotId,
            minLevel: minLevel,
            cachedQty: cachedQty,
            updatedAt: updatedAt,
            serverSeq: serverSeq,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LocalProductStockLevelsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $LocalProductStockLevelsTable,
        LocalProductStockLevel,
        $$LocalProductStockLevelsTableFilterComposer,
        $$LocalProductStockLevelsTableOrderingComposer,
        $$LocalProductStockLevelsTableAnnotationComposer,
        $$LocalProductStockLevelsTableCreateCompanionBuilder,
        $$LocalProductStockLevelsTableUpdateCompanionBuilder,
        (
          LocalProductStockLevel,
          BaseReferences<_$AppDatabase, $LocalProductStockLevelsTable,
              LocalProductStockLevel>
        ),
        LocalProductStockLevel,
        PrefetchHooks Function()>;
typedef $$LocalCustomersTableCreateCompanionBuilder = LocalCustomersCompanion
    Function({
  required String id,
  required String businessId,
  required String name,
  Value<String?> phone,
  Value<String> type,
  Value<String?> address,
  Value<String?> notes,
  Value<int?> creditLimit,
  Value<bool> deleted,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> serverSeq,
  Value<int> rowid,
});
typedef $$LocalCustomersTableUpdateCompanionBuilder = LocalCustomersCompanion
    Function({
  Value<String> id,
  Value<String> businessId,
  Value<String> name,
  Value<String?> phone,
  Value<String> type,
  Value<String?> address,
  Value<String?> notes,
  Value<int?> creditLimit,
  Value<bool> deleted,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> serverSeq,
  Value<int> rowid,
});

class $$LocalCustomersTableFilterComposer
    extends Composer<_$AppDatabase, $LocalCustomersTable> {
  $$LocalCustomersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get businessId => $composableBuilder(
      column: $table.businessId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get creditLimit => $composableBuilder(
      column: $table.creditLimit, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get serverSeq => $composableBuilder(
      column: $table.serverSeq, builder: (column) => ColumnFilters(column));
}

class $$LocalCustomersTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalCustomersTable> {
  $$LocalCustomersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get businessId => $composableBuilder(
      column: $table.businessId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get creditLimit => $composableBuilder(
      column: $table.creditLimit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get serverSeq => $composableBuilder(
      column: $table.serverSeq, builder: (column) => ColumnOrderings(column));
}

class $$LocalCustomersTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalCustomersTable> {
  $$LocalCustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get businessId => $composableBuilder(
      column: $table.businessId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get creditLimit => $composableBuilder(
      column: $table.creditLimit, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get serverSeq =>
      $composableBuilder(column: $table.serverSeq, builder: (column) => column);
}

class $$LocalCustomersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LocalCustomersTable,
    LocalCustomer,
    $$LocalCustomersTableFilterComposer,
    $$LocalCustomersTableOrderingComposer,
    $$LocalCustomersTableAnnotationComposer,
    $$LocalCustomersTableCreateCompanionBuilder,
    $$LocalCustomersTableUpdateCompanionBuilder,
    (
      LocalCustomer,
      BaseReferences<_$AppDatabase, $LocalCustomersTable, LocalCustomer>
    ),
    LocalCustomer,
    PrefetchHooks Function()> {
  $$LocalCustomersTableTableManager(
      _$AppDatabase db, $LocalCustomersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalCustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalCustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalCustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> businessId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int?> creditLimit = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> serverSeq = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalCustomersCompanion(
            id: id,
            businessId: businessId,
            name: name,
            phone: phone,
            type: type,
            address: address,
            notes: notes,
            creditLimit: creditLimit,
            deleted: deleted,
            createdAt: createdAt,
            updatedAt: updatedAt,
            serverSeq: serverSeq,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String businessId,
            required String name,
            Value<String?> phone = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int?> creditLimit = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> serverSeq = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalCustomersCompanion.insert(
            id: id,
            businessId: businessId,
            name: name,
            phone: phone,
            type: type,
            address: address,
            notes: notes,
            creditLimit: creditLimit,
            deleted: deleted,
            createdAt: createdAt,
            updatedAt: updatedAt,
            serverSeq: serverSeq,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LocalCustomersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LocalCustomersTable,
    LocalCustomer,
    $$LocalCustomersTableFilterComposer,
    $$LocalCustomersTableOrderingComposer,
    $$LocalCustomersTableAnnotationComposer,
    $$LocalCustomersTableCreateCompanionBuilder,
    $$LocalCustomersTableUpdateCompanionBuilder,
    (
      LocalCustomer,
      BaseReferences<_$AppDatabase, $LocalCustomersTable, LocalCustomer>
    ),
    LocalCustomer,
    PrefetchHooks Function()>;
typedef $$LocalSalesTableCreateCompanionBuilder = LocalSalesCompanion Function({
  required String id,
  required String businessId,
  required String depotId,
  Value<String?> customerId,
  required String userId,
  required String deviceId,
  required String number,
  Value<String> status,
  Value<int> totalAmount,
  Value<int> discountAmount,
  Value<String?> notes,
  Value<String?> cancelReason,
  Value<String?> cancelledBy,
  Value<bool> deleted,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> serverSeq,
  Value<int> rowid,
});
typedef $$LocalSalesTableUpdateCompanionBuilder = LocalSalesCompanion Function({
  Value<String> id,
  Value<String> businessId,
  Value<String> depotId,
  Value<String?> customerId,
  Value<String> userId,
  Value<String> deviceId,
  Value<String> number,
  Value<String> status,
  Value<int> totalAmount,
  Value<int> discountAmount,
  Value<String?> notes,
  Value<String?> cancelReason,
  Value<String?> cancelledBy,
  Value<bool> deleted,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> serverSeq,
  Value<int> rowid,
});

class $$LocalSalesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalSalesTable> {
  $$LocalSalesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get businessId => $composableBuilder(
      column: $table.businessId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get depotId => $composableBuilder(
      column: $table.depotId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customerId => $composableBuilder(
      column: $table.customerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get number => $composableBuilder(
      column: $table.number, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get discountAmount => $composableBuilder(
      column: $table.discountAmount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cancelReason => $composableBuilder(
      column: $table.cancelReason, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cancelledBy => $composableBuilder(
      column: $table.cancelledBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get serverSeq => $composableBuilder(
      column: $table.serverSeq, builder: (column) => ColumnFilters(column));
}

class $$LocalSalesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalSalesTable> {
  $$LocalSalesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get businessId => $composableBuilder(
      column: $table.businessId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get depotId => $composableBuilder(
      column: $table.depotId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customerId => $composableBuilder(
      column: $table.customerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get number => $composableBuilder(
      column: $table.number, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get discountAmount => $composableBuilder(
      column: $table.discountAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cancelReason => $composableBuilder(
      column: $table.cancelReason,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cancelledBy => $composableBuilder(
      column: $table.cancelledBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get serverSeq => $composableBuilder(
      column: $table.serverSeq, builder: (column) => ColumnOrderings(column));
}

class $$LocalSalesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalSalesTable> {
  $$LocalSalesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get businessId => $composableBuilder(
      column: $table.businessId, builder: (column) => column);

  GeneratedColumn<String> get depotId =>
      $composableBuilder(column: $table.depotId, builder: (column) => column);

  GeneratedColumn<String> get customerId => $composableBuilder(
      column: $table.customerId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => column);

  GeneratedColumn<int> get discountAmount => $composableBuilder(
      column: $table.discountAmount, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get cancelReason => $composableBuilder(
      column: $table.cancelReason, builder: (column) => column);

  GeneratedColumn<String> get cancelledBy => $composableBuilder(
      column: $table.cancelledBy, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get serverSeq =>
      $composableBuilder(column: $table.serverSeq, builder: (column) => column);
}

class $$LocalSalesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LocalSalesTable,
    LocalSale,
    $$LocalSalesTableFilterComposer,
    $$LocalSalesTableOrderingComposer,
    $$LocalSalesTableAnnotationComposer,
    $$LocalSalesTableCreateCompanionBuilder,
    $$LocalSalesTableUpdateCompanionBuilder,
    (LocalSale, BaseReferences<_$AppDatabase, $LocalSalesTable, LocalSale>),
    LocalSale,
    PrefetchHooks Function()> {
  $$LocalSalesTableTableManager(_$AppDatabase db, $LocalSalesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalSalesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalSalesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalSalesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> businessId = const Value.absent(),
            Value<String> depotId = const Value.absent(),
            Value<String?> customerId = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> deviceId = const Value.absent(),
            Value<String> number = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> totalAmount = const Value.absent(),
            Value<int> discountAmount = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> cancelReason = const Value.absent(),
            Value<String?> cancelledBy = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> serverSeq = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalSalesCompanion(
            id: id,
            businessId: businessId,
            depotId: depotId,
            customerId: customerId,
            userId: userId,
            deviceId: deviceId,
            number: number,
            status: status,
            totalAmount: totalAmount,
            discountAmount: discountAmount,
            notes: notes,
            cancelReason: cancelReason,
            cancelledBy: cancelledBy,
            deleted: deleted,
            createdAt: createdAt,
            updatedAt: updatedAt,
            serverSeq: serverSeq,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String businessId,
            required String depotId,
            Value<String?> customerId = const Value.absent(),
            required String userId,
            required String deviceId,
            required String number,
            Value<String> status = const Value.absent(),
            Value<int> totalAmount = const Value.absent(),
            Value<int> discountAmount = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> cancelReason = const Value.absent(),
            Value<String?> cancelledBy = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> serverSeq = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalSalesCompanion.insert(
            id: id,
            businessId: businessId,
            depotId: depotId,
            customerId: customerId,
            userId: userId,
            deviceId: deviceId,
            number: number,
            status: status,
            totalAmount: totalAmount,
            discountAmount: discountAmount,
            notes: notes,
            cancelReason: cancelReason,
            cancelledBy: cancelledBy,
            deleted: deleted,
            createdAt: createdAt,
            updatedAt: updatedAt,
            serverSeq: serverSeq,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LocalSalesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LocalSalesTable,
    LocalSale,
    $$LocalSalesTableFilterComposer,
    $$LocalSalesTableOrderingComposer,
    $$LocalSalesTableAnnotationComposer,
    $$LocalSalesTableCreateCompanionBuilder,
    $$LocalSalesTableUpdateCompanionBuilder,
    (LocalSale, BaseReferences<_$AppDatabase, $LocalSalesTable, LocalSale>),
    LocalSale,
    PrefetchHooks Function()>;
typedef $$LocalSaleLinesTableCreateCompanionBuilder = LocalSaleLinesCompanion
    Function({
  required String id,
  required String businessId,
  required String saleId,
  required String productId,
  required String unitId,
  required int qty,
  required int unitPrice,
  Value<int> discount,
  required int lineTotal,
  Value<bool> deleted,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> serverSeq,
  Value<int> rowid,
});
typedef $$LocalSaleLinesTableUpdateCompanionBuilder = LocalSaleLinesCompanion
    Function({
  Value<String> id,
  Value<String> businessId,
  Value<String> saleId,
  Value<String> productId,
  Value<String> unitId,
  Value<int> qty,
  Value<int> unitPrice,
  Value<int> discount,
  Value<int> lineTotal,
  Value<bool> deleted,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> serverSeq,
  Value<int> rowid,
});

class $$LocalSaleLinesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalSaleLinesTable> {
  $$LocalSaleLinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get businessId => $composableBuilder(
      column: $table.businessId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get saleId => $composableBuilder(
      column: $table.saleId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unitId => $composableBuilder(
      column: $table.unitId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get qty => $composableBuilder(
      column: $table.qty, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get unitPrice => $composableBuilder(
      column: $table.unitPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get discount => $composableBuilder(
      column: $table.discount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lineTotal => $composableBuilder(
      column: $table.lineTotal, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get serverSeq => $composableBuilder(
      column: $table.serverSeq, builder: (column) => ColumnFilters(column));
}

class $$LocalSaleLinesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalSaleLinesTable> {
  $$LocalSaleLinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get businessId => $composableBuilder(
      column: $table.businessId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get saleId => $composableBuilder(
      column: $table.saleId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unitId => $composableBuilder(
      column: $table.unitId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get qty => $composableBuilder(
      column: $table.qty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unitPrice => $composableBuilder(
      column: $table.unitPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get discount => $composableBuilder(
      column: $table.discount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lineTotal => $composableBuilder(
      column: $table.lineTotal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get serverSeq => $composableBuilder(
      column: $table.serverSeq, builder: (column) => ColumnOrderings(column));
}

class $$LocalSaleLinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalSaleLinesTable> {
  $$LocalSaleLinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get businessId => $composableBuilder(
      column: $table.businessId, builder: (column) => column);

  GeneratedColumn<String> get saleId =>
      $composableBuilder(column: $table.saleId, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get unitId =>
      $composableBuilder(column: $table.unitId, builder: (column) => column);

  GeneratedColumn<int> get qty =>
      $composableBuilder(column: $table.qty, builder: (column) => column);

  GeneratedColumn<int> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<int> get discount =>
      $composableBuilder(column: $table.discount, builder: (column) => column);

  GeneratedColumn<int> get lineTotal =>
      $composableBuilder(column: $table.lineTotal, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get serverSeq =>
      $composableBuilder(column: $table.serverSeq, builder: (column) => column);
}

class $$LocalSaleLinesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LocalSaleLinesTable,
    LocalSaleLine,
    $$LocalSaleLinesTableFilterComposer,
    $$LocalSaleLinesTableOrderingComposer,
    $$LocalSaleLinesTableAnnotationComposer,
    $$LocalSaleLinesTableCreateCompanionBuilder,
    $$LocalSaleLinesTableUpdateCompanionBuilder,
    (
      LocalSaleLine,
      BaseReferences<_$AppDatabase, $LocalSaleLinesTable, LocalSaleLine>
    ),
    LocalSaleLine,
    PrefetchHooks Function()> {
  $$LocalSaleLinesTableTableManager(
      _$AppDatabase db, $LocalSaleLinesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalSaleLinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalSaleLinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalSaleLinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> businessId = const Value.absent(),
            Value<String> saleId = const Value.absent(),
            Value<String> productId = const Value.absent(),
            Value<String> unitId = const Value.absent(),
            Value<int> qty = const Value.absent(),
            Value<int> unitPrice = const Value.absent(),
            Value<int> discount = const Value.absent(),
            Value<int> lineTotal = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> serverSeq = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalSaleLinesCompanion(
            id: id,
            businessId: businessId,
            saleId: saleId,
            productId: productId,
            unitId: unitId,
            qty: qty,
            unitPrice: unitPrice,
            discount: discount,
            lineTotal: lineTotal,
            deleted: deleted,
            createdAt: createdAt,
            updatedAt: updatedAt,
            serverSeq: serverSeq,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String businessId,
            required String saleId,
            required String productId,
            required String unitId,
            required int qty,
            required int unitPrice,
            Value<int> discount = const Value.absent(),
            required int lineTotal,
            Value<bool> deleted = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> serverSeq = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalSaleLinesCompanion.insert(
            id: id,
            businessId: businessId,
            saleId: saleId,
            productId: productId,
            unitId: unitId,
            qty: qty,
            unitPrice: unitPrice,
            discount: discount,
            lineTotal: lineTotal,
            deleted: deleted,
            createdAt: createdAt,
            updatedAt: updatedAt,
            serverSeq: serverSeq,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LocalSaleLinesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LocalSaleLinesTable,
    LocalSaleLine,
    $$LocalSaleLinesTableFilterComposer,
    $$LocalSaleLinesTableOrderingComposer,
    $$LocalSaleLinesTableAnnotationComposer,
    $$LocalSaleLinesTableCreateCompanionBuilder,
    $$LocalSaleLinesTableUpdateCompanionBuilder,
    (
      LocalSaleLine,
      BaseReferences<_$AppDatabase, $LocalSaleLinesTable, LocalSaleLine>
    ),
    LocalSaleLine,
    PrefetchHooks Function()>;
typedef $$LocalSalePaymentsTableCreateCompanionBuilder
    = LocalSalePaymentsCompanion Function({
  required String id,
  required String businessId,
  required String depotId,
  required String saleId,
  required String deviceId,
  required String method,
  required int amount,
  Value<String?> reference,
  Value<bool> deleted,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> serverSeq,
  Value<int> rowid,
});
typedef $$LocalSalePaymentsTableUpdateCompanionBuilder
    = LocalSalePaymentsCompanion Function({
  Value<String> id,
  Value<String> businessId,
  Value<String> depotId,
  Value<String> saleId,
  Value<String> deviceId,
  Value<String> method,
  Value<int> amount,
  Value<String?> reference,
  Value<bool> deleted,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> serverSeq,
  Value<int> rowid,
});

class $$LocalSalePaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalSalePaymentsTable> {
  $$LocalSalePaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get businessId => $composableBuilder(
      column: $table.businessId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get depotId => $composableBuilder(
      column: $table.depotId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get saleId => $composableBuilder(
      column: $table.saleId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get method => $composableBuilder(
      column: $table.method, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get serverSeq => $composableBuilder(
      column: $table.serverSeq, builder: (column) => ColumnFilters(column));
}

class $$LocalSalePaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalSalePaymentsTable> {
  $$LocalSalePaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get businessId => $composableBuilder(
      column: $table.businessId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get depotId => $composableBuilder(
      column: $table.depotId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get saleId => $composableBuilder(
      column: $table.saleId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get method => $composableBuilder(
      column: $table.method, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get serverSeq => $composableBuilder(
      column: $table.serverSeq, builder: (column) => ColumnOrderings(column));
}

class $$LocalSalePaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalSalePaymentsTable> {
  $$LocalSalePaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get businessId => $composableBuilder(
      column: $table.businessId, builder: (column) => column);

  GeneratedColumn<String> get depotId =>
      $composableBuilder(column: $table.depotId, builder: (column) => column);

  GeneratedColumn<String> get saleId =>
      $composableBuilder(column: $table.saleId, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get serverSeq =>
      $composableBuilder(column: $table.serverSeq, builder: (column) => column);
}

class $$LocalSalePaymentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LocalSalePaymentsTable,
    LocalSalePayment,
    $$LocalSalePaymentsTableFilterComposer,
    $$LocalSalePaymentsTableOrderingComposer,
    $$LocalSalePaymentsTableAnnotationComposer,
    $$LocalSalePaymentsTableCreateCompanionBuilder,
    $$LocalSalePaymentsTableUpdateCompanionBuilder,
    (
      LocalSalePayment,
      BaseReferences<_$AppDatabase, $LocalSalePaymentsTable, LocalSalePayment>
    ),
    LocalSalePayment,
    PrefetchHooks Function()> {
  $$LocalSalePaymentsTableTableManager(
      _$AppDatabase db, $LocalSalePaymentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalSalePaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalSalePaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalSalePaymentsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> businessId = const Value.absent(),
            Value<String> depotId = const Value.absent(),
            Value<String> saleId = const Value.absent(),
            Value<String> deviceId = const Value.absent(),
            Value<String> method = const Value.absent(),
            Value<int> amount = const Value.absent(),
            Value<String?> reference = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> serverSeq = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalSalePaymentsCompanion(
            id: id,
            businessId: businessId,
            depotId: depotId,
            saleId: saleId,
            deviceId: deviceId,
            method: method,
            amount: amount,
            reference: reference,
            deleted: deleted,
            createdAt: createdAt,
            updatedAt: updatedAt,
            serverSeq: serverSeq,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String businessId,
            required String depotId,
            required String saleId,
            required String deviceId,
            required String method,
            required int amount,
            Value<String?> reference = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> serverSeq = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalSalePaymentsCompanion.insert(
            id: id,
            businessId: businessId,
            depotId: depotId,
            saleId: saleId,
            deviceId: deviceId,
            method: method,
            amount: amount,
            reference: reference,
            deleted: deleted,
            createdAt: createdAt,
            updatedAt: updatedAt,
            serverSeq: serverSeq,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LocalSalePaymentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LocalSalePaymentsTable,
    LocalSalePayment,
    $$LocalSalePaymentsTableFilterComposer,
    $$LocalSalePaymentsTableOrderingComposer,
    $$LocalSalePaymentsTableAnnotationComposer,
    $$LocalSalePaymentsTableCreateCompanionBuilder,
    $$LocalSalePaymentsTableUpdateCompanionBuilder,
    (
      LocalSalePayment,
      BaseReferences<_$AppDatabase, $LocalSalePaymentsTable, LocalSalePayment>
    ),
    LocalSalePayment,
    PrefetchHooks Function()>;
typedef $$LocalStockMovementsTableCreateCompanionBuilder
    = LocalStockMovementsCompanion Function({
  required String id,
  required String businessId,
  required String depotId,
  required String productId,
  required String userId,
  required String deviceId,
  required String type,
  required int qtyInBase,
  Value<String?> reason,
  Value<String?> refDocId,
  Value<String?> refDocType,
  Value<bool> deleted,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> serverSeq,
  Value<int> rowid,
});
typedef $$LocalStockMovementsTableUpdateCompanionBuilder
    = LocalStockMovementsCompanion Function({
  Value<String> id,
  Value<String> businessId,
  Value<String> depotId,
  Value<String> productId,
  Value<String> userId,
  Value<String> deviceId,
  Value<String> type,
  Value<int> qtyInBase,
  Value<String?> reason,
  Value<String?> refDocId,
  Value<String?> refDocType,
  Value<bool> deleted,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> serverSeq,
  Value<int> rowid,
});

class $$LocalStockMovementsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalStockMovementsTable> {
  $$LocalStockMovementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get businessId => $composableBuilder(
      column: $table.businessId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get depotId => $composableBuilder(
      column: $table.depotId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get qtyInBase => $composableBuilder(
      column: $table.qtyInBase, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get refDocId => $composableBuilder(
      column: $table.refDocId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get refDocType => $composableBuilder(
      column: $table.refDocType, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get serverSeq => $composableBuilder(
      column: $table.serverSeq, builder: (column) => ColumnFilters(column));
}

class $$LocalStockMovementsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalStockMovementsTable> {
  $$LocalStockMovementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get businessId => $composableBuilder(
      column: $table.businessId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get depotId => $composableBuilder(
      column: $table.depotId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get qtyInBase => $composableBuilder(
      column: $table.qtyInBase, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get refDocId => $composableBuilder(
      column: $table.refDocId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get refDocType => $composableBuilder(
      column: $table.refDocType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get serverSeq => $composableBuilder(
      column: $table.serverSeq, builder: (column) => ColumnOrderings(column));
}

class $$LocalStockMovementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalStockMovementsTable> {
  $$LocalStockMovementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get businessId => $composableBuilder(
      column: $table.businessId, builder: (column) => column);

  GeneratedColumn<String> get depotId =>
      $composableBuilder(column: $table.depotId, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get qtyInBase =>
      $composableBuilder(column: $table.qtyInBase, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get refDocId =>
      $composableBuilder(column: $table.refDocId, builder: (column) => column);

  GeneratedColumn<String> get refDocType => $composableBuilder(
      column: $table.refDocType, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get serverSeq =>
      $composableBuilder(column: $table.serverSeq, builder: (column) => column);
}

class $$LocalStockMovementsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LocalStockMovementsTable,
    LocalStockMovement,
    $$LocalStockMovementsTableFilterComposer,
    $$LocalStockMovementsTableOrderingComposer,
    $$LocalStockMovementsTableAnnotationComposer,
    $$LocalStockMovementsTableCreateCompanionBuilder,
    $$LocalStockMovementsTableUpdateCompanionBuilder,
    (
      LocalStockMovement,
      BaseReferences<_$AppDatabase, $LocalStockMovementsTable,
          LocalStockMovement>
    ),
    LocalStockMovement,
    PrefetchHooks Function()> {
  $$LocalStockMovementsTableTableManager(
      _$AppDatabase db, $LocalStockMovementsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalStockMovementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalStockMovementsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalStockMovementsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> businessId = const Value.absent(),
            Value<String> depotId = const Value.absent(),
            Value<String> productId = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> deviceId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<int> qtyInBase = const Value.absent(),
            Value<String?> reason = const Value.absent(),
            Value<String?> refDocId = const Value.absent(),
            Value<String?> refDocType = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> serverSeq = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalStockMovementsCompanion(
            id: id,
            businessId: businessId,
            depotId: depotId,
            productId: productId,
            userId: userId,
            deviceId: deviceId,
            type: type,
            qtyInBase: qtyInBase,
            reason: reason,
            refDocId: refDocId,
            refDocType: refDocType,
            deleted: deleted,
            createdAt: createdAt,
            updatedAt: updatedAt,
            serverSeq: serverSeq,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String businessId,
            required String depotId,
            required String productId,
            required String userId,
            required String deviceId,
            required String type,
            required int qtyInBase,
            Value<String?> reason = const Value.absent(),
            Value<String?> refDocId = const Value.absent(),
            Value<String?> refDocType = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> serverSeq = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalStockMovementsCompanion.insert(
            id: id,
            businessId: businessId,
            depotId: depotId,
            productId: productId,
            userId: userId,
            deviceId: deviceId,
            type: type,
            qtyInBase: qtyInBase,
            reason: reason,
            refDocId: refDocId,
            refDocType: refDocType,
            deleted: deleted,
            createdAt: createdAt,
            updatedAt: updatedAt,
            serverSeq: serverSeq,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LocalStockMovementsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LocalStockMovementsTable,
    LocalStockMovement,
    $$LocalStockMovementsTableFilterComposer,
    $$LocalStockMovementsTableOrderingComposer,
    $$LocalStockMovementsTableAnnotationComposer,
    $$LocalStockMovementsTableCreateCompanionBuilder,
    $$LocalStockMovementsTableUpdateCompanionBuilder,
    (
      LocalStockMovement,
      BaseReferences<_$AppDatabase, $LocalStockMovementsTable,
          LocalStockMovement>
    ),
    LocalStockMovement,
    PrefetchHooks Function()>;
typedef $$LocalCustomerPaymentsTableCreateCompanionBuilder
    = LocalCustomerPaymentsCompanion Function({
  required String id,
  required String businessId,
  required String depotId,
  required String customerId,
  required String userId,
  required String deviceId,
  required int amount,
  required String method,
  Value<String?> reference,
  Value<bool> deleted,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> serverSeq,
  Value<int> rowid,
});
typedef $$LocalCustomerPaymentsTableUpdateCompanionBuilder
    = LocalCustomerPaymentsCompanion Function({
  Value<String> id,
  Value<String> businessId,
  Value<String> depotId,
  Value<String> customerId,
  Value<String> userId,
  Value<String> deviceId,
  Value<int> amount,
  Value<String> method,
  Value<String?> reference,
  Value<bool> deleted,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> serverSeq,
  Value<int> rowid,
});

class $$LocalCustomerPaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalCustomerPaymentsTable> {
  $$LocalCustomerPaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get businessId => $composableBuilder(
      column: $table.businessId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get depotId => $composableBuilder(
      column: $table.depotId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customerId => $composableBuilder(
      column: $table.customerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get method => $composableBuilder(
      column: $table.method, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get serverSeq => $composableBuilder(
      column: $table.serverSeq, builder: (column) => ColumnFilters(column));
}

class $$LocalCustomerPaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalCustomerPaymentsTable> {
  $$LocalCustomerPaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get businessId => $composableBuilder(
      column: $table.businessId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get depotId => $composableBuilder(
      column: $table.depotId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customerId => $composableBuilder(
      column: $table.customerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get method => $composableBuilder(
      column: $table.method, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reference => $composableBuilder(
      column: $table.reference, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted => $composableBuilder(
      column: $table.deleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get serverSeq => $composableBuilder(
      column: $table.serverSeq, builder: (column) => ColumnOrderings(column));
}

class $$LocalCustomerPaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalCustomerPaymentsTable> {
  $$LocalCustomerPaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get businessId => $composableBuilder(
      column: $table.businessId, builder: (column) => column);

  GeneratedColumn<String> get depotId =>
      $composableBuilder(column: $table.depotId, builder: (column) => column);

  GeneratedColumn<String> get customerId => $composableBuilder(
      column: $table.customerId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get serverSeq =>
      $composableBuilder(column: $table.serverSeq, builder: (column) => column);
}

class $$LocalCustomerPaymentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LocalCustomerPaymentsTable,
    LocalCustomerPayment,
    $$LocalCustomerPaymentsTableFilterComposer,
    $$LocalCustomerPaymentsTableOrderingComposer,
    $$LocalCustomerPaymentsTableAnnotationComposer,
    $$LocalCustomerPaymentsTableCreateCompanionBuilder,
    $$LocalCustomerPaymentsTableUpdateCompanionBuilder,
    (
      LocalCustomerPayment,
      BaseReferences<_$AppDatabase, $LocalCustomerPaymentsTable,
          LocalCustomerPayment>
    ),
    LocalCustomerPayment,
    PrefetchHooks Function()> {
  $$LocalCustomerPaymentsTableTableManager(
      _$AppDatabase db, $LocalCustomerPaymentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalCustomerPaymentsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalCustomerPaymentsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalCustomerPaymentsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> businessId = const Value.absent(),
            Value<String> depotId = const Value.absent(),
            Value<String> customerId = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> deviceId = const Value.absent(),
            Value<int> amount = const Value.absent(),
            Value<String> method = const Value.absent(),
            Value<String?> reference = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> serverSeq = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalCustomerPaymentsCompanion(
            id: id,
            businessId: businessId,
            depotId: depotId,
            customerId: customerId,
            userId: userId,
            deviceId: deviceId,
            amount: amount,
            method: method,
            reference: reference,
            deleted: deleted,
            createdAt: createdAt,
            updatedAt: updatedAt,
            serverSeq: serverSeq,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String businessId,
            required String depotId,
            required String customerId,
            required String userId,
            required String deviceId,
            required int amount,
            required String method,
            Value<String?> reference = const Value.absent(),
            Value<bool> deleted = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> serverSeq = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalCustomerPaymentsCompanion.insert(
            id: id,
            businessId: businessId,
            depotId: depotId,
            customerId: customerId,
            userId: userId,
            deviceId: deviceId,
            amount: amount,
            method: method,
            reference: reference,
            deleted: deleted,
            createdAt: createdAt,
            updatedAt: updatedAt,
            serverSeq: serverSeq,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LocalCustomerPaymentsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $LocalCustomerPaymentsTable,
        LocalCustomerPayment,
        $$LocalCustomerPaymentsTableFilterComposer,
        $$LocalCustomerPaymentsTableOrderingComposer,
        $$LocalCustomerPaymentsTableAnnotationComposer,
        $$LocalCustomerPaymentsTableCreateCompanionBuilder,
        $$LocalCustomerPaymentsTableUpdateCompanionBuilder,
        (
          LocalCustomerPayment,
          BaseReferences<_$AppDatabase, $LocalCustomerPaymentsTable,
              LocalCustomerPayment>
        ),
        LocalCustomerPayment,
        PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SyncOutboxTableTableManager get syncOutbox =>
      $$SyncOutboxTableTableManager(_db, _db.syncOutbox);
  $$SyncStateTableTableManager get syncState =>
      $$SyncStateTableTableManager(_db, _db.syncState);
  $$LocalBusinessesTableTableManager get localBusinesses =>
      $$LocalBusinessesTableTableManager(_db, _db.localBusinesses);
  $$LocalDepotsTableTableManager get localDepots =>
      $$LocalDepotsTableTableManager(_db, _db.localDepots);
  $$LocalUsersTableTableManager get localUsers =>
      $$LocalUsersTableTableManager(_db, _db.localUsers);
  $$LocalCategoriesTableTableManager get localCategories =>
      $$LocalCategoriesTableTableManager(_db, _db.localCategories);
  $$LocalProductsTableTableManager get localProducts =>
      $$LocalProductsTableTableManager(_db, _db.localProducts);
  $$LocalProductUnitsTableTableManager get localProductUnits =>
      $$LocalProductUnitsTableTableManager(_db, _db.localProductUnits);
  $$LocalProductStockLevelsTableTableManager get localProductStockLevels =>
      $$LocalProductStockLevelsTableTableManager(
          _db, _db.localProductStockLevels);
  $$LocalCustomersTableTableManager get localCustomers =>
      $$LocalCustomersTableTableManager(_db, _db.localCustomers);
  $$LocalSalesTableTableManager get localSales =>
      $$LocalSalesTableTableManager(_db, _db.localSales);
  $$LocalSaleLinesTableTableManager get localSaleLines =>
      $$LocalSaleLinesTableTableManager(_db, _db.localSaleLines);
  $$LocalSalePaymentsTableTableManager get localSalePayments =>
      $$LocalSalePaymentsTableTableManager(_db, _db.localSalePayments);
  $$LocalStockMovementsTableTableManager get localStockMovements =>
      $$LocalStockMovementsTableTableManager(_db, _db.localStockMovements);
  $$LocalCustomerPaymentsTableTableManager get localCustomerPayments =>
      $$LocalCustomerPaymentsTableTableManager(_db, _db.localCustomerPayments);
}
