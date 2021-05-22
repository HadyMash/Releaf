import 'package:animations/animations.dart';
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
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: AppTheme.homeNavkey,
      initialRoute: '/Dashboard',
      onGenerateRoute: (RouteSettings route) {
        Widget page;

        switch (route.name) {
          case '/Meditation':
            page = Meditation();
            break;
          case '/Tasks':
            page = Tasks(false);
            break;
          case '/Dashboard':
            page = Dashboard();
            break;
          case '/Journal':
            page = Journal(false);
            break;
          case '/Settings':
            page = Settings();
            break;
          default:
            page = Dashboard();
            break;
        }

        return PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 250),
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return page;
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return Align(
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
        );
      },
    );
  }
}

/*
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double _borderRadius = 25;
  // double _borderRadius = 0;
  bool animate = true;

  int _currentIndex = 2;
  // final List<Widget> _pages = <Widget>[
  //   Meditation(),
  //   Tasks(false),
  //   Dashboard(),
  //   Journal(false),
  //   Settings(),
  // ];

  @override
  Widget build(BuildContext context) {
    void _changePage(int index) {
      if (index == 0 || index == 2 || index == 4) {
        animate = true;
      } else {
        animate = false;
      }

      setState(() {
        _currentIndex = index;
      });
    }

    final List<Widget> pages = <Widget>[
      Meditation(),
      Tasks(animate), // TODO make it set the condition
      Dashboard(),
      Journal(animate), // TODO make it set the condition
      Settings(),
    ];

    return Scaffold(
      body: PageTransitionSwitcher(
        transitionBuilder: (
          Widget child,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return Align(
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        child: pages.elementAt(_currentIndex),
      ),

      // TODO make rive icons
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_borderRadius),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.4),
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
            unselectedItemColor: Theme.of(context).iconTheme.color,
            selectedItemColor: Theme.of(context).primaryColor,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedFontSize: 0,
            unselectedFontSize: 0,
            enableFeedback: true,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.sports_handball_outlined, size: 28),
                activeIcon: Icon(Icons.sports_handball, size: 28),
                label: 'Meditation',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.assignment_turned_in_outlined, size: 28),
                activeIcon: Icon(Icons.assignment_turned_in, size: 28),
                label: 'Goals',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_outlined, size: 28),
                activeIcon: Icon(Icons.dashboard_rounded, size: 28),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book_outlined, size: 28),
                activeIcon: Icon(Icons.book_rounded, size: 28),
                label: 'Journal',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined, size: 28),
                activeIcon: Icon(Icons.settings, size: 28),
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
}
*/