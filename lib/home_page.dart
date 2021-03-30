import 'dart:io';

import 'package:architect/shelfItem.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'authentication_service.dart';
import 'globals.dart' as globals;
import 'globals.dart' as globals;
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'main.dart';
import 'package:localstorage/localstorage.dart';

Future gridCheck() async {

  int col;
  int row;
  int count;
  List shelf_array = [];

  int space;
  globals.count = 0;

  try {
    //////////////////// update last login time ////////////////////////

    // final dsT = await FirebaseFirestore.instance
    //     .collection('users')
    //     .doc('${globals.user}').collection('dimensions').doc('login')
    //     .get()
    //     .then((DocumentSnapshot) {
    //
    //     globals.loginTime = DocumentSnapshot.data()["time"];
    //
    //     print("timr + ${globals.loginTime}");
    //
    // });

    ////////////// old /////////////////

    // final ds0 = await FirebaseFirestore.instance
    //     .collection('users')
    //     .doc('${globals.user}')
    //     .get()
    //     .then((DocumentSnapshot) {
    //   col = int.parse(DocumentSnapshot.data()["columns"].toString());
    //   row = int.parse(DocumentSnapshot.data()["rows"].toString());
    // });

    // final ds0 = await FirebaseFirestore.instance
    //     .collection('users')
    //     .doc('${globals.user}').collection('dimensions').doc('col')
    //     .get()
    //     .then((DocumentSnapshot) {
    //
    //         col = int.parse(DocumentSnapshot.data()["col"].toString());
    //
    //
    // });
    //
    // print(" col : $col");
    //
    // if (col != null) {
    //   globals.gridCheck = true;
    // }

    final ds0 = await FirebaseFirestore.instance
        .collection('users')
        .doc('${globals.user}')
        .collection('dimensions')
        .doc('space')
        .get()
        .then((DocumentSnapshot) {
      if (DocumentSnapshot.exists) {
        space = int.parse(DocumentSnapshot.data()["space"].toString());
      }
    });

    print("space : $space");

    if (space != null) {
      globals.gridCheck = true;  //// gridCheck true means shelf exists

      int len;
      var dataArray;

      final ds2 = await FirebaseFirestore.instance
          .collection('users')
          .doc('${globals.user}')
          .get()
          .then((DocumentSnapshot) {
        len = DocumentSnapshot.data().length;
        dataArray = DocumentSnapshot.data();

        globals.xrays = [];
        globals.xraysValue = [];

        for (int i = 1; i <= len; i++) {
          for (int j = 0; j < dataArray[i.toString()].length; j++) {
            globals.xrays.add({
              "id": i,
              "items": dataArray[i.toString()][j],
            });
            globals.xraysValue.add(dataArray[i.toString()][j]);
          }
        }
      });

      globals.itemLen = globals.xrays.length;
    }


    // final ds1 = await FirebaseFirestore.instance
    //     .collection('users')
    //     .doc('${globals.user}').collection('dimensions').doc('row')
    //     .get()
    //     .then((DocumentSnapshot) {
    //
    //     row = int.parse(DocumentSnapshot.data()["row"].toString());
    //
    //     globals.gridCheck = false;
    //     globals.formtest = false;
    //
    //
    //
    // });
    //
    // print(" row : $row");

    // int i = 1;
    //
    // dataArray.forEach((data) =>
    //
    //
    //     print(data[i.toString()].length)
    //
    //     // globals.xrays.add({
    //     //     "id": i,
    //     //     "items": data.id,
    //     //   })
    //
    // );

    //// i holds shelf number

    ///////////////////// old /////////////////

    // final ds1 = await FirebaseFirestore.instance
    //     .collection('users')
    //     .doc('${globals.user}')
    //     .get()
    //     .then((DocumentSnapshot) =>
    //         row = int.parse(DocumentSnapshot.data()["rows"].toString()));

    // globals.shelf_array = [];
    // // globals.xrays = [];
    // int len = globals.col * globals.row;
    // print(DateTime.now());
    //
    // for (int i = 1; i <= len; i++) {
    //   final QuerySnapshot result = await FirebaseFirestore.instance
    //       .collection('users')
    //       .doc('${globals.user}')
    //       .collection('shelf')
    //       .doc(i.toString())
    //       .collection("items")
    //       .get();
    //   final List<DocumentSnapshot> documents = result.docs;
    //
    //   documents.forEach((data) => globals.xrays.add({
    //         "id": i,
    //         "items": data.id,
    //       }));
    // }

    print(DateTime.now());
    print(globals.itemLen);

    // searchCheck();

  } on NoSuchMethodError catch (e) {
    globals.gridCheck = false;
    globals.formtest = false;
    print('exception ${e}');
  }

  print("gridcheck ");
  print(globals.gridCheck);
  print("gridchecked");

  // globals.row = row;
  // globals.col = col;

  print("space : $space");
  globals.space = space;

  var flag = 1;
  return flag;
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabController _tabController;
  final _formKey2 = GlobalKey<FormState>();

  final myController3 = TextEditingController();
  final myController4 = TextEditingController();
  List selectedValue;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController3.dispose();
    myController4.dispose();
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    gridCheck();
    globals.count = 0;
    setState(() {});
    print(globals.itemLen);
    //////////////////// set current login time ////////////////////////

    DocumentReference documentReferenceT = FirebaseFirestore.instance
        .collection("users")
        .doc(globals.user)
        .collection('dimensions')
        .doc('login');

    Map<String, dynamic> userDetail = {"time": DateTime.now()};

    documentReferenceT
        .set(userDetail)
        .whenComplete(() => print("Login data saved!!"));
  }
   refreshData(){
     setState(() {});
   }

  incrementCount() {
    globals.count++;

    setState(() {});
  }

  decrementCount() {


    if(globals.count <= 0) {

      Fluttertoast.showToast(
          backgroundColor: Colors.red,
          textColor: Colors.white,
          msg: "Count cannot be negative",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          fontSize: 16.0
      );

    }

    else{
      globals.count--;
    }
    setState(() {});
  }

  reset() async{
    print('Account reset : ${globals.user}');

      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('my_file.txt');
      await file.writeAsString("test");
      print(file.path);

    // FirebaseFirestore.instance
    //     .collection('users/${globals.user}/dimensions')
    //     .get()
    //     .then((snapshot) {
    //   for (DocumentSnapshot ds in snapshot.docs) {
    //     print(ds.id);
    //     ds.reference.delete();
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    globals.xrays = [];

    return MaterialApp(
      home: DefaultTabController(
          length: 3,
          child: Scaffold(

              // backgroundColor: Color(0xFFCAA472),   ///8b5a2b

              appBar: AppBar(
                title: Text("Architect"),
                centerTitle: true,
                backgroundColor: Color(0xFF536872),
                bottom: TabBar(
                  controller: this._tabController,
                  tabs: [
                    Tab(icon: Icon(Icons.table_rows), text: 'Closet'),
                    Tab(icon: Icon(Icons.library_add_rounded), text: 'Stats'),
                    Tab(icon: Icon(Icons.person), text: 'Profile'),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  ///////////////////////////// First Tab ////////////////////////////////

                  Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyCustomForm(),
                    ],
                  ),

                  ////////////////////////////// add new shelf ////////////////////////////////

                  Scaffold(
                    body:

                        //////////////////// Condition to check for a new user to not allow new user to expand closet ////////////////////////////

                        (globals.formtest == true)
                            ? Center(
                                child: Text(
                                    "Still waiting for the space allocation in the closet tab"))
                            : Form(
                                key: _formKey2,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(children: <Widget>[
                                      SizedBox(height: 20),

                                      Card(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceAround,
                                                children: <Widget>[
                                                  Container(
                                                    child: RawMaterialButton(
                                                      onPressed: () {
                                                        decrementCount();
                                                      },
                                                      elevation: 2.0,
                                                      child: Icon(
                                                        Icons.remove_circle,
                                                        size: 30,
                                                        color: Color(0xFF536872),
                                                      ),
                                                      padding:
                                                          EdgeInsets.all(15.0),
                                                      shape: CircleBorder(),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Text(
                                                        globals.count.toString()),
                                                  ),
                                                  Container(
                                                    child: RawMaterialButton(
                                                      onPressed: () {
                                                        incrementCount();
                                                      },
                                                      elevation: 2.0,
                                                      child: Icon(
                                                        Icons.add_circle,
                                                        size: 30,
                                                        color: Color(0xFF536872),
                                                      ),
                                                      padding:
                                                          EdgeInsets.all(15.0),
                                                      shape: CircleBorder(),
                                                    ),
                                                  )
                                                ]),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .resolveWith<Color>(
                                                  (Set<MaterialState> states) {
                                                    if (states.contains(
                                                        MaterialState.pressed))
                                                      return Color(0xFF536872);
                                                    return Color(
                                                        0xFF536872); // Use the component's default.
                                                  },
                                                ),
                                              ),
                                              onPressed: () {
                                                if (_formKey2.currentState
                                                    .validate()) {
                                                  globals.formtest = false;

                                                  // globals.ncol = 0;
                                                  // globals.nrow = 0;

                                                  globals.nspace = 0;

                                                  setState(() {});

                                                  // globals.nrow = int.parse(myController3.text);
                                                  // globals.ncol = int.parse(myController4.text);

                                                  // globals.nspace = int.parse(myController4.text);

                                                  globals.nspace = globals.count;

                                                  incrementSpace();

                                                  myController4.clear();
                                                }
                                              },
                                              child: Text('Increase your space'),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(
                                        height: 20,
                                      ),

                                      Card(
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Expanded(
                                                  child: ListTile(
                                                    title: Text('Current shelf count'),
                                                    subtitle: Text('${globals.space}'),
                                                  ),
                                                ),
                                                RawMaterialButton(
                                                  onPressed: () {
                                                    refreshData();
                                                  },
                                                  elevation: 2.0,
                                                  child: Icon(
                                                    Icons.refresh,
                                                    size: 30,
                                                    color: Color(0xFF536872),
                                                  ),
                                                  padding:
                                                  EdgeInsets.all(15.0),
                                                  shape: CircleBorder(),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),

                                      SizedBox(height: 5),

                                      Card(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                Expanded(
                                                  child: ListTile(
                                                    title: Text('Current item count'),
                                                    subtitle:
                                                    Text('${globals.itemLen}'),
                                                  ),
                                                ),
                                                RawMaterialButton(
                                                  onPressed: () {
                                                    refreshData();
                                                  },
                                                  elevation: 2.0,
                                                  child: Icon(
                                                    Icons.refresh,
                                                    size: 30,
                                                    color: Color(0xFF536872),
                                                  ),
                                                  padding:
                                                  EdgeInsets.all(15.0),
                                                  shape: CircleBorder(),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),

                                      // TextFormField(
                                      //   controller: myController3,
                                      //   decoration: new InputDecoration(
                                      //       contentPadding: EdgeInsets.only(
                                      //           left: 15, bottom: 11, top: 11, right: 15),
                                      //       hintText: "Enter the rows"),
                                      //   validator: (value) {
                                      //     if (value.isEmpty) {
                                      //       return 'Please enter rows';
                                      //     }
                                      //     return null;
                                      //   },
                                      // ),
                                      // TextFormField(
                                      //   controller: myController4,
                                      //   decoration: new InputDecoration(
                                      //       contentPadding: EdgeInsets.only(
                                      //           left: 15, bottom: 11, top: 11, right: 15),
                                      //       hintText: "Enter the columns"),
                                      //   validator: (value) {
                                      //     if (value.isEmpty) {
                                      //       return 'Please enter columns';
                                      //     }
                                      //     return null;
                                      //   },
                                      // ),
                                    ]),
                                  ),
                                )),
                  ),

                  Scaffold(
                    body: Column(
                      children: [
                        SizedBox(height: 10),
                        Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                title: Text('User'),
                                subtitle: Text('${globals.user}'),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 5),
                        Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                title: Text('To be updated'),
                                // subtitle: Text('${globals.loginTime}'),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                        Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                title: Text('To be updated'),
                                // subtitle: Text('${globals.loginTime}'),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty
                                .resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                if (states.contains(
                                    MaterialState.pressed))
                                  return Color(0xFF536872);
                                return Color(
                                    0xFF536872); // Use the component's default.
                              },
                            ),
                          ),
                          onPressed: () {
                            reset();
                          },
                          child: Text('Reset Account'),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              floatingActionButton: new FloatingActionButton(
                  elevation: 50.0,
                  child: new Icon(Icons.power_settings_new),
                  backgroundColor: new Color(0xFF536872),
                  onPressed: () {
                    context.read<AuthenticationService>().signOut();
                    globals.user = "";
                    globals.formtest = false;
                    globals.login = false;
                    globals.xrays = [];
                    globals.newUser = false;
                    print(globals.xrays);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MyApp()),
                    );
                  })

              // bottomNavigationBar: GestureDetector(
              //   child: BottomNavigationBar(
              //     currentIndex: 1,// this will be set when a new tab is tapped
              //     items: [
              //       BottomNavigationBarItem(
              //         icon: new Icon(Icons.home),
              //         label: 'Home',
              //       ),
              //       BottomNavigationBarItem(
              //         icon: new Icon(Icons.mail),
              //         label: "test"
              //       ),
              //       BottomNavigationBarItem(
              //           icon: Icon(Icons.person),
              //           label: 'Sign Out',
              //       )
              //     ],
              //   ),
              // ),

              )),
    );

    Scaffold(
      appBar: AppBar(
        title: Text("Welcome ${globals.user}"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyCustomForm(),
            RaisedButton(
              onPressed: () {
                context.read<AuthenticationService>().signOut();
                globals.user = "";
                globals.formtest = false;
                // createData();
              },
              child: Text("Sign out"),
            ),
            // RaisedButton(
            //   onPressed: () {
            //     createData();
            //   },
            //   child: Text("Create"),
            // ),
          ],
        ),
      ),
    );
  }
}

