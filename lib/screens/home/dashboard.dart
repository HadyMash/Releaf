import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:releaf/screens/home/settings.dart';
import 'package:releaf/shared/const/app_theme.dart';
import 'package:releaf/services/auth.dart';
import 'package:releaf/services/database.dart';

class Dashboard extends StatelessWidget {
  final _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<AppTheme>(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              'Dashboard',
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
        ],
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
