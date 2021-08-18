import 'dart:typed_data';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:releaf/screens/home/hidden_fab.dart';
import 'package:releaf/screens/home/journal.dart';
import 'package:releaf/screens/home/settings.dart';
import 'package:releaf/services/auth.dart';
import 'package:releaf/services/database.dart';
import 'package:releaf/services/storage.dart';
import 'package:releaf/shared/assets/home/dashboard/journal_summary.dart';
import 'package:releaf/shared/assets/home/dashboard/tasks_summary.dart';
import 'package:releaf/shared/assets/home/journal_entry.dart';
import 'package:releaf/shared/assets/home/journal_entry_form.dart';
import 'package:releaf/shared/assets/home/navigation_bar.dart';
import 'package:releaf/screens/home/tasks.dart';
import 'package:releaf/shared/const/app_theme.dart';
import 'package:releaf/shared/models/journal_entry_data.dart';
import 'package:releaf/shared/models/todo_data.dart';

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
                // TODO add Quote of the day
                Placeholder(fallbackHeight: 100),
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
