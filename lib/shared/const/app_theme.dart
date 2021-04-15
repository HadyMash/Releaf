import 'package:flutter/material.dart';
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
  ThemeBase currentTheme;
  ThemeBase lightTheme;
  ThemeBase darkTheme;

  AppTheme({
    required this.currentTheme,
    required this.lightTheme,
    required this.darkTheme,
  });

  void toggleTheme() {
    if (currentTheme.backgroundColor == lightTheme.backgroundColor) {
      currentTheme = darkTheme;
    } else if (currentTheme.backgroundColor == darkTheme.backgroundColor) {
      currentTheme = lightTheme;
    }
    notifyListeners();
  }
}

class TestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AppTheme theme = Provider.of<AppTheme>(context);

    return Scaffold(
      backgroundColor: theme.currentTheme.backgroundColor,
      appBar: AppBar(
        title: Text('Test Widget'),
        centerTitle: true,
        backgroundColor: theme.currentTheme.secondary,
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Change Primary Colour'),
          onPressed: () {
            theme.toggleTheme();
            print('toggling theme');
          },
        ),
      ),
    );
  }
}
