import 'dart:math';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:releaf/shared/assets/navigation_bar.dart';
import 'package:releaf/shared/const/app_theme.dart';
import 'package:releaf/shared/const/hero_route.dart';
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
            child: Hero(
              tag: 'journal entry',
              child: JournalEntry(
                  date: 'Jan 18, 2021',
                  entryText:
                      'Amet ea aute reprehenderit occaecat incididunt excepteur anim id reprehenderit ad voluptate.'),
            ),
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
  late Color _shadowColor;
  double _blurRadius = 20;
  double _spreadRadius = 2;

  late Color _pressedShadowColor;
  double _pressedBlurRadius = 27;
  double _pressedSpreadRadius = 3;

  late Color _color;
  late double _blur;
  late double _spread;

  @override
  void didChangeDependencies() {
    _shadowColor = Theme.of(context).shadowColor.withOpacity(0.42);
    _pressedShadowColor = Theme.of(context).shadowColor.withOpacity(0.63);

    _color = _shadowColor;
    _blur = _blurRadius;
    _spread = _spreadRadius;
    super.didChangeDependencies();
  }

  void _tapDown() {
    setState(() {
      _color = _pressedShadowColor;
      _blur = _pressedBlurRadius;
      _spread = _pressedSpreadRadius;
    });
  }

  void _tapUp() {
    setState(() {
      _color = _shadowColor;
      _blur = _blurRadius;
      _spread = _spreadRadius;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.transparent,
      // TODO wrap with hero
      child: GestureDetector(
        onTap: () {
          AppTheme.homeNavkey.currentState!.push(
            HeroDialogRoute(
                builder: (context) =>
                    JournalEntryExpanded(widget.date, widget.entryText)),
          );
        },
        onTapDown: (_) => _tapDown(),
        onTapUp: (_) => _tapUp(),
        onTapCancel: () => _tapUp(),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 220),
          margin: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          padding: EdgeInsets.fromLTRB(20, 15, 20, 18),
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: _color,
                blurRadius: _blur,
                spreadRadius: _spread,
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
      ),
    );
  }
}

class JournalEntryExpanded extends StatelessWidget {
  final String date;
  final String entryText;
  // final feeling; // TODO add feeling variable

  JournalEntryExpanded(this.date, this.entryText);

  @override
  Widget build(BuildContext context) {
    // TODO add hero
    return Hero(
      tag: 'journal entry',
      child: Container(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              date,
              style: Theme.of(context).textTheme.headline3,
            ),
            automaticallyImplyLeading: false,
            leadingWidth: 35,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Theme.of(context).iconTheme.color,
                size: Theme.of(context).iconTheme.size,
              ),
              onPressed: () => AppTheme.homeNavkey.currentState!.pop(),
            ),
          ),
          body: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // TODO add caresoul of pictures
                  Placeholder(fallbackHeight: 200),
                  SizedBox(height: 20),
                  Expanded(
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Text(
                          entryText,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  // TODO add feeling display
                  Placeholder(
                    fallbackHeight: 100,
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ),
          ),
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
  DateTime _currentDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    print(_currentDate);
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
                  onPressed: () {
                    showDatePicker(
                            context: context,
                            initialDate: _currentDate,
                            firstDate: DateTime(2001),
                            lastDate: DateTime(2023))
                        .then((date) {
                      setState(() {
                        _currentDate = date!;
                      });
                    });
                  },
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
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // TODO add rive feeling selector
              Placeholder(
                fallbackHeight: 70,
                fallbackWidth: 150,
              ),
              ThemedButton(
                label: 'submit text',
                onPressed: () async {},
                tapDownFeedback: true,
                tapFeedback: true,
              ),
            ],
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}
