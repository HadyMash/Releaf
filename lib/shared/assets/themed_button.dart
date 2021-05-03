import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:releaf/shared/const/app_theme.dart';

class ThemedButton extends StatefulWidget {
  // * Variables
  final String label;
  final TextStyle? style;
  final bool? notAllCaps;
  final double? gap;
  final Widget icon;
  final VoidCallback? onPressed;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;
  final Color? pressedColor;
  final double? borderRadius;
  final Color? shadowColor;
  final Color? pressedShadowColor;
  final double? shadowBlurRadius;
  final double? pressedShadowBlurRadius;
  final double? shadowSpreadRadius;
  final double? pressedShadowSpreadRadius;
  final Offset? shadowOffset;
  final Offset? pressedShadowOffset;
  final bool? tapDownFeedback;
  final bool? tapFeedback;

  // * Constructors
  final bool iconButton;
  ThemedButton({
    required this.label,
    this.style,
    this.notAllCaps,
    required this.onPressed,
    this.padding,
    this.margin,
    this.color,
    this.pressedColor,
    this.borderRadius,
    this.shadowColor,
    this.pressedShadowColor,
    this.shadowBlurRadius,
    this.pressedShadowBlurRadius,
    this.shadowSpreadRadius,
    this.pressedShadowSpreadRadius,
    this.shadowOffset,
    this.pressedShadowOffset,
    this.tapDownFeedback,
    this.tapFeedback,
  })  : icon = Container(height: 0, width: 0),
        iconButton = false,
        gap = 0.0;

  ThemedButton.icon({
    required this.label,
    this.style,
    this.notAllCaps,
    this.gap,
    required this.icon,
    required this.onPressed,
    this.padding,
    this.margin,
    this.color,
    this.borderRadius,
    this.shadowColor,
    this.pressedShadowColor,
    this.shadowBlurRadius,
    this.shadowSpreadRadius,
    this.shadowOffset,
    this.pressedColor,
    this.pressedShadowBlurRadius,
    this.pressedShadowSpreadRadius,
    this.pressedShadowOffset,
    this.tapDownFeedback,
    this.tapFeedback,
  }) : iconButton = true;

  @override
  _ThemedButtonState createState() => _ThemedButtonState();
}

class _ThemedButtonState extends State<ThemedButton>
    with SingleTickerProviderStateMixin {
  // Variables
  late Color _color;
  late Color _shadowColor;
  late double _shadowBlurRadius;
  late double _shadowSpreadRadius;
  late Offset _shadowOffset;

  // Animate When tapped down
  void _animateDown() {
    _color = widget.pressedColor ?? Theme.of(context).accentColor;
    _shadowColor = widget.pressedShadowColor ??
        Theme.of(context).accentColor.withOpacity(0.7);
    _shadowBlurRadius = widget.pressedShadowBlurRadius ?? 17.0;
    _shadowSpreadRadius = widget.pressedShadowSpreadRadius ?? 1.7;
    _shadowOffset = widget.pressedShadowOffset ?? Offset(0, 0);
  }

  // Animate When Tapped up
  void _animateUp() {
    _color = widget.color ?? Theme.of(context).primaryColor;
    _shadowColor =
        widget.shadowColor ?? Theme.of(context).shadowColor.withOpacity(0.6);
    _shadowBlurRadius = widget.shadowBlurRadius ?? 16.0;
    _shadowSpreadRadius = widget.shadowSpreadRadius ?? 0;
    _shadowOffset = widget.shadowOffset ?? Offset(0, 0);
  }

  @override
  void didChangeDependencies() {
    _animateUp();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Provider.of<AppTheme>(context);
    return GestureDetector(
      onTap: () {
        widget.onPressed!();
        if (widget.tapFeedback == true && _theme.haptics == true) {
          HapticFeedback.mediumImpact();
        }
      },
      onTapDown: (TapDownDetails) => setState(() {
        _animateDown();
        SystemSound.play(SystemSoundType.click);
        if (widget.tapFeedback == true && _theme.haptics == true) {
          HapticFeedback.lightImpact();
        }
      }),
      onTapUp: (TapUpDetails) => setState(() => _animateUp()),
      onTapCancel: () => setState(() => _animateUp()),
      // * AnimatedContainer
      child: AnimatedContainer(
        duration: Duration(milliseconds: 133),
        margin: widget.margin ?? EdgeInsets.all(0),
        padding: widget.padding ??
            EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 13.0,
            ),
        decoration: BoxDecoration(
          color: _color,
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
          boxShadow: [
            BoxShadow(
                blurRadius: _shadowBlurRadius,
                spreadRadius: _shadowSpreadRadius,
                color: _shadowColor,
                offset: _shadowOffset),
          ],
        ),
        // Text
        // * Text
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            widget.icon,
            SizedBox(width: (widget.iconButton) ? (widget.gap ?? 8.0) : 0.0),
            Text(
              (widget.notAllCaps ?? false)
                  ? widget.label
                  : widget.label.toUpperCase(),
              style: widget.style ?? Theme.of(context).textTheme.button,
            ),
          ],
        ),
      ),
    );
  }
}