createData() {
  // DocumentReference documentReference =
  //     FirebaseFirestore.instance.collection("users").doc(globals.user).collection('dimensions').doc('col');
  //
  // Map<String, dynamic> userDetail = {
  //   "col": globals.col
  // };
  //
  // documentReference.set(userDetail).whenComplete(() => print("Col created!!"));
  //
  // DocumentReference documentReference2 =
  // FirebaseFirestore.instance.collection("users").doc(globals.user).collection('dimensions').doc('row');
  //
  // Map<String, dynamic> userDetail2 = {
  //   "row": globals.row
  // };
  //
  // documentReference2.set(userDetail2).whenComplete(() => print("Row created!!"));

  DocumentReference documentReference = FirebaseFirestore.instance
      .collection("users")
      .doc(globals.user)
      .collection('dimensions')
      .doc('space');

  Map<String, dynamic> userDetail = {"space": globals.space};

  documentReference
      .set(userDetail)
      .whenComplete(() => print("Space created!!"));

  print("${globals.user} logged in at ${DateTime.now()}");
  globals.loginTime = DateTime.now();
  globals.newUser = false;
  setShelf();
}

setShelf() {
  // var len = (globals.col * globals.row);

  var len = globals.space;
  print(len);

  //////////////////   old code //////////////////////
  // // if (len < 10) {
  // for (int i = 1; i <= len; i++) {
  //   DocumentReference documentReference = FirebaseFirestore.instance
  //       .collection("users")
  //       .doc('${globals.user}/shelf/' + '$i');
  //
  //   Map<String, dynamic> userDetail = {
  //     "name": 'test',
  //     "count": 0,
  //     "index": int.parse('$i')
  //   };
  //
  //   documentReference
  //       .set(userDetail)
  //       .whenComplete(() => print("Shelf created!!"));
  //
  //   ///////////////////////////// to create a new empty doc ////////////////////////////////
  //
  //   // final CollectionReference postsRef = FirebaseFirestore.instance.collection('users/${globals.user}/shelf/$i/items/');
  //   //
  //   // Map<String, dynamic> listDetail = {
  //   //   // "name": name,
  //   //   // "index": int.parse('$i')
  //   // };
  //   //
  //   // postsRef.doc("list").set(listDetail);
  //
  // }

  DocumentReference documentReference =
      FirebaseFirestore.instance.collection("users").doc(globals.user);

  Map<String, dynamic> arrayDetail = {
    "1": [],
  };

  documentReference
      .set(arrayDetail)
      .whenComplete(() => print("Shelf created!!"));

  for (int i = 2; i <= len; i++) {
    Map<String, dynamic> arrayDetail = {
      i.toString(): [],
    };

    documentReference
        .update(arrayDetail)
        .whenComplete(() => print("Shelf created!!"));
  }
}

