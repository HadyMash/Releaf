import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:releaf/screens/authentication/change_email.dart';
import 'package:releaf/screens/authentication/change_password.dart';
import 'package:releaf/shared/assets/navigation_bar.dart';
import 'package:releaf/screens/home/setting_popup.dart';
import 'package:releaf/shared/assets/themed_toggle.dart';
import 'package:releaf/shared/const/app_theme.dart';
import 'package:releaf/shared/assets/themed_button.dart';
import 'package:releaf/services/auth.dart';
import 'package:releaf/shared/const/custom_popup_route.dart';

import '../../wrapper.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final CurvedAnimation animation;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 320));
    super.initState();
    animation = CurvedAnimation(curve: Curves.easeInOut, parent: controller);

    super.initState();

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _auth = new AuthService();
    final theme = Provider.of<AppTheme>(context);
    final width = MediaQuery.of(context).size.width;

    // # Name Setting
    final _nameController =
        TextEditingController(text: _auth.getUser()!.displayName);

    // # Theme Setting
    final themes = <DropdownMenuItem<ThemeMode>>[
      DropdownMenuItem<ThemeMode>(
        value: ThemeMode.system,
        child: Row(
          children: [
            Icon(Icons.settings),
            SizedBox(width: 12),
            Text('System'),
          ],
        ),
      ),
      DropdownMenuItem<ThemeMode>(
        value: ThemeMode.light,
        child: Row(
          children: [
            Icon(Icons.lightbulb_rounded),
            SizedBox(width: 12),
            Text('Light'),
          ],
        ),
      ),
      DropdownMenuItem<ThemeMode>(
        value: ThemeMode.dark,
        child: Row(
          children: [
            Icon(Icons.nightlight_round),
            SizedBox(width: 12),
            Text('Dark'),
          ],
        ),
      ),
    ];

    return Scaffold(
      // TODO make body custom scroll view.
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
          SliverAppBar(
            title: Text(
              'Settings',
              style: Theme.of(context).textTheme.headline3,
            ),
            automaticallyImplyLeading: false,
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 15, right: 30, left: 30),
                    child: Text('Account',
                        style: Theme.of(context).textTheme.headline4),
                  ),
                ),
                Setting(
                  label: 'Name',
                  preferencePadding: 10,
                  preference: SizedBox(
                    width: 150,
                    child: TextField(
                      autocorrect: false,
                      controller: _nameController,
                      onSubmitted: (val) {
                        if (val != _auth.getUser()!.displayName) {
                          _auth.changeUsername(newName: val, context: context);
                        }
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.grey[300],
                        filled: true,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
                Setting(
                  label: 'Theme',
                  preference: DropdownButton<ThemeMode>(
                      underline: Container(),
                      value: theme.themeMode,
                      items: themes,
                      onChanged: (newTheme) {
                        theme.setTheme(newTheme!);
                      }),
                ),
                Setting(
                  label: 'Haptics',
                  preference: ThemedToggle(
                    onChanged: (state) => theme.setHaptics(state),
                    defaultState: theme.haptics,
                    icon: Icon(Icons.clear_rounded),
                    enabledIcon: Icon(Icons.check_rounded),
                    tapFeedback: true,
                  ),
                ),
                Setting.clickable(
                  label: 'Info',
                  preference: Icon(
                    Icons.keyboard_arrow_right_rounded,
                    color: Theme.of(context).iconTheme.color,
                    size: 40,
                  ),
                  onPressed: () => AppTheme.mainNavKey.currentState!.push(
                    CustomPopupRoute(builder: (context) => Info()),
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20, right: 30, left: 30),
                    child: Text('Security',
                        style: Theme.of(context).textTheme.headline4),
                  ),
                ),
                Setting.clickable(
                  label: 'Change Email',
                  preference: Icon(
                    Icons.keyboard_arrow_right_rounded,
                    color: Theme.of(context).iconTheme.color,
                    size: 40,
                  ),
                  onPressed: () => AppTheme.mainNavKey.currentState!.push(
                    CustomPopupRoute(builder: (context) => ChangeEmail()),
                  ),
                ),
                Setting.clickable(
                  label: 'Change Password',
                  preference: Icon(
                    Icons.keyboard_arrow_right_rounded,
                    color: Theme.of(context).iconTheme.color,
                    size: 40,
                  ),
                  onPressed: () => AppTheme.mainNavKey.currentState!.push(
                    CustomPopupRoute(builder: (context) => ChangePassword()),
                  ),
                ),
                Setting(
                  label: 'Log Out',
                  preferencePadding: 10,
                  preference: ThemedFlatButton(
                    label: 'Log out',
                    onPressed: () => _auth.logOut(),
                    tapDownFeedback: true,
                    tapFeedback: true,
                  ),
                ),
                Setting(
                  label: 'Delete Account',
                  preference: ElevatedButton(
                    child: Text('test'),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20, right: 30, left: 30),
                    child: Text('Extra',
                        style: Theme.of(context).textTheme.headline4),
                  ),
                ),
                Setting.clickable(
                  label: 'About',
                  preference: Icon(
                    Icons.keyboard_arrow_right_rounded,
                    color: Theme.of(context).iconTheme.color,
                    size: 40,
                  ),
                  onPressed: () => showAboutDialog(
                    context: context,
                    applicationName: 'Releaf',
                    applicationVersion: '0.1 Alpha',
                  ),
                ),
                Setting.clickable(
                  label: 'Contact Us',
                  preference: Icon(
                    Icons.keyboard_arrow_right_rounded,
                    color: Theme.of(context).iconTheme.color,
                    size: 40,
                  ),
                  onPressed: () => showAboutDialog(
                    context: context,
                    applicationName: 'Releaf',
                    applicationVersion: '0.1 Alpha',
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
        ],
      ),
      floatingActionButton: Transform.translate(
        offset: Offset(
            MediaQuery.of(context).size.width / 6 + ((1 / 428) * width), 0),
        child: FloatingActionButton(
          heroTag: 'floatingActionButton',
          backgroundColor: Theme.of(context).primaryColor,
          splashColor: Theme.of(context).accentColor,
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Transform.rotate(
                angle: (pi * animation.value) / 2,
                child: child,
              );
            },
            child: Icon(
              Icons.add_rounded,
              color: Theme.of(context).accentIconTheme.color,
              size: 40,
            ),
          ),
          onPressed: () {},
        ),
      ),
      bottomNavigationBar:
          ThemedNavigationBar(pageIndex: 4, animateFloatingActionButton: true),
    );
  }
}

