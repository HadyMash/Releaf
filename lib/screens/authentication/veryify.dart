import 'dart:async';

import 'package:flutter/material.dart';
import 'package:releaf/services/auth.dart';
import 'package:releaf/shared/const/app_theme.dart';

class Verify extends StatefulWidget {
  @override
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  final _auth = AuthService();
  late Timer timer;
  int timerCountdown = 5;

  @override
  void initState() {
    Timer.periodic(Duration(seconds: 5), (timer) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            flex: 3,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(flex: 2),
                Flexible(
                  flex: 4,
                  child: Column(
                    children: [
                      Text(
                        'Verify',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 36,
                        ),
                      ),
                      Text('Please verify your email address.',
                          style: Theme.of(context).textTheme.caption),
                      SizedBox(height: 20),
                      Text(
                        'Checking in [#]...', // TODO make the number change as it counts down.
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 25),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ThemedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(Icons.arrow_back_ios_new_rounded),
                            label: 'Go Back',
                          ),
                          SizedBox(width: 20),
                          ThemedButton.icon(
                            onPressed: () => _auth.sendVerificationEmail(),
                            icon: Icon(Icons.email),
                            label: 'Resend Email',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
          Flexible(
            flex: 4,
            child: Placeholder(), // TODO Make rive animation for loading
          ),
        ],
      ),
    );
  }
}
