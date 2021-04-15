import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class AppTheme with ChangeNotifier {
  static Color primary = Colors.green;
  static late Color secondary;
  static late Color accent;
  static late TextStyle heading;
  static late TextStyle body;

  void toggleTheme() {
    notifyListeners();
  }
}

class TestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Widget'),
        backgroundColor: AppTheme.primary,
      ),
      body: Center(),
    );
  }
}
