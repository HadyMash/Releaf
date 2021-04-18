import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class AppTheme with ChangeNotifier {
  ThemeData light;
  ThemeData dark;
  late ThemeMode themeMode;

  AppTheme({
    required this.light,
    required this.dark,
  }) {
    themeMode = ThemeMode.system;
  }

  void toggleTheme() {
    if (themeMode == ThemeMode.light) {
      themeMode = ThemeMode.dark;
    } else if (themeMode == ThemeMode.dark) {
      themeMode = ThemeMode.light;
    } else if (themeMode == ThemeMode.system) {
      themeMode = ThemeMode.light;
    }
    notifyListeners();
  }

  void setTheme(ThemeMode theme) {
    themeMode = theme;
    notifyListeners();
  }
}

// TODO animate button on tapdown and up
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

  // * Constructors
  final bool iconButton;
  // TODO add ThemedButton.icon constructor and implement it.
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
    required this.shadowColor,
    required this.pressedShadowColor,
    this.shadowBlurRadius,
    this.pressedShadowBlurRadius,
    this.shadowSpreadRadius,
    this.pressedShadowSpreadRadius,
    this.shadowOffset,
    this.pressedShadowOffset,
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
    required this.shadowColor,
    required this.pressedShadowColor,
    this.shadowBlurRadius,
    this.shadowSpreadRadius,
    this.shadowOffset,
    this.pressedColor,
    this.pressedShadowBlurRadius,
    this.pressedShadowSpreadRadius,
    this.pressedShadowOffset,
  }) : iconButton = true;

  @override
  _ThemedButtonState createState() => _ThemedButtonState();
}

class _ThemedButtonState extends State<ThemedButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Semantics(
        button: true,
        // * Container
        child: Container(
          margin: widget.margin ?? EdgeInsets.all(0),
          padding: widget.padding ??
              EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 13.0,
              ),
          decoration: BoxDecoration(
            color: widget.color ?? Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
            boxShadow: [
              BoxShadow(
                blurRadius: widget.shadowBlurRadius ?? 15.0,
                spreadRadius: widget.shadowSpreadRadius ?? 0,
                color: Color.fromRGBO(
                  widget.shadowColor!.red,
                  widget.shadowColor!.green,
                  widget.shadowColor!.blue,
                  widget.shadowColor!.opacity,
                ),
                offset: widget.shadowOffset ?? Offset(0, 0),
              ),
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
      ),
    );
  }
}
