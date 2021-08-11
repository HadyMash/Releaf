import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:releaf/screens/home/dashboard.dart';
import 'package:releaf/screens/home/journal.dart';
import 'package:releaf/screens/home/meditation.dart';
import 'package:releaf/screens/home/settings.dart';
import 'package:releaf/screens/home/tasks.dart';
import 'package:releaf/shared/const/app_theme.dart';

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
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/adobe/illustrator/icons/svg/meditation_unselected.svg',
                    width: (45 * width) / 428,
                    height: (45 * width) / 428,
                  ),
                  activeIcon: SvgPicture.asset(
                    'assets/adobe/illustrator/icons/svg/meditation_selected.svg',
                    width: (45 * width) / 428,
                    height: (45 * width) / 428,
                  ),
                  label: 'Meditation',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/adobe/illustrator/icons/svg/tasks_unselected.svg',
                    width: (47 * width) / 428,
                    height: (47 * width) / 428,
                  ),
                  activeIcon: SvgPicture.asset(
                    'assets/adobe/illustrator/icons/svg/tasks_selected.svg',
                    width: (47 * width) / 428,
                    height: (47 * width) / 428,
                  ),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/adobe/illustrator/icons/svg/dashboard_unselected.svg',
                    width: (40 * width) / 428,
                    height: (40 * width) / 428,
                  ),
                  activeIcon: SvgPicture.asset(
                    'assets/adobe/illustrator/icons/svg/dashboard_selected.svg',
                    width: (40 * width) / 428,
                    height: (40 * width) / 428,
                  ),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/adobe/illustrator/icons/svg/journal_unselected.svg',
                    width: (45 * width) / 428,
                    height: (45 * width) / 428,
                  ),
                  activeIcon: SvgPicture.asset(
                    'assets/adobe/illustrator/icons/svg/journal_selected.svg',
                    width: (45 * width) / 428,
                    height: (45 * width) / 428,
                  ),
                  label: 'Journal',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/adobe/illustrator/icons/svg/settings_unselected.svg',
                    width: (45 * width) / 428,
                    height: (45 * width) / 428,
                    semanticsLabel: 'Settings',
                  ),
                  activeIcon: SvgPicture.asset(
                    'assets/adobe/illustrator/icons/svg/settings_selected.svg',
                    width: (45 * width) / 428,
                    height: (45 * width) / 428,
                    semanticsLabel: 'Settings',
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
