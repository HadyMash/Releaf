import 'dart:math';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:releaf/screens/home/dashboard.dart';
import 'package:releaf/screens/home/navigation_bar.dart';
import 'package:releaf/shared/const/app_theme.dart';
import 'package:releaf/services/auth.dart';
import 'package:releaf/services/database.dart';
import 'package:releaf/shared/assets/themed_button.dart';

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
  late DateTime _dateTime;
}

class _JournalEntryFormState extends State<JournalEntryForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Journal Entry',
          style: Theme.of(context).textTheme.headline3,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ThemedButton(
                  label: 'pick photo',
                  onPressed: () async {},
                  tapDownFeedback: true,
                  tapFeedback: true,
                ),
                ThemedButton(
                  label: 'change date',
                  onPressed: () async {},
                  tapDownFeedback: true,
                  tapFeedback: true,
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: TextField(
                expands: true,
                decoration: InputDecoration(
                  fillColor: Colors.grey[300],
                  filled: true,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Lorem ipsum",
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
            ),
          ),
          SizedBox(height: 10),
          ThemedButton(
            label: 'submit text',
            onPressed: () async {},
            tapDownFeedback: true,
            tapFeedback: true,
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}
