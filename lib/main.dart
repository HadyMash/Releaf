import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:releaf/shared/const/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppTheme(
            light: ThemeBase(
              primary: Colors.green,
              secondary: Colors.lightGreen[400],
              accent: Colors.greenAccent,
              backgroundColor: Colors.white,
              heading: TextStyle(),
              body: TextStyle(),
            ),
            dark: ThemeBase(
              primary: Colors.green,
              secondary: Colors.lightGreen[400],
              accent: Colors.greenAccent,
              backgroundColor: Colors.grey[850],
              heading: TextStyle(),
              body: TextStyle(),
            ),
          ),
          lazy: false,
        ),
      ],
      child: ThemedApp(),
    ),
  );
}

class ThemedApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AppTheme theme = Provider.of<AppTheme>(context);

    final bool autoTheme = false;
    final ThemeMode defaultTheme = ThemeMode.light;

    return MaterialApp(
      home: TestWidget(),
      theme: theme.getLightTheme(),
      darkTheme: theme.getDarkTheme(),
      themeMode: autoTheme ? ThemeMode.system : null,
    );
  }
}
