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
}

// ! TEST WIDGET - TEMP
class TestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AppTheme theme = Provider.of<AppTheme>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(
          'Test Widget',
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: Center(
        child: ThemedButton(
          onPressed: () => theme.toggleTheme(),
          text: 'Click Me!',
          color: Theme.of(context).primaryColor,
          shadowColor: Colors.black.withOpacity(0.6),
          pressedShadowColor: Colors.greenAccent,
          shadowBlurRadius: 20,
        ),
      ),
    );
  }
}

// TODO animate button on tapdown and up
class ThemedButton extends StatefulWidget {
  // * Variables
  final VoidCallback? onPressed;
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
  });

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
                vertical: 10,
                horizontal: 15,
              ),
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
            boxShadow: [
              BoxShadow(
                blurRadius: widget.shadowBlurRadius ?? 10.0,
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
          child: Text(
            (widget.notAllCaps ?? false)
                ? widget.text
                : widget.text.toUpperCase(),
            style: widget.style ?? Theme.of(context).textTheme.button,
          ),
        ),
      ),
    );
  }
}
