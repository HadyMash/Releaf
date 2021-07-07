import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:releaf/screens/authentication/change_email.dart';
import 'package:releaf/screens/authentication/change_password.dart';
import 'package:releaf/screens/home/hidden_fab.dart';
import 'package:releaf/shared/assets/home/navigation_bar.dart';
import 'package:releaf/shared/assets/home/setting_popup.dart';
import 'package:releaf/shared/assets/themed_toggle.dart';
import 'package:releaf/shared/const/app_theme.dart';
import 'package:releaf/shared/assets/themed_button.dart';
import 'package:releaf/services/auth.dart';
import 'package:releaf/shared/const/custom_popup_route.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _auth = new AuthService();
    final _theme = Provider.of<AppTheme>(context);

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
      body: Scrollbar(
        child: CustomScrollView(
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
                            _auth.changeUsername(
                                newName: val, context: context);
                          }
                        },
                        decoration: InputDecoration(
                          fillColor:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.grey[300]
                                  : Colors.grey[800],
                          filled: true,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
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
                        value: _theme.themeMode,
                        items: themes,
                        onChanged: (newTheme) {
                          _theme.setTheme(newTheme!);
                        }),
                  ),
                  Setting(
                    label: 'Haptics',
                    preference: ThemedToggle(
                      onChanged: (state) => _theme.setHaptics(state),
                      defaultState: _theme.haptics,
                      icon: Center(child: Icon(Icons.clear_rounded, size: 24)),
                      enabledIcon:
                          Center(child: Icon(Icons.check_rounded, size: 24)),
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
                    preferencePadding: 10,
                    preference: ThemedFlatButton(
                      label: 'Delete',
                      style: Theme.of(context).textTheme.button!.copyWith(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black
                                  : Colors.white),
                      color: Theme.of(context).errorColor.withOpacity(0.15),
                      pressedColor:
                          Theme.of(context).errorColor.withOpacity(0.4),
                      border: Border.all(
                        color: Theme.of(context).errorColor,
                        width: 2,
                      ),
                      onPressed: () => showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => AlertDialog(
                          title: Text('Confirm Delete'),
                          content: Text(
                              'Are you sure you want to delete your account?'),
                          actions: [
                            TextButton(
                              child: Text('No'),
                              onPressed: () {
                                AppTheme.mainNavKey.currentState!.pop();
                              },
                            ),
                            TextButton(
                              child: Text('Yes'),
                              onPressed: () {
                                AppTheme.mainNavKey.currentState!.pop();
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) => AlertDialog(
                                    title: Text('Are You Absolutely Sure?'),
                                    content: Text(
                                        "This action is PERMANENT. Your account and ALL of it's data will be DELETED. This action CANNOT be undone!"),
                                    actions: [
                                      // TODO disable button one pressed
                                      TextButton(
                                        child: Text('Yes'),
                                        onPressed: () async {
                                          await _auth.deleteUser(context);
                                          AppTheme.mainNavKey.currentState!
                                              .pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text('No'),
                                        onPressed: () {
                                          AppTheme.mainNavKey.currentState!
                                              .pop();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      tapDownFeedback: true,
                      tapFeedback: true,
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
      ),
      floatingActionButton: HiddenFAB(),
      bottomNavigationBar:
          ThemedNavigationBar(pageIndex: 4, animateFloatingActionButton: true),
    );
  }
}

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
  late Color _shadowColor = Colors.black.withOpacity(0.35);
  double _blurRadius = 20.0;
  double _spreadRadius = 0.0;

  void _animateDown() {
    _shadowColor = Theme.of(context).shadowColor.withOpacity(0.45);
    _blurRadius = 25.0;
    _spreadRadius = 5.0;
  }

  void _animateUp() {
    _shadowColor = Theme.of(context).shadowColor.withOpacity(0.35);
    _blurRadius = 20.0;
    _spreadRadius = 0.0;
  }

  @override
  void didChangeDependencies() {
    _shadowColor = Theme.of(context).shadowColor.withOpacity(0.35);
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
                      color: _shadowColor,
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
                        color: _shadowColor,
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
    return SettingPopup(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Name: ${_auth.getUser()!.displayName}'),
          SizedBox(height: 10),
          Text('Email: ${_auth.getUser()!.email}'),
        ],
      ),
    );
  }
}
