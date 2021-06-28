import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:releaf/services/auth.dart';
import 'package:releaf/shared/const/app_theme.dart';
import 'package:releaf/shared/assets/themed_button.dart';

class Verify extends StatefulWidget {
  @override
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  final _auth = new AuthService();
  final GlobalKey lottieKey = GlobalKey();
  late Timer timer;
  late Timer countdownUpdate;
  bool checkingVerification = false;
  int timerCountdown = 30;

  Future checkVerified() async {
    await _auth.reloadUser();
    if (_auth.getUser()!.emailVerified) {
      timer.cancel();
      // TODO add rive page transition.
      AppTheme.mainNavKey.currentState!.popUntil((route) => route.isFirst);
    } else {
      timerCountdown = 30;
      countdownUpdate = Timer.periodic(Duration(seconds: 1), (timer) {
        if (timerCountdown > 0) {
          setState(() => timerCountdown--);
        }
      });
    }
  }

  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 30), (timer) {
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
    final _height = MediaQuery.of(context).size.height;
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
                Spacer(),
                Flexible(
                  flex: 4,
                  child: Column(
                    children: [
                      Text(
                        'Verify',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Theme.of(context).textTheme.headline4!.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 36 - ((926 * 0.01) - (_height * 0.01)),
                        ),
                      ),
                      Text('Please verify your email address.',
                          style: Theme.of(context).textTheme.caption),
                      SizedBox(height: (20 / 926) * _height),
                      Text(
                        'Checking in $timerCountdown...',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 16 - ((926 * 0.01) - (_height * 0.01)),
                        ),
                      ),
                      SizedBox(height: (25 / 926) * _height),
                      SizedBox(width: 20),
                      ThemedButton.icon(
                        onPressed: () => _auth.getUser()!.emailVerified
                            ? {}
                            : _auth.sendVerificationEmail(context),
                        icon: Icon(
                          Icons.email,
                          color: Theme.of(context)
                              .floatingActionButtonTheme
                              .foregroundColor,
                        ),
                        label: 'Resend Email',
                        tapDownFeedback: true,
                      ),
                      SizedBox(height: (20 / 926) * _height),
                      ThemedButton.icon(
                        label: 'Log out',
                        icon: Icon(Icons.logout_rounded,
                            color: Theme.of(context)
                                .floatingActionButtonTheme
                                .foregroundColor),
                        onPressed: () => _auth.logOut(),
                        tapFeedback: true,
                      ),
                    ],
                  ),
                ),
                // Spacer(),
              ],
            ),
          ),
          Flexible(
            flex: 4,
            child: Center(
              child: Lottie.asset(
                'assets/lottie/verify_animation.json',
                frameRate: FrameRate.max,
                key: lottieKey,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
