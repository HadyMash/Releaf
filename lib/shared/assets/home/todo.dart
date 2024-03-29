import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:releaf/screens/home/tasks.dart';
import 'package:releaf/services/auth.dart';
import 'package:releaf/services/database.dart';
import 'package:releaf/shared/const/app_theme.dart';
import 'package:releaf/shared/const/custom_popup_route.dart';

// ignore: must_be_immutable
class Todo extends StatefulWidget {
  bool completed;
  String task;
  String docID;
  int year;

  Todo({
    required this.completed,
    required this.task,
    required this.docID,
    required this.year,
  });

  @override
  _TodoState createState() => _TodoState();
}

class _TodoState extends State<Todo> with SingleTickerProviderStateMixin {
  AuthService _auth = AuthService();
  Duration duration = Duration(milliseconds: 220);
  late AnimationController lottieController;
  late SlidableController slidableController;
  // late TextEditingController controller;

  late Color _enabledBackgroundColor;
  late Color _enabledShadowColor;
  double _enabledBlurRadius = 15;
  double _enabledSpreadRadius = 0;

  late Color _pressedShadowColor;
  double _pressedBlurRadius = 20;
  double _pressedSpreadRadius = 2;

  late Color _disabledBackgroundColor;
  late Color _disabledShadowColor;
  double _disabledBlurRadius = 0;
  double _disabledSpreadRadius = 0;

  late Color _color;
  late Color _shadowColor;
  late double _blur;
  late double _spread;

  final GlobalKey lottieKey = GlobalKey();

  bool initalised = false;
  bool lottieControllerInitialised = false;
  bool slid = false;

  @override
  void initState() {
    slidableController = SlidableController(
      onSlideAnimationChanged: (anim) {},
      onSlideIsOpenChanged: (isSlid) {
        slid = isSlid ?? false;
      },
    );

    lottieController = AnimationController(vsync: this);
    if (widget.completed == true) {
      lottieController.value = 1;
    }
    super.initState();
  }

  @override
  void dispose() {
    // controller.dipose();
    lottieController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (initalised == false) {
      _enabledBackgroundColor = Theme.of(context).backgroundColor;
      _enabledShadowColor = Theme.of(context).shadowColor.withOpacity(0.2);
      _pressedShadowColor = Theme.of(context).shadowColor.withOpacity(0.35);
      int alphaDifference = 12;
      int red = Theme.of(context).scaffoldBackgroundColor.red - alphaDifference;
      int green =
          Theme.of(context).scaffoldBackgroundColor.green - alphaDifference;
      int blue =
          Theme.of(context).scaffoldBackgroundColor.blue - alphaDifference;
      if (red < 0) {
        red = 0;
      }
      if (green < 0) {
        green = 0;
      }
      if (blue < 0) {
        blue = 0;
      }
      _disabledBackgroundColor = Color.fromRGBO(red, green, blue, 1);
      _disabledShadowColor = Colors.transparent;

      if (widget.completed == false) {
        _color = _enabledBackgroundColor;
        _shadowColor = _enabledShadowColor;
        _blur = _enabledBlurRadius;
        _spread = _enabledSpreadRadius;
      } else {
        _color = _disabledBackgroundColor;
        _shadowColor = _disabledShadowColor;
        _blur = _disabledBlurRadius;
        _spread = _disabledSpreadRadius;
      }
      initalised = true;
    }
    super.didChangeDependencies();
  }

  bool animating = false;

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<AppTheme>(context);

    void _tapDown() {
      if (!slid) {
        if (theme.haptics == true) {
          HapticFeedback.lightImpact();
        }
        _shadowColor = _pressedShadowColor;
        _blur = _pressedBlurRadius;
        _spread = _pressedSpreadRadius;
      }
    }

    void _tapUp() {
      if (widget.completed == false) {
        _shadowColor = _enabledShadowColor;
        _blur = _enabledBlurRadius;
        _spread = _enabledSpreadRadius;
      } else {
        _shadowColor = _disabledShadowColor;
        _blur = _disabledBlurRadius;
        _spread = _disabledSpreadRadius;
      }
      Future.delayed(duration).then((value) {
        setState(() => animating = false);
      });
    }

    void _toggle() {
      if (!slid) {
        if (widget.completed == false) {
          if (theme.haptics == true) {
            HapticFeedback.heavyImpact();
          }
          DatabaseService(uid: _auth.getUser()!.uid)
              .completeTodo(widget.year, widget.docID);
        } else {
          if (theme.haptics == true) {
            HapticFeedback.mediumImpact();
          }
          DatabaseService(uid: _auth.getUser()!.uid)
              .uncompleteTodo(widget.year, widget.docID);
        }
      }
    }

