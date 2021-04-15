import 'package:flutter/material.dart';

class AppTheme {
  static Color primary = Colors.green;
  static late Color secondary;
  static late Color accent;
  static late TextStyle heading;
  static late TextStyle body;
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
