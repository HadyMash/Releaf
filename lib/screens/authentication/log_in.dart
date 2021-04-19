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

class _LogInState extends State<LogIn> {
  // final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  FocusNode emailFocusNode = new FocusNode();
  FocusNode passwordFocusNode = new FocusNode();

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

  ModalRoute? _mountRoute;

  @override
  void didChangeDependencies() {
    _mountRoute ??= ModalRoute.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Log In',
          style: Theme.of(context).textTheme.headline2,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
          splashRadius: 32,
          onPressed: () => Navigator.pop(context),
        ),
        automaticallyImplyLeading: false,
        titleSpacing: 15,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: TextButton.icon(
              label: Text(
                'Register',
                style: Theme.of(context).textTheme.button,
              ),
              icon: Icon(Icons.person, color: Colors.white),
              onPressed: () {
                print('switch');
              },
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.resolveWith(_getColor),
              ),
            ),
          ),
        ],
      ),
      body: Hero(
        tag: "Welcome Screen Center Box",
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(0),
          ),
          alignment: Alignment.center,
          child: GestureDetector(
            onTap:
                () {}, // TODO remove focus from text field when it is clicked.
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // * Email
                    TextFormField(
                      // TODO make label change color on focus
                      initialValue: widget.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) =>
                          val!.isEmpty ? 'Pleas enter an email' : null,
                      autocorrect: false,
                      onChanged: (val) {
                        setState(() => widget.email = val);
                      },
                      decoration: CustomInputDecoration(
                        context,
                        focusNode: emailFocusNode,
                        label: 'Email',
                        hint: 'example@domain.com',
                        prefixIcon: Icon(Icons.email,
                            color: Theme.of(context).primaryColor),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear, color: Colors.black),
                          onPressed: () {},
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      // TODO make label change color on focus
                      initialValue: widget.password,
                      obscureText: true,
                      validator: (val) => val!.isEmpty
                          ? 'Password needs to be at least 8 characters'
                          : null,
                      autocorrect: false,
                      onChanged: (val) {
                        setState(() => widget.password = val);
                      },
                      decoration: CustomInputDecoration(
                        context,
                        focusNode: passwordFocusNode,
                        label: 'Password',
                        prefixIcon: Icon(Icons.lock,
                            color: Theme.of(context).primaryColor),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.clear, color: Colors.black),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 35),
                    ThemedButton(
                      label: 'Log In',
                      onPressed: () {},
                      shadowColor: Colors.black.withOpacity(0.6),
                      pressedShadowColor: Theme.of(context).accentColor,
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
