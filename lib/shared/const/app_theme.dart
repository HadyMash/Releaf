import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:releaf/shared/assets/custom_widget_border.dart';

class AppTheme with ChangeNotifier {
  ThemeData light;
  ThemeData dark;
  ThemeMode themeMode = ThemeMode.system;
  late bool haptics;
  double bottomNavigationBarBorderRadius = 25;

  static final GlobalKey<NavigatorState> mainNavKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> homeNavkey =
      GlobalKey<NavigatorState>();

  var inputDecoration = InputDecoration(
    contentPadding: EdgeInsets.fromLTRB(10, 15, 8, 20),
    border: CustomWidgetBorder(color: Colors.grey, width: 1.2),
    enabledBorder: CustomWidgetBorder(color: Colors.grey, width: 1.2),
    errorBorder: CustomWidgetBorder(color: Colors.red[300], width: 1.5),
    focusedErrorBorder: CustomWidgetBorder(color: Colors.red[300], width: 2.4),
    errorStyle: TextStyle(fontSize: 14),
  );

  AppTheme({
    required this.light,
    required this.dark,
  });

  void setTheme(ThemeMode theme) async {
    themeMode = theme;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    switch (theme) {
      case ThemeMode.system:
        {
          await preferences.setString('theme', 'system');
        }
        break;
      case ThemeMode.light:
        {
          await preferences.setString('theme', 'light');
        }
        break;
      case ThemeMode.dark:
        {
          await preferences.setString('theme', 'dark');
        }
        break;
      default:
        {
          await preferences.setString('theme', 'system');
        }
        break;
    }
    notifyListeners();
  }

  void setHaptics(bool haptics) async {
    this.haptics = haptics;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool('haptics', haptics);
  }

  Future getSavedData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String theme = preferences.getString('theme') ?? 'system';
    bool hapticsPreference = preferences.getBool('haptics') ?? true;
    switch (theme) {
      case 'system':
        {
          themeMode = ThemeMode.system;
        }
        break;
      case 'light':
        {
          themeMode = ThemeMode.light;
        }
        break;
      case 'dark':
        {
          themeMode = ThemeMode.dark;
        }
        break;
      default:
        {
          themeMode = ThemeMode.system;
        }
        break;
    }
    haptics = hapticsPreference;
  }
}
