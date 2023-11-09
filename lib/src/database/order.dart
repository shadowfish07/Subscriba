import 'dart:async';

import 'package:flutter/material.dart';
import 'package:subscriba/src/database/model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

enum PaymentType { recurring, onetime }

enum PaymentCycleType { daily, monthly, yearly }

class Order extends BaseModel {
  const Order(
      {required super.id,
      required this.description,
      required super.createdAt,
      required super.updatedAt,
      super.deletedAt,
      required this.subscriptionId,
      required this.orderDate,
      required this.paymentType,
      required this.startDate,
      this.endDate,
      this.paymentCycleType,
      this.paymentPerPeriod,
      this.paymentPerPeriodUnit});

  final int subscriptionId;
  final String? description;
  final int orderDate;
  // 0-> recurring 1-> one-time
  final PaymentType paymentType;
  final int startDate;
  // recurring Type only
  final int? endDate;
  // recurring Type only
  // 0-> day 1-> month 2-> year
  final PaymentCycleType? paymentCycleType;
  // recurring Type only
  final int? paymentPerPeriod;
  // recurring Type only
  // $/￥
  final String? paymentPerPeriodUnit;

  static const String columnSubscriptionId = "subscription_id";
  static const String columnDescription = "description";
  static const String columnOrderDate = "order_date";
  static const String columnPaymentType = "payment_type";
  static const String columnStartDate = "start_date";
  static const String columnEndDate = "end_date";
  static const String columnPaymentCycleType = "payment_cycle_type";
  static const String columnPaymentPerPeriod = "payment_per_period";
  static const String columnPaymentPerPeriodUnit = "payment_per_period_unit";

  @override
  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      ...super.toMap(),
      columnSubscriptionId: subscriptionId,
      columnDescription: description,
      columnOrderDate: orderDate,
      columnPaymentType: paymentType.index,
      columnStartDate: startDate,
      columnEndDate: endDate,
      columnPaymentCycleType: paymentCycleType?.index,
      columnPaymentPerPeriod: paymentPerPeriod,
      columnPaymentPerPeriodUnit: paymentPerPeriodUnit
    };
    return map;
  }

  static Order create(
      {String? description,
      required int orderDate,
      required PaymentType paymentType,
      required int startDate,
      required int subscriptionId,
      int? endDate,
      PaymentCycleType? paymentCycleType,
      int? paymentPerPeriod,
      String? paymentPerPeriodUnit}) {
    return Order(
      id: -1,
      createdAt: DateTime.now().microsecondsSinceEpoch,
      updatedAt: DateTime.now().microsecondsSinceEpoch,
      subscriptionId: subscriptionId,
      description: description,
      orderDate: orderDate,
      paymentType: paymentType,
      startDate: startDate,
      endDate: endDate,
      paymentCycleType: paymentCycleType,
      paymentPerPeriod: paymentPerPeriod,
      paymentPerPeriodUnit: paymentPerPeriodUnit,
    );
  }

  static Order fromMap(Map<String, Object?> map) {
    return Order(
        id: map[BaseModel.columnId] as int,
        createdAt: map[BaseModel.columnCreatedAt] as int,
        updatedAt: map[BaseModel.columnUpdatedAt] as int,
        deletedAt: map[BaseModel.columnDeletedAt] as int?,
        subscriptionId: map[columnSubscriptionId] as int,
        description: map[columnDescription] as String,
        orderDate: map[columnOrderDate] as int,
        paymentType: PaymentType.values[map[columnPaymentType] as int],
        startDate: map[columnStartDate] as int,
        endDate: map[columnEndDate] as int?,
        paymentCycleType: map[columnPaymentCycleType] != null
            ? PaymentCycleType.values[map[columnPaymentCycleType] as int]
            : null,
        paymentPerPeriod: map[columnPaymentPerPeriod] as int?,
        paymentPerPeriodUnit: map[columnPaymentPerPeriodUnit] as String?);
  }

  @override
  String toString() {
    return "${super.toString()} , subscriptionId: $subscriptionId, description: $description, orderDate: $orderDate, paymentType: $paymentType, startDate: $startDate, endDate: $endDate, paymentCycleType: $paymentCycleType, paymentPerPeriod: $paymentPerPeriod, paymentPerPeriodUnit: $paymentPerPeriodUnit)";
  }
}

class OrderProvider extends BaseModalProvider {
  static const tableName = "order";

  OrderProvider() {
    super.table = tableName;
  }

  Future<Order?> getOrder(int id) async {
    final map = await super.get(id);
    if (map == null) {
      return null;
    }

    return Order.fromMap(map);
  }
}
