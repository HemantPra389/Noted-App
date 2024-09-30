// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
part 'category_model.g.dart'; // Generated file for Hive

CategoryModel categoryModelFromJson(String str) =>
    CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

@HiveType(typeId: 1)
class CategoryModel {
  @HiveField(0)
  String title;
  @HiveField(1)
  DateTime createdAt;

  CategoryModel({
    required this.title,
    required this.createdAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        title: json["title"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "createdAt": createdAt.toIso8601String(),
      };
}
