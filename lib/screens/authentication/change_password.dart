import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:releaf/shared/assets/home/setting_popup.dart';
import 'package:releaf/services/auth.dart';
import 'package:releaf/shared/const/app_theme.dart';
import 'package:releaf/shared/assets/themed_button.dart';
import 'package:releaf/shared/assets/custom_widget_border.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _auth = AuthService();
  final _formKey = new GlobalKey<FormState>();
  FocusNode _oldPasswordFocusNode = new FocusNode();
  TextEditingController _oldPasswordController = TextEditingController();
  FocusNode _newPasswordFocusNode = new FocusNode();
  TextEditingController _newPasswordController = TextEditingController();
  FocusNode _confirmPasswordFocusNode = new FocusNode();
  TextEditingController _confirmPasswordController = TextEditingController();
  String _oldPassword = '';
  String? _oldPasswordError;
  String _newPassword = '';
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
    _newPasswordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
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
                    if (val == null || val.isEmpty) {
                      return 'Please enter a password';
                    } else if (val.length < 8) {
                      return 'Password needs to be at least 8 characters';
                    }
                  },
                  autocorrect: false,
                  onChanged: (val) {
                    setState(() => _oldPassword = val);
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(10, 15, 8, 20),
                    labelText: 'Old Password',
                    labelStyle: TextStyle(
                      color:
                          (_oldPasswordError == null || _oldPasswordError == '')
                              ? (_oldPasswordFocusNode.hasFocus
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey)
                              : Theme.of(context).errorColor,
                    ),
                    border: CustomWidgetBorder(color: Colors.grey, width: 1.2),
                    enabledBorder: CustomWidgetBorder(
                        color:
                            _oldPasswordError == null || _oldPasswordError == ''
                                ? Colors.grey
                                : Theme.of(context).errorColor,
                        width: 1.2),
                    errorBorder:
                        CustomWidgetBorder(color: Colors.red[300], width: 1.5),
                    focusedErrorBorder:
                        CustomWidgetBorder(color: Colors.red[300], width: 2.4),
                    errorStyle: TextStyle(fontSize: 14),
                    focusedBorder: CustomWidgetBorder(
                        color:
                            _oldPasswordError == null || _oldPasswordError == ''
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).errorColor,
                        width: 2.2),
                    prefixIcon: Icon(
                      Icons.lock,
                      color:
                          _oldPasswordError == null || _oldPasswordError == ''
                              ? (_oldPasswordFocusNode.hasFocus
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey)
                              : Theme.of(context).errorColor,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.clear,
                        color:
                            _oldPasswordError == null || _oldPasswordError == ''
                                ? (_oldPasswordFocusNode.hasFocus
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey)
                                : Theme.of(context).errorColor,
                      ),
                      onPressed: () {
                        _oldPasswordController.clear();
                        _oldPassword = '';
                      },
                    ),
                    errorText: _oldPasswordError,
                  ),
                ),
                // * Enter new password
                SizedBox(height: 20),
                TextFormField(
                  focusNode: _newPasswordFocusNode,
                  controller: _newPasswordController,
                  obscureText: true,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter a password';
                    } else if (val.length < 8) {
                      return 'Password needs to be at least 8 characters';
                    }
                  },
                  autocorrect: false,
                  onChanged: (val) {
                    setState(() => _newPassword = val);
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
                      onPressed: () {
                        _newPasswordController.clear();
                        _newPassword = '';
                      },
                    ),
                  ),
                ),
                // * Confirm New Password
                SizedBox(height: 20),
                TextFormField(
                  focusNode: _confirmPasswordFocusNode,
                  controller: _confirmPasswordController,
                  obscureText: true,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter a password';
                    } else if (val.length < 8) {
                      return 'Password needs to be at least 8 characters';
                    } else if (val != _newPassword) {
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
                      onPressed: () {
                        _confirmPasswordController.clear();
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
                  label: 'Change Password',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      dynamic oldPassResult =
                          await _auth.verifyCurrentPassword(_oldPassword);
                      if (oldPassResult != true) {
                        setState(() {
                          if (oldPassResult == 'Incorrect Email or Password') {
                            _oldPasswordError = 'Incorrect Password';
                          } else {
                            _oldPasswordError = oldPassResult;
                          }
                        });
                      } else if (oldPassResult == true) {
                        setState(() => _oldPasswordError = null);
                        dynamic newPassResult = await _auth.updatePassword(
                          context,
                          oldPassword: _oldPassword,
                          newPassword: _newPassword,
                        );
                        if (newPassResult == true) {
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                          AppTheme.mainNavKey.currentState!.pop(context);
                        }
                      }
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
