import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:releaf/screens/home/tasks.dart';
import 'package:releaf/services/auth.dart';
import 'package:releaf/services/database.dart';
import 'package:releaf/shared/const/app_theme.dart';
import 'package:releaf/shared/models/todo_data.dart';

class TasksSummary extends StatefulWidget {
  const TasksSummary({Key? key}) : super(key: key);

  @override
  _TasksSummaryState createState() => _TasksSummaryState();
}

class _TasksSummaryState extends State<TasksSummary> {
  final AuthService _auth = AuthService();
  late final DatabaseService database;
  late Future<List> yearsFuture;

  final FixedExtentScrollController yearPickerScrollController =
      FixedExtentScrollController(initialItem: DateTime.now().year - 2000);

  late Color _shadowColor;
  double _blurRadius = 15;

  void _animateDown() {
    _shadowColor = Theme.of(context).shadowColor.withOpacity(0.40);
    _blurRadius = 25;
  }

  void _animateUp() {
    _shadowColor = Theme.of(context).shadowColor.withOpacity(0.19);
    _blurRadius = 15;
  }

  @override
  void initState() {
    database = DatabaseService(uid: _auth.getUser()!.uid);
    yearsFuture = database.getTaskYears();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _shadowColor = Theme.of(context).shadowColor.withOpacity(0.19);
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
              return GestureDetector(
                onTap: () => AppTheme.homeNavkey.currentState!.pushReplacement(
                  PageRouteBuilder(
                    transitionDuration: Duration(milliseconds: 320),
                    pageBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return Tasks(false);
                    },
                    transitionsBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation,
                        Widget child) {
                      return Align(
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      );
                    },
                  ),
                ),
                onTapDown: (_) => setState(_animateDown),
                onTapUp: (_) => setState(_animateUp),
                onTapCancel: () => setState(_animateUp),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: _shadowColor,
                        blurRadius: _blurRadius,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context)
                                      .shadowColor
                                      .withOpacity(0.13),
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: SvgPicture.asset(
                              'assets/adobe/illustrator/icons/svg/tasks_selected.svg',
                              width: 35,
                              height: 35,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Yearly Goals',
                            style:
                                Theme.of(context).textTheme.subtitle2!.copyWith(
                              shadows: [
                                Shadow(
                                  color: Theme.of(context)
                                      .shadowColor
                                      .withOpacity(0.13),
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
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
                                  Theme.of(context)
                                          .scaffoldBackgroundColor
                                          .red -
                                      20,
                                  Theme.of(context)
                                          .scaffoldBackgroundColor
                                          .green -
                                      20,
                                  Theme.of(context)
                                          .scaffoldBackgroundColor
                                          .blue -
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
                                width:
                                    (MediaQuery.of(context).size.width - 50) *
                                        progress,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
