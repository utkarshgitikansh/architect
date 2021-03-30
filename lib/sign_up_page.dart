import 'package:architect/home_page.dart';
import 'package:architect/main.dart';
import 'package:architect/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'globals.dart' as globals;

class SignUpPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    globals.eStatus = "";

    signUp() async {
      final status = await AuthenticationHelper()
          .signUp(email: globals.user, password: globals.pwd);
      if (status == AuthResultStatus.successful) {
        // Navigate to success page
      } else {
        final errorMsg = AuthExceptionHandler.generateExceptionMessage(status);
        print(errorMsg + "test");
        showDialog(
            context: context,
            child: new AlertDialog(
              title: new Text("Error"),
              content: new Text('${globals.eStatus}'),
            ));
      }
    }

    return Center(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(10.0,200.0,10.0,10.0),
          child: Column(
            children: [
              Text("Architect",  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
              SizedBox(
                  height: 20
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                ),
              ),
              TextField(
                controller: passwordController,
                enableSuggestions: false,
                autocorrect: false,
                autofocus: false,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RaisedButton(
                      onPressed: () {
                        globals.user = emailController.text.toLowerCase().trim();
                        globals.pwd =
                            passwordController.text.toLowerCase().trim();

                        // context.read<AuthenticationService>().signUp(
                        //       email: emailController.text.trim(),
                        //       password: passwordController.text.trim(),
                        //     );

                        signUp();
                        globals.newUser = true;
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyApp()),
                        );
                      },
                      child: Text("Sign Up"),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              new Center(
                child: new InkWell(
                    child: new Text(
                      'Back to login',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Color(0xff0392cf),
                      ),
                    ),
                    onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyApp()),
                        )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AuthExceptionHandler {
  static handleException(e) {
    globals.eStatus = e.code;
    print(e.code);
    var status;
    switch (e.code) {
      case "ERROR_INVALID_EMAIL":
        status = AuthResultStatus.invalidEmail;
        break;
      case "ERROR_WRONG_PASSWORD":
        status = AuthResultStatus.wrongPassword;
        break;
      case "ERROR_USER_NOT_FOUND":
        status = AuthResultStatus.userNotFound;
        break;
      case "ERROR_USER_DISABLED":
        status = AuthResultStatus.userDisabled;
        break;
      case "ERROR_TOO_MANY_REQUESTS":
        status = AuthResultStatus.tooManyRequests;
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
        status = AuthResultStatus.operationNotAllowed;
        break;
      case "ERROR_EMAIL_ALREADY_IN_USE":
        status = AuthResultStatus.emailAlreadyExists;
        break;
      default:
        status = AuthResultStatus.undefined;
    }
    return status;
  }

  ///
  /// Accepts AuthExceptionHandler.errorType
  ///
  static generateExceptionMessage(exceptionCode) {
    String errorMessage;
    switch (exceptionCode) {
      case AuthResultStatus.invalidEmail:
        errorMessage = "Your email address appears to be malformed.";
        break;
      case AuthResultStatus.wrongPassword:
        errorMessage = "Your password is wrong.";
        break;
      case AuthResultStatus.userNotFound:
        errorMessage = "User with this email doesn't exist.";
        break;
      case AuthResultStatus.userDisabled:
        errorMessage = "User with this email has been disabled.";
        break;
      case AuthResultStatus.tooManyRequests:
        errorMessage = "Too many requests. Try again later.";
        break;
      case AuthResultStatus.operationNotAllowed:
        errorMessage = "Signing in with Email and Password is not enabled.";
        break;
      case AuthResultStatus.emailAlreadyExists:
        errorMessage =
            "The email has already been registered. Please login or reset your password.";
        break;
      default:
        errorMessage = "An undefined Error happened.";
    }

    return errorMessage;
  }
}

class AuthenticationHelper {
  final _firebaseAuth = FirebaseAuth.instance;
  AuthResultStatus _status = AuthResultStatus.successful;

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<AuthResultStatus> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      // return "Signed in";
    }
    //  on FirebaseAuthException
    // catch (e){
    //   return e.message;
    //
    // }

    catch (e) {
      print('Exception @createAccount: $e');
      _status = AuthExceptionHandler.handleException(e);
    }

    print('yass');
    return _status;
  }

  Future<AuthResultStatus> signUp({String email, String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      // return "Signed up";
    } catch (e) {
      print('Exception @createAccount: $e');
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }
}