incrementSpace() {
  //////////////////////// to calculate current length /////////////////////

  // var olen = (globals.col * globals.row);
  // var len = (globals.ncol * globals.nrow);

  var olen = globals.space;

  var len = globals.nspace;

  print("New length demanded is $len");

  DocumentReference documentReference =
      FirebaseFirestore.instance.collection("users").doc(globals.user);

  for (int i = (olen + 1); i <= (olen + len); i++) {
    Map<String, dynamic> arrayDetail = {
      i.toString(): [],
    };

    documentReference
        .update(arrayDetail)
        .whenComplete(() => print("Shelf increased !!"));
  }

  // globals.row = 2;    ////// keeping row constant after space increment
  //
  // globals.col = globals.col + globals.ncol;

  // DocumentReference documentReference3 =
  // FirebaseFirestore.instance.collection("users").doc(globals.user).collection('dimensions').doc('col');
  //
  // Map<String, dynamic> userDetail = {
  //   "col": globals.col
  // };
  //
  // documentReference3.set(userDetail).whenComplete(() => print("Col created!!"));
  //
  // DocumentReference documentReference4 =
  // FirebaseFirestore.instance.collection("users").doc(globals.user).collection('dimensions').doc('row');
  //
  // Map<String, dynamic> userDetail2 = {
  //   "row": globals.row
  // };
  //
  // documentReference4.set(userDetail2).whenComplete(() => print("Row created!!"));

  globals.space = globals.space + globals.nspace;

  DocumentReference documentReference4 = FirebaseFirestore.instance
      .collection("users")
      .doc(globals.user)
      .collection('dimensions')
      .doc('space');

  Map<String, dynamic> userDetail2 = {"space": globals.space};

  documentReference4
      .set(userDetail2)
      .whenComplete(() => print("Space updated !!"));

  print("${globals.user} updated space at ${DateTime.now()}");

  print(globals.space);

  globals.count = 0;
}

