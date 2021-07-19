import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:releaf/services/auth.dart';
import 'package:releaf/services/database.dart';
import 'package:releaf/shared/assets/custom_widget_border.dart';
import 'package:releaf/shared/assets/home/navigation_bar.dart';
import 'package:releaf/shared/assets/home/setting_popup.dart';
import 'package:releaf/shared/assets/home/todo.dart';
import 'package:releaf/shared/assets/themed_button.dart';
import 'package:releaf/shared/const/app_theme.dart';
import 'package:releaf/shared/const/custom_popup_route.dart';
import 'package:releaf/shared/models/todo_data.dart';

class Tasks extends StatefulWidget {
  final bool animate;
  Tasks(this.animate);
  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> with SingleTickerProviderStateMixin {
  final AuthService _auth = AuthService();
  late final DatabaseService database;
  late Future<List> yearsFuture;

  late final AnimationController controller;
  late final CurvedAnimation animation;

  final FixedExtentScrollController yearPickerScrollController =
      FixedExtentScrollController(initialItem: DateTime.now().year - 2000);

  final GlobalKey lottieKey = GlobalKey();

  @override
  void initState() {
    database = DatabaseService(uid: _auth.getUser()!.uid);
    yearsFuture = database.getTaskYears();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 320));
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

  Future makeNewYear(int year) async {
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
              if ((years ?? [])[(years ?? []).length - 1] <
                  DateTime.now().year) {
                makeNewYear(DateTime.now().year);
              } else {
                selectedYear =
                    findClosestYear(years ?? [], DateTime.now().year);
              }
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

            return Scaffold(
              extendBody:
                  ((snapshot.data ?? []) as List).isEmpty ? false : true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              body: NestedScrollView(
                  physics: NeverScrollableScrollPhysics(),
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
                                      items: (years ?? [])
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
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
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
                                                      child: Text(e.toString(),
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyText1)))
                                                  .toList(),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 1,
                                            child: ThemedButton(
                                              label: 'Add Year',
                                              notAllCaps: true,
                                              onPressed: () async {
                                                await database.addTaskYear(
                                                    (addedYear ??
                                                            (DateTime.now()
                                                                    .year -
                                                                2000)) +
                                                        2000);
                                                yearsFuture =
                                                    database.getTaskYears();
                                                setState(() =>
                                                    selectedYear = addedYear!);
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
                                          'Are you sure you want to delete your $selectedYear goals?'),
                                      actions: [
                                        TextButton(
                                          child: Text('No'),
                                          onPressed: () {
                                            AppTheme.mainNavKey.currentState!
                                                .pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text('Yes'),
                                          onPressed: () async {
                                            List years =
                                                await database.getTaskYears();
                                            if (years.length > 1) {
                                              await database
                                                  .deleteTaskYear(selectedYear);
                                            } else {
                                              await database
                                                  .deleteTaskYear(selectedYear);
                                              await database.addTaskYear(
                                                  DateTime.now().year);
                                              yearsFuture =
                                                  database.getTaskYears();
                                            }
                                            setState(() {});
                                            AppTheme.mainNavKey.currentState!
                                                .pop();
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
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: Stack(
                            children: [
                              Container(
                                height: 30,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(200),
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
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: AnimatedContainer(
                                    curve: Curves.easeInOut,
                                    duration: Duration(milliseconds: 800),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(200),
                                      gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Theme.of(context).primaryColor,
                                          Theme.of(context)
                                              .colorScheme
                                              .secondary,
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
                                    width: (MediaQuery.of(context).size.width -
                                            50) *
                                        progress,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Text(
                                      ((snapshot.data ?? []) as List).isEmpty
                                          ? ''
                                          : (progress.isNaN
                                              ? ''
                                              : '${(progress * 100).round()}%'),
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ];
                  },
                  body: (future.connectionState == ConnectionState.done)
                      ? ((snapshot.connectionState == ConnectionState.done ||
                              snapshot.connectionState ==
                                  ConnectionState.active)
                          ? (((snapshot.data ?? []) as List).isEmpty
                              ? Center(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    child: Lottie.asset(
                                      'assets/lottie/empty_list.json',
                                      key: lottieKey,
                                      frameRate: FrameRate.max,
                                      repeat: true,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  padding: EdgeInsets.only(
                                    top: 10,
                                    bottom: 70 +
                                        MediaQuery.of(context).padding.bottom,
                                  ),
                                  itemCount: (snapshot.data as List).length,
                                  itemBuilder: (context, index) {
                                    return Todo(
                                      completed: ((snapshot.data as List)[index]
                                              as TodoData)
                                          .completed,
                                      task: ((snapshot.data as List)[index]
                                              as TodoData)
                                          .task,
                                      docID: ((snapshot.data as List)[index]
                                              as TodoData)
                                          .docID,
                                      year: selectedYear,
                                    );
                                  },
                                ))
                          : Center(child: CircularProgressIndicator()))
                      : Center(child: CircularProgressIndicator())),
              floatingActionButton: FloatingActionButton(
                heroTag: 'floatingActionButton',
                backgroundColor: Theme.of(context).primaryColor,
                splashColor: Theme.of(context).colorScheme.secondary,
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
                    color: Theme.of(context)
                        .floatingActionButtonTheme
                        .foregroundColor,
                    size: 40,
                  ),
                ),
                onPressed: () => AppTheme.mainNavKey.currentState!.push(
                  CustomPopupRoute(
                      builder: (context) => AddTodo(
                            selectedYear,
                            edit: false,
                          )),
                ),
              ),
              bottomNavigationBar: ThemedNavigationBar(
                  pageIndex: 1, animateFloatingActionButton: false),
            );
          },
        );
      },
    );
  }
}

class AddTodo extends StatefulWidget {
  final int year;
  final String? task;
  final String? docID;
  final bool edit;
  const AddTodo(this.year,
      {Key? key, this.task, this.docID, required this.edit})
      : super(key: key);

