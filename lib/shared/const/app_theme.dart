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
  }

  // TODO Make colour animate
  void toggleTheme() {
    if (current == light) {
      current = dark;
    } else if (current == dark) {
      current = light;
    }
    notifyListeners();
  }
}

class TestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AppTheme theme = Provider.of<AppTheme>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.current.primary,
        title: Text('Test Widget'),
        centerTitle: true,
      ),
      body: Center(
        child: ThemedButton(
          onPressed: () => print('tapped'), // TODO Test with empty function
          text: Text('Click Me!'),
          color: theme.current.primary,
          shadowColor: Colors.black.withOpacity(0.6),
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
  final double? borderRadius;
  final Color shadowColor;
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
    this.shadowBlurRadius,
    this.shadowSpreadRadius,
    this.shadowOffset,
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
                color: widget.shadowColor,
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
