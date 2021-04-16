import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class ThemeBase {
  Color? primary;
  Color? secondary;
  Color? accent;
  Color? backgroundColor;
  TextStyle heading;
  TextStyle body;
  // AppBarTheme appBarTheme; // TODO implement app bar theme

  ThemeBase({
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.backgroundColor,
    required this.heading,
    required this.body,
  });
}

class AppTheme with ChangeNotifier {
  late ThemeBase current;
  ThemeBase light;
  ThemeBase dark;

  AppTheme({
    required this.light,
    required this.dark,
  }) {
    current = light;
    _light = ThemeData(
      brightness: Brightness.light,
      primaryColor: light.primary,
      backgroundColor: light.backgroundColor,
      accentColor: light.accent,
    );
    _dark = ThemeData(
      brightness: Brightness.dark,
      primaryColor: dark.primary,
      backgroundColor: Colors.grey[850],
      accentColor: dark.accent,
    );
    _currentThemeData = _light;
  }

  ThemeData _currentThemeData = ThemeData();
  ThemeData _light = ThemeData();
  ThemeData _dark = ThemeData();

  getThemeData() => _currentThemeData;
  getLightTheme() => _light;
  getDarkTheme() => _dark;
  setThemeData(bool light) {
    _currentThemeData = light ? _light : _dark;
    notifyListeners();
  }

  // TODO Make colour animate
  void toggleTheme() {
    if (current == light) {
      current = dark;
      setThemeData(false);
    } else if (current == dark) {
      current = light;
      setThemeData(true);
    }
    notifyListeners();
  }
}

// * TEST WIDGET - TEMP
class TestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AppTheme theme = Provider.of<AppTheme>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('Test Widget'),
        centerTitle: true,
      ),
      body: Center(
        child: ThemedButton(
          onPressed: () {
            theme.toggleTheme();
            print(Theme.of(context).brightness);
          },
          text: Text('Click Me!'),
          color: theme.current.primary,
          shadowColor: Colors.black.withOpacity(0.6),
          pressedShadowColor: Colors.greenAccent,
          shadowBlurRadius: 20,
        ),
      ),
    );
  }
}

// TODO Make custom button
class ThemedButton extends StatefulWidget {
  // * Variables
  final VoidCallback? onPressed;
  final Text text;
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
          child: widget.text,
        ),
      ),
    );
  }
}
