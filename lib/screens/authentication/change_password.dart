import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:releaf/services/auth.dart';
import 'package:releaf/shared/const/app_theme.dart';
import 'package:releaf/shared/assets/custom_form_field.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _auth = AuthService();
  final _formKey = new GlobalKey<FormState>();
  FocusNode _oldPasswordFocusNode = new FocusNode();
  FocusNode _newPasswordFocusNode = new FocusNode();
  FocusNode _confirmPasswordFocusNode = new FocusNode();
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
    _newPasswordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Provider.of<AppTheme>(context);
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0),
        body: Center(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: BackdropFilter(
              filter: ColorFilter.mode(
                  Colors.black.withOpacity(0.55), BlendMode.darken),
              child: GestureDetector(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.8),
                        blurRadius: 20,
                      ),
                    ],
                  ),
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
                              initialValue: _password,
                              obscureText: true,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Please enter a password';
                                } else if (val.length < 8) {
                                  return 'Password needs to be at least 8 characters';
                                }
                                // TODO check if it matches old password
                              },
                              autocorrect: false,
                              decoration: _theme.inputDecoration.copyWith(
                                labelText: 'Old Password',
                                labelStyle: TextStyle(
                                  color: _oldPasswordFocusNode.hasFocus
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey,
                                ),
                                focusedBorder: CustomWidgetBorder(
                                    color: Theme.of(context).primaryColor,
                                    width: 2.2),
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
                              initialValue: _password,
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
                                    color: Theme.of(context).primaryColor,
                                    width: 2.2),
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
                                    color: Theme.of(context).primaryColor,
                                    width: 2.2),
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
                            SizedBox(
                                height:
                                    (_error == null || _error == '') ? 30 : 0),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical:
                                    (_error == null || _error == '') ? 0 : 13,
                              ),
                              child: Text('$_error',
                                  style: TextStyle(
                                    fontSize: (_error == null || _error == '')
                                        ? 0
                                        : 14,
                                    color: Colors.red[800],
                                  ),
                                  textAlign: TextAlign.center),
                            ),
                            ThemedButton(
                              label: 'Change Password',
                              onPressed: () {},
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
