import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:releaf/shared/const/app_theme.dart';
import 'package:releaf/shared/assets/custom_form_field.dart';

class ChangeEmail extends StatefulWidget {
  @override
  _ChangeEmailState createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  final _formKey = new GlobalKey<FormState>();
  FocusNode _emailFocusNode = new FocusNode();
  String _email = '';

  @override
  Widget build(BuildContext context) {
    final _theme = Provider.of<AppTheme>(context);
    return Center(
      child: Material(
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
                      child: Text('Change Email',
                          style: Theme.of(context).textTheme.headline3),
                    ),
                    SizedBox(height: 20),
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
                              } else if (EmailValidator.validate(val) ==
                                  false) {
                                return 'Please enter a valid email address.';
                              }
                            },
                            autocorrect: false,
                            onChanged: (val) {
                              setState(() => _email = val);
                            },
                            decoration: _theme.inputDecoration.copyWith(
                              labelText: 'Email',
                              labelStyle: TextStyle(
                                color: _emailFocusNode.hasFocus
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey,
                              ),
                              hintText: 'example@domain.com',
                              focusedBorder: CustomWidgetBorder(
                                  color: Theme.of(context).primaryColor,
                                  width: 2.2),
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
    );
  }
}
