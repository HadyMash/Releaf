import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:releaf/screens/home/dashboard.dart';
import 'package:releaf/screens/home/navigation_bar.dart';
import 'package:releaf/shared/const/app_theme.dart';
import 'package:releaf/services/auth.dart';
import 'package:releaf/services/database.dart';

class Meditation extends StatefulWidget {
  @override
  _MeditationState createState() => _MeditationState();
}

class _MeditationState extends State<Meditation>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final CurvedAnimation animation;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 320));
    super.initState();
    animation = CurvedAnimation(curve: Curves.easeInOut, parent: controller);

    super.initState();

    controller.forward();
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
              'Meditation',
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 100)),
          SliverToBoxAdapter(
            child: Hero(
              tag: 'pageText',
              child: Material(
                color: Colors.white.withOpacity(0),
                child: Container(
                  color: Colors.blue,
                  width: 50,
                  height: 50,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Transform.translate(
        offset: Offset(
            MediaQuery.of(context).size.width / 6 + ((1 / 428) * width), 0),
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          splashColor: Theme.of(context).accentColor,
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Transform.rotate(
                angle: (pi * animation.value) / 2,
                child: child,
              );
            },
            child: Icon(
              Icons.add_rounded,
              color: Theme.of(context).accentIconTheme.color,
              size: 40,
            ),
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}
