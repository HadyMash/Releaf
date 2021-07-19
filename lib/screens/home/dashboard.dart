import 'package:flutter/material.dart';
import 'package:releaf/screens/home/hidden_fab.dart';
import 'package:releaf/screens/home/settings.dart';
import 'package:releaf/services/auth.dart';
import 'package:releaf/services/database.dart';
import 'package:releaf/shared/assets/home/journal_entry_form.dart';
import 'package:releaf/shared/assets/home/navigation_bar.dart';
import 'package:releaf/screens/home/tasks.dart';
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
            child: Center(
              child: Text('Coming Soon!'),
            ),
            // child: Column(
            //   children: [
            //     // // TODO add Quote of the day
            //     // TaskProgress(),
            //   ],
            // ),
          )
        ],
      ),
      floatingActionButton: HiddenFAB(),
      bottomNavigationBar:
          ThemedNavigationBar(pageIndex: 2, animateFloatingActionButton: true),
    );
  }
}

class TaskProgress extends StatefulWidget {
  const TaskProgress({Key? key}) : super(key: key);

  @override
  _TaskProgressState createState() => _TaskProgressState();
}

class _TaskProgressState extends State<TaskProgress> {
  final AuthService _auth = AuthService();
  late final DatabaseService database;
  late Future<List> yearsFuture;

  final FixedExtentScrollController yearPickerScrollController =
      FixedExtentScrollController(initialItem: DateTime.now().year - 2000);

  final GlobalKey lottieKey = GlobalKey();

  @override
  void initState() {
    database = DatabaseService(uid: _auth.getUser()!.uid);
    yearsFuture = database.getTaskYears();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool yearChangedManually = false;
  int selectedYear = DateTime.now().year;
  int? addedYear;
  double progress = 0;
  List<Widget?> progressPercentages = [
    Text('0%'),
    Text('10%'),
    Text('20%'),
    Text('30%'),
    Text('40%'),
    Text('50%'),
    Text('60%'),
    Text('70%'),
    Text('80%'),
    Text('90%'),
    Text('100%'),
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: FutureBuilder<List?>(
        initialData: [],
        future: yearsFuture,
        builder: (context, future) {
          List? years = future.data;

          if (future.connectionState == ConnectionState.done) {
            if (years != null) {
              years.sort((a, b) => (a as int).compareTo(b as int));
            }
          }

          if (yearChangedManually == false) {
            if (future.connectionState == ConnectionState.done) {
              if ((years ?? []).contains(DateTime.now().year)) {
                selectedYear = DateTime.now().year;
              } else {
                selectedYear =
                    findClosestYear(years ?? [], DateTime.now().year);
              }
            }
          }

          return StreamBuilder(
            stream: future.connectionState == ConnectionState.done
                ? database.getTodos(selectedYear)
                : null,
            builder: (context, snapshot) {
              if (future.connectionState == ConnectionState.done) {
                if (snapshot.connectionState == ConnectionState.active ||
                    snapshot.connectionState == ConnectionState.done) {
                  List<TodoData> data = snapshot.data as List<TodoData>;
                  int totalTodos = 0;
                  int completedTodos = 0;
                  data.forEach((todo) {
                    if (todo.completed == true) {
                      totalTodos += 1;
                      completedTodos += 1;
                    } else {
                      totalTodos += 1;
                    }
                  });
                  progress = completedTodos / totalTodos;

                  if (progress.isNaN) {
                    progress = 0;
                  }

                  data.sort((a, b) {
                    int aNum = a.completed ? 1 : 0;
                    int bNum = b.completed ? 1 : 0;

                    return aNum.compareTo(bNum);
                  });
                }
              }
              return Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withOpacity(0.19),
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/nav_bar_icons/tasks_selected.png',
                          width: 50,
                          height: 50,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Yearly Goals',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(color: Theme.of(context).primaryColor),
                        ),
                        Spacer(),
                        Text(
                          ((snapshot.data ?? []) as List).isEmpty
                              ? ''
                              : (progress.isNaN
                                  ? ''
                                  : '${(progress * 100).round()}%'),
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 3),
                      child: Stack(
                        children: [
                          Container(
                            height: 30,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color.fromRGBO(
                                Theme.of(context).scaffoldBackgroundColor.red -
                                    20,
                                Theme.of(context)
                                        .scaffoldBackgroundColor
                                        .green -
                                    20,
                                Theme.of(context).scaffoldBackgroundColor.blue -
                                    20,
                                1,
                              ),
                            ),
                            // clipBehavior: Clip.hardEdge,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: AnimatedContainer(
                              curve: Curves.easeInOut,
                              duration: Duration(milliseconds: 800),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Theme.of(context).primaryColor,
                                    Theme.of(context).colorScheme.secondary,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary
                                        .withOpacity(0.5),
                                    blurRadius: 20,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              height: 30,
                              width: (MediaQuery.of(context).size.width - 50) *
                                  progress,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
