import 'dart:math';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:releaf/shared/assets/navigation_bar.dart';
import 'package:releaf/screens/home/settings.dart';
import 'package:releaf/shared/const/app_theme.dart';
import 'package:releaf/services/auth.dart';
import 'package:releaf/services/database.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  late final AnimationController controller;
  late final CurvedAnimation animation;
  late final AnimationController _tempController;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 320));
    animation = CurvedAnimation(curve: Curves.easeInOut, parent: controller);
    _tempController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    super.initState();

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<AppTheme>(context);
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverAppBar(
            title: Text(
              'Dashboard',
              style: Theme.of(context).textTheme.headline3,
            ),
            automaticallyImplyLeading: false,
          ),
        ],
      ),
      floatingActionButton: Transform.translate(
        offset: Offset(
            MediaQuery.of(context).size.width / 6 + ((1 / 428) * width), 0),
        child: Hero(
          tag: 'floatingActionButton',
          child: GestureDetector(
            child: AnimatedBuilder(
              animation: _tempController,
              builder: (context, child) {
                return OpenContainer(
                  transitionDuration: Duration(milliseconds: 500),
                  closedElevation: 6,
                  closedShape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(56 / 2),
                    ),
                  ),
                  closedColor: Theme.of(context).primaryColor,
                  closedBuilder:
                      (BuildContext context, VoidCallback openContainer) {
                    return SizedBox(
                      height: 56,
                      width: 56,
                      child: Center(
                        child: AnimatedBuilder(
                          animation: animation,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: (pi * 2) - ((pi * animation.value) / 2),
                              child: child,
                            );
                          },
                          child: Icon(
                            Icons.add_rounded,
                            color: Theme.of(context).accentIconTheme.color,
                            size: 40,
                          ),
                        ),
                      ),
                    );
                  },
                  openBuilder: (BuildContext context, VoidCallback _) {
                    return SizedBox(
                      height: 56,
                      width: 56,
                      child: Center(
                        child: AnimatedBuilder(
                          animation: animation,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: (pi * 2) - ((pi * animation.value) / 2),
                              child: child,
                            );
                          },
                          child: Icon(
                            Icons.add_rounded,
                            color: Theme.of(context).accentIconTheme.color,
                            size: 40,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar:
          ThemedNavigationBar(pageIndex: 2, animateFloatingActionButton: true),
    );
  }
}
