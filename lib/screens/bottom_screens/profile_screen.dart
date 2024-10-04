import 'dart:math';

import 'package:flutter/material.dart';
import 'package:noted/core/app_colors.dart';
import 'package:noted/widgets/custom_bar_chart.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 0;

  final List<Color> colors = [
    Colors.orangeAccent,
    Colors.blueAccent,
    Colors.greenAccent,
    Colors.redAccent,
    Colors.purpleAccent
  ];

  final List<String> categories = [
    'Work',
    'Personal',
    'Shopping',
    'Fitness',
    'Study',
    'Travel',
    'Health',
    'Hobby'
  ];

  final List<int> taskCounts =
      List.generate(8, (index) => Random().nextInt(30) + 1);

  @override
  Widget build(BuildContext context) {
    List<String> titlesList = ["daily", "weekly", "monthly"];
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: List.generate(
              3,
              (index) => Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              if (index == _selectedIndex)
                                const BoxShadow(
                                    color: Colors.black,
                                    offset: Offset(1.5, 1.8),
                                    spreadRadius: 2,
                                    blurStyle: BlurStyle.solid)
                            ],
                            color: index == _selectedIndex
                                ? TColors.appPrimaryColor
                                : Colors.white),
                        child: Text(titlesList[index]),
                      ),
                    ),
                  )),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                icon: const Icon(Icons.arrow_back_ios), onPressed: () {}),
            const Text(
              'This Week',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            IconButton(
                icon: const Icon(Icons.arrow_forward_ios), onPressed: () {}),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Weekly overview',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 24),
        SizedBox(
            height: MediaQuery.of(context).size.height * .3,
            child: CustomBarChart(
                context: context,
                daysData: [1, 2, 3, 4],
                totalHabitLength: 4,
                startDate: DateTime.now().subtract(const Duration(days: 4)),
                endDate: DateTime.now())),
        const SizedBox(height: 12),
        Divider(),
        const Text(
          'Category analytics',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        Column(
          children: List.generate(
            8,
            (index) {
              // Select random values from the lists
              final color = colors[Random().nextInt(colors.length)];
              final category = categories[index];
              final taskCount = taskCounts[index];

              return ListTile(
                leading: CircleAvatar(backgroundColor: color),
                contentPadding: const EdgeInsets.symmetric(vertical: 4),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          height: 8,
                          width: MediaQuery.of(context).size.width * .4,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "$taskCount Tasks",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded),
              );
            },
          ),
        )
      ]),
    );
  }
}
