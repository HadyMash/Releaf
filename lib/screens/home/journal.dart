import 'dart:math';
import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:releaf/services/auth.dart';
import 'package:releaf/services/database.dart';
import 'package:releaf/shared/assets/home/journal_entry.dart';
import 'package:releaf/shared/assets/home/journal_entry_form.dart';
import 'package:releaf/shared/assets/home/navigation_bar.dart';
import 'package:releaf/shared/models/journal_entry_data.dart';

class Journal extends StatefulWidget {
  final bool animate;
  Journal(this.animate);
  @override
  _JournalState createState() => _JournalState();
}

class _JournalState extends State<Journal> with TickerProviderStateMixin {
  final AuthService _auth = new AuthService();
  late final DatabaseService _database;
  late Future<List<JournalEntryData>> journalEntriesFuture;
  late final AnimationController controller;
  late final CurvedAnimation animation;

  late final AnimationController fabController;
  late final Animation fabColorAnimation;
  late final Animation<double> fabElevationTween;

  final GlobalKey lottieKey = GlobalKey();
  final GlobalKey<NestedScrollViewState> nestedScrollViewKey = GlobalKey();

  ScrollController get innerController {
    return nestedScrollViewKey.currentState!.innerController;
  }

  List<JournalEntryData> entries = [];
  int docLimit = 5;

  bool _initialised = false;
  bool _keyInitialised = false;
  bool _isFetchingDocs = false;
  bool _hasNext = true;

  void _setFetching() => _isFetchingDocs = true;
  void _setNotFetching() => _isFetchingDocs = false;
  int _sortEntries(JournalEntryData firstEntry, JournalEntryData secondEntry) {
    DateTime firstDate = DateTime.parse(firstEntry.date);
    DateTime secondDate = DateTime.parse(secondEntry.date);
    return secondDate.compareTo(firstDate);
  }

