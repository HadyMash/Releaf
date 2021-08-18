import 'package:flutter/material.dart';
import 'package:releaf/screens/home/hidden_fab.dart';
import 'package:releaf/shared/assets/home/dashboard/journal_summary.dart';
import 'package:releaf/shared/assets/home/dashboard/qod.dart';
import 'package:releaf/shared/assets/home/dashboard/tasks_summary.dart';
import 'package:releaf/shared/assets/home/navigation_bar.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverAppBar(
            title: Text(
              'Dashboard',
              style: Theme.of(context).textTheme.headline3,
            ),
            automaticallyImplyLeading: false,
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                QuoteOfTheDay(),
                TasksSummary(),
                JournalSummary(),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: HiddenFAB(),
      bottomNavigationBar:
          ThemedNavigationBar(pageIndex: 2, animateFloatingActionButton: true),
    );
  }
}
