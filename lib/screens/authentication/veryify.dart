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
  late Timer countdownUpdate;
  bool checkingVerification = false;
  int timerCountdown = 5;

  // TODO Show dashboard when it is updated
  Future checkVerified() async {
    var user = _auth.getUser();
    await user!.reload();
    if (user.emailVerified) {
      print('verified');
      timer.cancel();
    } else {
      timerCountdown = 6;
      countdownUpdate = Timer.periodic(Duration(seconds: 1), (timer) {
        if (timerCountdown > 0) {
          setState(() => timerCountdown--);
        }
      });
    }
  }

  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 6), (timer) {
      countdownUpdate.cancel();
      checkVerified();
    });
    countdownUpdate = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timerCountdown > 0) {
        setState(() => timerCountdown--);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    countdownUpdate.cancel();
    super.dispose();
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
                        'Checking in $timerCountdown...', // TODO make the number change as it counts down.
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
                            onPressed: () => _auth.getUser()!.emailVerified
                                ? print('route to home')
                                : _auth.sendVerificationEmail(),
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

class VerifyNoBack extends StatefulWidget {
  @override
  _VerifyNoBackState createState() => _VerifyNoBackState();
}

class _VerifyNoBackState extends State<VerifyNoBack> {
  final _auth = AuthService();
  late Timer timer;
  late Timer countdownUpdate;
  bool checkingVerification = false;
  int timerCountdown = 5;

  Future checkVerified() async {
    var user = _auth.getUser();
    await user!.reload();
    if (user.emailVerified) {
      print('verified');
      timer.cancel();
    } else {
      timerCountdown = 6;
      countdownUpdate = Timer.periodic(Duration(seconds: 1), (timer) {
        if (timerCountdown > 0) {
          setState(() => timerCountdown--);
        }
      });
    }
  }

  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 6), (timer) {
      countdownUpdate.cancel();
      checkVerified();
    });
    countdownUpdate = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timerCountdown > 0) {
        setState(() => timerCountdown--);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    countdownUpdate.cancel();
    super.dispose();
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
                        'Checking in $timerCountdown...', // TODO make the number change as it counts down.
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 25),
                      ThemedButton.icon(
                        onPressed: () => _auth.getUser()!.emailVerified
                            ? print('route to home')
                            : _auth.sendVerificationEmail(),
                        icon: Icon(Icons.email),
                        label: 'Resend Email',
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
