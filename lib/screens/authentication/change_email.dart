import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:releaf/screens/home/setting_popup.dart';
import 'package:releaf/services/auth.dart';
import 'package:releaf/shared/const/app_theme.dart';
import 'package:releaf/shared/assets/themed_button.dart';
import 'package:releaf/shared/assets/custom_form_field.dart';

class ChangeEmail extends StatefulWidget {
  @override
  _ChangeEmailState createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  final _auth = AuthService();
  final _formKey = new GlobalKey<FormState>();
  FocusNode _emailFocusNode = new FocusNode();
  String _email = '';
  String? _error;

  @override
  void initState() {
    _emailFocusNode.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  void dispose() {
    _formKey.currentState?.dispose();
    _emailFocusNode.dispose();
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
            child: Text('Change Email',
                style: Theme.of(context).textTheme.headline3),
          ),
          SizedBox(height: 30),
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  focusNode: _emailFocusNode,
                  onTap: () => setState(() {}),
                  initialValue: _email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter an email';
                    } else if (EmailValidator.validate(val) == false) {
                      return 'Please enter a valid email address.';
                    }
                  },
                  autocorrect: false,
                  onChanged: (val) {
                    setState(() => _email = val);
                  },
                  decoration: _theme.inputDecoration.copyWith(
                    labelText: 'New Email',
                    labelStyle: TextStyle(
                      color: _emailFocusNode.hasFocus
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                    hintText: 'example@domain.com',
                    focusedBorder: CustomWidgetBorder(
                        color: Theme.of(context).primaryColor, width: 2.2),
                    prefixIcon: Icon(
                      Icons.mail,
                      color: _emailFocusNode.hasFocus
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: _emailFocusNode.hasFocus
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                      ),
                      onPressed: () {},
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
                  label: 'Change Email',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }

                      dynamic result = await _auth.updateEmail(
                          newEmail: _email, context: context);

                      if (result == null) {
                        // TODO send verification email if email isn't verified before popping.
                        AppTheme.mainNavKey.currentState!.pop(context);
                        print('no errors, email changed');
                        // TODO make success animation
                      } else {
                        setState(() => _error = _auth.getError(result));
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
