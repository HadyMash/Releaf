import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class BlurredAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  /// An `AppBar()` which has a blur effect behind it which fades in to hide it
  /// until content appears behind it. This has a similar effect to the iOS 14
  /// App Library app bar. It also has the possibility of having a fade effect to
  /// redude the opacity of widgets behind the `BlurredAppBar()` using a `LinearGradient()`.
  const BlurredAppBar({required this.title, this.actions, Key? key})
      : super(key: key);

  /// The height of the `AppBar()`
  final double height = 56;

  /// Returns a `List<Widget>` of `BackdropFilter()`s which have decreasing blur values.
  /// This will create the illusion of a gradient blur effect as if a `ShaderMask()` was used.
  List<Widget> _makeBlurGradient(double height, MediaQueryData mediaQuery) {
    List<Widget> widgets = [];
    double length = height + mediaQuery.padding.top;

    for (int i = 1; i <= (length / 3); i++) {
      widgets.add(
        ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: max(((length / 3) - i.toDouble()) / 3, 0),
              sigmaY: min(5, max(((length / 3) - i.toDouble()) / 3, 0)),
            ),
            child: SizedBox(
              height: 3,
              width: mediaQuery.size.width,
            ),
          ),
        ),
      );
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return Stack(
      children: [
        // BackdropFilters
        SizedBox(
          height: height + mediaQuery.padding.top,
          child: Column(
            children: _makeBlurGradient(height, mediaQuery),
          ),
        ),
        // Fade effect.
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.5, 1],
              colors: [
                Colors.white.withOpacity(0.6),
                Colors.white.withOpacity(0),
              ],
            ),
          ),
        ),

        // AppBar
        AppBar(
          title: Text(
            title,
            style: Theme.of(context).textTheme.headline3,
          ),
          automaticallyImplyLeading: false,
          actions: actions,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
