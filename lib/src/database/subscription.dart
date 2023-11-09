import 'dart:async';

import 'package:flutter/material.dart';
import 'package:subscriba/src/database/model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class Subscription extends BaseModel {
  const Subscription(
      {required super.id,
      required this.description,
      required this.title,
      required super.createdAt,
      required super.updatedAt,
      super.deletedAt});

  final String title;
  final String? description;

  static const String columnTitle = "title";
  static const String columnDescription = "description";

  @override
  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      ...super.toMap(),
      columnTitle: title,
      columnDescription: description
    };
    return map;
  }

  static Subscription create({String? description, required String title}) {
    return Subscription(
        id: -1,
        createdAt: DateTime.now().microsecondsSinceEpoch,
        updatedAt: DateTime.now().microsecondsSinceEpoch,
        description: description,
        title: title);
  }

  static Subscription fromMap(Map<String, Object?> map) {
    return Subscription(
        id: map[BaseModel.columnId] as int,
        createdAt: map[BaseModel.columnCreatedAt] as int,
        updatedAt: map[BaseModel.columnUpdatedAt] as int,
        deletedAt: map[BaseModel.columnDeletedAt] as int?,
        description: map[columnDescription] as String,
        title: map[columnTitle] as String);
  }

  @override
  String toString() {
    return "${super.toString()} ,title: $title, description: $description)";
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

    return Subscription.fromMap(map);
  }
}
