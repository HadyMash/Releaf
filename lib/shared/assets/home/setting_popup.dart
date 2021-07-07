import 'package:flutter/material.dart';
import 'package:releaf/shared/const/app_theme.dart';

class SettingPopup extends StatelessWidget {
  final Widget? child;

  const SettingPopup({this.child});

  @override
  Widget build(BuildContext context) {
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
