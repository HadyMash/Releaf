import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:releaf/shared/const/app_theme.dart';

void main() {
  runApp(
    MaterialApp(
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => AppTheme(
              currentTheme: ThemeBase(
                primary: Colors.green,
                secondary: Colors.lightGreen[400],
                accent: Colors.greenAccent,
                backgroundColor: Colors.white,
                heading: TextStyle(),
                body: TextStyle(),
              ),
              lightTheme: ThemeBase(
                primary: Colors.green,
                secondary: Colors.lightGreen[400],
                accent: Colors.greenAccent,
                backgroundColor: Colors.white,
                heading: TextStyle(),
                body: TextStyle(),
              ),
              darkTheme: ThemeBase(
                primary: Colors.lightGreen[400],
                secondary: Colors.green,
                accent: Colors.greenAccent,
                backgroundColor: Colors.grey[850],
                heading: TextStyle(),
                body: TextStyle(),
              ),
            ),
            lazy: false,
          ),
        ],
        child: TestWidget(),
      ),
    ),
  );
}
