import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:releaf/screens/home/dashboard.dart';
import 'package:releaf/screens/home/settings.dart';
import 'package:releaf/shared/const/app_theme.dart';
import 'package:releaf/services/auth.dart';
import 'package:releaf/services/database.dart';
import 'package:releaf/shared/assets/custom_popup_route.dart';

class Dashboard extends StatelessWidget {
  final _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<AppTheme>(context);

    return Scaffold(
      appBar: AppBar(
        // TODO Make it a sliver app bar
        title: Text(
          'Dashboard',
          style: Theme.of(context).textTheme.headline3,
        ),
        actions: [
          IconButton(
            onPressed: () => _auth.logOut(),
            icon: Icon(
              Icons.logout_rounded,
              color: Colors.black,
            ),
            splashRadius: 28,
            padding: EdgeInsets.symmetric(horizontal: 30),
          ),
        ],
      ),
      body: Center(
        child: Text('Dashboard'),
      ),
    );
  }
}

class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Setting(
        label: 'test',
        preference: Icon(Icons.settings),
        heroTag: 'testSetting',
      ),
    );
  }
}
