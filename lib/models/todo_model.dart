// To parse this JSON data, do
//
//     final todoModel = todoModelFromJson(jsonString);

import 'dart:convert';

TodoModel todoModelFromJson(String str) => TodoModel.fromJson(json.decode(str));

String todoModelToJson(TodoModel data) => json.encode(data.toJson());

class TodoModel {
    String title;
    String category;
    bool isCompleted;
    DateTime reminderTime;
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
