import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:releaf/screens/authentication/welcome.dart';
import 'package:releaf/screens/home/dashboard.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final user = Provider.of
    // return user == null ? Welcome() : Dashboard();
    return Welcome();
  }
}
