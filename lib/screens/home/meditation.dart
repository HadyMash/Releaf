import 'package:flutter/material.dart';
import 'package:releaf/screens/home/hidden_fab.dart';
import 'package:releaf/shared/assets/home/navigation_bar.dart';

class Meditation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverAppBar(
            title: Text(
              'Meditation',
              style: Theme.of(context).textTheme.headline3,
            ),
            automaticallyImplyLeading: false,
          ),
          SliverToBoxAdapter(child: SizedBox(height: 100)),
          SliverToBoxAdapter(
            child: Center(
              child: Text('Coming Soon'),
            ),
          ),
        ],
      ),
      floatingActionButton: HiddenFAB(),
      bottomNavigationBar:
          ThemedNavigationBar(pageIndex: 0, animateFloatingActionButton: true),
    );
  }
}
