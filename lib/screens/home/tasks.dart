import 'dart:math';
import 'package:flutter/material.dart';
import 'package:releaf/shared/assets/home/navigation_bar.dart';

class Tasks extends StatefulWidget {
  final bool animate;
  Tasks(this.animate);
  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final CurvedAnimation animation;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 320));
    super.initState();
    animation = CurvedAnimation(curve: Curves.easeInOut, parent: controller);

    super.initState();

    if (widget.animate == true) {
      controller.forward();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverAppBar(
            title: Text(
              'Tasks',
              style: Theme.of(context).textTheme.headline3,
            ),
            automaticallyImplyLeading: false,
            actions: [
              // DropdownButton(items: items),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'floatingActionButton',
        backgroundColor: Theme.of(context).primaryColor,
        splashColor: Theme.of(context).accentColor,
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
        onPressed: () {},
      ),
      bottomNavigationBar:
          ThemedNavigationBar(pageIndex: 1, animateFloatingActionButton: false),
    );
  }
}
