import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:noted/core/hive_constants.dart';
import '../models/category_model.dart';
import '../models/todo_model.dart';

class TodoHandlerProvider extends ChangeNotifier {
  List<TodoModel> _todos = [];
  List<CategoryModel> _categories = [];

  TodoHandlerProvider() {
    _loadData();
  }

  List<TodoModel> get todos => _todos;
  List<CategoryModel> get categories => _categories;

  Future<void> _loadData() async {
    _todos = await getTasks();
    _categories = await getCategories();
    notifyListeners();
  }

  Future<bool> saveTask({required TodoModel todoModel}) async {
    try {
      await Hive.box<TodoModel>(HiveConstants.todoBox).add(todoModel);
      _todos.add(todoModel);
      notifyListeners();
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> completeTask({required TodoModel todoModel}) async {
    try {
      var todoBox = Hive.box<TodoModel>(HiveConstants.todoReportBox);

      // Check if a task with the same date (based on reminderTime) already exists
      bool taskExists = todoBox.values.any((task) =>
          ((task.reminderTime.day == todoModel.reminderTime.day) &&
              (task.reminderTime.month == todoModel.reminderTime.month) &&
              (task.reminderTime.year == todoModel.reminderTime.year)) &&
          task.title == todoModel.title);

      if (!taskExists) {
        // Add the task if it doesn't exist for the same date
        await todoBox.add(todoModel);

        _todos.add(todoModel); // Add to the local list
        notifyListeners(); // Notify listeners about the change

        return true; // Task successfully added
      } else {
        Fluttertoast.showToast(msg: "Already Completed !!");
        return false; // Task for that date already exists, do nothing
      }
    } catch (e) {
      log(e.toString());
      return false; // Return false if an error occurs
    }
  }

  Future<bool> saveCategory({required CategoryModel categoryModel}) async {
    try {
      await Hive.box<CategoryModel>(HiveConstants.categoryBox)
          .add(categoryModel);
      _categories.add(categoryModel);
      notifyListeners();
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<List<TodoModel>> getTasks() async {
    try {
      var box = Hive.box<TodoModel>(HiveConstants.todoBox);
      return box.values.toList();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<List<CategoryModel>> getCategories() async {
    try {
      var box = Hive.box<CategoryModel>(HiveConstants.categoryBox);
      return box.values.toList();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<bool> updateTask(
      {required int index, required TodoModel updatedTodo}) async {
    try {
      var box = Hive.box<TodoModel>(HiveConstants.todoBox);
      await box.putAt(index, updatedTodo);
      _todos[index] = updatedTodo; // Update the in-memory list
      notifyListeners();
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> updateCategory(
      {required int index, required CategoryModel updatedCategory}) async {
    try {
      var box = Hive.box<CategoryModel>(HiveConstants.categoryBox);
      await box.putAt(index, updatedCategory);
      _categories[index] = updatedCategory; // Update the in-memory list
      notifyListeners();
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> deleteTask(int index) async {
    try {
      var box = Hive.box<TodoModel>(HiveConstants.todoBox);
      await box.deleteAt(index);
      _todos.removeAt(index); // Remove from the in-memory list
      notifyListeners();
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> deleteCategory(int index) async {
    try {
      var box = Hive.box<CategoryModel>(HiveConstants.categoryBox);
      await box.deleteAt(index);
      _categories.removeAt(index); // Remove from the in-memory list
      notifyListeners();
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
