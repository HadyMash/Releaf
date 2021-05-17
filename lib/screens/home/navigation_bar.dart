import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:releaf/screens/home/dashboard.dart';
import 'package:releaf/screens/home/journal.dart';
import 'package:releaf/screens/home/meditation.dart';
import 'package:releaf/screens/home/settings.dart';
import 'package:releaf/screens/home/tasks.dart';
import 'package:releaf/shared/const/app_theme.dart';

class ThemedNavigationBar extends StatelessWidget {
  final int pageIndex;
  ThemedNavigationBar(this.pageIndex);

  final List _pages = [
    Meditation(),
    Tasks(),
    Dashboard(),
    Journal(),
    Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<AppTheme>(context);

    void _changePage(index) {
      if (index != pageIndex) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 250),
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return _pages[index];
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
          ),
        );
      }
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(theme.bottomNavigationBarBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.4),
            blurRadius: 22.0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(theme.bottomNavigationBarBorderRadius),
          topRight: Radius.circular(theme.bottomNavigationBarBorderRadius),
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
          onTap: _changePage,
          currentIndex: pageIndex,
        ),
      ),
    );
  }
}
