import 'package:flutter/material.dart';

class CustomPopupRoute extends PopupRoute {
  CustomPopupRoute({
    required this.builder,
    this.dismissible = true,
    this.label,
    this.color,
    RouteSettings? setting,
  }) : super(settings: setting);

  final WidgetBuilder builder;
  final bool dismissible;
  final String? label;
  final Color? color;

  @override
  Color? get barrierColor => color;

  @override
  bool get barrierDismissible => dismissible;

  @override
  String? get barrierLabel => label;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return builder(context);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return Transform(
      transform: Matrix4.diagonal3Values(1,
          CurvedAnimation(curve: Curves.easeInOut, parent: animation).value, 1),
      alignment: FractionalOffset.center,
      child: child,
    );
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}
