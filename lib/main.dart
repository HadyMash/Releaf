import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:releaf/shared/const/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:releaf/services/auth.dart';
import 'package:releaf/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        StreamProvider<User?>.value(
          initialData: null,
          value: AuthService().user,
        ),
        ChangeNotifierProvider(
          create: (_) => AppTheme(
            // * Light Theme
            light: ThemeData(
              brightness: Brightness.light,
              scaffoldBackgroundColor: Colors.grey[200],
              backgroundColor: Colors.white,
              primaryColor: Colors.green,
              accentColor: Colors.greenAccent[400],
              shadowColor: Colors.black,
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
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
                headline2: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 28,
                ),
                headline3: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  height: 1,
                ),
                headline4: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 30,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w700,
                ),
                subtitle1: TextStyle(
                  // TextFields
                  fontFamily: 'Poppins',
                ),
                subtitle2: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                bodyText1: TextStyle(),
                bodyText2: TextStyle(),
                caption: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
                button: TextStyle(
                  fontFamily:
                      'Poppins', // TODO find font similar to Rift for buttons
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              iconTheme: IconThemeData(color: Colors.black),
              accentIconTheme: IconThemeData(color: Colors.white),
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
      home: Wrapper(),
      theme: theme.light,
      darkTheme: theme.dark,
      themeMode: theme.themeMode,
    );
  }
}
