import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:releaf/services/auth.dart';
import 'package:releaf/shared/assets/custom_form_field.dart';
import 'package:releaf/screens/authentication/register.dart';
import 'package:releaf/shared/const/app_theme.dart';

class LogIn extends StatefulWidget {
  String? email;
  String? password;

  LogIn({this.email, this.password}) {
    email ?? '';
    password ?? '';
  }

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> with SingleTickerProviderStateMixin {
  // final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>(debugLabel: 'form key');
  FocusNode _emailFocusNode = new FocusNode();
  FocusNode _passwordFocusNode = new FocusNode();
  FocusNode _confirmPasswordFocusNode = new FocusNode();
  void _requestFocus(FocusNode focusNode) {
    setState(() {
      FocusScope.of(context).requestFocus(focusNode);
    });
  }

  final inputDecoration = InputDecoration(
    contentPadding: EdgeInsets.fromLTRB(10, 15, 8, 20),
    border: CustomWidgetBorder(color: Colors.grey, width: 1.2),
    enabledBorder: CustomWidgetBorder(color: Colors.grey, width: 1.2),
    errorBorder: CustomWidgetBorder(color: Colors.red[300], width: 1.5),
    focusedErrorBorder: CustomWidgetBorder(color: Colors.red[300], width: 2.4),
  );

  Color _getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.white.withOpacity(0.3);
    }
    return Colors.white.withOpacity(0.3);
  }

  late AnimationController _topBarAnimController;
  late Animation<double> _topBarAnim;

  @override
  void initState() {
    super.initState();

    _topBarAnimController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _topBarAnim = Tween<double>(begin: -200, end: 0).animate(CurvedAnimation(
        parent: _topBarAnimController, curve: Curves.easeOutCubic));

    _topBarAnimController.forward();

    _emailFocusNode.addListener(() {
      setState(() {});
    });
    _passwordFocusNode.addListener(() {
      setState(() {});
    });
    _confirmPasswordFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _topBarAnimController.dispose();
    _formKey.currentState?.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Placeholder(), // TODO add rive background
          Center(
            child: Hero(
              tag: "Welcome Screen Center Box",
              child: Container(
                clipBehavior: Clip.antiAlias,
                height: 490,
                width: 380,
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.8),
                      blurRadius: 30.0,
                      spreadRadius: 1.0,
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _topBarAnim,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _topBarAnim.value),
                          child: child,
                        );
                      },
                      child: Material(
                        child: Container(
                          color: Theme.of(context).primaryColor,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.arrow_back_ios_rounded,
                                        color: Colors.white,
                                        size: 28.0,
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                      splashColor: Colors.white,
                                    ),
                                    Text(
                                      'Log In',
                                      style:
                                          Theme.of(context).textTheme.headline1,
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 8, 0),
                                  child: TextButton.icon(
                                    icon:
                                        Icon(Icons.person, color: Colors.white),
                                    label: Text(
                                      'Register',
                                      style: Theme.of(context).textTheme.button,
                                    ),
                                    onPressed: () {},
                                    style: ButtonStyle(
                                      overlayColor:
                                          MaterialStateProperty.resolveWith(
                                              _getColor),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    Material(
                      child: Container(
                        color: Colors.lightGreen,
                        child: Text(
                          '[Releaf Logo]',
                          style: TextStyle(fontSize: 40),
                        ),
                      ),
                    ),
                    // SizedBox(height: 50),
                    Expanded(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: Form(
                          // key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              // * Email
                              Material(
                                child: TextFormField(
                                  // TODO make label change color on focus
                                  // onTap: () => _requestFocus(_emailFocusNode),
                                  focusNode: _emailFocusNode,
                                  onTap: () => setState(() {}),
                                  initialValue: widget.email,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (val) => val!.isEmpty
                                      ? 'Pleas enter an email'
                                      : null,
                                  autocorrect: false,
                                  onChanged: (val) {
                                    setState(() => widget.email = val);
                                  },
                                  decoration: inputDecoration.copyWith(
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
                              ),
                              SizedBox(height: 20),
                              Material(
                                child: TextFormField(
                                  // TODO make label change color on focus
                                  // onTap: () => _requestFocus(_passwordFocusNode),
                                  focusNode: _passwordFocusNode,
                                  initialValue: widget.password,
                                  obscureText: true,
                                  validator: (val) => val!.isEmpty
                                      ? 'Password needs to be at least 8 characters'
                                      : null,
                                  autocorrect: false,
                                  onChanged: (val) {
                                    setState(() => widget.password = val);
                                  },
                                  decoration: inputDecoration.copyWith(
                                    labelText: 'Password',
                                    labelStyle: TextStyle(
                                      color: _passwordFocusNode.hasFocus
                                          ? Theme.of(context).primaryColor
                                          : Colors.grey,
                                    ),
                                    focusedBorder: CustomWidgetBorder(
                                        color: Theme.of(context).primaryColor,
                                        width: 2.2),
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: _passwordFocusNode.hasFocus
                                          ? Theme.of(context).primaryColor
                                          : Colors.grey,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        Icons.clear,
                                        color: _passwordFocusNode.hasFocus
                                            ? Theme.of(context).primaryColor
                                            : Colors.grey,
                                      ),
                                      onPressed: () => print('clear'),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 35),
                              ThemedButton(
                                label: 'Log In',
                                onPressed: () => print('log in'),
                                shadowColor: Colors.black.withOpacity(0.6),
                                pressedShadowColor:
                                    Theme.of(context).accentColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
