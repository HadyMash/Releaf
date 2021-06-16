import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:releaf/screens/home/dashboard.dart';
import 'package:releaf/screens/home/journal.dart';
import 'package:releaf/screens/home/meditation.dart';
import 'package:releaf/screens/home/settings.dart';
import 'package:releaf/screens/home/tasks.dart';
import 'package:releaf/shared/const/app_theme.dart';

// TODO add glow under icon that is being pressed
class ThemedNavigationBar extends StatefulWidget {
  final int pageIndex;
  final bool animateFloatingActionButton;
  const ThemedNavigationBar({
    Key? key,
    required this.pageIndex,
    required this.animateFloatingActionButton,
  }) : super(key: key);

  @override
  _ThemedNavigationBarState createState() => _ThemedNavigationBarState();
}

class _ThemedNavigationBarState extends State<ThemedNavigationBar> {
  final GlobalKey containerKey = GlobalKey();
  double glowHeight = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      final RenderBox renderBox =
          containerKey.currentContext!.findRenderObject() as RenderBox;
      setState(() => glowHeight = renderBox.size.height);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<AppTheme>(context);
    final glowWidth = MediaQuery.of(context).size.width / 5;

    final List pages = [
      Meditation(),
      Tasks(widget.animateFloatingActionButton),
      Dashboard(),
      Journal(widget.animateFloatingActionButton),
      Settings(),
    ];

    void _changePage(index) {
      if (index != widget.pageIndex) {
        AppTheme.homeNavkey.currentState!.pushReplacement(
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 320),
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return pages[index];
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

    return Stack(
      children: [
        Positioned(
          left: glowWidth * widget.pageIndex,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.6),
                  blurRadius: 25,
                )
              ],
            ),
            width: glowWidth,
            height: glowHeight,
          ),
        ),
        Container(
          key: containerKey,
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
                // TODO make rive icons.
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
              currentIndex: widget.pageIndex,
            ),
          ),
        ),
      ],
    );
  }
}
