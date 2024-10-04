import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:noted/core/app_colors.dart';
import 'package:noted/core/hive_constants.dart';
import 'package:noted/models/todo_model.dart';
import 'package:noted/providers/todo_handler_provider.dart';
import 'package:noted/widgets/popup_menu_helper.dart';
import 'package:provider/provider.dart';

class DailyScreen extends StatefulWidget {
  const DailyScreen({super.key});

  @override
  State<DailyScreen> createState() => _DailyScreenState();
}

class _DailyScreenState extends State<DailyScreen>
    with AutomaticKeepAliveClientMixin {
  DateTime _selectedDate = DateTime.now(); // State variable to track the date

  // Format the date to a string for display purposes
  String formatDateTimeToString(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
  }

  // Format the time from the DateTime object
  String formatTimeFromDateTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  // Move to the previous day
  void _goToPreviousDay() {
    setState(() {
      _selectedDate = _selectedDate.subtract(const Duration(days: 1));
    });
  }

  // Move to the next day
  void _goToNextDay() {
    setState(() {
      _selectedDate = _selectedDate.add(const Duration(days: 1));
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: _goToPreviousDay, // Go to the previous day
          ),
          Text(
            formatDateTimeToString(_selectedDate), // Display the current date
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: _goToNextDay, // Go to the next day
          ),
        ],
      ),
      const Gap(12),
      ValueListenableBuilder(
        valueListenable:
            Hive.box<TodoModel>(HiveConstants.todoBox).listenable(),
        builder: (context, value, child) {
          var data = value.values;
          var box = Hive.box<TodoModel>(HiveConstants.todoReportBox).values;

          return ListView.builder(
              shrinkWrap: true,
              itemCount: data.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final todo = data.elementAt(index);
                bool isCompleted = box.any((element) =>
                    (element.title == todo.title &&
                        element.category == todo.category &&
                        element.reminderTime == todo.reminderTime) &&
                    (todo.createdAt.year == _selectedDate.year &&
                        todo.createdAt.month == _selectedDate.month &&
                        todo.createdAt.day == _selectedDate.day));
                return Container(
                  margin: const EdgeInsets.all(6),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                      border: Border.all(),
                      color:
                          isCompleted ? TColors.appPrimaryColor : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black,
                            offset: Offset(1.5, 2),
                            spreadRadius: 2,
                            blurStyle: BlurStyle.solid)
                      ]),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                              backgroundColor: Colors.redAccent, radius: 8),
                          const Gap(8),
                          Text(todo.category),
                          Spacer(),
                          PopupMenuHelper.buildPopupMenu(context,
                              onSelected: (value) async {
                            switch (value) {
                              case "complete":
                                await Provider.of<TodoHandlerProvider>(context,
                                        listen: false)
                                    .completeTask(
                                        todoModel: TodoModel(
                                            title: todo.title,
                                            category: todo.category,
                                            isCompleted: true,
                                            reminderTime: todo.reminderTime,
                                            createdAt: DateTime.now()));
                                break;
                              case "delete":
                                await Provider.of<TodoHandlerProvider>(context,
                                        listen: false)
                                    .deleteTask(index);
                                break;
                              default:
                                break;
                            }
                          }, optionsList: [
                            if (!isCompleted) {"complete": "Complete"},
                            {"delete": "Delete"}
                          ])
                        ],
                      ),
                      const Gap(8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            todo.title,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          const Icon(Icons.flag, color: Colors.redAccent)
                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_month_rounded,
                            color: Colors.black54,
                          ),
                          const Gap(8),
                          Text(formatDateTimeToString(todo.createdAt))
                        ],
                      ),
                      const Gap(4),
                      Row(
                        children: [
                          const Icon(
                            Icons.timelapse_rounded,
                            color: Colors.black54,
                          ),
                          const Gap(8),
                          Text(formatTimeFromDateTime(todo.reminderTime))
                        ],
                      ),
                    ],
                  ),
                );
              });
        },
      )
    ]);
  }

  @override
  bool get wantKeepAlive => true;
}
