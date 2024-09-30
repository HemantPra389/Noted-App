import 'package:flutter/material.dart';
import 'package:noted/core/app_colors.dart';
import 'package:noted/models/category_model.dart';
import 'package:noted/models/todo_model.dart';
import 'package:noted/providers/todo_handler_provider.dart';
import 'package:provider/provider.dart';

class TodoFormWidget extends StatefulWidget {
  const TodoFormWidget({super.key});

  @override
  _TodoFormWidgetState createState() => _TodoFormWidgetState();
}

class _TodoFormWidgetState extends State<TodoFormWidget> {
  final _formKey = GlobalKey<FormState>();
  String? _title;
  String? _category;
  TimeOfDay? _reminderTime;
  String? _newCategory;
  final List<String> _categories = ['Personal', 'Work', 'Other'];
  DateTime convertTimeOfDayToDateTime(TimeOfDay timeOfDay, DateTime date) {
    return DateTime(
        date.year, date.month, date.day, timeOfDay.hour, timeOfDay.minute);
  }

  @override
  Widget build(BuildContext context) {
    final todoHandler = Provider.of<TodoHandlerProvider>(context);
    return Dialog(
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                offset: Offset(6, 6),
                spreadRadius: 2,
                blurStyle: BlurStyle.solid,
              ),
            ],
          ),
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: CloseButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const Center(
                  child: Text(
                    "Add Task",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Category",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[400]!),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _category,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    isExpanded: true,
                    items: _categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _category = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Please select a category' : null,
                  ),
                ),
                if (_category == 'Other') ...[
                  const SizedBox(height: 16),
                  const Text(
                    "Add Category",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    onChanged: (value) {
                      setState(() {
                        _newCategory = value;
                      });
                    },
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a category' : null,
                  ),
                ],
                const SizedBox(height: 16),
                const Text(
                  "Task",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  onChanged: (value) {
                    setState(() {
                      _title = value;
                    });
                  },
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a task title' : null,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Reminder Timing",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: _reminderTime ?? TimeOfDay.now(),
                    );

                    if (pickedTime != null && pickedTime != _reminderTime) {
                      setState(() {
                        _reminderTime = pickedTime;
                      });
                    }
                  },
                  controller: TextEditingController(
                    text: _reminderTime == null
                        ? ''
                        : _reminderTime!.format(context),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please pick a reminder time' : null,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (_category == 'Other' &&
                            _newCategory != null &&
                            _newCategory!.isNotEmpty) {
                          todoHandler.saveCategory(
                              categoryModel: CategoryModel(
                                  title: _newCategory!,
                                  createdAt: DateTime.now()));
                          // _categories.add(_newCategory!);
                          _category = _newCategory;
                        }
                        todoHandler
                            .saveTask(
                                todoModel: TodoModel(
                                    title: _title!,
                                    category: _category!,
                                    isCompleted: false,
                                    reminderTime: convertTimeOfDayToDateTime(
                                        _reminderTime!, DateTime.now()),
                                    createdAt: DateTime.now()))
                            .whenComplete(() => Navigator.of(context).pop());
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          const WidgetStatePropertyAll(TColors.appPrimaryColor),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
