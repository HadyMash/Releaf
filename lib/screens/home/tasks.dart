import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:releaf/screens/home/dashboard.dart';
import 'package:releaf/screens/home/navigation_bar.dart';
import 'package:releaf/shared/const/app_theme.dart';
import 'package:releaf/services/auth.dart';
import 'package:releaf/services/database.dart';

class Tasks extends StatelessWidget {
  void _changePage(int index) {}

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<AppTheme>(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverAppBar(
            title: Text(
              'Tasks',
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          SliverToBoxAdapter(
            child: Hero(
              tag: 'pageText',
              child: Material(
                color: Colors.white.withOpacity(0),
                child: Container(
                  color: Colors.red,
                  width: 100,
                  height: 100,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ThemedNavigationBar(1),
    );
  }
}
