import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:releaf/services/auth.dart';
import 'package:releaf/services/database.dart';
import 'package:releaf/shared/assets/home/navigation_bar.dart';
import 'package:releaf/shared/assets/themed_button.dart';
import 'package:releaf/shared/const/app_theme.dart';
import 'package:releaf/shared/const/custom_popup_route.dart';

class Tasks extends StatefulWidget {
  final bool animate;
  Tasks(this.animate);
  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> with SingleTickerProviderStateMixin {
  final AuthService _auth = AuthService();
  late Future<List> yearsFuture;

  late final AnimationController controller;
  late final CurvedAnimation animation;

  final FixedExtentScrollController yearPickerScrollController =
      FixedExtentScrollController(initialItem: DateTime.now().year - 2000);

  @override
  void initState() {
    yearsFuture = DatabaseService(uid: _auth.getUser()!.uid).getTaskYears();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 320));
    super.initState();
    animation = CurvedAnimation(curve: Curves.easeInOut, parent: controller);

    super.initState();

    if (widget.animate == true) {
      controller.forward();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool yearChangedManually = false;
  int selectedYear = DateTime.now().year;
  int? addedYear;

  Future makeNewYear(int year) async {
    DatabaseService database = DatabaseService(uid: _auth.getUser()!.uid);
    await database.addTaskYear(year);
    yearsFuture = database.getTaskYears();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return FutureBuilder<List?>(
      initialData: [],
      future: yearsFuture,
      builder: (context, future) {
        List? years = future.data;
        print(years);
        if (years != null) {
          years.sort((a, b) => (a as int).compareTo(b as int));
        }

        if (yearChangedManually == false) {
          if (future.connectionState == ConnectionState.done) {
            if (years!.contains(DateTime.now().year)) {
              selectedYear = DateTime.now().year;
            } else {
              if (years[years.length - 1] < DateTime.now().year) {
                // TODO add check to see if they made the year before and deleted it
                makeNewYear(DateTime.now().year);
              } else {
                selectedYear = findClosestYear(years, DateTime.now().year);
              }
            }
          }
        }

        // TODO wrap with stream provider
        return Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, _) {
              return <Widget>[
                SliverToBoxAdapter(child: SizedBox(height: 20)),
                SliverAppBar(
                  title: Text(
                    'Tasks',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  automaticallyImplyLeading: false,
                  actions: [
                    Row(
                      children: [
                        future.connectionState == ConnectionState.done
                            ? (DropdownButton<int>(
                                underline: Container(),
                                value: selectedYear,
                                items: years!
                                    .map(
                                      (e) => DropdownMenuItem(
                                        child: Text(
                                          e.toString(),
                                          style: TextStyle(
                                            fontSize: 20 -
                                                ((926 * 0.01) -
                                                    (height * 0.01)),
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .color,
                                          ),
                                        ),
                                        value: e as int,
                                      ),
                                    )
                                    .toList(),
                                onChanged: (year) {
                                  yearChangedManually = true;
                                  setState(() => selectedYear = year!);
                                },
                              ))
                            : Container(),
                        IconButton(
                          icon: Icon(
                            CupertinoIcons.add,
                            size: 32,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          onPressed: () {
                            List yearList = [];
                            for (int i = 0; i < 51; i++) {
                              yearList.add(2000 + i);
                            }
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: CupertinoPicker(
                                        scrollController:
                                            yearPickerScrollController,
                                        itemExtent: 40,
                                        onSelectedItemChanged: (year) {
                                          addedYear = year;
                                        },
                                        children: yearList
                                            .map((e) => Center(
                                                child: Text(e.toString())))
                                            .toList(),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: ThemedButton(
                                        label: 'Add Year',
                                        notAllCaps: true,
                                        onPressed: () async {
                                          await DatabaseService(
                                                  uid: _auth.getUser()!.uid)
                                              .addTaskYear((addedYear ??
                                                      (DateTime.now().year -
                                                          2000)) +
                                                  2000);
                                          yearsFuture = DatabaseService(
                                                  uid: _auth.getUser()!.uid)
                                              .getTaskYears();
                                          await DatabaseService(
                                                  uid: _auth.getUser()!.uid)
                                              .getTaskYears();
                                          setState(
                                              () => selectedYear = addedYear!);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    )
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete_rounded,
                            size: 32,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => AlertDialog(
                                title: Text('Confirm Delete'),
                                content: Text(
                                    'Are you sure you want to delete your ${selectedYear} goals?'),
                                actions: [
                                  TextButton(
                                    child: Text('No'),
                                    onPressed: () {
                                      AppTheme.mainNavKey.currentState!.pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Yes'),
                                    onPressed: () async {
                                      DatabaseService database =
                                          DatabaseService(
                                              uid: _auth.getUser()!.uid);
                                      List years =
                                          await database.getTaskYears();
                                      if (years.length > 0) {
                                        await database
                                            .deleteTaskYear(selectedYear);
                                      } else {
                                        await database
                                            .deleteTaskYear(selectedYear);
                                        await database
                                            .addTaskYear(DateTime.now().year);
                                        yearsFuture = database.getTaskYears();
                                        years.remove(selectedYear);
                                        setState(() {});
                                      }
                                      AppTheme.mainNavKey.currentState!.pop();
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                  ],
                ),
              ];
            },
            body: (future.connectionState == ConnectionState.done)
                ? Center(child: CircularProgressIndicator())
                : Center(child: CircularProgressIndicator()),
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: 'floatingActionButton',
            backgroundColor: Theme.of(context).primaryColor,
            splashColor: Theme.of(context).accentColor,
            child: AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: (pi * 2) - ((pi * animation.value) / 2),
                  child: child,
                );
              },
              child: Icon(
                Icons.add_rounded,
                color: Theme.of(context).accentIconTheme.color,
                size: 40,
              ),
            ),
            onPressed: () {},
          ),
          bottomNavigationBar: ThemedNavigationBar(
              pageIndex: 1, animateFloatingActionButton: false),
        );
      },
    );
  }
}

int findClosestYear(List years, int target) {
  int length = years.length;

  // Corner Cases
  if (target <= years[0]) {
    return years[0];
  }
  if (target >= years[length - 1]) {
    return years[length - 1];
  }

// Doing binary search
  int i = 0;
  int j = length;
  int mid = 0;

  while (i < j) {
    mid = ((i + j) / 2).round();
    if (years[mid] == target) {
      return years[mid];
    }

    /* If target is less
    than array element,
    then search in left */
    if (target < years[mid]) {
      if (mid > 0 && target > years[mid - 1])
        return getClosest(years[mid - 1], years[mid], target);

      /* Repeat for left half */
      j = mid;
    } else {
      // If target is
      // greater than mid

      if (mid < length - 1 && target < years[mid + 1]) {
        return getClosest(years[mid], years[mid + 1], target);
      }
      i = mid + 1; // update i
    }
  }

  // Only single element
  // left after search
  return years[mid];
}

// Method to compare which one
// is the more close We find the
// closest by taking the difference
// between the target and both
// values. It assumes that val2 is
// greater than val1 and target
// lies between these two.
int getClosest(int val1, int val2, int target) {
  if (target - val1 >= val2 - target) {
    return val2;
  } else {
    return val1;
  }
}
