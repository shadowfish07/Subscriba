import 'dart:async';

import 'package:subscriba/src/database/model.dart';
import 'package:subscriba/src/util/currency.dart';
import 'package:subscriba/src/util/currency_amount.dart';

enum PaymentType { recurring, lifetime }

enum PaymentFrequency { daily, monthly, yearly, oneTime }

class Order extends BaseModel {
  const Order({
    required super.id,
    this.description,
    required super.createdAt,
    required super.updatedAt,
    super.deletedAt,
    required this.subscriptionId,
    required this.orderDate,
    required this.paymentType,
    required this.startDate,
    this.endDate,
    this.paymentFrequency,
    required this.paymentPerPeriod,
  });

  final int subscriptionId;
  final String? description;
  final int orderDate;
  // 0-> recurring 1-> one-time
  final PaymentType paymentType;
  final int startDate;
  // recurring Type only
  final int? endDate;
  // recurring Type only
  // 0-> day 1-> month 2-> year 3-> one-time
  final PaymentFrequency? paymentFrequency;
  // 实付
  final CurrencyAmount paymentPerPeriod;

  static const String columnSubscriptionId = "subscription_id";
  static const String columnDescription = "description";
  static const String columnOrderDate = "order_date";
  static const String columnPaymentType = "payment_type";
  static const String columnStartDate = "start_date";
  static const String columnEndDate = "end_date";
  static const String columnPaymentFrequency = "payment_frequency";
  static const String columnPaymentPerPeriod = "payment_per_period";
  // 存储USD/CNY 等三字母代码
  static const String columnPaymentCurrencyPerPeriod =
      "payment_currency_per_period";

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
      columnPaymentFrequency: paymentFrequency?.index,
      columnPaymentPerPeriod: paymentPerPeriod.amount,
      columnPaymentCurrencyPerPeriod: paymentPerPeriod.currency.ISOCode
    };
    return map;
  }

  static Order create({
    int? id,
    String? description,
    required int orderDate,
    required PaymentType paymentType,
    required int startDate,
    required int subscriptionId,
    int? endDate,
    PaymentFrequency? paymentFrequency,
    required CurrencyAmount paymentPerPeriod,
  }) {
    return Order(
      id: id ?? -1,
      createdAt: DateTime.now().microsecondsSinceEpoch,
      updatedAt: DateTime.now().microsecondsSinceEpoch,
      subscriptionId: subscriptionId,
      description: description,
      orderDate: orderDate,
      paymentType: paymentType,
      startDate: startDate,
      endDate: endDate,
      paymentFrequency: paymentFrequency,
      paymentPerPeriod: paymentPerPeriod,
    );
  }

  static Order fromMap(Map<String, Object?> map) {
    return Order(
        id: map[BaseModel.columnId] as int,
        createdAt: map[BaseModel.columnCreatedAt] as int,
        updatedAt: map[BaseModel.columnUpdatedAt] as int,
        deletedAt: map[BaseModel.columnDeletedAt] as int?,
        subscriptionId: map[columnSubscriptionId] as int,
        description: map[columnDescription] as String?,
        orderDate: map[columnOrderDate] as int,
        paymentType: PaymentType.values[map[columnPaymentType] as int],
        startDate: map[columnStartDate] as int,
        endDate: map[columnEndDate] as int?,
        paymentFrequency: map[columnPaymentFrequency] != null
            ? PaymentFrequency.values[map[columnPaymentFrequency] as int]
            : null,
        paymentPerPeriod: CurrencyAmount(
            currency: Currency.fromISOCode(
                map[columnPaymentCurrencyPerPeriod] as String),
            amount: map[columnPaymentPerPeriod] as double));
  }

  @override
  String toString() {
    return "${super.toString()} , subscriptionId: $subscriptionId, description: $description, orderDate: $orderDate, paymentType: $paymentType, startDate: $startDate, endDate: $endDate, paymentFrequency: $paymentFrequency, paymentPerPeriod: $paymentPerPeriod)";
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

    final newMap = {...map}..['paymentCurrencyPerPeriod'] =
        Currency.fromISOCode(
            map["paymentCurrencyPerPeriod"] as String? ?? "CNY");

    return Order.fromMap(newMap);
  }

  Future<List<Order>> getOrdersOfSubscription(int subscriptionId) async {
    final db = await BaseModalProvider.db;

    final List<Map<String, Object?>> maps = await db.query(tableName,
        where: "subscription_id = ? AND ${BaseModel.columnDeletedAt} is null",
        whereArgs: [subscriptionId]);

    return maps.map((e) {
      final newMap = {...e}..['paymentCurrencyPerPeriod'] =
          Currency.fromISOCode(
              e["paymentCurrencyPerPeriod"] as String? ?? "CNY");

      return Order.fromMap(newMap);
    }).toList();
  }
}
