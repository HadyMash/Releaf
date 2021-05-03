import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:releaf/shared/const/app_theme.dart';

class ThemedToggle extends StatefulWidget {
  // * Variables
  final ValueChanged<bool> onChanged;
  final bool? defaultState;
  final Color? pegColor;
  final Color? backgroundDisabledColor;
  final Color? backgroundEnabledColor;
  final Color? pegDisabledShadowColor;
  final Color? pegEnabledShadowColor;
  final Color? backgroundDisabledShadowColor;
  final Color? backgroundEnabledShadowColor;
  final EdgeInsets? margin;
  final Duration? duration;
  final bool? tapFeedback;
  final bool? tapDownFeedback;

  ThemedToggle({
    required this.onChanged,
    this.defaultState,
    this.pegColor,
    this.backgroundDisabledColor,
    this.backgroundEnabledColor,
    this.pegDisabledShadowColor,
    this.pegEnabledShadowColor,
    this.backgroundDisabledShadowColor,
    this.backgroundEnabledShadowColor,
    this.margin,
    this.duration,
    this.tapFeedback,
    this.tapDownFeedback,
  });

  @override
  _ThemedToggleState createState() => _ThemedToggleState();
}

class _ThemedToggleState extends State<ThemedToggle>
    with SingleTickerProviderStateMixin {
  late bool _state;
  late Color? _backgroundColor;
  late Color? _pegShadowColor;
  late Color? _backgroundShadowColor;
  final double _width = 75;
  late final Duration _duration;
  late double _offset;

  late AnimationController _controller;
  late CurvedAnimation _animation;

  void _toggleOn() {
    _backgroundColor =
        widget.backgroundEnabledColor ?? Theme.of(context).primaryColor;
    _pegShadowColor = widget.pegEnabledShadowColor ??
        Theme.of(context).shadowColor.withOpacity(0.6);
    _backgroundShadowColor = widget.backgroundEnabledShadowColor ??
        Theme.of(context).primaryColor.withOpacity(0.6);
    _state = !_state;
    _offset = 10;
    _controller.forward();
  }

  void _toggleOff() {
    _backgroundColor =
        widget.backgroundEnabledColor ?? Theme.of(context).disabledColor;
    _pegShadowColor = widget.pegEnabledShadowColor ??
        Theme.of(context).shadowColor.withOpacity(0.6);
    _backgroundShadowColor = widget.backgroundEnabledShadowColor ??
        Theme.of(context).disabledColor.withOpacity(0.6);
    _state = !_state;
    _controller.reverse();
  }

  @override
  void initState() {
    _state = widget.defaultState ?? false;
    _duration = widget.duration ?? Duration(milliseconds: 266);

    _controller = AnimationController(
      vsync: this,
      duration: _duration,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_state == true) {
      _toggleOn();
    } else {
      _toggleOff();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Provider.of<AppTheme>(context);
    return GestureDetector(
      onTap: () {
        setState(() => _state == true ? _toggleOff() : _toggleOn());

        widget.onChanged(_state);

        if (widget.tapFeedback == true && _theme.haptics == true) {
          HapticFeedback.mediumImpact();
        }
      },
      onTapDown: (details) {
        //animate down

        if (widget.tapDownFeedback == true && _theme.haptics == true) {
          HapticFeedback.lightImpact();
        }
      },
      onTapUp: (details) {
        // animate up
      },
      // TODO Make toggle work with drag right and left
      child: AnimatedContainer(
        duration: _duration,
        margin: widget.margin,
        // padding: EdgeInsets.symmetric(vertical: 2),
        width: _width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(10000),
          boxShadow: [
            BoxShadow(
              color: _backgroundShadowColor!,
              blurRadius: 16.0,
              spreadRadius: 0.0,
            ),
          ],
        ),
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(
                  (_animation.value * (_width - 31)) - (((_width - 31) / 2)),
                  0),
              child: child,
            );
          },
          child: AnimatedContainer(
            height: 30,
            width: 30,
            duration: _duration,
            decoration: BoxDecoration(
              color: widget.pegColor ?? Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.circular(10000),
              boxShadow: [
                BoxShadow(
                  color: _pegShadowColor!,
                  blurRadius: 14.0,
                  spreadRadius: 0.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
