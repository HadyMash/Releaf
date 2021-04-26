import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:releaf/screens/authentication/veryify.dart';
import 'package:releaf/screens/authentication/welcome.dart';
import 'package:releaf/screens/home/dashboard.dart';
import 'package:releaf/services/auth.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    final _auth = AuthService();

    return user == null
        ? Welcome()
        : (_auth.getUser()!.emailVerified ? Dashboard() : Verify());
  }
}
