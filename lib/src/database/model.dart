import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:subscriba/src/database/order.dart';
import 'package:subscriba/src/database/subscription.dart';
import 'package:sqflite_common/sqflite_logger.dart';

abstract class BaseModel {
  const BaseModel(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt});

  final int id;
  final int? deletedAt;
  final int createdAt;
  final int updatedAt;

  static const String columnId = "id";
  static const String columnCreatedAt = "created_at";
  static const String columnUpdatedAt = "updated_at";
  static const String columnDeletedAt = "deleted_at";

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      columnId: id,
      columnCreatedAt: createdAt,
      columnUpdatedAt: updatedAt,
      columnDeletedAt: deletedAt
    };

    return map;
  }

  static BaseModel fromMap(Map<String, Object?> map) {
    throw UnimplementedError();
  }

  @override
  String toString() {
    return "$runtimeType(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt";
  }
}

class BaseModalProvider<T extends BaseModel> {
  static final Future<Database> db = open();
  late String table;
  var createCompleter = Completer();

  static const createBaseColumns = '''
  ${BaseModel.columnId} integer primary key autoincrement,
  ${BaseModel.columnCreatedAt} integer not null,
  ${BaseModel.columnUpdatedAt} integer not null,
  ${BaseModel.columnDeletedAt} integer''';

  static Future<Database> open() async {
    var factoryWithLogs = SqfliteDatabaseFactoryLogger(databaseFactory,
        options:
            SqfliteLoggerOptions(type: SqfliteDatabaseFactoryLoggerType.all));
    Completer onCreateCompleter = Completer();
    var databasesPath = await getApplicationSupportDirectory();
    debugPrint("databasesPath: ${p.join(databasesPath.path, "subscriba.db")}");
    final result = factoryWithLogs.openDatabase(
      p.join(databasesPath.path, "subscriba.db"),
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (Database db, int version) async {
          debugPrint("onCreate");
          await db.execute('''
create table ${SubscriptionProvider.tableName} (
  ${BaseModalProvider.createBaseColumns},
  ${Subscription.columnTitle} text not null,
  ${Subscription.columnIsRenew} integer not null,
  ${Subscription.columnDescription} text)
''');

          await db.execute('''
create table "${OrderProvider.tableName}" (
  ${BaseModalProvider.createBaseColumns},
  ${Order.columnSubscriptionId} integer not null,
  ${Order.columnDescription} text,
  ${Order.columnOrderDate} integer not null,
  ${Order.columnPaymentType} integer not null,
  ${Order.columnStartDate} integer not null,
  ${Order.columnEndDate} integer,
  ${Order.columnPaymentCycleType} integer,
  ${Order.columnPaymentPerPeriod} REAL not null,
  ${Order.columnPaymentPerPeriodUnit} text)
''');
        },
        onOpen: (db) {
          debugPrint("open");
          onCreateCompleter.complete();
        },
      ),
    );

    await onCreateCompleter.future;

    return result;
  }

  Future<int> insert(T modal) async {
    final db = await BaseModalProvider.db;

    final mapWithoutId = modal.toMap();
    mapWithoutId.remove("id");

    final id = await db.insert(table, mapWithoutId);
    debugPrint("[modal-insert] inserted $id with $mapWithoutId");
    return id;
  }

  Future<Map<String, Object?>?> get(int id) async {
    final db = await BaseModalProvider.db;

    List<Map> maps = await db.query(table,
        columns: null, where: '${BaseModel.columnId} = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return maps.first as Map<String, Object?>;
    }
    return null;
  }

  Future<List<Map<String, Object?>>> getAll() async {
    final db = await BaseModalProvider.db;

    return await db.query(table, columns: null);
  }

  Future<bool> delete(int id) async {
    final db = await BaseModalProvider.db;
    final count = await db.update(table,
        {BaseModel.columnDeletedAt: DateTime.now().microsecondsSinceEpoch},
        where: '${BaseModel.columnId} = ?', whereArgs: [id]);

    return count > 0;
  }

  Future<bool> update(T modal) async {
    final db = await BaseModalProvider.db;
    final count = await db.update(table, modal.toMap(),
        where: '${BaseModel.columnId} = ?', whereArgs: [modal.id]);

    return count > 0;
  }

  Future close() async {
    final db = await BaseModalProvider.db;

    await db.close();
    createCompleter = Completer();
  }
}
