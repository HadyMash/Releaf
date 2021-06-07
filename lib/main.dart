import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:releaf/shared/assets/custom_widget_border.dart';
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
              colorScheme: ColorScheme(
                primary: Colors.green,
                secondary: Colors.greenAccent[400]!,
                onBackground: Colors.black,
                brightness: Brightness.light,
                surface: Colors.white,
                onSurface: Colors.black,
                primaryVariant: Colors.green[700]!,
                onError: Colors.white,
                onSecondary: Colors.black,
                background: Colors.grey[200]!,
                onPrimary: Colors.white,
                secondaryVariant: Colors.greenAccent[700]!,
                error: Colors.red[300]!,
              ),
              scaffoldBackgroundColor: Colors.grey[200],
              backgroundColor: Colors.white,
              primaryColor: Colors.green,
              // accentColor: Colors.greenAccent[400],
              shadowColor: Colors.black,
              errorColor: Colors.red[300],
              disabledColor: Colors.grey,
              appBarTheme: AppBarTheme(
                brightness: Brightness.light,
                backgroundColor: AppTheme.transparent,
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
                bodyText1: TextStyle(fontSize: 16),
                bodyText2: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
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
              iconTheme: IconThemeData(color: Colors.black, size: 34),
              // accentIconTheme: IconThemeData(color: Colors.white),
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
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

class ThemedApp extends StatefulWidget {
  @override
  _ThemedAppState createState() => _ThemedAppState();
}

class _ThemedAppState extends State<ThemedApp> {
  @override
  Widget build(BuildContext context) {
    final AppTheme theme = Provider.of<AppTheme>(context);
    return FutureBuilder(
      future: theme.getSavedData(),
      builder: (context, snapshot) {
        return MaterialApp(
          builder: (context, child) {
            final theme = Provider.of<AppTheme>(context);
            final height = MediaQuery.of(context).size.height;
            final width = MediaQuery.of(context).size.width;

            theme.inputDecoration = InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                (10 / 428) * width,
                (15 / 926) * height,
                (8 / 428) * width,
                (20 / 926) * height,
              ),
              border: CustomWidgetBorder(color: Colors.grey, width: 1.2),
              enabledBorder: CustomWidgetBorder(color: Colors.grey, width: 1.2),
              errorBorder:
                  CustomWidgetBorder(color: Colors.red[300], width: 1.5),
              focusedErrorBorder:
                  CustomWidgetBorder(color: Colors.red[300], width: 2.4),
              errorStyle:
                  TextStyle(fontSize: 14 - ((926 * 0.002) - (height * 0.002))),
            );

            theme.light = ThemeData(
              brightness: Brightness.light,
              colorScheme: ColorScheme(
                primary: Colors.green,
                secondary: Colors.greenAccent[400]!,
                onBackground: Colors.black,
                brightness: Brightness.light,
                surface: Colors.white,
                onSurface: Colors.black,
                primaryVariant: Colors.green[700]!,
                onError: Colors.white,
                onSecondary: Colors.black,
                background: Colors.grey[200]!,
                onPrimary: Colors.white,
                secondaryVariant: Colors.greenAccent[700]!,
                error: Colors.red[300]!,
              ),
              scaffoldBackgroundColor: Colors.grey[200],
              backgroundColor: Colors.white,
              primaryColor: Colors.green,
              // accentColor: Colors.greenAccent[400],
              shadowColor: Colors.black,
              disabledColor: Colors.grey,
              appBarTheme: AppBarTheme(
                brightness: Brightness.light,
                backgroundColor: AppTheme.transparent,
                elevation: 0,
                centerTitle: false,
                titleSpacing: 28,
                titleTextStyle: TextStyle(
                  color: Colors.black,
                ),
              ),
              textTheme: theme.light.textTheme.copyWith(
                headline1: theme.light.textTheme.headline1!.copyWith(
                  fontSize: 32 - ((926 * 0.01) - (height * 0.01)),
                ),
                headline2: theme.light.textTheme.headline2!.copyWith(
                  fontSize: 28 - ((926 * 0.01) - (height * 0.01)),
                ),
                headline3: theme.light.textTheme.headline3!.copyWith(
                  fontSize: 40 - ((926 * 0.01) - (height * 0.01)),
                ),
                headline4: theme.light.textTheme.headline4!.copyWith(
                  fontSize: 30 - ((926 * 0.01) - (height * 0.01)),
                ),
                subtitle2: theme.light.textTheme.subtitle2!.copyWith(
                  fontSize: 26 - ((926 * 0.01) - (height * 0.01)),
                ),
                bodyText1: theme.light.textTheme.bodyText1!.copyWith(
                  fontSize: 16 - ((926 * 0.01) - (height * 0.01)),
                ),
                bodyText2: theme.light.textTheme.bodyText2!.copyWith(
                  fontSize: 16 - ((926 * 0.01) - (height * 0.01)),
                ),
                caption: theme.light.textTheme.caption!.copyWith(
                  fontSize: 18 - ((926 * 0.01) - (height * 0.01)),
                ),
                button: theme.light.textTheme.button!.copyWith(
                  fontSize: 18 - ((926 * 0.01) - (height * 0.01)),
                ),
              ),
              iconTheme: IconThemeData(color: Colors.black, size: 34),
              // accentIconTheme: IconThemeData(color: Colors.white),
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            );

            return child!;
          },
          home: Wrapper(),
          navigatorKey: AppTheme.mainNavKey,
          theme: theme.light,
          darkTheme: theme.dark,
          themeMode: theme.themeMode,
        );
      },
    );
  }
}

// TODO Implement Loading widget to preload data.
class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Loading'),
      ),
    );
  }
}
