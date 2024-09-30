// To parse this JSON data, do
//
//     final todoModel = todoModelFromJson(jsonString);

import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
part 'todo_model.g.dart'; // Generated file for Hive

TodoModel todoModelFromJson(String str) => TodoModel.fromJson(json.decode(str));

String todoModelToJson(TodoModel data) => json.encode(data.toJson());

@HiveType(typeId: 0)
class TodoModel {
  @HiveField(0)
  String title;
  @HiveField(1)
  String category;
  @HiveField(2)
  bool isCompleted;
  @HiveField(3)
  DateTime reminderTime;
  @HiveField(4)
  DateTime createdAt;

  TodoModel({
    required this.title,
    required this.category,
    required this.isCompleted,
    required this.reminderTime,
    required this.createdAt,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) => TodoModel(
        title: json["title"],
        category: json["category"],
        isCompleted: json["isCompleted"],
        reminderTime: DateTime.parse(json["reminderTime"]),
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "category": category,
        "isCompleted": isCompleted,
        "reminderTime": reminderTime.toIso8601String(),
        "createdAt": createdAt.toIso8601String(),
      };
}
