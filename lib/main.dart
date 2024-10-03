import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:noted/core/hive_constants.dart';
import 'package:noted/models/category_model.dart';
import 'package:noted/models/todo_model.dart';
import 'package:noted/providers/todo_handler_provider.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'screens/main_home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await openHiveBoxes().whenComplete(() {
    runApp(const MyApp());
  });
}

Future<void> openHiveBoxes() async {
  Directory directory = await path_provider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(directory.path);
  Hive.registerAdapter(TodoModelAdapter());
  Hive.registerAdapter(CategoryModelAdapter());
  await Hive.openBox<CategoryModel>(HiveConstants.categoryBox);
  await Hive.openBox<TodoModel>(HiveConstants.todoBox);
  await Hive.openBox<TodoModel>(HiveConstants.todoReportBox);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider(
          create: (context) => TodoHandlerProvider(), child: MainHomeScreen()),
    );
  }
}
