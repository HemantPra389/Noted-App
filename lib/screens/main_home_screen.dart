import 'package:flutter/material.dart';
import 'package:noted/core/app_colors.dart';
import 'package:noted/providers/todo_handler_provider.dart';
import 'package:noted/widgets/todo_form_widget.dart';
import 'package:provider/provider.dart';
import 'bottom_screens/home_screen.dart';
import 'bottom_screens/profile_screen.dart';
import 'bottom_screens/setting_screen.dart';

class MainHomeScreen extends StatefulWidget {
  @override
  _MainHomeScreenState createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> widgetOptions = [
    HomeScreen(),
    ProfileScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Hello Christina!'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
        child: widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        selectedItemColor: TColors.appPrimaryColor,
        unselectedItemColor: Colors.blueGrey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: TColors.appPrimaryColor,
          onPressed: () {
            showDialog(
                context: context,
                builder: (ctx) {
                  return ChangeNotifierProvider(
                      create: (context) => TodoHandlerProvider(),
                      child: TodoFormWidget());
                });
          },
          child: const Icon(Icons.add)),
    );
  }
}
