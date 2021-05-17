import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:releaf/screens/home/navigation_bar.dart';
import 'package:releaf/screens/home/settings.dart';
import 'package:releaf/shared/const/app_theme.dart';
import 'package:releaf/services/auth.dart';
import 'package:releaf/services/database.dart';

class Dashboard extends StatelessWidget {
  final _auth = AuthService();

  void _changePage(int index) {}

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<AppTheme>(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
          SliverAppBar(
            title: Text(
              'Dashboard',
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
        ],
      ),
      bottomNavigationBar: ThemedNavigationBar(2),
    );
  }
}