setItemName(i, name) {
  FirebaseFirestore.instance
      .collection("users")
      .doc('${globals.user}/shelf/${(i + 1).toString()}')
      .update({"name": name});
}

incrementShelf(i) {
  print(globals.user);

  FirebaseFirestore.instance
      .collection("users")
      .doc('${globals.user}/shelf/${(i + 1).toString()}')
      .update({"count": FieldValue.increment(1)});
}

decrementShelf(i) {
  print(globals.user);

  // DocumentReference documentReference =
  FirebaseFirestore.instance
      .collection("users")
      .doc('${globals.user}/shelf/${(i + 1).toString()}')
      .update({"count": FieldValue.increment(-1)});
}

resetShelf(i) {
  print(globals.user);

  // DocumentReference documentReference =
  FirebaseFirestore.instance
      .collection("users")
      .doc('${globals.user}/shelf/${(i + 1).toString()}')
      .update({"count": 0});
}



class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();

  final myController1 = TextEditingController();
  final myController2 = TextEditingController();
  List selectedValue;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController1.dispose();
    myController2.dispose();
    super.dispose();
  }

  incrementCount() {
    globals.count++;

    setState(() {});
  }

  decrementCount() {
    globals.count--;

    setState(() {});
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("${globals.search[0]["items"]}"),
      content: Text("Location : Shelf ${globals.search[0]["id"]}"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        globals.search = [];
        return alert;
      },
    );
  }
  @override
  Widget build(BuildContext context) {


    return Expanded(
      child: Column(
        children: <Widget>[
          // (globals.gridCheck == false && globals.formtest == false)
          (globals.formtest == true && globals.gridCheck == true)
              ? Form(
                  key: _formKey,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(children: <Widget>[
                        // TextFormField(
                        //   controller: myController1,
                        //   decoration: new InputDecoration(
                        //       contentPadding: EdgeInsets.only(
                        //           left: 15, bottom: 11, top: 11, right: 15),
                        //       hintText: "Enter the rows"),
                        //   validator: (value) {
                        //     if (value.isEmpty) {
                        //       return 'Please enter rows';
                        //     }
                        //     return null;
                        //   },
                        // ),
                        // TextFormField(
                        //   controller: myController2,
                        //   decoration: new InputDecoration(
                        //       contentPadding: EdgeInsets.only(
                        //           left: 15, bottom: 11, top: 11, right: 15),
                        //       hintText: "Enter the columns"),
                        //   validator: (value) {
                        //     if (value.isEmpty) {
                        //       return 'Please enter columns';
                        //     }
                        //     return null;
                        //   },
                        // ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
                                child: RawMaterialButton(
                                  onPressed: () {
                                    decrementCount();
                                  },
                                  elevation: 2.0,
                                  child: Icon(
                                    Icons.remove_circle,
                                    size: 30,
                                    color: Color(0xFF536872),
                                  ),
                                  padding: EdgeInsets.all(15.0),
                                  shape: CircleBorder(),
                                ),
                              ),
                              Container(
                                child: Text(globals.count.toString()),
                              ),
                              Container(
                                child: RawMaterialButton(
                                  onPressed: () {
                                    incrementCount();
                                  },
                                  elevation: 2.0,
                                  child: Icon(
                                    Icons.add_circle,
                                    size: 30,
                                    color: Color(0xFF536872),
                                  ),
                                  padding: EdgeInsets.all(15.0),
                                  shape: CircleBorder(),
                                ),
                              )
                            ]),

                        // TextFormField(
                        //   controller: myController1,
                        //   decoration: new InputDecoration(
                        //       contentPadding: EdgeInsets.only(
                        //           left: 15, bottom: 11, top: 11, right: 15),
                        //       hintText: "Enter the shelves"),
                        //   validator: (value) {
                        //     if (value.isEmpty) {
                        //       return 'Please enter valid values';
                        //     }
                        //     return null;
                        //   },
                        // ),

                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed))
                                  return Color(0xFF536872);
                                return Color(
                                    0xFF536872); // Use the component's default.
                              },
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              globals.formtest = false;
                              setState(() {});

                              // globals.row = int.parse(myController1.text);
                              // globals.col = int.parse(myController2.text);

                              // globals.space = int.parse(myController1.text);
                              globals.space = globals.count;
                              globals.count = 0;
                              setState(() {});
                              createData();

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()),
                              );
                            }
                          },
                          child: Text('Generate your space !!'),
                        )
                      ]),
                    ),
                  ))

              ////////////////////////////
              :
              ////////////////////////////

              FutureBuilder(
                  future: gridCheck(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Expanded(
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Container(
                                      child: Tab(icon: Icon(Icons.search)),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SearchableDropdown(
                                        hint: "Shelf items search",
                                        items: globals.xrays.map((item) {
                                          return new DropdownMenuItem(
                                            child:
                                                Text(item["items"].toString()),
                                            value: item,
                                          );
                                        }).toList(),
                                        isExpanded: true,
                                        isCaseSensitiveSearch: true,
                                        searchHint: new Text(
                                          'Search for the item',
                                          style: new TextStyle(fontSize: 20),
                                        ),
                                        onChanged: (value) {
                                          globals.search = [];
                                          globals.search.add(value);
                                          showAlertDialog(context);
                                        },
                                      ),
                                    ),
                                  ),
                                ]),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: GridView.count(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              crossAxisCount: 2,
                              children: List.generate(
                                  // globals.col * globals.row,
                                  globals.space, (index) {
                                return InkWell(
                                  //////////////////////////////// to open a new shelf //////////////////////////////

                                  onTap: () {
                                    print("tapped shelf ${index + 1}");
                                    globals.shelfItem.add("${index + 1}");
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ShelfItem()),
                                    );
                                  },

                                  //////////////////////////////////////////////////////////////////////////////////

                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Card(
                                      color: Color(0xFF96ceb4),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Center(
                                          child: Text(
                                            'Shelf ${index + 1}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // onTap: () {
                                  //   globals.shelf = index + 1;
                                  //   setShelf();
                                  //   print(globals.row);
                                  //   // setState(() {
                                  //   //   print(index);
                                  //   // });
                                  // },
                                );
                              }),
                            ),
                          ),
                        ]),
                      );
                    } else {
                      return Expanded(
                        child: Material(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 20),
                                Text("Loading your closet ...")
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  })

          // Expanded(
          //           child: GridView.count(
          //             crossAxisCount: 1,
          //             children: List.generate(
          //                 int.parse(globals.col.toString()) *
          //                     int.parse(globals.row.toString()), (index) {
          //               return
          //                   InkWell(
          //                 child: Center(
          //                   child: Text(
          //                     'Shelf ${index + 1}',
          //                     style: Theme.of(context).textTheme.headline5,
          //                   ),
          //                 ),
          //                 onTap: () {
          //                   globals.shelf = index + 1;
          //                   setShelf();
          //                   showDialog(
          //                       context: context,
          //                       child: new AlertDialog(
          //                         title: new Text('Shelf ${index + 1}'),
          //                         content: new Text("Items"),
          //                       ));
          //                   print(globals.row);
          //                   // setState(() {
          //                   //   print(index);
          //                   // });
          //                 },
          //               );
          //             }),
          //           ),
          //         )
        ],
      ),
    );
  }
}

