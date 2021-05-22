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
  late HeroController _heroController;

  @override
  void initState() {
    super.initState();

    _heroController = HeroController(createRectTween: _createRectTween);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: AppTheme.homeNavkey,
      observers: [_heroController],
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

  Tween<Rect?> _createRectTween(Rect? begin, Rect? end) {
    return MaterialRectArcTween(begin: begin, end: end);
  }
}
