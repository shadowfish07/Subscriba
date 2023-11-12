import 'dart:async';

import 'package:flutter/material.dart';
import 'package:subscriba/src/database/model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:subscriba/src/database/order.dart';

class Subscription extends BaseModel {
  const Subscription(
      {required super.id,
      required this.description,
      required this.title,
      required this.orders,
      required this.isRenew,
      required super.createdAt,
      required super.updatedAt,
      super.deletedAt});

  final String title;
  final String? description;
  final bool isRenew;

  final List<Order> orders;

  static const String columnTitle = "title";
  static const String columnDescription = "description";
  static const String columnIsRenew = "is_renew";

  static const String ordersProperty = "orders";

  @override
  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      ...super.toMap(),
      columnTitle: title,
      columnDescription: description,
      columnIsRenew: isRenew
    };
    return map;
  }

  static Subscription create(
      {String? description, required String title, bool isRenew = true}) {
    return Subscription(
        id: -1,
        createdAt: DateTime.now().microsecondsSinceEpoch,
        updatedAt: DateTime.now().microsecondsSinceEpoch,
        description: description,
        title: title,
        isRenew: isRenew,
        orders: []);
  }

  static Subscription fromMap(Map<String, Object?> map) {
    return Subscription(
        id: map[BaseModel.columnId] as int,
        createdAt: map[BaseModel.columnCreatedAt] as int,
        updatedAt: map[BaseModel.columnUpdatedAt] as int,
        deletedAt: map[BaseModel.columnDeletedAt] as int?,
        description: map[columnDescription] as String?,
        title: map[columnTitle] as String,
        isRenew: map[columnIsRenew] as int == 1 ? true : false,
        orders: map[ordersProperty] as List<Order>? ?? []);
  }

  @override
  String toString() {
    return "${super.toString()} ,title: $title, description: $description, isRenew: $isRenew, orders: $orders)";
  }
}

class SubscriptionProvider extends BaseModalProvider {
  static const tableName = "subscription";

  SubscriptionProvider() {
    super.table = tableName;
  }

  Future<Subscription?> getSubscription(int id) async {
    final map = await super.get(id);
    if (map == null) {
      return null;
    }

    final orders = await getOrders(id);
    final newMap = {...map};
    newMap[Subscription.ordersProperty] = orders;
    return Subscription.fromMap(newMap);
  }

  Future<List<Order>> getOrders(int id) async {
    return await OrderProvider().getOrdersOfSubscription(id);
  }

  Future<List<Subscription>> getSubscriptions() async {
    final map = await super.getAll();
    return (await Future.wait(map.map((e) async {
      final orders = await getOrders(e[BaseModel.columnId] as int);
      final map = {...e};
      map[Subscription.ordersProperty] = orders;
      return Subscription.fromMap(map);
    })))
        .toList();
  }

  Future<bool> setIsRenew(int id, bool isRenew) async {
    final db = await BaseModalProvider.db;

    final count = await db.update(
        table, {Subscription.columnIsRenew: isRenew ? 1 : 0},
        where: '${BaseModel.columnId} = ?', whereArgs: [id]);

    return count > 0;
  }
}
