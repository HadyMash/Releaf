import 'package:firebase_auth/firebase_auth.dart';
import 'package:releaf/services/database.dart';
import 'package:provider/provider.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? getUser() => _auth.currentUser;
  Future reloadUser() => _auth.currentUser!.reload();

  // auth change user stream
  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  // Send verification email
  Future sendVerificationEmail() async {
    if (_auth.currentUser != null) {
      await _auth.currentUser!.sendEmailVerification();
    } else {
      print('user is null');
    }
  }

  // register with email and password
  Future register({required String email, required String password}) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
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

  // log out
  Future logOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return e.toString();
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
    '': 'Unkown Error',
    null: 'Unkown Error',
  };
  String getError([String? e]) {
    var error = _authErrors[e];
    print(e);
    return error ?? e;
  }
}
