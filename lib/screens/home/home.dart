import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:releaf/shared/const/app_theme.dart';
import 'package:releaf/services/auth.dart';
import 'package:releaf/services/database.dart';
import 'package:releaf/screens/home/meditation.dart';
import 'package:releaf/screens/home/tasks.dart';
import 'package:releaf/screens/home/dashboard.dart';
import 'package:releaf/screens/home/journal.dart';
import 'package:releaf/screens/home/settings.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double _borderRadius = 25;

  late PageController _pageController;
  int _currentIndex = 2;

  final List<Widget> _pages = <Widget>[
    Meditation(),
    Tasks(),
    Dashboard(),
    Journal(),
    Settings(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.elementAt(_currentIndex),

      // TODO make rive icons
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 22.0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(_borderRadius),
            topRight: Radius.circular(_borderRadius),
          ),
          child: BottomNavigationBar(
            unselectedItemColor: Colors.black,
            selectedItemColor: Colors.green,
            showUnselectedLabels: true,
            enableFeedback: true,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.sports_handball_outlined),
                activeIcon: Icon(Icons.sports_handball),
                label: 'Meditation',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.assignment_turned_in_outlined),
                activeIcon: Icon(Icons.assignment_turned_in),
                label: 'Goals',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_outlined),
                activeIcon: Icon(Icons.dashboard_rounded),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book_outlined),
                activeIcon: Icon(Icons.book_rounded),
                label: 'Journal',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                activeIcon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
            currentIndex: _currentIndex,
            onTap: _changePage,
          ),
        ),
      ),
    );
  }

  void _changePage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
