import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:releaf/screens/authentication/log_in.dart';
import 'package:releaf/screens/authentication/register.dart';
import 'package:releaf/screens/authentication/veryify.dart';
import 'package:releaf/screens/authentication/welcome.dart';
import 'package:releaf/services/auth.dart';
import 'package:releaf/shared/assets/custom_form_field.dart';
import 'package:releaf/shared/const/app_theme.dart';
import 'package:releaf/wrapper.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // timeDilation: 2.0;
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
              primaryColor: Colors.green,
              accentColor: Colors.greenAccent[400],
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
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                ),
                headline2: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 28,
                ),
                subtitle1: TextStyle(
                  // TextFields
                  fontFamily: 'Poppins',
                ),
                subtitle2: TextStyle(),
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
