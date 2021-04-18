import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:releaf/shared/const/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppTheme(
            // * Light Theme
            light: ThemeData(
              brightness: Brightness.light,
              primaryColor: Colors.green,
              accentColor: Colors.greenAccent,
              backgroundColor: Colors.white,
              appBarTheme: AppBarTheme(
                brightness: Brightness.light,
                backgroundColor: Colors.white.withAlpha(0),
                elevation: 0,
                centerTitle: false,
                titleSpacing: 28,
                titleTextStyle: TextStyle(
                  color: Colors.black,
                ),
              ),
              textTheme: TextTheme(
                headline1: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                ),
                subtitle1: TextStyle(),
                subtitle2: TextStyle(),
                bodyText1: TextStyle(),
                bodyText2: TextStyle(),
                button: TextStyle(
                  fontFamily:
                      'Poppins', // TODO find font similar to Rift for buttons
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            // * Dark Theme
            dark: ThemeData.dark(),
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

    return MaterialApp(
      home: TestWidget(),
      theme: theme.light,
      darkTheme: theme.dark,
      themeMode: theme.themeMode,
      // themeMode: autoTheme ? ThemeMode.system : null
    );
  }
}
