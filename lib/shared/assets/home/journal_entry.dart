import 'package:flutter/material.dart';
import 'package:releaf/shared/const/app_theme.dart';
import 'package:releaf/shared/const/hero_route.dart';

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
    return Hero(
      tag: 'journal entry',
      child: Material(
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
    );
  }
}
