import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:releaf/screens/authentication/log_in.dart';
import 'package:releaf/shared/const/app_theme.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Placeholder(), // TODO add rive background
          Center(
            child: Hero(
              tag: "Welcome Screen Center Box",
              child: Material(
                child: Container(
                  height: 350,
                  width: 350,
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.8),
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
                      Container(
                        color: Colors.lightGreen,
                        child: Text(
                          '[Releaf Logo]',
                          style: TextStyle(fontSize: 40),
                        ),
                      ),
                      // SizedBox(height: 50),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ThemedButton.icon(
                              label: 'Email & Password',
                              style: TextStyle(
                                fontFamily:
                                    'Poppins', // TODO find font similar to Rift for buttons
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 23,
                              ),
                              notAllCaps: true,
                              icon: Icon(
                                Icons.email /* TODO Make Icon */,
                                color: Colors.white,
                                size: 28,
                              ),
                              onPressed: () =>
                                  // Navigator.pushNamed(context, '/pageTwo');
                                  Navigator.of(context).push(
                                PageRouteBuilder(
                                  transitionDuration:
                                      Duration(milliseconds: 600),
                                  pageBuilder: (BuildContext context,
                                      Animation<double> animation,
                                      Animation<double> secondaryAnimation) {
                                    return LogIn();
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
                            ),
                            SizedBox(height: 30),
                            ThemedButton.icon(
                              label: 'Google',
                              style: TextStyle(
                                fontFamily:
                                    'Poppins', // TODO find font similar to Rift for buttons
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 23,
                              ),
                              notAllCaps: true,
                              icon: Icon(
                                Icons.email /* TODO Make Icon */,
                                color: Colors.white,
                                size: 28,
                              ),
                              onPressed: () {},
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
