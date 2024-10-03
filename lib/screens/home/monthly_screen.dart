import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:noted/core/app_colors.dart';
import 'package:noted/core/hive_constants.dart';
import 'package:noted/models/todo_model.dart';
import 'package:noted/providers/todo_handler_provider.dart';
import 'package:noted/widgets/popup_menu_helper.dart';
import 'package:provider/provider.dart';

class MonthlyScreen extends StatefulWidget {
  const MonthlyScreen({super.key});

  @override
  State<MonthlyScreen> createState() => _MonthlyScreenState();
}

class _MonthlyScreenState extends State<MonthlyScreen> {
  late DateTime currentMonth;
  late List<DateTime> datesGrid;

  @override
  void initState() {
    super.initState();
    currentMonth = DateTime.now();
    datesGrid = _generateDatesGrid(currentMonth);
  }

  String _monthName(int monthNumber) {
    return [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ][monthNumber - 1];
  }

  List<DateTime> _generateDatesGrid(DateTime month) {
    int numDays = DateTime(month.year, month.month + 1, 0).day;
    int firstWeekday = DateTime(month.year, month.month, 1).weekday % 7;
    List<DateTime> dates = [];

    // Fill previous month's dates
    DateTime previousMonth = DateTime(month.year, month.month - 1);
    int previousMonthLastDay =
        DateTime(previousMonth.year, previousMonth.month + 1, 0).day;
    for (int i = firstWeekday; i > 0; i--) {
      dates.add(DateTime(previousMonth.year, previousMonth.month,
          previousMonthLastDay - i + 1));
    }

    // Fill current month's dates
    for (int day = 1; day <= numDays; day++) {
      dates.add(DateTime(month.year, month.month, day));
    }

    // Fill next month's dates
    int remainingBoxes = 42 - dates.length; // 6 weeks * 7 days
    for (int day = 1; day <= remainingBoxes; day++) {
      dates.add(DateTime(month.year, month.month + 1, day));
    }

    return dates;
  }

  void _changeMonth(int offset) {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month + offset);
      datesGrid = _generateDatesGrid(currentMonth);
    });
  }

  String formatDateTimeToString(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
  }

  String formatTimeFromDateTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  bool areAllTasksCompletedForDate(Box<TodoModel> box, DateTime date) {
    var tasksForDate = box.values.where((task) =>
        task.createdAt.year == date.year &&
        task.createdAt.month == date.month &&
        task.createdAt.day == date.day);
    return tasksForDate.isNotEmpty &&
        tasksForDate.every((task) => task.isCompleted);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            ValueListenableBuilder(
                valueListenable:
                    Hive.box<TodoModel>(HiveConstants.todoReportBox)
                        .listenable(),
                builder: (context, box, child) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios),
                            onPressed: () => _changeMonth(-1),
                          ),
                          Text(
                            '${_monthName(currentMonth.month)} ${currentMonth.year}',
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w500),
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios),
                            onPressed: () => _changeMonth(1),
                          ),
                        ],
                      ),
                      const Gap(12),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                              7,
                              (index) => Text(
                                    [
                                      'Sun',
                                      'Mon',
                                      'Tue',
                                      'Wed',
                                      'Thu',
                                      'Fri',
                                      'Sat'
                                    ][index],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        color: Colors.blueGrey),
                                  )),
                        ),
                      ),
                      const Gap(12),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 7),
                        itemCount: datesGrid.length,
                        itemBuilder: (context, index) {
                          DateTime date = datesGrid[index];
                          bool isCurrentMonth =
                              date.month == currentMonth.month;
                          bool isCompleted =
                              areAllTasksCompletedForDate(box, date);
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: CircleAvatar(
                              backgroundColor: isCompleted
                                  ? TColors.appPrimaryColor
                                  : Colors.transparent,
                              child: Text(
                                date.day.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: isCompleted
                                      ? Colors.white
                                      : isCurrentMonth
                                          ? Colors.black
                                          : Colors.grey,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                }),
            const Divider(),
            ValueListenableBuilder(
              valueListenable:
                  Hive.box<TodoModel>(HiveConstants.todoBox).listenable(),
              builder: (context, value, child) {
                var data = value.values;
                var box =
                    Hive.box<TodoModel>(HiveConstants.todoReportBox).values;
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final todo = data.elementAt(index);
                      bool isCompleted = box.any((element) =>
                          element.title == todo.title &&
                          element.category == todo.category &&
                          element.reminderTime == todo.reminderTime);
                      return Container(
                        margin: const EdgeInsets.all(6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 16),
                        decoration: BoxDecoration(
                            border: Border.all(),
                            color: isCompleted
                                ? TColors.appPrimaryColor
                                : Colors.white,
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
                                    backgroundColor: Colors.redAccent,
                                    radius: 8),
                                const Gap(8),
                                Text(todo.category),
                                Spacer(),
                                PopupMenuHelper.buildPopupMenu(context,
                                    onSelected: (value) async {
                                  switch (value) {
                                    case "complete":
                                      await Provider.of<TodoHandlerProvider>(
                                              context,
                                              listen: false)
                                          .completeTask(
                                              todoModel: TodoModel(
                                                  title: todo.title,
                                                  category: todo.category,
                                                  isCompleted: true,
                                                  reminderTime:
                                                      todo.reminderTime,
                                                  createdAt: DateTime.now()));
                                      break;
                                    case "delete":
                                      await Provider.of<TodoHandlerProvider>(
                                              context,
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
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
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
          ],
        ));
  }
}