class ThemedFlatButton extends StatefulWidget {
  // * Variables
  final String label;
  final TextStyle? style;
  final bool? notAllCaps;
  final double? gap;
  final Widget icon;
  final VoidCallback? onPressed;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;
  final Color? pressedColor;
  final double? borderRadius;
  final bool? tapDownFeedback;
  final bool? tapFeedback;

  // * Constructors
  final bool iconButton;
  ThemedFlatButton({
    required this.label,
    this.style,
    this.notAllCaps,
    required this.onPressed,
    this.padding,
    this.margin,
    this.color,
    this.pressedColor,
    this.borderRadius,
    this.tapDownFeedback,
    this.tapFeedback,
  })  : icon = Container(height: 0, width: 0),
        iconButton = false,
        gap = 0.0;

  ThemedFlatButton.icon({
    required this.label,
    this.style,
    this.notAllCaps,
    this.gap,
    required this.icon,
    required this.onPressed,
    this.padding,
    this.margin,
    this.color,
    this.borderRadius,
    this.pressedColor,
    this.tapDownFeedback,
    this.tapFeedback,
  }) : iconButton = true;

  @override
  _ThemedFlattButtonState createState() => _ThemedFlattButtonState();
}

class _ThemedFlattButtonState extends State<ThemedFlatButton>
    with SingleTickerProviderStateMixin {
  // Variables
  late Color _color;

  // Animate When tapped down
  void _animateDown() {
    _color = widget.pressedColor ?? Theme.of(context).accentColor;
  }

  // Animate When Tapped up
  void _animateUp() {
    _color = widget.color ?? Theme.of(context).primaryColor;
  }

  @override
  void didChangeDependencies() {
    _animateUp();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Provider.of<AppTheme>(context);
    return GestureDetector(
      onTap: () {
        widget.onPressed!();
        if (widget.tapFeedback == true && _theme.haptics == true) {
          HapticFeedback.mediumImpact();
        }
      },
      onTapDown: (TapDownDetails) => setState(() {
        _animateDown();
        SystemSound.play(SystemSoundType.click);
        if (widget.tapFeedback == true && _theme.haptics == true) {
          HapticFeedback.lightImpact();
        }
      }),
      onTapUp: (TapUpDetails) => setState(() => _animateUp()),
      onTapCancel: () => setState(() => _animateUp()),
      // * AnimatedContainer
      child: AnimatedContainer(
        duration: Duration(milliseconds: 133),
        margin: widget.margin ?? EdgeInsets.all(0),
        padding: widget.padding ??
            EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 13.0,
            ),
        decoration: BoxDecoration(
          color: _color,
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
        ),
        // Text
        // * Text
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            widget.icon,
            SizedBox(width: (widget.iconButton) ? (widget.gap ?? 8.0) : 0.0),
            Text(
              (widget.notAllCaps ?? false)
                  ? widget.label
                  : widget.label.toUpperCase(),
              style: widget.style ?? Theme.of(context).textTheme.button,
            ),
          ],
        ),
      ),
    );
  }
}
