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
    return Transform.translate(
      offset: Offset(MediaQuery.of(context).size.width / 3, 0),
      child: FloatingActionButton(
        heroTag: 'floatingActionButton',
        backgroundColor: Theme.of(context).primaryColor,
        splashColor: Theme.of(context).colorScheme.secondary,
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
            color: Theme.of(context).floatingActionButtonTheme.foregroundColor,
            size: 40,
          ),
        ),
        onPressed: () {},
      ),
    );
  }
}
