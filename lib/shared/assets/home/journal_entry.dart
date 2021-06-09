import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:releaf/services/auth.dart';
import 'package:releaf/services/database.dart';
import 'package:releaf/shared/assets/home/journal_entry_form.dart';
import 'package:releaf/shared/const/app_theme.dart';
import 'package:releaf/shared/const/hero_route.dart';

class JournalEntry extends StatefulWidget {
  final String date;
  // final List pictures; // TODO add pictures list
  final String entryText;
  late final int feeling;

  JournalEntry(
      {required this.date, required this.entryText, required feeling}) {
    if (feeling < 1) {
      feeling = 1;
    } else if (feeling > 3) {
      feeling = 3;
    }
    this.feeling = feeling;
  }

  @override
  _JournalEntryState createState() => _JournalEntryState();
}

class _JournalEntryState extends State<JournalEntry> {
  late Color _shadowColor;
  double _blurRadius = 15;
  double _spreadRadius = 0;

  late Color _pressedShadowColor;
  double _pressedBlurRadius = 25;
  double _pressedSpreadRadius = 2;

  late Color _color;
  late double _blur;
  late double _spread;

  @override
  void didChangeDependencies() {
    _shadowColor = Theme.of(context).shadowColor.withOpacity(0.42);
    _pressedShadowColor = Theme.of(context).shadowColor.withOpacity(0.60);

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
    return Hero(
      tag: widget.date,
      child: Material(
        color: AppTheme.transparent,
        child: GestureDetector(
          onTapDown: (_) => _tapDown(),
          onTapUp: (_) => _tapUp(),
          onTapCancel: () => _tapUp(),
          child: AnimatedContainer(
            clipBehavior: Clip.hardEdge,
            duration: Duration(milliseconds: 220),
            margin: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
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
            child: OpenContainer(
              closedShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              closedElevation: 0,
              closedColor: Theme.of(context).backgroundColor,
              openColor: Theme.of(context).scaffoldBackgroundColor,
              closedBuilder: (context, _) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(20, 15, 20, 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // * Heading
                      Text(
                        _formatedDate(widget.date),
                        style: Theme.of(context).textTheme.subtitle2,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 10),
                      Placeholder(fallbackHeight: 160),
                      SizedBox(height: 10),
                      Text(
                        widget.entryText,
                        style: Theme.of(context).textTheme.bodyText2,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
              openBuilder: (context, _) {
                return JournalEntryExpanded(
                  widget.date,
                  widget.entryText,
                  widget.feeling,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class JournalEntryExpanded extends StatefulWidget {
  final String date;
  final String entryText;
  final feeling;

  JournalEntryExpanded(this.date, this.entryText, this.feeling);
  @override
  _JournalEntryExpandedState createState() => _JournalEntryExpandedState();
}

class _JournalEntryExpandedState extends State<JournalEntryExpanded>
    with SingleTickerProviderStateMixin {
  final AuthService _auth = AuthService();

  late final AnimationController fabController;
  late final Animation fabColorAnimation;
  late final Animation<double> fabElevationTween;

  bool initialised = false;

  void initState() {
    fabController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));

    fabElevationTween = Tween<double>(begin: 6, end: 10)
        .animate(CurvedAnimation(parent: fabController, curve: Curves.linear));

    super.initState();
  }

  @override
  void dispose() {
    fabController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (initialised == false) {
      fabColorAnimation = ColorTween(
              begin: Theme.of(context).primaryColor,
              end: Theme.of(context).colorScheme.secondary)
          .animate(
              CurvedAnimation(curve: Curves.linear, parent: fabController));
      initialised = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Journal",
          style: Theme.of(context).textTheme.headline3,
        ),
        automaticallyImplyLeading: false,
        leadingWidth: 35,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 22),
            child: IconButton(
              onPressed: () async {
                dynamic result =
                    await DatabaseService(uid: _auth.getUser()!.uid)
                        .deleteEntry(widget.date);
                if (result == true) {
                  Navigator.of(context).pop();
                } else {
                  print(result.toString());
                  final snackBar = SnackBar(
                    content: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child:
                              Icon(Icons.error_rounded, color: Colors.red[700]),
                        ),
                        Expanded(child: Text(result.toString())),
                      ],
                    ),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              icon: Icon(
                Icons.delete_rounded,
                size: 32,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          ),
        ],
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
          padding: EdgeInsets.only(
            right: 20,
            left: 20,
            top: 15,
            bottom: MediaQuery.of(context).padding.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _formatedDate(widget.date),
                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      fontSize:
                          Theme.of(context).textTheme.subtitle2!.fontSize! + 6,
                    ),
              ),
              SizedBox(height: 15),
              // TODO add caresoul of pictures
              Placeholder(fallbackHeight: 200),
              SizedBox(height: 20),
              Expanded(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        widget.entryText,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25),
              // TODO add feeling display
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Feeling:',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  Placeholder(
                    fallbackHeight: 100,
                    fallbackWidth: 180,
                  ),
                ],
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
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
                        child: Icon(
                          Icons.edit_rounded,
                          color: Theme.of(context)
                              .floatingActionButtonTheme
                              .foregroundColor,
                          size: 32,
                        ),
                      ),
                    );
                  },
                  openBuilder: (BuildContext context, VoidCallback _) {
                    return JournalEntryForm(
                      date: widget.date,
                      initialText: widget.entryText,
                      feeling: widget.feeling,
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

String _formatedDate(String date) {
  DateTime dateTime = DateTime.parse(date);
  Map<int, String> _monthNumToName = {
    1: 'Jan',
    2: 'Feb',
    3: 'Mar',
    4: 'Apr',
    5: 'May',
    6: 'Jun',
    7: 'Jul',
    8: 'Aug',
    9: 'Sep',
    10: 'Oct',
    11: 'Nov',
    12: 'Dec',
  };

  return '${_monthNumToName[dateTime.month]} ${dateTime.day}, ${dateTime.year}';
}
