import 'package:flutter/material.dart';
import 'package:noted/core/app_colors.dart';
import 'package:noted/screens/home/daily_screen.dart';
import 'package:noted/screens/home/monthly_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final TabController _tabController;
  final List<Widget> _body = [const MonthlyScreen(), const DailyScreen()];

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Column(
        children: [
          Container(
            height: kToolbarHeight - 8.0,
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: TColors.appPrimaryColor,
              ),
              padding: const EdgeInsets.all(4),
              labelStyle: Theme.of(context).textTheme.titleMedium,
              unselectedLabelStyle: Theme.of(context).textTheme.titleMedium!,
              tabs: const [
                Tab(text: "monthly"),
                Tab(text: "daily"),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: _body,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
