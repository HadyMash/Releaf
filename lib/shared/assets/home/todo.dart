import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:releaf/services/auth.dart';
import 'package:releaf/services/database.dart';
import 'package:releaf/shared/const/app_theme.dart';

class Todo extends StatefulWidget {
  bool completed;
  String task;
  String docID;
  int year;

  Todo({
    required this.completed,
    required this.task,
    required this.docID,
    required this.year,
  });

  @override
  _TodoState createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  AuthService _auth = AuthService();
  Duration duration = Duration(milliseconds: 220);

  late Color _enabledBackgroundColor;
  late Color _enabledShadowColor;
  double _enabledBlurRadius = 15;
  double _enabledSpreadRadius = 0;

  late Color _pressedShadowColor;
  double _pressedBlurRadius = 20;
  double _pressedSpreadRadius = 2;

  late Color _disabledBackgroundColor;
  late Color _disabledShadowColor;
  double _disabledBlurRadius = 0;
  double _disabledSpreadRadius = 0;

  late Color _color;
  late Color _shadowColor;
  late double _blur;
  late double _spread;

  bool initalised = false;

  @override
  void didChangeDependencies() {
    if (initalised == false) {
      _enabledBackgroundColor = Theme.of(context).backgroundColor;
      _enabledShadowColor = Theme.of(context).shadowColor.withOpacity(0.2);
      _pressedShadowColor = Theme.of(context).shadowColor.withOpacity(0.35);
      int alphaDifference = 12;
      int red = Theme.of(context).scaffoldBackgroundColor.red - alphaDifference;
      int green =
          Theme.of(context).scaffoldBackgroundColor.green - alphaDifference;
      int blue =
          Theme.of(context).scaffoldBackgroundColor.blue - alphaDifference;
      if (red < 0) {
        red = 0;
      }
      if (green < 0) {
        green = 0;
      }
      if (blue < 0) {
        blue = 0;
      }
      _disabledBackgroundColor = Color.fromRGBO(red, green, blue, 1);
      _disabledShadowColor = Colors.transparent;

      if (widget.completed == false) {
        _color = _enabledBackgroundColor;
        _shadowColor = _enabledShadowColor;
        _blur = _enabledBlurRadius;
        _spread = _enabledSpreadRadius;
      } else {
        _color = _disabledBackgroundColor;
        _shadowColor = _disabledShadowColor;
        _blur = _disabledBlurRadius;
        _spread = _disabledSpreadRadius;
      }
      initalised = true;
    }
    super.didChangeDependencies();
  }

  bool animating = false;

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<AppTheme>(context);

    void _tapDown() {
      if (theme.haptics == true) {
        HapticFeedback.lightImpact();
      }
      _shadowColor = _pressedShadowColor;
      _blur = _pressedBlurRadius;
      _spread = _pressedSpreadRadius;
    }

    void _tapUp() {
      if (widget.completed == false) {
        _shadowColor = _enabledShadowColor;
        _blur = _enabledBlurRadius;
        _spread = _enabledSpreadRadius;
      } else {
        _shadowColor = _disabledShadowColor;
        _blur = _disabledBlurRadius;
        _spread = _disabledSpreadRadius;
      }
      Future.delayed(duration).then((value) {
        setState(() => animating = false);
      });
    }

    void _toggle() {
      if (widget.completed == false) {
        if (theme.haptics == true) {
          HapticFeedback.mediumImpact();
        }
        DatabaseService(uid: _auth.getUser()!.uid)
            .completeTodo(widget.year, widget.docID);
      } else {
        if (theme.haptics == true) {
          HapticFeedback.heavyImpact();
        }
        DatabaseService(uid: _auth.getUser()!.uid)
            .uncompleteTodo(widget.year, widget.docID);
      }
    }

    if (animating == false) {
      if (widget.completed == false) {
        _color = _enabledBackgroundColor;
        _shadowColor = _enabledShadowColor;
        _blur = _enabledBlurRadius;
        _spread = _enabledSpreadRadius;
      } else {
        _color = _disabledBackgroundColor;
        _shadowColor = _disabledShadowColor;
        _blur = _disabledBlurRadius;
        _spread = _disabledSpreadRadius;
      }
    }

    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: _toggle,
        onTapDown: (_) {
          animating = true;
          setState(() => _tapDown());
        },
        onTapUp: (_) {
          animating = true;
          setState(() => _tapUp());
        },
        onTapCancel: () {
          animating = true;
          setState(() => _tapUp());
        },
        child: AnimatedContainer(
          duration: duration,
          margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          decoration: BoxDecoration(
            color: _color,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: _shadowColor,
                blurRadius: _blur,
                spreadRadius: _spread,
              )
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Spacer(),
              Flexible(
                flex: 4,
                child: Center(child: Placeholder(fallbackHeight: 50)),
              ),
              Spacer(),
              Flexible(
                flex: 24,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 25),
                  child: Text(
                    widget.task,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
