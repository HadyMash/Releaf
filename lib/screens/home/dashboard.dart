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
                TaskProgress(),
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

  final GlobalKey lottieKey = GlobalKey(debugLabel: 'lottieKey');

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
                          SvgPicture.asset(
                            'assets/adobe/illustrator/icons/svg/tasks_selected.svg',
                            width: 35,
                            height: 35,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Yearly Goals',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(
                                    color: Theme.of(context).primaryColor),
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

class JournalSummary extends StatefulWidget {
  const JournalSummary({Key? key}) : super(key: key);

  @override
  _JournalSummaryState createState() => _JournalSummaryState();
}

class _JournalSummaryState extends State<JournalSummary> {
  final GlobalKey lottieKey = GlobalKey(debugLabel: 'Lottie Key');

  late Future<List<JournalEntryData>> journalFuture;
  Future? picturesFuture;

  late Color _shadowColor;
  double _blurRadius = 15;

  String _heroTag = '';

  void _animateDown() {
    setState(() {
      _shadowColor = Theme.of(context).shadowColor.withOpacity(0.40);
      _blurRadius = 25;
    });
  }

  void _animateUp() {
    setState(() {
      _shadowColor = Theme.of(context).shadowColor.withOpacity(0.19);
      _blurRadius = 15;
    });
  }

  void Function() _openContainer = () {};

