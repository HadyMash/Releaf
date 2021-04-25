import 'dart:async';

import 'package:flutter/material.dart';
import 'package:releaf/services/auth.dart';

class Verify extends StatefulWidget {
  @override
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  final _auth = AuthService();
  late Timer timer;

  @override
  void initState() {
    // _auth.sendVerificationEmail();

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
                )
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
