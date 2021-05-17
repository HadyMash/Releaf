import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:releaf/screens/home/dashboard.dart';
import 'package:releaf/screens/home/navigation_bar.dart';
import 'package:releaf/shared/const/app_theme.dart';
import 'package:releaf/services/auth.dart';
import 'package:releaf/services/database.dart';

class Meditation extends StatelessWidget {
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
              'Meditation',
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 100)),
          SliverToBoxAdapter(
            child: Hero(
              tag: 'pageText',
              child: Material(
                color: Colors.white.withOpacity(0),
                child: Container(
                  color: Colors.blue,
                  width: 50,
                  height: 50,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ThemedNavigationBar(0),
    );
  }
}
