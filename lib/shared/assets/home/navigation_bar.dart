import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:releaf/screens/home/dashboard.dart';
import 'package:releaf/screens/home/journal.dart';
import 'package:releaf/screens/home/meditation.dart';
import 'package:releaf/screens/home/settings.dart';
import 'package:releaf/screens/home/tasks.dart';
import 'package:releaf/shared/const/app_theme.dart';

// TODO make icons SVGs and not pictures.
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
    final width = MediaQuery.of(context).size.width;
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
                  icon: Image.asset(
                    'assets/images/nav_bar_icons/meditation_unselected.png',
                    width: (45 * width) / 428,
                    height: (45 * width) / 428,
                  ),
                  activeIcon: Image.asset(
                    'assets/images/nav_bar_icons/meditation_selected.png',
                    width: (45 * width) / 428,
                    height: (45 * width) / 428,
                  ),
                  label: 'Meditation',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/images/nav_bar_icons/tasks_unselected.png',
                    width: (50 * width) / 428,
                    height: (50 * width) / 428,
                  ),
                  activeIcon: Image.asset(
                    'assets/images/nav_bar_icons/tasks_selected.png',
                    width: (50 * width) / 428,
                    height: (50 * width) / 428,
                  ),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/images/nav_bar_icons/dashboard_unselected.png',
                    width: (40 * width) / 428,
                    height: (40 * width) / 428,
                  ),
                  activeIcon: Image.asset(
                    'assets/images/nav_bar_icons/dashboard_selected.png',
                    width: (40 * width) / 428,
                    height: (40 * width) / 428,
                  ),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/images/nav_bar_icons/journal_unselected.png',
                    width: (55 * width) / 428,
                    height: (55 * width) / 428,
                  ),
                  activeIcon: Image.asset(
                    'assets/images/nav_bar_icons/journal_selected.png',
                    width: (55 * width) / 428,
                    height: (55 * width) / 428,
                  ),
                  label: 'Journal',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/images/nav_bar_icons/settings_unselected.png',
                    width: (45 * width) / 428,
                    height: (45 * width) / 428,
                  ),
                  activeIcon: Image.asset(
                    'assets/images/nav_bar_icons/settings_selected.png',
                    width: (45 * width) / 428,
                    height: (45 * width) / 428,
                  ),
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
