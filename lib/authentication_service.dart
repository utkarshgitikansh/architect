import 'package:architect/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'main.dart';
import 'package:localstorage/localstorage.dart';


class AuthenticationService {

  final FirebaseAuth _firebaseAuth;
  final storage = new LocalStorage('login_user');

  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signOut() async {
    storage.setItem('login_user', "");
    await _firebaseAuth.signOut();
  }
}

//   Future<String> signIn({String email, String password}) async {
//     try {
//       await _firebaseAuth.signInWithEmailAndPassword(
//           email: email, password: password);
//       return "Signed in";
//     }
//     //  on FirebaseAuthException
//     // catch (e){
//     //   return e.message;
//     //
//     // }
//
//     catch (e) {
//       globals.signInIssue = true;  // On this line, call your class and show the error message.
//     }
//   }
//
//   Future<String> signUp({String email, String password}) async {
//     try {
//       await _firebaseAuth.createUserWithEmailAndPassword(
//           email: email, password: password);
//       return "Signed up";
//     }
//     catch (e) {
//       globals.signInIssue = true;
//       print(Errors.show(
//           e.code)); // On this line, call your class and show the error message.
//     }
//
//     on FirebaseAuthException
//     catch (e) {
//       return e.message;
//     }
//     on NoSuchMethodError catch (e) {
//       print('exception');
//     }
//   }
//
// }
//
// class Errors {
//   static String show(String errorCode) {
//     switch (errorCode) {
//       case 'ERROR_EMAIL_ALREADY_IN_USE':
//         return "This e-mail address is already in use, please use a different e-mail address.";
//
//       case 'ERROR_INVALID_EMAIL':
//         return "The email address is badly formatted.";
//
//       case 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL':
//         return "The e-mail address in your Facebook account has been registered in the system before. Please login by trying other methods with this e-mail address.";
//
//       case 'ERROR_WRONG_PASSWORD':
//         return "E-mail address or password is incorrect.";
//
//       default:
//         return "An error has occurred";
//     }
//   }
// }