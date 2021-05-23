import 'dart:math';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:releaf/screens/home/dashboard.dart';
import 'package:releaf/shared/assets/navigation_bar.dart';
import 'package:releaf/shared/const/app_theme.dart';
import 'package:releaf/services/auth.dart';
import 'package:releaf/services/database.dart';

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
          SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverToBoxAdapter(
            child: JournalEntry(
                date: 'Jan 18, 2021',
                entryText:
                    'Amet ea aute reprehenderit occaecat incididunt excepteur anim id reprehenderit ad voluptate.'),
          ),
          SliverToBoxAdapter(
            child: JournalEntry(
                date: 'Jan 18, 2021',
                entryText:
                    'Amet ea aute reprehenderit occaecat incididunt excepteur anim id reprehenderit ad voluptate.'),
          ),
          SliverToBoxAdapter(
            child: JournalEntry(
                date: 'Jan 18, 2021',
                entryText:
                    'Amet ea aute reprehenderit occaecat incididunt excepteur anim id reprehenderit ad voluptate.'),
          ),
          SliverToBoxAdapter(
            child: JournalEntry(
                date: 'Jan 18, 2021',
                entryText:
                    'Amet ea aute reprehenderit occaecat incididunt excepteur anim id reprehenderit ad voluptate.'),
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

class JournalEntry extends StatefulWidget {
  final String date;
  // final List pictures; // TODO add pictures list
  final String entryText;

  JournalEntry({required this.date, required this.entryText});

  @override
  _JournalEntryState createState() => _JournalEntryState();
}

class _JournalEntryState extends State<JournalEntry> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        padding: EdgeInsets.fromLTRB(20, 15, 20, 18),
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.42),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // * Heading
            Text(
              widget.date,
              style: Theme.of(context).textTheme.subtitle2,
            ),
            SizedBox(height: 10),
            Placeholder(fallbackHeight: 160),
            SizedBox(height: 10),
            Text(
              widget.entryText,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ),
      ),
    );
  }
}

class JournalEntryForm extends StatefulWidget {
  @override
  _JournalEntryFormState createState() => _JournalEntryFormState();
}

class _JournalEntryFormState extends State<JournalEntryForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Journal Entry Form'),
      ),
    );
  }
}
