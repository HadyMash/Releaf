import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:releaf/screens/authentication/veryify.dart';
import 'package:releaf/services/auth.dart';
import 'package:releaf/shared/assets/custom_form_field.dart';
import 'package:releaf/screens/authentication/log_in.dart';
import 'package:releaf/shared/const/app_theme.dart';
import 'package:email_validator/email_validator.dart';

class Register extends StatefulWidget {
  String? email;
  String? password;
  bool? animate;

  Register({this.email, this.password, this.animate}) {
    email ?? '';
    password ?? '';
    animate ?? true;
  }

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register>
    with SingleTickerProviderStateMixin {
  final AuthService _auth = AuthService();
  dynamic _error;
  final _formKey = GlobalKey<FormState>(debugLabel: 'form key');
  FocusNode _emailFocusNode = new FocusNode();
  FocusNode _passwordFocusNode = new FocusNode();
  FocusNode _confirmPasswordFocusNode = new FocusNode();

  bool _showingErrors = false;

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

    if (widget.animate == true || widget.animate == null) {
      _topBarAnimController.forward();
    } else if (widget.animate == false) {
      _topBarAnim =
          Tween<double>(begin: 0, end: 0).animate(_topBarAnimController);
    }

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
    final _theme = Provider.of<AppTheme>(context);

    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Placeholder(), // TODO add rive background
          Center(
            child: Hero(
              tag: "Welcome Screen Center Box",
              child: Container(
                clipBehavior: Clip.antiAlias,
                height: (435 / 380) * _width,
                width: (1140 / 1284) * _width,
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
                                        color: Theme.of(context)
                                            .accentIconTheme
                                            .color,
                                        size: 28.0,
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                      splashColor: Theme.of(context)
                                          .accentIconTheme
                                          .color,
                                    ),
                                    Text(
                                      'Register',
                                      style:
                                          Theme.of(context).textTheme.headline1,
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 8, 0),
                                  child: TextButton.icon(
                                    icon: Icon(Icons.person,
                                        color: Theme.of(context)
                                            .accentIconTheme
                                            .color),
                                    label: Text(
                                      'Log In',
                                      style: Theme.of(context).textTheme.button,
                                    ),
                                    onPressed: () =>
                                        Navigator.of(context).pushReplacement(
                                      PageRouteBuilder(
                                        transitionDuration:
                                            Duration(milliseconds: 1),
                                        pageBuilder: (BuildContext context,
                                            Animation<double> animation,
                                            Animation<double>
                                                secondaryAnimation) {
                                          return LogIn(
                                            email: widget.email,
                                            password: widget.password,
                                            animate: false,
                                          );
                                        },
                                        transitionsBuilder:
                                            (BuildContext context,
                                                Animation<double> animation,
                                                Animation<double>
                                                    secondaryAnimation,
                                                Widget child) {
                                          return Align(
                                            child: FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
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
                    SizedBox(height: _showingErrors ? 13 : 30),
                    Material(
                      child: Container(
                        color: Colors.lightGreen,
                        child: Text(
                          '[Releaf Logo]',
                          style: TextStyle(fontSize: 40),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              // * Email
                              Material(
                                child: TextFormField(
                                  focusNode: _emailFocusNode,
                                  onTap: () => setState(() {}),
                                  initialValue: widget.email,
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
                                    setState(() => widget.email = val);
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
                              ),
                              SizedBox(height: _showingErrors ? 10 : 20),
                              Material(
                                child: TextFormField(
                                  focusNode: _passwordFocusNode,
                                  initialValue: widget.password,
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
                                    setState(() => widget.password = val);
                                  },
                                  decoration: _theme.inputDecoration.copyWith(
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
                              SizedBox(height: _showingErrors ? 10 : 20),
                              Material(
                                child: TextFormField(
                                  focusNode: _confirmPasswordFocusNode,
                                  obscureText: true,
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return 'Please enter a password';
                                    } else if (val.length < 8) {
                                      return 'Password needs to be at least 8 characters';
                                    } else if (val != widget.password) {
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
                                        color:
                                            _confirmPasswordFocusNode.hasFocus
                                                ? Theme.of(context).primaryColor
                                                : Colors.grey,
                                      ),
                                      onPressed: () => print('clear'),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: _showingErrors
                                      ? 10
                                      : (_error == null || _error == ''
                                          ? 30
                                          : 0)),
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
                                label: 'Register',
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() => _showingErrors = false);

                                    dynamic result = await _auth.register(
                                      email: widget.email.toString(),
                                      password: widget.password.toString(),
                                    );

                                    if (result is User) {
                                      FocusScopeNode currentFocus =
                                          FocusScope.of(context);
                                      if (!currentFocus.hasPrimaryFocus) {
                                        currentFocus.unfocus();
                                      }
                                      _error = null;
                                      setState(() => _showingErrors = false);
                                      if (!_auth.getUser()!.emailVerified) {
                                        await _auth
                                            .sendVerificationEmail(context);
                                        Navigator.popUntil(
                                            context, (route) => route.isFirst);
                                      }
                                    } else {
                                      setState(() =>
                                          _error = _auth.getError(result));
                                      print(_error);
                                    }
                                  } else {
                                    setState(() => _showingErrors = true);
                                  }
                                },
                                tapDownFeedback: true,
                                tapFeedback: true,
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
