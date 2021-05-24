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
      offset: Offset(((width / 6) > 56 ? width / 6 : 60) + (width / 428), 0),
      child: FloatingActionButton(
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
