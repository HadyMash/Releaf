import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class ThemeBase {
  Color? primary;
  Color? secondary;
  Color? accent;
  TextStyle heading;
  TextStyle body;

  ThemeBase({
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.heading,
    required this.body,
  });
}

class AppTheme with ChangeNotifier {
  late ThemeBase theme;
  ThemeBase lightTheme;
  ThemeBase darkTheme;

  AppTheme({required this.lightTheme, required this.darkTheme});
}

class TestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Widget'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Change Primary Colour'),
          onPressed: () {},
        ),
      ),
    );
  }
}
