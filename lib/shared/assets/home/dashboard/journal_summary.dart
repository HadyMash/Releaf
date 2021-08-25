import 'dart:typed_data';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:releaf/screens/home/journal.dart';
import 'package:releaf/screens/home/tasks.dart';
import 'package:releaf/services/auth.dart';
import 'package:releaf/services/database.dart';
import 'package:releaf/services/storage.dart';
import 'package:releaf/shared/assets/home/journal_entry.dart';
import 'package:releaf/shared/const/app_theme.dart';
import 'package:releaf/shared/models/journal_entry_data.dart';

class JournalSummary extends StatefulWidget {
  const JournalSummary({Key? key}) : super(key: key);

  @override
  _JournalSummaryState createState() => _JournalSummaryState();
}

class _JournalSummaryState extends State<JournalSummary> {
  final GlobalKey lottieKey = GlobalKey(debugLabel: 'Lottie Key');

  late Future<List<JournalEntryDataNoPictures>> journalFuture;
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
        .getJournalEntriesWithNoPictures(limit: 10);

    journalFuture.then((entries) {
      if (entries.isNotEmpty) {
        setState(() => _heroTag = entries[0].date);

        entries.sort((JournalEntryDataNoPictures firstEntry,
            JournalEntryDataNoPictures secondEntry) {
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
            List<JournalEntryDataNoPictures> entries =
                (entryFuture.data as List<JournalEntryDataNoPictures>?) ?? [];

            // Sort entries based on [feeling] and [date]. This makes the first
            // entry in the list (after sorting) the most recent and happiest entry.
            if (entries.isNotEmpty) {
              entries.sort((JournalEntryDataNoPictures firstEntry,
                  JournalEntryDataNoPictures secondEntry) {
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
                                    Container(
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(context)
                                                .shadowColor
                                                .withOpacity(0.25),
                                            blurRadius: 6,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/adobe/illustrator/icons/svg/journal_selected.svg',
                                        width: 35,
                                        height: 35,
                                      ),
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
                                    (entryFuture.data == null)
                                        ? Container()
                                        : Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
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
                                            child: Lottie.asset(
                                              'assets/lottie/faces/${(entries[0].feeling == 1 ? 'sad' : (entries[0].feeling == 2 ? 'meh' : 'happy'))}.json',
                                              key: lottieKey,
                                              repeat: false,
                                              width: 50,
                                              height: 50,
                                            ),
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
                              ? JournalEntryExpandedNoPictures(
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
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                    'assets/adobe/illustrator/icons/svg/journal_unselected.svg',
                                    width: 35,
                                    height: 35,
                                  ),
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
                          ? JournalEntryExpandedNoPictures(
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
