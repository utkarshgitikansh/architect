import 'authentication_service.dart';
import 'package:architect/home_page.dart';
import 'package:architect/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'globals.dart' as globals;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:localstorage/localstorage.dart';

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    // final storage = new LocalStorage('login_user');
    // globals.user = storage.getItem('login_user');
    // print("yoyoyooy" + storage.getItem('login_user'));
  }


  @override
  Widget build(BuildContext context) {
    return

            MultiProvider(

          providers: [
          Provider<AuthenticationService>(
             create: (_) => AuthenticationService(FirebaseAuth.instance),),
          StreamProvider(
              create: (context) => context.read<AuthenticationService>().authStateChanges )
        ],
        child:

        Center(
          child: Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(image: new AssetImage('assets/images/gray_wall.png'), fit: BoxFit.cover,),
            ),

            child:

            //MyCustomForm(),
            MaterialApp(home: AuthenticationWrapper()),

          ),
        ),
        );


  }
}


// class MyApp extends StatelessWidget {
//
//   @override
//   Widget build(BuildContext context) {
//     final title = 'Grid';
//
//     return
//
//         MultiProvider(
//
//           providers: [
//           Provider<AuthenticationService>(
//              create: (_) => AuthenticationService(FirebaseAuth.instance),),
//           StreamProvider(
//               create: (context) => context.read<AuthenticationService>().authStateChanges )
//         ],
//         child:
//
//         Center(
//           child: Container(
//             decoration: new BoxDecoration(
//               image: new DecorationImage(image: new AssetImage('assets/images/gray_wall.png'), fit: BoxFit.cover,),
//             ),
//
//             child:
//
//             //MyCustomForm(),
//             MaterialApp(home: AuthenticationWrapper()),
//
//           ),
//         ),
//         );
//   }
// }

//////////////////

class AuthenticationWrapper extends StatefulWidget {
  @override
  _AuthenticationWrapperState createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {

  @override
  Widget build(BuildContext context) {


    final firebaseUser =  context.watch<User>();
    try {
      if (firebaseUser != null &&  globals.user != "") {


        if(globals.newUser){
          globals.formtest = true;
          globals.gridCheck = true;
        }
        else{
          globals.formtest = false;
        }
        print("${globals.newUser} + homepage + ${firebaseUser}" );
        return HomePage();

      }
      print("signinpage");
      return SignInPage();


    }

    on NoSuchMethodError catch (e) {
      globals.gridCheck = false;
      print('exception at signIn Page');
    }
  }
}


// class AuthenticationWrapper extends StatelessWidget {
//
//
//   @override
//   Widget build(BuildContext context) {
//
//
//     final firebaseUser =  context.watch<User>();
// try {
//   if (firebaseUser != null ||  globals.user != "") {
//
//
//     if(globals.newUser){
//       globals.formtest = true;
//       globals.gridCheck = true;
//     }
//     else{
//       globals.formtest = false;
//     }
//     print("${globals.newUser} + homepage + ${firebaseUser}" );
//     return HomePage();
//
//   }
//   print("signinpage");
//     return SignInPage();
//
//
//   }
//
//   on NoSuchMethodError catch (e) {
//   globals.gridCheck = false;
//   print('exception at signIn Page');
//   }
//   }
// }


class Errors {
  static String show(String errorCode) {
    switch (errorCode) {
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        return "This e-mail address is already in use, please use a different e-mail address.";

      case 'ERROR_INVALID_EMAIL':
        return "The email address is badly formatted.";

      case 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL':
        return "The e-mail address in your Facebook account has been registered in the system before. Please login by trying other methods with this e-mail address.";

      case 'ERROR_WRONG_PASSWORD':
        return "E-mail address or password is incorrect.";

      default:
        return "An error has occurred";
    }
  }
}




