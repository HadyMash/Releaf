import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:releaf/services/encrypt.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();
  User? getUser() => _auth.currentUser;
  Future reloadUser() => _auth.currentUser!.reload();

  // auth change user stream
  Stream<User?> get user {
    return _auth.userChanges();
  }

  // Send verification email
  Future sendVerificationEmail(context) async {
    late final SnackBar snackBar;
    try {
      if (_auth.currentUser != null) {
        await _auth.currentUser!.sendEmailVerification();
        snackBar = SnackBar(
          content: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Icon(Icons.check_circle_rounded, color: Colors.green),
              ),
              Expanded(
                child: Text('Success, an email has been sent your address.'),
              ),
            ],
          ),
        );
      } else {
        snackBar = SnackBar(
          content: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Icon(Icons.warning_rounded, color: Colors.amber),
              ),
              Expanded(child: Text('Unkown Error')),
            ],
          ),
        );
      }
    } catch (e) {
      snackBar = SnackBar(
        content: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Icon(Icons.error_rounded, color: Colors.red[700]),
            ),
            Expanded(child: Text(getError(e.toString()))),
          ],
        ),
      );
    }
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // register with email and password
  Future register({required String email, required String password}) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      if (user != null) {
        var firestore = FirebaseFirestore.instance;
        EncryptService encryptService = EncryptService(_auth.currentUser!.uid);
        // Make a sample journal entry
        firestore.collection('journal').doc(user.uid).set({
          DateTime.now().toString(): {
            "entryText": encryptService.encrypt(
                '''Hello! Welcome to Releaf. This is your personal space to reflect and talk about how you are feeling. Remember, it's ok, even normal, to feel down. We aren't computers and our emotions fluctuate. What's important is that we make the best of the times when we are happy. And remember to always ask for help when you need to.
            
You can write whatever you want here as all the data is encrypted. Only you can see what you write here and anything else you write on the app.
          '''),
            "feeling": 3,
          },
        }, SetOptions(merge: true));

        // Make a todo collection
        var year = DateTime.now().year;
        firestore.collection('tasks').doc(user.uid).collection(year.toString())
          ..add({
            'index': 0,
            'task': encryptService.encrypt('Download Releaf'),
            'completed': true,
          })
          ..add({
            'index': 1,
            'task': encryptService.encrypt('Use Releaf'),
            'completed': false,
          });
        firestore.collection('tasks').doc(user.uid).set({
          'years': [year],
        });
      }
      return user;
    } catch (e) {
      return e.toString();
    }
  }

  // log in with email and password
  Future logIn({required String email, required String password}) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } catch (e) {
      return e.toString();
    }
  }

  // log in with Google
  Future logInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth!.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);

      // if (result.user != null) {
      //   var firestore = FirebaseFirestore.instance;
      //   // Make a sample journal entry
      //   firestore.collection('journal').doc(result.user!.uid).set({
      //     DateTime.now().toString(): {
      //       "entryText": '''Hello! Welcome to Releaf. This is your personal space to reflect and talk about how you are feeling. Remember, it's ok, even normal, to feel down. We aren't computers and our emotions fluctuate. What's important is that we make the best of the times when we are happy. And remember to always ask for help when you need to.

      //     You can write whatever you want here as all the data is encrypted. Only you can see what you write here and anything else you write on the app.
      //     ''',
      //       "feeling": 3,
      //     },
      //   }, SetOptions(merge: true));

      //   var year = DateTime.now().year;
      //   firestore
      //       .collection('tasks')
      //       .doc(result.user!.uid)
      //       .collection(year.toString())
      //         ..doc().set({
      //           'index': 0,
      //           'task': 'Download Releaf',
      //           'completed': true,
      //         })
      //         ..doc().set({
      //           'index': 1,
      //           'task': 'Use Releaf',
      //           'completed': false,
      //         });
      //   firestore.collection('tasks').doc(result.user!.uid).set({
      //     'years': [year],
      //   });
      // }

      return result.user;
    } catch (e) {
      print(e.toString());
    }
  }

  // Forgot password
  Future resetPassword(String email, context) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);

      final snackBar = SnackBar(
        content: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Icon(Icons.check_circle_rounded, color: Colors.green),
            ),
            Expanded(
                child: Text(
                    'Success, an email has been sent to your email address.')),
          ],
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      final snackBar = SnackBar(
        content: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Icon(Icons.error_rounded, color: Colors.red[700]),
            ),
            Expanded(child: Text(getError(e.toString()))),
          ],
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      print(e.toString());
      return e.toString();
    }
  }

  // Transfer Account to a new email
  Future updateEmail(context, {required String newEmail}) async {
    // TODO use verifyBeforeUpdateEmail
    try {
      if (_auth.currentUser != null) {
        await _auth.currentUser!.updateEmail(newEmail);

        final snackBar = SnackBar(
          content: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Icon(Icons.check_circle_rounded, color: Colors.green),
              ),
              Expanded(
                child: Text(
                    'Success, an email has been sent to the original email if you wish to undo this action.'),
              ),
            ],
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return null;
      } else {
        final snackBar = SnackBar(
          content: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Icon(Icons.warning_rounded, color: Colors.amber),
              ),
              Expanded(child: Text('Unkown Error')),
            ],
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      final snackBar = SnackBar(
        content: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Icon(Icons.error_rounded, color: Colors.red[700]),
            ),
            Expanded(child: Text('An Error has occured.')),
          ],
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return e.toString();
    }
  }

  // Change Password
  Future verifyCurrentPassword(String password) async {
    try {
      User? user = _auth.currentUser;

      var authCredential =
          EmailAuthProvider.credential(email: user!.email!, password: password);

      var authResult = await user.reauthenticateWithCredential(authCredential);

      return authResult.user != null;
    } catch (e) {
      print(e.toString());
      return getError(e.toString());
    }
  }

  Future updatePassword(
    context, {
    required String oldPassword,
    required String newPassword,
  }) async {
    // TODO add verification code logic
    try {
      dynamic oldPasswordVerified = await verifyCurrentPassword(oldPassword);
      if (oldPasswordVerified == true) {
        await _auth.currentUser!.updatePassword(newPassword);
        final snackBar = SnackBar(
          content: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Icon(Icons.check_circle_rounded, color: Colors.green),
              ),
              Expanded(
                child: Text('Success, your password has been changed.'),
              ),
            ],
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return true;
      }
    } catch (e) {
      final snackBar = SnackBar(
        content: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Icon(Icons.error_rounded, color: Colors.red[700]),
            ),
            Expanded(child: Text('An Error has occured.')),
          ],
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return getError(e.toString());
    }
  }

  // log out
  Future logOut() async {
    try {
      await googleSignIn.signOut();
      return await _auth.signOut();
    } catch (e) {
      return e.toString();
    }
  }

  // Change Username
  Future changeUsername({required String newName, required context}) async {
    try {
      if (_auth.currentUser != null) {
        await _auth.currentUser!.updateProfile(displayName: newName);
        final snackBar = SnackBar(
          content: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Icon(Icons.check_circle_rounded, color: Colors.green),
              ),
              Expanded(child: Text('Success')),
            ],
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      final snackBar = SnackBar(
        content: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Icon(Icons.error_rounded, color: Colors.red[700]),
            ),
            Expanded(child: Text(getError(e.toString()))),
          ],
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  final Map _authErrors = {
    '[firebase_auth/invalid-email] The email address is badly formatted.':
        'Invalid Email',
    '[firebase_auth/too-many-requests] Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later.':
        'Account temporarily disabled. Reset your passowrd or try again later.',
    '[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.':
        'Incorrect Email or Password',
    '[firebase_auth/wrong-password] The password is invalid or the user does not have a password.':
        'Incorrect Email or Password',
    'Password should be at least 6 characters':
        'Password should be at least 6 characters',
    '[firebase_auth/email-already-in-use] The email address is already in use by another account.':
        'Email address is already in use',
    '[firebase_auth/user-disabled] The user account has been disabled by an administrator.':
        'Account disabled, please contact us for help.',
    '[firebase_auth/requires-recent-login] This operation is sensitive and requires recent authentication. Log in again before retrying this request.':
        'Please log out, log in, then try again.',
    '[firebase_auth/too-many-requests] We have blocked all requests from this device due to unusual activity. Try again later.':
        'Requests from this device have been temporarliy blocked due to unusual activity. Please try again later.',
    '[firebase_auth/network-request-failed] Network error (such as timeout, interrupted connection or unreachable host) has occurred.':
        'Connection to server failed.',
    '': 'Unkown Error',
    null: 'Unkown Error',
  };
  String getError([String? e]) {
    var error = _authErrors[e];
    print(e);
    return error ?? e;
  }
}