// class xray {
//   int id;
//   String name;
//   String count;
//
//   xray({this.id, this.name, this.count});
//
//   @override
//   String toString() {
//     return '$id $name $count';
//   }
// }

/////////////////////////// earlier code to display and edit count ///////////////////////////////

// Center(
//   child: new Row(
//     mainAxisAlignment:
//     MainAxisAlignment
//         .spaceEvenly,
//     children: [
//
//
//
//       // new RaisedButton(
//       //   child: Text('Add Item'),
//       //   color: Colors.orange,
//       //   onPressed: () {
//       //     // addItem(index);
//       //   },
//       // ),
//
//       //////////////////////////////////// code to have count and increment //////////////////////////////////////
//
//       // Expanded(
//       //   child: new RaisedButton(
//       //     shape: CircleBorder(),
//       //     child: Icon(
//       //       Icons.add,
//       //       size: 20.0,
//       //       color: Colors.white,
//       //     ),
//       //     color: Colors.blue,
//       //     onPressed: () {
//       //       incrementShelf(index);
//       //     },
//       //   ),
//       // ),
//       // new StreamBuilder(
//       //   stream: FirebaseFirestore
//       //       .instance
//       //       .collection("users")
//       //       .doc(globals.user)
//       //       .collection('shelf')
//       //       .orderBy("index")
//       //       .snapshots(),
//       //   // ignore: missing_return
//       //   builder:
//       //       (context, snapshot) {
//       //     if (!snapshot.hasData) {
//       //     if (!snapshot.hasData) {
//       //       return Text(
//       //         'No Data...',
//       //       );
//       //     } else {
//       //       int ind = int.parse(
//       //           index
//       //               .toString()
//       //               .padLeft(
//       //               2, '0'));
//       //       print(ind);
//       //       print("ind");
//       //       return Text(
//       //         '${snapshot.data.docs[index]["count"]}',
//       //       );
//       //     }
//       //   },
//       // ),
//       // Expanded(
//       //   child: new RaisedButton(
//       //     shape: CircleBorder(),
//       //     child: Icon(
//       //       Icons.remove,
//       //       size: 20.0,
//       //       color: Colors.white,
//       //     ),
//       //     color: Colors.blue,
//       //     onPressed: () {
//       //       decrementShelf(index);
//       //     },
//       //   ),
//       // ),
//     ],
//   ),
// ),

////////////////// code to reset count ///////////////////

// new RaisedButton(
//   child: Text('Reset'),
//   color: Colors.orange,
//   onPressed: () {
//     resetShelf(index);
//   },
// ),
