import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiver/time.dart' as quiverTime;
import 'package:releaf/shared/const/app_theme.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  /// Light Theme Week Day Text Style
  final TextStyle lightDayTextStyle = TextStyle(
    fontSize: 16,
    color: Colors.grey[850],
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w300,
  );

  /// Dark Theme Week Day Text Style
  final TextStyle darkDayTextStyle = TextStyle(
    fontSize: 16,
    color: Colors.grey[300],
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w300,
  );

  /// List of the Week Days (e.g. 'S', 'M'...)
  List<String> days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  /// Returns a `List` of `Row`s which contain the days of the current month.
  List<Widget> layOutMonthDays(List<int> activeDays) {
    final DateTime dateTime = DateTime.now();
    final int daysInMonth =
        quiverTime.daysInMonth(dateTime.year, dateTime.month);
    final MainAxisAlignment mainAxisAlignment = MainAxisAlignment.spaceAround;
    final Widget space =
        const Opacity(opacity: 0, child: Day(number: 0, active: false));
    final Map<int, int> weekDayNumbers = {
      1: 1,
      2: 2,
      3: 3,
      4: 4,
      5: 5,
      6: 6,
      7: 0,
    };
    List<int> days = [...activeDays];
    if (days.isNotEmpty) {
      days.removeAt(0);
    }

    List<List<Widget>> listOfDays = [];
    int numOfRows = 0;

    // Get number of blank spaces before the first day.
    int numOfSpacesBefore =
        weekDayNumbers[DateTime(dateTime.year, dateTime.month, 1).weekday]!;
    listOfDays.add([]);
    numOfRows += 1;

    // Add the spaces to the first row
    for (int i = 0; i < numOfSpacesBefore; i++) {
      listOfDays[0].add(space);
    }

    // total duration (in milliseconds) between the first animation starting and the last.
    final double activeAnimatonDuration = 1000;
    // delay multiple
    final double delayMultiple = activeAnimatonDuration / days.length;
    // number of active days done so far
    int activeDaysBuilt = 0;

    // Add the day numbers
    for (int i = 1; i <= daysInMonth; i++) {
      // Check and create a new row if the current row has the max number of days (7)
      if (listOfDays[numOfRows - 1].length == 7) {
        listOfDays.add([]);
        numOfRows += 1;
      }

      bool active =
          (days.contains(i) || i == DateTime.now().day) && i <= dateTime.day;
      if (active) {
        activeDaysBuilt += 1;
      }

      // Add a day to the newest row
      listOfDays[numOfRows - 1].add(Day(
        number: i,
        active: active,
        delay: active
            ? Duration(milliseconds: (activeDaysBuilt * delayMultiple).round())
            : null,
      ));
    }

    var lastRow = listOfDays[listOfDays.length - 1];
    int numOfSpacesAfter = 7 - lastRow.length;

    for (int i = 0; i < numOfSpacesAfter; i++) {
      listOfDays[numOfRows - 1].add(space);
    }

    List<Widget> rows = [];

    listOfDays.forEach((row) {
      rows.addAll([
        Row(
          mainAxisAlignment: mainAxisAlignment,
          children: row,
        ),
        SizedBox(height: 10),
      ]);
    });

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<AppTheme>(context);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // * Header
          Text(
            'Activity',
            style: Theme.of(context).textTheme.subtitle2!.copyWith(
              shadows: [
                Shadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.13),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          // * Week Days
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                days[0],
                style: Theme.of(context).brightness == Brightness.light
                    ? lightDayTextStyle
                    : darkDayTextStyle,
              ),
              Text(
                days[1],
                style: Theme.of(context).brightness == Brightness.light
                    ? lightDayTextStyle
                    : darkDayTextStyle,
              ),
              Text(
                days[2],
                style: Theme.of(context).brightness == Brightness.light
                    ? lightDayTextStyle
                    : darkDayTextStyle,
              ),
              Text(
                days[3],
                style: Theme.of(context).brightness == Brightness.light
                    ? lightDayTextStyle
                    : darkDayTextStyle,
              ),
              Text(
                days[4],
                style: Theme.of(context).brightness == Brightness.light
                    ? lightDayTextStyle
                    : darkDayTextStyle,
              ),
              Text(
                days[5],
                style: Theme.of(context).brightness == Brightness.light
                    ? lightDayTextStyle
                    : darkDayTextStyle,
              ),
              Text(
                days[6],
                style: Theme.of(context).brightness == Brightness.light
                    ? lightDayTextStyle
                    : darkDayTextStyle,
              ),
            ],
          ),
          SizedBox(height: 5),
          // * Day Numbers
          // ...layOutMonthDays(theme.activeDays)
          ...layOutMonthDays([4, 7, 8, 14, 17, 16, 18, 20, 21, 22])
        ],
      ),
    );
  }
}

class Day extends StatefulWidget {
  final int number;
  final bool active;
  final Duration? delay;
  const Day({required this.number, required this.active, this.delay, Key? key})
      : super(key: key);

  @override
  _DayState createState() => _DayState();
}

class _DayState extends State<Day> with SingleTickerProviderStateMixin {
  late final double size;
  bool _initialised = false;

  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    bool widgetIsActive =
        widget.active == true || widget.number == DateTime.now().day;

    if (widgetIsActive) {
      controller = AnimationController(
          vsync: this, duration: const Duration(milliseconds: 1500));
    } else {
      controller = AnimationController(
          vsync: this, duration: const Duration(milliseconds: 0));
    }

    animation = CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    if (widgetIsActive) {
      Future.delayed(widget.delay ?? const Duration(milliseconds: 0)).then((_) {
        controller.forward();
      });
    } else {
      controller.forward();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialised) {
      _initialised = true;
      size = (35 * MediaQuery.of(context).size.width) / 428;
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = widget.number == DateTime.now().day
        ? Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white)
        : (widget.active
            ? Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Colors.white)
            : Theme.of(context).textTheme.bodyText1!);

    return ScaleTransition(
      scale: animation,
      child: Stack(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: widget.number == DateTime.now().day
                    ? Theme.of(context).errorColor
                    : (widget.active ? Theme.of(context).primaryColor : null),
                boxShadow: widget.number == DateTime.now().day
                    ? [
                        BoxShadow(
                          color: Theme.of(context).shadowColor.withOpacity(0.4),
                          offset: Offset(0, 3),
                          blurRadius: 5,
                          spreadRadius: 0,
                        )
                      ]
                    : (widget.active
                        ? [
                            BoxShadow(
                              color: Theme.of(context)
                                  .shadowColor
                                  .withOpacity(0.4),
                              offset: Offset(0, 3),
                              blurRadius: 5,
                              spreadRadius: 0,
                            )
                          ]
                        : [])),
          ),
          SizedBox(
            height: size,
            width: size,
            child:
                Center(child: Text(widget.number.toString(), style: textStyle)),
          ),
        ],
      ),
    );
  }
}