// TODO make shadow color change on theme change.
class Setting extends StatefulWidget {
  final String label;
  final Widget? preference;
  final double? preferencePadding;
  final VoidCallback? onPressed;
  final String? heroTag;

  Setting({
    required this.label,
    required this.preference,
    this.preferencePadding,
    this.heroTag,
  }) : onPressed = null;

  Setting.clickable({
    required this.label,
    required this.preference,
    this.preferencePadding,
    required this.onPressed,
    this.heroTag,
  });

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  Color? _shadowColor = Colors.black.withOpacity(0.35);
  double _blurRadius = 20.0;
  double _spreadRadius = 0.0;

  void _animateDown() {
    _shadowColor = Theme.of(context).shadowColor.withOpacity(0.5);
    _blurRadius = 30.0;
    _spreadRadius = 5.0;
  }

  void _animateUp() {
    _shadowColor = Theme.of(context).shadowColor.withOpacity(0.35);
    _blurRadius = 20.0;
    _spreadRadius = 0.0;
  }

  @override
  void didChangeDependencies() {
    _animateUp();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return widget.heroTag == null
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            child: GestureDetector(
              onTap: widget.onPressed,
              onTapDown: (details) => widget.onPressed == null
                  ? null
                  : (setState(() => _animateDown())),
              onTapUp: (details) => widget.onPressed == null
                  ? null
                  : (setState(() => _animateUp())),
              onTapCancel: () => widget.onPressed == null
                  ? null
                  : (setState(() => _animateUp())),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: _shadowColor!,
                      blurRadius: _blurRadius,
                      spreadRadius: _spreadRadius,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(widget.label,
                          style: Theme.of(context).textTheme.subtitle2),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          right: widget.preferencePadding ?? 20),
                      child: widget.preference,
                    ),
                  ],
                ),
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            child: GestureDetector(
              onTap: widget.onPressed,
              onTapDown: (details) => widget.onPressed == null
                  ? null
                  : (setState(() => _animateDown())),
              onTapUp: (details) => widget.onPressed == null
                  ? null
                  : (setState(() => _animateUp())),
              onTapCancel: () => widget.onPressed == null
                  ? null
                  : (setState(() => _animateUp())),
              child: Hero(
                tag: widget.heroTag!,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: _shadowColor!,
                        blurRadius: _blurRadius,
                        spreadRadius: _spreadRadius,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(widget.label,
                            style: Theme.of(context).textTheme.subtitle2),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            right: widget.preferencePadding ?? 20),
                        child: widget.preference,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}

class Info extends StatelessWidget {
  final _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    final _theme = Provider.of<AppTheme>(context);
    return SettingPopup(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // TODO Make text better looking.
          Text('Name: ${_auth.getUser()!.displayName}'),
          SizedBox(height: 10),
          Text('Email: ${_auth.getUser()!.email}'),
        ],
      ),
    );
  }
}
