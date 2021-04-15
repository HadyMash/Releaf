import 'package:flutter/material.dart';

class AppTheme {}

class TestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test Widget')),
      body: Center(),
    );
  }
}
