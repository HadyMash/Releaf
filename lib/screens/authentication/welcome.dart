import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:releaf/screens/authentication/log_in.dart';
import 'package:releaf/services/auth.dart';
import 'package:releaf/shared/const/app_theme.dart';
import 'package:releaf/shared/assets/themed_button.dart';

class Welcome extends StatelessWidget {
  final _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final theme = Provider.of<AppTheme>(context);

    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    // * iPhone 12 Pro Max screen info
    // height: 926.0 -> 2778
    // width: 428.0 -> 1284
    // ratio: 3.0

    return Scaffold(
      body: Stack(
        children: [
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Image.asset(
              'assets/images/background_2.jpg',
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
          ),
          Center(
            child: Hero(
              tag: "Welcome Screen Center Box",
              child: Material(
                color: Colors.white.withOpacity(0),
                child: Container(
                  height: (1050 / 1284) * _width,
                  width: (1050 / 1284) * _width,
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor.withOpacity(0.8),
                        blurRadius: 30.0,
                        spreadRadius: 1.0,
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 35),
                      SvgPicture.asset(
                        'assets/releafLogo.svg',
                        height: (70 / 428) * _width,
                      ),
                      // SizedBox(height: 50),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ThemedButton.icon(
                              label: 'Email & Password',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2!
                                  .copyWith(
                                      fontSize: 23 -
                                          ((926 * 0.01) - (_height * 0.01))),
                              notAllCaps: true,
                              icon: Icon(
                                Icons.email,
                                size: 28,
                                color: Theme.of(context)
                                    .floatingActionButtonTheme
                                    .foregroundColor,
                              ),
                              onPressed: () =>
                                  AppTheme.mainNavKey.currentState!.push(
                                PageRouteBuilder(
                                  transitionDuration:
                                      Duration(milliseconds: 600),
                                  pageBuilder: (BuildContext context,
                                      Animation<double> animation,
                                      Animation<double> secondaryAnimation) {
                                    return LogInMock();
                                  },
                                  transitionsBuilder: (BuildContext context,
                                      Animation<double> animation,
                                      Animation<double> secondaryAnimation,
                                      Widget child) {
                                    return Align(
                                      child: FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              tapDownFeedback: true,
                              tapFeedback: true,
                            ),
                            SizedBox(height: 30),
                            ThemedButton.icon(
                              label: 'Google',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2!
                                  .copyWith(
                                      fontSize: 23 -
                                          ((926 * 0.01) - (_height * 0.01))),
                              notAllCaps: true,
                              icon: Image(
                                height: 30,
                                width: 30,
                                image:
                                    AssetImage('assets/images/google_logo.png'),
                              ),
                              onPressed: () => _auth.logInWithGoogle(),
                              tapDownFeedback: true,
                              tapFeedback: true,
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