  @override
  void initState() {
    super.initState();
    journalFuture = DatabaseService(uid: AuthService().getUser()!.uid)
        .getJournalEntries(limit: 10);

    journalFuture.then((entries) {
      if (entries.isNotEmpty) {
        setState(() => _heroTag = entries[0].date);

        entries
            .sort((JournalEntryData firstEntry, JournalEntryData secondEntry) {
          DateTime firstDate = DateTime.parse(firstEntry.date);
          DateTime secondDate = DateTime.parse(secondEntry.date);

          int feelingCmp = secondEntry.feeling.compareTo(firstEntry.feeling);

          if (feelingCmp != 0) return feelingCmp;
          return secondDate.compareTo(firstDate);
        });
      }

      picturesFuture = StorageService(AuthService().getUser()!.uid)
          .getPictures(entries[0].date);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _shadowColor = Theme.of(context).shadowColor.withOpacity(0.19);
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: _heroTag,
      child: Material(
        color: Colors.transparent,
        child: FutureBuilder(
          future: journalFuture,
          builder: (context, entryFuture) {
            List<JournalEntryData> entries =
                (entryFuture.data as List<JournalEntryData>?) ?? [];

            // Sort entries based on [feeling] and [date]. This makes the first
            // entry in the list (after sorting) the most recent and happiest entry.
            if (entries.isNotEmpty) {
              entries.sort(
                  (JournalEntryData firstEntry, JournalEntryData secondEntry) {
                DateTime firstDate = DateTime.parse(firstEntry.date);
                DateTime secondDate = DateTime.parse(secondEntry.date);

                int feelingCmp =
                    secondEntry.feeling.compareTo(firstEntry.feeling);

                if (feelingCmp != 0) return feelingCmp;
                return secondDate.compareTo(firstDate);
              });
            }

            if (entryFuture.connectionState == ConnectionState.done) {
              return FutureBuilder(
                future: picturesFuture,
                initialData: [],
                builder: (context, picFuture) {
                  return GestureDetector(
                    onTap: () {
                      _openContainer();
                      AppTheme.homeNavkey.currentState!.pushReplacement(
                        PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 320),
                          pageBuilder: (BuildContext context,
                              Animation<double> animation,
                              Animation<double> secondaryAnimation) {
                            return Journal(false);
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
                      );
                    },
                    onTapDown: (_) => _animateDown(),
                    onTapUp: (_) => _animateUp(),
                    onTapCancel: () => _animateUp(),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 25),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 10),
                      clipBehavior: Clip.hardEdge,
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
                      child: OpenContainer(
                        closedShape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        closedElevation: 0,
                        closedColor: Theme.of(context).backgroundColor,
                        openColor: Theme.of(context).scaffoldBackgroundColor,
                        tappable: false,
                        useRootNavigator: true,
                        closedBuilder: (context, expandEntry) {
                          _openContainer = expandEntry;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/adobe/illustrator/icons/svg/journal_selected.svg',
                                      width: 35,
                                      height: 35,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      entryFuture.data == null
                                          ? 'Journal'
                                          : _formatedDate(entries[0].date),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                    ),
                                    Spacer(),
                                    (entryFuture.data == null)
                                        ? Container()
                                        : Lottie.asset(
                                            'assets/lottie/faces/${(entries[0].feeling == 1 ? 'sad' : (entries[0].feeling == 2 ? 'meh' : 'happy'))}.json',
                                            key: lottieKey,
                                            repeat: false,
                                            width: 50,
                                            height: 50,
                                          ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                (picFuture.connectionState ==
                                        ConnectionState.done)
                                    ? SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                40 -
                                                50,
                                        height: 160,
                                        child: ListView(
                                          scrollDirection: Axis.horizontal,
                                          clipBehavior: Clip.none,
                                          children: _buildPictures((picFuture
                                              .data as List<Uint8List>)),
                                        ),
                                      )
                                    : Center(
                                        child: CircularProgressIndicator()),
                                SizedBox(height: 10),
                                (entryFuture.data == null)
                                    ? Container()
                                    : Text(
                                        entries[0].entryText,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                              ],
                            ),
                          );
                        },
                        openBuilder: (context, _) {
                          return (entryFuture.data != null)
                              ? JournalEntryExpanded(
                                  entries[0].date,
                                  entries[0].entryText,
                                  entries[0].feeling,
                                  picturesFuture)
                              : Scaffold(
                                  appBar: AppBar(
                                    automaticallyImplyLeading: false,
                                    leading: IconButton(
                                      icon: Icon(
                                        Icons.arrow_back_ios_new_rounded,
                                        color:
                                            Theme.of(context).iconTheme.color,
                                        size: Theme.of(context).iconTheme.size,
                                      ),
                                      onPressed: () => AppTheme
                                          .homeNavkey.currentState!
                                          .pop(),
                                    ),
                                  ),
                                );
                        },
                      ),
                    ),
                  );
                },
              );
            } else {
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
                onTapDown: (_) => _animateDown(),
                onTapUp: (_) => _animateUp(),
                onTapCancel: () => _animateUp(),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  clipBehavior: Clip.hardEdge,
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
                  child: OpenContainer(
                    closedShape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    closedElevation: 0,
                    closedColor: Theme.of(context).backgroundColor,
                    openColor: Theme.of(context).scaffoldBackgroundColor,
                    closedBuilder: (context, _) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/adobe/illustrator/icons/svg/journal_selected.svg',
                                  width: 35,
                                  height: 35,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  entryFuture.data == null
                                      ? 'Journal'
                                      : _formatedDate(entries[0].date),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2!
                                      .copyWith(
                                          color:
                                              Theme.of(context).primaryColor),
                                ),
                                Spacer(),
                                (entryFuture.data == null)
                                    ? Container()
                                    : Lottie.asset(
                                        'assets/lottie/faces/${(entries[0].feeling == 1 ? 'sad' : (entries[0].feeling == 2 ? 'meh' : 'happy'))}.json',
                                        key: lottieKey,
                                        repeat: false,
                                        width: 50,
                                        height: 50,
                                      ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Center(child: CircularProgressIndicator()),
                            SizedBox(height: 10),
                            (entryFuture.data == null)
                                ? Container()
                                : Text(
                                    entries[0].entryText,
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                          ],
                        ),
                      );
                    },
                    openBuilder: (context, _) {
                      return (entryFuture.data != null)
                          ? JournalEntryExpanded(
                              entries[0].date,
                              entries[0].entryText,
                              entries[0].feeling,
                              picturesFuture,
                              rootNavigator: true,
                            )
                          : Scaffold(
                              appBar: AppBar(
                                automaticallyImplyLeading: false,
                                leading: IconButton(
                                  icon: Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    color: Theme.of(context).iconTheme.color,
                                    size: Theme.of(context).iconTheme.size,
                                  ),
                                  onPressed: () =>
                                      AppTheme.homeNavkey.currentState!.pop(),
                                ),
                              ),
                            );
                    },
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  List<Widget> _buildPictures(List<Uint8List> pictures) {
    List<Widget> picWidgets = [];
    int index = 0;
    for (var pic in pictures) {
      picWidgets.add(
        Container(
          key: UniqueKey(),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                blurRadius: 6,
                color: Theme.of(context).shadowColor.withOpacity(0.52),
                offset: Offset(0, 3),
              )
            ],
          ),
          clipBehavior: Clip.hardEdge,
          margin: index == 0
              ? EdgeInsets.only(right: 10)
              : EdgeInsets.symmetric(horizontal: 10),
          child: Image.memory(
            pic,
            key: UniqueKey(),
            height: 160,
            fit: BoxFit.cover,
          ),
        ),
      );
      index += 1;
    }
    return picWidgets;
  }

  String _formatedDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    Map<int, String> _monthNumToName = {
      1: 'Jan',
      2: 'Feb',
      3: 'Mar',
      4: 'Apr',
      5: 'May',
      6: 'Jun',
      7: 'Jul',
      8: 'Aug',
      9: 'Sep',
      10: 'Oct',
      11: 'Nov',
      12: 'Dec',
    };

    return '${_monthNumToName[dateTime.month]} ${dateTime.day}, ${dateTime.year}';
  }
}
