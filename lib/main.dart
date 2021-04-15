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
                lightTheme: ThemeBase(
                  primary: Colors.green,
                  secondary: Colors.lightGreen[400],
                  accent: Colors.greenAccent,
                  heading: TextStyle(),
                  body: TextStyle(),
                ),
                darkTheme: ThemeBase(
                  primary: Colors.green,
                  secondary: Colors.lightGreen[400],
                  accent: Colors.greenAccent,
                  heading: TextStyle(),
                  body: TextStyle(),
                )),
            lazy: false,
          ),
        ],
        child: TestWidget(),
      ),
    ),
  );
}
