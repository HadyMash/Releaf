import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:releaf/screens/authentication/veryify.dart';
import 'package:releaf/services/auth.dart';
import 'package:releaf/shared/assets/custom_widget_border.dart';
import 'package:releaf/screens/authentication/register.dart';
import 'package:releaf/shared/const/app_theme.dart';
import 'package:releaf/shared/assets/themed_button.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';

// ignore: must_be_immutable
class LogIn extends StatefulWidget {
  String? email;
  String? password;
  bool? animate;

  LogIn({this.email, this.password, this.animate}) {
    email = email ?? '';
    password = password ?? '';
    animate = animate ?? true;
  }

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> with SingleTickerProviderStateMixin {
  final AuthService _auth = AuthService();
  dynamic _error;
  final _formKey = GlobalKey<FormState>(debugLabel: 'form key');
  FocusNode _emailFocusNode = new FocusNode();
  late TextEditingController _emailController;
  FocusNode _passwordFocusNode = new FocusNode();
  late TextEditingController _passwordController;

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
    _emailController = TextEditingController(text: widget.email);
    _passwordController = TextEditingController(text: widget.password);

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
  }

  @override
  void dispose() {
    _topBarAnimController.dispose();
    _formKey.currentState?.dispose();
    _emailFocusNode.dispose();
    _emailController.dispose();
    _passwordFocusNode.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
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
                        color: Colors.white.withOpacity(0),
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
                                      onPressed: () => AppTheme
                                          .mainNavKey.currentState!
                                          .pop(context),
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
                                    onPressed: () => AppTheme
                                        .mainNavKey.currentState!
                                        .pushReplacement(
                                      PageRouteBuilder(
                                        transitionDuration:
                                            Duration(milliseconds: 0),
                                        pageBuilder: (BuildContext context,
                                            Animation<double> animation,
                                            Animation<double>
                                                secondaryAnimation) {
                                          return Register(
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
                    SizedBox(height: (40 / 926) * _height),
                    Material(
                      color: Colors.white.withOpacity(0),
                      child: Container(
                        color: Colors.lightGreen,
                        child: Text(
                          '[Releaf Logo]',
                          style: TextStyle(
                              fontSize: 40 - ((926 * 0.01) - (_height * 0.01))),
                        ),
                      ),
                    ),
                    Expanded(
                      // TODO fix all vertical padding to chang based on height
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              // * Email
                              Material(
                                color: Colors.white.withOpacity(0),
                                child: TextFormField(
                                  focusNode: _emailFocusNode,
                                  controller: _emailController,
                                  onTap: () => setState(() {}),
                                  // initialValue: widget.email,
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
                                  onChanged: (val) => setState(() {
                                    widget.email = val;
                                    print('value changed: $val');
                                  }),
                                  style: TextStyle(
                                    fontSize: 16 -
                                        ((926 * 0.008) - (_height * 0.008)),
                                  ),
                                  decoration: _theme.inputDecoration.copyWith(
                                    labelText: 'Email',
                                    labelStyle: TextStyle(
                                      color: _emailFocusNode.hasFocus
                                          ? Theme.of(context).primaryColor
                                          : Colors.grey,
                                      fontSize: 16 -
                                          ((926 * 0.008) - (_height * 0.008)),
                                    ),
                                    hintText: 'example@domain.com',
                                    hintStyle: TextStyle(
                                      fontSize: 16 -
                                          ((926 * 0.008) - (_height * 0.008)),
                                    ),
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
                                      onPressed: () {
                                        _emailController.clear();
                                        widget.email = '';
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: (20 / 926) * _height),
                              Material(
                                color: Colors.white.withOpacity(0),
                                child: TextFormField(
                                  focusNode: _passwordFocusNode,
                                  controller: _passwordController,
                                  // initialValue: widget.password,
                                  obscureText: true,
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return 'Please enter a password';
                                    } else if (val.length < 8) {
                                      return 'Password needs to be at least 8 characters';
                                    }
                                  },
                                  autocorrect: false,
                                  onChanged: (val) =>
                                      setState(() => widget.password = val),
                                  style: TextStyle(
                                    fontSize: 16 -
                                        ((926 * 0.008) - (_height * 0.008)),
                                  ),
                                  decoration: _theme.inputDecoration.copyWith(
                                    labelText: 'Password',
                                    labelStyle: TextStyle(
                                      color: _passwordFocusNode.hasFocus
                                          ? Theme.of(context).primaryColor
                                          : Colors.grey,
                                      fontSize: 16 -
                                          ((926 * 0.008) - (_height * 0.008)),
                                    ),
                                    hintStyle: TextStyle(
                                      fontSize: 16 -
                                          ((926 * 0.008) - (_height * 0.008)),
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
                                      onPressed: () {
                                        _passwordController.clear();
                                        widget.password = '';
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: _error == null || _error == ''
                                      ? (30 / 926) * _height
                                      : 0),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical:
                                      (_error == null || _error == '') ? 0 : 13,
                                ),
                                child: Text('$_error',
                                    style: TextStyle(
                                      fontSize: (_error == null || _error == '')
                                          ? 0
                                          : 14 -
                                              ((926 * 0.01) - (_height * 0.01)),
                                      color: Colors.red[800],
                                    ),
                                    textAlign: TextAlign.center),
                              ),
                              ThemedButton(
                                label: 'Log In',
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    dynamic result = await _auth.logIn(
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
                                      if (_auth.getUser()!.emailVerified) {
                                        // TODO make rive page transition.
                                        AppTheme.mainNavKey.currentState!
                                            .popUntil((route) => route.isFirst);
                                      } else {
                                        if (_auth.getUser() != null) {
                                          AppTheme.mainNavKey.currentState!
                                              .push(
                                            MaterialPageRoute(
                                              builder: (context) => Verify(),
                                            ),
                                          );
                                        }
                                      }
                                    } else {
                                      setState(() =>
                                          _error = _auth.getError(result));
                                      print(_error);
                                    }
                                  }
                                  setState(() {});
                                },
                                tapDownFeedback: true,
                                tapFeedback: true,
                              ),
                              SizedBox(height: (20 / 926) * _height),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    decoration: TextDecoration.underline,
                                  ),
                                  text: 'Forgot Password',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      AppTheme.mainNavKey.currentState!
                                          .pushReplacement(
                                        PageRouteBuilder(
                                          transitionDuration:
                                              Duration(milliseconds: 0),
                                          pageBuilder: (BuildContext context,
                                              Animation<double> animation,
                                              Animation<double>
                                                  secondaryAnimation) {
                                            return ResetPassword(
                                                email: widget.email);
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
                                      );
                                    },
                                ),
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

class ResetPassword extends StatefulWidget {
  String? email;

  ResetPassword({this.email});

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword>
    with SingleTickerProviderStateMixin {
  final AuthService _auth = AuthService();
  dynamic _error;
  final _formKey = GlobalKey<FormState>(debugLabel: 'form key');
  FocusNode _emailFocusNode = new FocusNode();
  late TextEditingController _emailController;

  final inputDecoration = InputDecoration(
    contentPadding: EdgeInsets.fromLTRB(10, 15, 8, 20),
    border: CustomWidgetBorder(color: Colors.grey, width: 1.2),
    enabledBorder: CustomWidgetBorder(color: Colors.grey, width: 1.2),
    errorBorder: CustomWidgetBorder(color: Colors.red[300], width: 1.5),
    focusedErrorBorder: CustomWidgetBorder(color: Colors.red[300], width: 2.4),
    errorStyle: TextStyle(fontSize: 14),
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

  @override
  void initState() {
    _emailController = TextEditingController(text: widget.email);
    super.initState();
    _emailFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    _emailFocusNode.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      color: Theme.of(context).shadowColor.withOpacity(0.8),
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
                    Material(
                      color: Colors.white.withOpacity(0),
                      child: Container(
                        color: Theme.of(context).primaryColor,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios_rounded,
                                  color:
                                      Theme.of(context).accentIconTheme.color,
                                  size: 28.0,
                                ),
                                onPressed: () => AppTheme
                                    .mainNavKey.currentState!
                                    .pop(context),
                                splashColor:
                                    Theme.of(context).accentIconTheme.color,
                              ),
                              Expanded(
                                child: Text(
                                  'Reset Password',
                                  style: Theme.of(context).textTheme.headline1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: (40 / 926) * _height),
                    Material(
                      color: Colors.white.withOpacity(0),
                      child: Container(
                        color: Colors.lightGreen,
                        child: Text(
                          '[Releaf Logo]',
                          style: TextStyle(
                              fontSize: 40 - ((926 * 0.01) - (_height * 0.01))),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              // * Email
                              Material(
                                color: Colors.white.withOpacity(0),
                                child: TextFormField(
                                  focusNode: _emailFocusNode,
                                  controller: _emailController,
                                  onTap: () => setState(() {}),
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
                                  onChanged: (val) =>
                                      setState(() => widget.email = val),
                                  style: TextStyle(
                                    fontSize: 16 -
                                        ((926 * 0.008) - (_height * 0.008)),
                                  ),
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
                                      onPressed: () {
                                        _emailController.clear();
                                        widget.email = '';
                                      },
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(
                                  height: _error == null || _error == ''
                                      ? (30 / 926) * _height
                                      : 0),
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
                                label: 'Reset Password',
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    FocusScopeNode currentFocus =
                                        FocusScope.of(context);
                                    if (!currentFocus.hasPrimaryFocus) {
                                      currentFocus.unfocus();
                                    }
                                    _auth.resetPassword(widget.email!, context);
                                  }
                                  setState(() {});
                                },
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

// ! PLEASE IGNORE
// ! PLEASE IGNORE
// ! PLEASE IGNORE

class LogInMock extends StatefulWidget {
  @override
  _LogInMockState createState() => _LogInMockState();
}

class _LogInMockState extends State<LogInMock>
    with SingleTickerProviderStateMixin {
  // TODO Simplify Login mock code because it won't be used.

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
      duration: Duration(milliseconds: 700),
    );

    _topBarAnim = Tween<double>(begin: -200, end: 0).animate(CurvedAnimation(
        parent: _topBarAnimController, curve: Curves.easeOutCubic));
    _topBarAnimController.forward();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    Future.delayed(Duration(milliseconds: 710), () {
      AppTheme.mainNavKey.currentState!.pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) =>
              LogIn(animate: false),
          transitionDuration: Duration(seconds: 0),
        ),
      );
    });
  }

  @override
  void dispose() {
    _topBarAnimController.dispose();
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
                      color: Theme.of(context).shadowColor.withOpacity(0.8),
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
                        color: Colors.white.withOpacity(0),
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
                                      onPressed: () => AppTheme
                                          .mainNavKey.currentState!
                                          .pop(context),
                                      splashColor: Theme.of(context)
                                          .accentIconTheme
                                          .color,
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
                                    icon: Icon(Icons.person,
                                        color: Theme.of(context)
                                            .accentIconTheme
                                            .color),
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
                    SizedBox(height: (40 / 926) * _height),
                    Material(
                      color: Colors.white.withOpacity(0),
                      child: Container(
                        color: Colors.lightGreen,
                        child: Text(
                          '[Releaf Logo]',
                          style: TextStyle(
                              fontSize: 40 - ((926 * 0.01) - (_height * 0.01))),
                        ),
                      ),
                    ),
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
                                color: Colors.white.withOpacity(0),
                                child: TextFormField(
                                  onTap: () => setState(() {}),
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
                                  onChanged: (val) => setState(() {}),
                                  decoration: _theme.inputDecoration.copyWith(
                                    labelText: 'Email',
                                    labelStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16 -
                                          ((926 * 0.008) - (_height * 0.008)),
                                    ),
                                    hintText: 'example@domain.com',
                                    hintStyle: TextStyle(
                                      fontSize: 16 -
                                          ((926 * 0.008) - (_height * 0.008)),
                                    ),
                                    focusedBorder: CustomWidgetBorder(
                                        color: Theme.of(context).primaryColor,
                                        width: 2.2),
                                    prefixIcon: Icon(
                                      Icons.mail,
                                      color: Colors.grey,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        Icons.clear,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {},
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: (20 / 926) * _height),
                              Material(
                                color: Colors.white.withOpacity(0),
                                child: TextFormField(
                                  obscureText: true,
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return 'Please enter a password';
                                    } else if (val.length < 8) {
                                      return 'Password needs to be at least 8 characters';
                                    }
                                  },
                                  autocorrect: false,
                                  onChanged: (val) => setState(() {}),
                                  decoration: _theme.inputDecoration.copyWith(
                                    labelText: 'Password',
                                    labelStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16 -
                                          ((926 * 0.008) - (_height * 0.008)),
                                    ),
                                    hintStyle: TextStyle(
                                      fontSize: 16 -
                                          ((926 * 0.008) - (_height * 0.008)),
                                    ),
                                    focusedBorder: CustomWidgetBorder(
                                        color: Theme.of(context).primaryColor,
                                        width: 2.2),
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Colors.grey,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        Icons.clear,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {},
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: (35 / 926) * _height),
                              ThemedButton(
                                label: 'Log In',
                                onPressed: () {},
                              ),
                              SizedBox(height: (20 / 926) * _height),
                              RichText(
                                text: new TextSpan(
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    decoration: TextDecoration.underline,
                                  ),
                                  text: 'Forgot Password',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // Reset Password
                                    },
                                ),
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

// ! PLEASE IGNORE
// ! PLEASE IGNORE
// ! PLEASE IGNORE