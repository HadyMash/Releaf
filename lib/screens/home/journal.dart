import 'dart:math';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:releaf/shared/const/app_theme.dart';
import 'package:releaf/shared/const/hero_route.dart';
import 'package:releaf/shared/assets/themed_button.dart';
import 'package:releaf/shared/assets/home/journal_entry.dart';
import 'package:releaf/shared/assets/home/journal_entry_form.dart';
import 'package:releaf/shared/assets/home/navigation_bar.dart';

class Journal extends StatefulWidget {
  final bool animate;
  Journal(this.animate);
  @override
  _JournalState createState() => _JournalState();
}

class _JournalState extends State<Journal> with TickerProviderStateMixin {
  late final AnimationController controller;
  late final CurvedAnimation animation;

  late final AnimationController fabController;
  late final Animation fabColorAnimation;
  late final Animation<double> fabElevationTween;

  bool initialised = false;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 320));
    animation = CurvedAnimation(curve: Curves.easeInOut, parent: controller);

    if (widget.animate == true) {
      controller.forward();
    }

    fabController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));

    fabElevationTween = Tween<double>(begin: 6, end: 10)
        .animate(CurvedAnimation(parent: fabController, curve: Curves.linear));

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    fabController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (initialised == false) {
      fabColorAnimation = ColorTween(
              begin: Theme.of(context).primaryColor,
              end: Theme.of(context).accentColor)
          .animate(
              CurvedAnimation(curve: Curves.linear, parent: fabController));
      initialised = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverAppBar(
            title: Text(
              'Journal',
              style: Theme.of(context).textTheme.headline3,
            ),
            automaticallyImplyLeading: false,
          ),
        ],
      ),
      floatingActionButton: Hero(
        tag: 'floatingActionButton',
        child: Transform.translate(
          offset: Offset(0, 0),
          child: GestureDetector(
            onTapDown: (_) => fabController.forward(),
            onTapUp: (_) => fabController.reverse(),
            onTapCancel: () => fabController.reverse(),
            child: AnimatedBuilder(
              animation: fabController,
              builder: (context, child) {
                return OpenContainer(
                  transitionDuration: Duration(milliseconds: 500),
                  transitionType: ContainerTransitionType.fade,
                  closedElevation: fabElevationTween.value,
                  closedShape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(56 / 2),
                    ),
                  ),
                  closedColor: fabColorAnimation.value,
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
                    return JournalEntryForm();
                  },
                );
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar:
          ThemedNavigationBar(pageIndex: 3, animateFloatingActionButton: false),
    );
  }
}