  @override
  void initState() {
    super.initState();

    _database = DatabaseService(uid: _auth.getUser()!.uid);

    journalEntriesFuture = _database.getJournalEntries(
      limit: docLimit,
      setFetching: _setFetching,
      setNotFetching: _setNotFetching,
    );
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 320));
    animation = CurvedAnimation(curve: Curves.easeInOut, parent: controller);

    if (widget.animate == true) {
      controller.forward();
    }

    fabController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));

    fabElevationTween = Tween<double>(begin: 6, end: 10)
        .animate(CurvedAnimation(parent: fabController, curve: Curves.linear));
  }

  @override
  void dispose() {
    controller.dispose();
    fabController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_initialised == false) {
      fabColorAnimation = ColorTween(
              begin: Theme.of(context).primaryColor,
              end: Theme.of(context).colorScheme.secondary)
          .animate(
              CurvedAnimation(curve: Curves.linear, parent: fabController));
      _initialised = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<JournalEntryData>>(
      future: journalEntriesFuture,
      initialData: [],
      builder: (context, future) {
        if (future.connectionState == ConnectionState.done ||
            future.connectionState == ConnectionState.active) {
          entries = future.data ?? [];
          // TODO remove sorting if data is already sorted from firebase
          entries.sort(_sortEntries);

          if (!_keyInitialised) {
            _keyInitialised = true;
            WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
              innerController.addListener(() async {
                if (innerController.offset >=
                    innerController.position.maxScrollExtent) {
                  if (_hasNext == true) {
                    if (!_isFetchingDocs) {
                      var newEntries = await _database.getJournalEntries(
                        limit: docLimit,
                        lastDocDate: entries[entries.length - 1].date,
                        setFetching: _setFetching,
                        setNotFetching: _setNotFetching,
                      );

                      if (newEntries.length < docLimit) {
                        _hasNext = false;
                      }
                      setState(() => entries.addAll(newEntries));
                    }
                  }
                }
              });
            });
          }

          return Scaffold(
            extendBody: entries.isEmpty ? false : true,
            body: NestedScrollView(
              key: nestedScrollViewKey,
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return <Widget>[
                  SliverToBoxAdapter(child: SizedBox(height: 20)),
                  SliverAppBar(
                    floating: false,
                    pinned: false,
                    snap: false,
                    title: Text(
                      'Journal',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    automaticallyImplyLeading: false,
                  ),
                ];
              },
              body: entries.isEmpty
                  ? RefreshIndicator(
                      child: Center(
                        child: SingleChildScrollView(
                          clipBehavior: Clip.none,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Lottie.asset(
                              'assets/lottie/empty_list.json',
                              key: lottieKey,
                              frameRate: FrameRate.max,
                            ),
                          ),
                        ),
                      ),
                      onRefresh: () {
                        setState(() {});
                        return journalEntriesFuture =
                            _database.getJournalEntries();
                      },
                    )
                  : RefreshIndicator(
                      child: Scrollbar(
                        child: ListView.builder(
                          padding: EdgeInsets.only(
                              top: 10,
                              bottom:
                                  75 + MediaQuery.of(context).padding.bottom),
                          itemCount: entries.length,
                          itemBuilder: (context, index) => JournalEntry(
                            date: entries[index].date,
                            entryText: entries[index].entryText,
                            feeling: entries[index].feeling,
                          ),
                        ),
                      ),
                      onRefresh: () {
                        setState(() {});
                        return journalEntriesFuture =
                            _database.getJournalEntries();
                      },
                    ),
            ),
            floatingActionButton: Hero(
              tag: 'floatingActionButton',
              child: GestureDetector(
                onTapDown: (_) => fabController.forward(),
                onTapUp: (_) => fabController.reverse(),
                onTapCancel: () => fabController.reverse(),
                child: AnimatedBuilder(
                  animation: fabController,
                  builder: (context, child) {
                    return OpenContainer(
                      transitionDuration: Duration(milliseconds: 500),
                      transitionType: ContainerTransitionType.fade,
                      closedElevation: fabElevationTween.value,
                      closedShape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(56 / 2),
                        ),
                      ),
                      closedColor: fabColorAnimation.value,
                      closedBuilder:
                          (BuildContext context, VoidCallback openContainer) {
                        return SizedBox(
                          height: 56,
                          width: 56,
                          child: Center(
                            child: AnimatedBuilder(
                              animation: animation,
                              builder: (context, child) {
                                return Transform.rotate(
                                  angle:
                                      (pi * 2) - ((pi * animation.value) / 2),
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
                          ),
                        );
                      },
                      openBuilder: (BuildContext context, VoidCallback _) {
                        return JournalEntryForm();
                      },
                    );
                  },
                ),
              ),
            ),
            bottomNavigationBar: ThemedNavigationBar(
                pageIndex: 3, animateFloatingActionButton: false),
          );
        } else {
          return Scaffold(
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return <Widget>[
                  SliverToBoxAdapter(child: SizedBox(height: 20)),
                  SliverAppBar(
                    title: Text(
                      'Journal',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    automaticallyImplyLeading: false,
                  ),
                ];
              },
              body: Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: Hero(
              tag: 'floatingActionButton',
              child: GestureDetector(
                onTapDown: (_) => fabController.forward(),
                onTapUp: (_) => fabController.reverse(),
                onTapCancel: () => fabController.reverse(),
                child: AnimatedBuilder(
                  animation: fabController,
                  builder: (context, child) {
                    return OpenContainer(
                      transitionDuration: Duration(milliseconds: 500),
                      transitionType: ContainerTransitionType.fade,
                      closedElevation: fabElevationTween.value,
                      closedShape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(56 / 2),
                        ),
                      ),
                      closedColor: fabColorAnimation.value,
                      closedBuilder:
                          (BuildContext context, VoidCallback openContainer) {
                        return SizedBox(
                          height: 56,
                          width: 56,
                          child: Center(
                            child: AnimatedBuilder(
                              animation: animation,
                              builder: (context, child) {
                                return Transform.rotate(
                                  angle:
                                      (pi * 2) - ((pi * animation.value) / 2),
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
                          ),
                        );
                      },
                      openBuilder: (BuildContext context, VoidCallback _) {
                        return JournalEntryForm();
                      },
                    );
                  },
                ),
              ),
            ),
            bottomNavigationBar: ThemedNavigationBar(
                pageIndex: 3, animateFloatingActionButton: false),
          );
        }
      },
    );
  }
}
