import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:releaf/screens/home/setting_popup.dart';
import 'package:releaf/services/auth.dart';
import 'package:releaf/shared/const/app_theme.dart';
import 'package:releaf/shared/assets/themed_button.dart';
import 'package:releaf/shared/assets/custom_form_field.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _auth = AuthService();
  final _formKey = new GlobalKey<FormState>();
  FocusNode _oldPasswordFocusNode = new FocusNode();
  TextEditingController _oldPasswordController = new TextEditingController();
  FocusNode _newPasswordFocusNode = new FocusNode();
  FocusNode _confirmPasswordFocusNode = new FocusNode();
  String _oldPassword = '';
  String _password = '';
  String? _error;

  @override
  void initState() {
    _oldPasswordFocusNode.addListener(() {
      setState(() {});
    });
    _newPasswordFocusNode.addListener(() {
      setState(() {});
    });
    _confirmPasswordFocusNode.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    _oldPasswordFocusNode.dispose();
    _oldPasswordController.dispose();
    _newPasswordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
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
            child: Text('Change Password',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline3),
          ),
          SizedBox(height: 20),
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // * Enter old paassword
                TextFormField(
                  focusNode: _oldPasswordFocusNode,
                  controller: _oldPasswordController,
                  obscureText: true,
                  validator: (val) {
                    // TODO make old password validation show error in old password form field.
                    if (val == null || val.isEmpty) {
                      return 'Please enter a password';
                    } else if (val.length < 8) {
                      return 'Password needs to be at least 8 characters';
                    }
                    // TODO check if it matches old password
                  },
                  autocorrect: false,
                  onChanged: (val) {
                    setState(() => _oldPassword = val);
                  },
                  decoration: _theme.inputDecoration.copyWith(
                    labelText: 'Old Password',
                    labelStyle: TextStyle(
                      color: _oldPasswordFocusNode.hasFocus
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                    focusedBorder: CustomWidgetBorder(
                        color: Theme.of(context).primaryColor, width: 2.2),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: _oldPasswordFocusNode.hasFocus
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: _oldPasswordFocusNode.hasFocus
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                      ),
                      onPressed: () => print('clear'),
                    ),
                  ),
                ),
                // * Enter new password
                SizedBox(height: 20),
                TextFormField(
                  focusNode: _newPasswordFocusNode,
                  obscureText: true,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter a password';
                    } else if (val.length < 8) {
                      return 'Password needs to be at least 8 characters';
                    }
                    // TODO Check it is not equal to the old password
                  },
                  autocorrect: false,
                  onChanged: (val) {
                    setState(() => _password = val);
                  },
                  decoration: _theme.inputDecoration.copyWith(
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      color: _newPasswordFocusNode.hasFocus
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                    focusedBorder: CustomWidgetBorder(
                        color: Theme.of(context).primaryColor, width: 2.2),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: _newPasswordFocusNode.hasFocus
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: _newPasswordFocusNode.hasFocus
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                      ),
                      onPressed: () => print('clear'),
                    ),
                  ),
                ),
                // * Confirm New Password
                SizedBox(height: 20),
                TextFormField(
                  focusNode: _confirmPasswordFocusNode,
                  obscureText: true,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter a password';
                    } else if (val.length < 8) {
                      return 'Password needs to be at least 8 characters';
                    } else if (val != _password) {
                      return 'Passwords do not match';
                    }
                  },
                  autocorrect: false,
                  onChanged: (val) {
                    setState(() {});
                  },
                  decoration: _theme.inputDecoration.copyWith(
                    labelText: 'Confirm Password',
                    labelStyle: TextStyle(
                      color: _confirmPasswordFocusNode.hasFocus
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                    focusedBorder: CustomWidgetBorder(
                        color: Theme.of(context).primaryColor, width: 2.2),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: _confirmPasswordFocusNode.hasFocus
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: _confirmPasswordFocusNode.hasFocus
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                      ),
                      onPressed: () => print('clear'),
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
                  label: 'Change Password',
                  onPressed: () async {},
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
