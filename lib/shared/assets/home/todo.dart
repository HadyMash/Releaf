import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:releaf/shared/const/app_theme.dart';

class Todo extends StatefulWidget {
  bool completed;
  String task;

  Todo({required this.completed, required this.task});

  @override
  _TodoState createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  late Color _enabledBackgroundColor;
  late Color _enabledShadowColor;
  double _enabledBlurRadius = 15;
  double _enabledSpreadRadius = 0;

  late Color _pressedShadowColor;
  double _pressedBlurRadius = 25;
  double _pressedSpreadRadius = 2;

  late Color _disabledBackgroundColor;
  late Color _disabledShadowColor;
  double _disabledBlurRadius = 25;
  double _disabledSpreadRadius = 2;

  late Color _color;
  late Color _shadowColor;
  late double _blur;
  late double _spread;

  @override
  void didChangeDependencies() {
    _enabledBackgroundColor = Theme.of(context).backgroundColor;
    _enabledShadowColor = Theme.of(context).shadowColor.withOpacity(0.4);
    _pressedShadowColor = Theme.of(context).shadowColor.withOpacity(0.6);
    int red = Theme.of(context).scaffoldBackgroundColor.red - 50;
    int green = Theme.of(context).scaffoldBackgroundColor.green - 50;
    int blue = Theme.of(context).scaffoldBackgroundColor.blue - 50;
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

    super.didChangeDependencies();
  }

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
    }

    void _enable() {
      if (theme.haptics == true) {
        HapticFeedback.mediumImpact();
      }
    }

    void _disable() {
      if (theme.haptics == true) {
        HapticFeedback.heavyImpact();
      }
    }

    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _tapDown()),
        onTapUp: (_) => setState(() => _tapUp()),
        onTapCancel: () => setState(() => _tapUp()),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 220),
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                flex: 3,
                child: Center(child: Placeholder(fallbackHeight: 70)),
              ),
              Spacer(),
              Flexible(
                flex: 12,
                child: Text(widget.task),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
