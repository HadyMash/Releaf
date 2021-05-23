import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:releaf/services/auth.dart';
import 'package:releaf/shared/const/app_theme.dart';
import 'package:releaf/shared/assets/custom_widget_border.dart';

class SettingPopup extends StatelessWidget {
  final Widget? child;

  const SettingPopup({this.child});

  @override
  Widget build(BuildContext context) {
    final _theme = Provider.of<AppTheme>(context);
    return GestureDetector(
      onTap: () => AppTheme.mainNavKey.currentState!.pop(context),
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0),
        body: Center(
          child: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            // TODO make glowy container behind that animates in a pie chart
            /*
            Clip rectangle through some sort of pie chart clip or something similar to achieve a border with a trim path effect.
            */
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.8),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
