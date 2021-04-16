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
  late ThemeBase theme;
  ThemeBase light;
  ThemeBase dark;

  AppTheme({
    required this.light,
    required this.dark,
  }) {
    theme = light;
  }

  // TODO Make colour animate
  void toggleTheme() {
    if (theme == light) {
      theme = dark;
    } else if (theme == dark) {
      theme = light;
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
        backgroundColor: theme.theme.primary,
        title: Text('Test Widget'),
        centerTitle: true,
      ),
      body: Center(
        child: ThemedButton(),
      ),
    );
  }
}

// TODO Make custom button
class ThemedButton extends StatefulWidget {
  // Button

  @override
  _ThemedButtonState createState() => _ThemedButtonState();
}

class _ThemedButtonState extends State<ThemedButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => print('tapped'),
      child: Semantics(
        button: true,
        // * Container
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 15,
          ),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                blurRadius: 10.0,
                spreadRadius: 0,
                color: Colors.black.withAlpha(60),
                offset: Offset(0, 0),
              ),
            ],
          ),
          // Text
          // * Text
          child: Text(
            'Click Me!',
            style: TextStyle(),
          ),
        ),
      ),
    );
  }
}