    if (animating == false) {
      if (widget.completed == false) {
        if (lottieControllerInitialised == true) {
          lottieController.reverse();
        }
        _color = _enabledBackgroundColor;
        _shadowColor = _enabledShadowColor;
        _blur = _enabledBlurRadius;
        _spread = _enabledSpreadRadius;
      } else {
        if (lottieControllerInitialised == true) {
          lottieController.forward();
        }
        _color = _disabledBackgroundColor;
        _shadowColor = _disabledShadowColor;
        _blur = _disabledBlurRadius;
        _spread = _disabledSpreadRadius;
      }
    }

    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: _toggle,
        onTapDown: (_) {
          animating = true;
          setState(() => _tapDown());
        },
        // onLongPress: () =>
        //     AppTheme.mainNavKey.currentState!.push(CustomPopupRoute(
        //         builder: (context) => AddTodo(
        //               widget.year,
        //               task: widget.task,
        //               docID: widget.docID,
        //               edit: true,
        //             ))),
        onTapUp: (_) {
          animating = true;
          setState(() => _tapUp());
        },
        onTapCancel: () {
          animating = true;
          setState(() => _tapUp());
        },
        child: AnimatedContainer(
          duration: duration,
          margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          decoration: BoxDecoration(
            color: _color,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: _shadowColor,
                blurRadius: _blur,
                spreadRadius: _spread,
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Slidable(
              key: UniqueKey(),
              dismissal: SlidableDismissal(
                child: SlidableDrawerDismissal(),
                onDismissed: (_) {
                  DatabaseService(uid: _auth.getUser()!.uid)
                      .deleteTodo(year: widget.year, docID: widget.docID);
                },
              ),
              controller: slidableController,
              actionPane: SlidableDrawerActionPane(),
              secondaryActions: [
                ClipRRect(
                  // borderRadius: BorderRadius.only(
                  //   topLeft: Radius.circular(15),
                  //   bottomLeft: Radius.circular(15),
                  // ),
                  child: IconSlideAction(
                    icon: Icons.edit_rounded,
                    caption: 'Edit',
                    color: Theme.of(context).primaryColor,
                    foregroundColor: Theme.of(context)
                        .floatingActionButtonTheme
                        .foregroundColor,
                    onTap: () =>
                        AppTheme.mainNavKey.currentState!.push(CustomPopupRoute(
                            builder: (context) => AddTodo(
                                  widget.year,
                                  task: widget.task,
                                  docID: widget.docID,
                                  edit: true,
                                ))),
                  ),
                ),
                IconSlideAction(
                  icon: Icons.delete_rounded,
                  caption: 'Delete',
                  color: Theme.of(context).errorColor,
                  foregroundColor: Theme.of(context)
                      .floatingActionButtonTheme
                      .foregroundColor,
                  onTap: () {
                    DatabaseService(uid: _auth.getUser()!.uid)
                        .deleteTodo(year: widget.year, docID: widget.docID);
                  },
                ),
              ],
              actionExtentRatio: 1 / 5,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Spacer(),
                  Flexible(
                    flex: 4,
                    child: Center(
                      child: Lottie.asset(
                        'assets/lottie/check.json',
                        controller: lottieController,
                        key: lottieKey,
                        frameRate: FrameRate.max,
                        onLoaded: (composition) {
                          lottieController.duration = composition.duration;
                          lottieControllerInitialised = true;
                        },
                      ),
                    ),
                  ),
                  Spacer(),
                  Flexible(
                    flex: 24,
                    child: Padding(
                      padding: EdgeInsets.only(top: 25, bottom: 25, right: 10),
                      child: Text(
                        widget.task,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      // child: TextFormField(
                      //   scrollPadding: EdgeInsets.zero,
                      //   controller: controller,
                      //   onFieldSubmitted: (val) {
                      //     DatabaseService(uid: _auth.getUser()!.uid).editTodo(
                      //         task: val, year: widget.year, docID: widget.docID);
                      //   },
                      //   style: Theme.of(context).textTheme.headline5,
                      //   decoration: InputDecoration(
                      //     contentPadding: EdgeInsets.zero,
                      //     border: InputBorder.none,
                      //   ),
                      // ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// class Check extends StatefulWidget {
//   bool completed;
//   Function()? forward;
//   Function()? reverse;

//   Check(this.completed, {Key? key}) : super(key: key);

//   @override
//   _CheckState createState() => _CheckState();
// }

// class _CheckState extends State<Check> with SingleTickerProviderStateMixin {
//   late final AnimationController controller;

//   @override
//   void initState() {
//     controller = AnimationController(vsync: this);
//     widget.forward = () {
//       controller.reverse();
//     };
//     widget.reverse = () {
//       controller.forward();
//     };

//     if (widget.completed == true) {
//       controller.value = 1;
//     }

//     super.initState();
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Lottie.asset(
//       'assets/lottie/check.json',
//       controller: controller,
//       onLoaded: (composition) {
//         controller.duration = composition.duration;
//         if (widget.completed == true) {
//           controller.forward();
//         } else {
//           controller.reverse();
//         }
//       },
//     );
//   }
// }
