import 'dart:math';
import 'package:flutter/material.dart';

class HiddenFAB extends StatefulWidget {
  @override
  _HiddenFABState createState() => _HiddenFABState();
}

class _HiddenFABState extends State<HiddenFAB>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final CurvedAnimation animation;

  final GlobalKey _fabKey = new GlobalKey();

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 320));
    animation = CurvedAnimation(curve: Curves.easeInOut, parent: controller);
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
    final double width = MediaQuery.of(context).size.width;
    return Transform.translate(
      offset: Offset(
          MediaQuery.of(context).size.width / 6 + ((1 / 428) * width), 0),
      child: FloatingActionButton(
        key: _fabKey,
        heroTag: 'floatingActionButton',
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
    );
  }
}