  @override
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  AuthService _auth = AuthService();

  final formkey = new GlobalKey<FormState>();
  FocusNode focusNode = new FocusNode();
  late TextEditingController controller;
  String? _error;

  @override
  void initState() {
    controller = TextEditingController(text: widget.edit ? widget.task : '');
    focusNode.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  void dispose() {
    formkey.currentState?.dispose();
    focusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Provider.of<AppTheme>(context);
    return SettingPopup(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child:
                Text('Add Todo', style: Theme.of(context).textTheme.headline3),
          ),
          SizedBox(height: 30),
          Form(
            key: formkey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  focusNode: focusNode,
                  controller: controller,
                  onTap: () => setState(() {}),
                  decoration: _theme.inputDecoration.copyWith(
                    labelText: 'New Todo',
                    labelStyle: TextStyle(
                      color: focusNode.hasFocus
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                    focusedBorder: CustomWidgetBorder(
                        color: Theme.of(context).primaryColor, width: 2.2),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: focusNode.hasFocus
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                      ),
                      onPressed: () {
                        controller.clear();
                      },
                    ),
                  ),
                ),
                SizedBox(height: (_error == null || _error == '') ? 30 : 0),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: (_error == null || _error == '') ? 0 : 13,
                  ),
                  child: Text('$_error',
                      style: TextStyle(
                        fontSize: (_error == null || _error == '') ? 0 : 14,
                        color: Colors.red[800],
                      ),
                      textAlign: TextAlign.center),
                ),
                ThemedButton(
                  label: 'Add Todo',
                  notAllCaps: true,
                  onPressed: () async {
                    if (widget.edit == false) {
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }

                      dynamic result =
                          await DatabaseService(uid: _auth.getUser()!.uid)
                              .addTodo(
                        task: controller.text,
                        index: 0,
                        year: widget.year,
                      );

                      if (result == null) {
                        AppTheme.mainNavKey.currentState!.pop(context);
                      } else {
                        setState(() => _error = result);
                      }
                    } else {
                      dynamic result =
                          await DatabaseService(uid: _auth.getUser()!.uid)
                              .editTodo(
                        task: controller.text,
                        year: widget.year,
                        docID: widget.docID!,
                      );
                      if (result == null) {
                        AppTheme.mainNavKey.currentState!.pop(context);
                      } else {
                        setState(() => _error = result);
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

int findClosestYear(List years, int target) {
  int length = years.length;

  if (years.isEmpty) {
    return DateTime.now().year;
  }
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
