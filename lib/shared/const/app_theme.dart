import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:releaf/shared/assets/custom_widget_border.dart';

class AppTheme with ChangeNotifier {
  ThemeData light;
  ThemeData dark;
  ThemeMode themeMode = ThemeMode.system;
  late bool haptics;
  List<int> activeDays = [];
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

  Future setHaptics(bool haptics) async {
    this.haptics = haptics;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool('haptics', haptics);
  }

  Future updateActiveDays() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    DateTime dt = DateTime.now();

    List<String> days = preferences.getStringList('activity') ?? [];

    if (days.isNotEmpty) {
      // the first element is the month number so it is removed
      int month = int.parse(days[0]);
      days.removeAt(0);
      // the month has changed so all of the previous months activity will be deleted.
      if (month != dt.month) {
        days.clear();
      }
    }

    // add today if it doesn't already exist
    if (!days.contains(dt.day.toString())) {
      days.add(dt.day.toString());
    }

    // add the month back to the start for when the method is run again.
    days.insert(0, dt.month.toString());

    // set the string list again
    preferences.setStringList('activity', days);

    // turn the `List<String>` into a `List<int>` so that the `activeDays`
    // can be set to the current active days.
    List<int> intDays = [];

    for (String day in days) {
      intDays.add(int.parse(day));
    }

    activeDays = intDays;
  }

  Future getSavedData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await updateActiveDays();
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
