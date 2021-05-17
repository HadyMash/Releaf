import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:releaf/screens/authentication/veryify.dart';
import 'package:releaf/screens/authentication/welcome.dart';
import 'package:releaf/screens/home/dashboard.dart';
import 'package:releaf/services/auth.dart';
import 'package:releaf/shared/const/app_theme.dart';

class Wrapper extends StatelessWidget {
  // TODO make wrapper transition between screens and use navigator's first route to change them.

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    final _auth = AuthService();
    // ignore: unused_local_variable
    final theme = Provider.of<AppTheme>(context);

    Navigator.popUntil(context, (route) => route.isFirst);

    return user == null
        ? Welcome()
        : (_auth.getUser()!.emailVerified ? Dashboard() : Verify());
  }
}
