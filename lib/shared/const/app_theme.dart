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
  final VoidCallback? onPressed;
  final Widget icon;
  final double? gap;
  final String text;
  final bool? notAllCaps;
  final TextStyle? style;
  final EdgeInsets? padding;
  final Color? color;
  final Color? pressedColor;
  final double? borderRadius;
  final Color? shadowColor;
  final Color? pressedShadowColor;
  final double? shadowBlurRadius;
  final double? shadowSpreadRadius;
  final Offset? shadowOffset;

  // * Constructors
  final bool iconButton;
  // TODO add ThemedButton.icon constructor and implement it.
  ThemedButton({
    required this.onPressed,
    required this.text,
    this.notAllCaps,
    this.style,
    this.color,
    this.padding,
    this.borderRadius,
    required this.shadowColor,
    required this.pressedShadowColor,
    this.shadowBlurRadius,
    this.shadowSpreadRadius,
    this.shadowOffset,
    this.pressedColor,
  })  : icon = Container(height: 0, width: 0),
        iconButton = false,
        gap = 0.0;

  ThemedButton.icon({
    required this.onPressed,
    required this.icon,
    this.gap,
    required this.text,
    this.notAllCaps,
    this.style,
    this.color,
    this.padding,
    this.borderRadius,
    required this.shadowColor,
    required this.pressedShadowColor,
    this.shadowBlurRadius,
    this.shadowSpreadRadius,
    this.shadowOffset,
    this.pressedColor,
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
                    ? widget.text
                    : widget.text.toUpperCase(),
                style: widget.style ?? Theme.of(context).textTheme.button,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
