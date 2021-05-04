import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:releaf/shared/const/app_theme.dart';

// TODO add icon support
class ThemedToggle extends StatefulWidget {
  // * Variables
  final ValueChanged<bool> onChanged;
  final bool? defaultState;
  final Widget? icon;
  final Widget? enabledIcon;
  late final bool transformIcon;
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
    this.icon,
    this.enabledIcon,
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
  }) {
    transformIcon = enabledIcon != null ? true : false;
  }

  @override
  _ThemedToggleState createState() => _ThemedToggleState();
}

class _ThemedToggleState extends State<ThemedToggle>
    with TickerProviderStateMixin {
  late bool _state;
  late Color? _backgroundColor;
  late Color? _pegShadowColor;
  late Color? _backgroundShadowColor;
  final double _width = 75;
  late final Duration _duration;
  late double _offset;

  late AnimationController _controller;
  late CurvedAnimation _animation;
  late AnimationController _scaleController;
  late CurvedAnimation _scaleAnimation;

  void _toggleOn() {
    _backgroundColor =
        widget.backgroundEnabledColor ?? Theme.of(context).primaryColor;
    _pegShadowColor = widget.pegEnabledShadowColor ??
        Theme.of(context).shadowColor.withOpacity(0.6);
    _backgroundShadowColor = widget.backgroundEnabledShadowColor ??
        Theme.of(context).primaryColor.withOpacity(0.7);
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
    _offset = -10;
    _controller.reverse();
  }

  // TODO make animations for on tap down and up
  void _tapDown() {
    _scaleController.forward();
  }

  void _animateUp() {
    _scaleController.reverse();
  }

  @override
  void initState() {
    _state = widget.defaultState ?? false;
    _duration = widget.duration ?? Duration(milliseconds: 399);

    _controller = AnimationController(
      vsync: this,
      duration: _duration,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _scaleController = AnimationController(
      vsync: this,
      duration: _duration,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _scaleController.animateTo(0);
    if (_state == true) {
      _backgroundColor =
          widget.backgroundEnabledColor ?? Theme.of(context).primaryColor;
      _pegShadowColor = widget.pegEnabledShadowColor ??
          Theme.of(context).shadowColor.withOpacity(0.6);
      _backgroundShadowColor = widget.backgroundEnabledShadowColor ??
          Theme.of(context).primaryColor.withOpacity(0.7);
      _offset = 10;
      _controller.animateTo(1);
    } else {
      _backgroundColor =
          widget.backgroundEnabledColor ?? Theme.of(context).disabledColor;
      _pegShadowColor = widget.pegEnabledShadowColor ??
          Theme.of(context).shadowColor.withOpacity(0.6);
      _backgroundShadowColor = widget.backgroundEnabledShadowColor ??
          Theme.of(context).disabledColor.withOpacity(0.6);
      _offset = -10;
      _controller.animateBack(0);
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
        _tapDown();

        SystemSound.play(SystemSoundType.click);

        if (widget.tapDownFeedback == true && _theme.haptics == true) {
          HapticFeedback.lightImpact();
        }
      },
      onTapUp: (details) {
        // animate up
        setState(() => _animateUp());
      },
      onTapCancel: () => _animateUp(),
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
                  (_animation.value * (_width - 36)) - (((_width - 36) / 2)),
                  0),
              child: Transform.rotate(
                angle: (pi * _animation.value) - pi,
                child: child,
              ),
            );
          },
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: 1 - (_scaleAnimation.value * 0.2),
                child: child,
              );
            },
            child: Container(
              height: 35,
              width: 35,
              alignment: Alignment.center,
              child: AnimatedContainer(
                duration: _duration,
                height: 30,
                width: 30,
                alignment: Alignment.center,
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
                child: widget.transformIcon == true
                    ? Stack(
                        children: [
                          AnimatedBuilder(
                            animation: _animation,
                            builder: (context, child) {
                              return Opacity(
                                opacity: (_animation.value - 1).abs(),
                                child: child,
                              );
                            },
                            child: widget.icon,
                          ),
                          AnimatedBuilder(
                            animation: _animation,
                            builder: (context, child) {
                              return Opacity(
                                opacity: _animation.value,
                                child: child,
                              );
                            },
                            child: widget.enabledIcon,
                          ),
                        ],
                      )
                    : widget.icon,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
