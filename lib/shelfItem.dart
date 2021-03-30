import 'dart:io';
import 'dart:math';
import 'package:architect/home_page.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'authentication_service.dart';
import 'globals.dart' as globals;import 'package:fluttertoast/fluttertoast.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';


/////////////////////////////// Get shelf items from shelf/items endpoint ///////////////////////////////

Future getShelfItem() async {


  int col;
  int row;
  int flag;
  int count;
  List shelf_array = [];

  globals.shelfList = [];

  try {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .doc('${globals.user}/shelf/${globals.shelfItem[0]}')
        .collection("items")
        .get();


    final List<DocumentSnapshot> documents = result.docs;

    documents.forEach((data) => globals.shelfList.add(data.id));

    // result.forEach((data) => globals.shelfList.add(data.id));

    print(globals.shelfList);

    int len = globals.col * globals.row;
    for(int i = 1; i<= len; i++) {

      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .doc('${globals.user}')
          .collection('shelf').doc(i.toString()).collection("items")
          .get();
      final List<DocumentSnapshot> documents = result.docs;


      documents.forEach((data) => globals.listItems.add(
            data.id,
      )

      );

    }

    if (globals.shelfList.length == 0) {
      return globals.shelfList = ["No Item"];
    }
    return globals.shelfList;
  } on RangeError catch (e) {
    print('exception');
  } on NoSuchMethodError catch (e) {
    print('exception');
  }
}

addShelfItem(name) {

  // final CollectionReference postsRef = FirebaseFirestore.instance
  //     .collection('users/${globals.user}/shelf/${globals.shelfItem[0]}/items/');
  //
  // Map<String, dynamic> listDetail = {
  //   // "name": name,
  //   // "index": int.parse('$i')
  // };

  final CollectionReference postsRef = FirebaseFirestore.instance
      .collection('users');

  Map<String, dynamic> listDetail = {
    globals.shelfItem[0] : FieldValue.arrayUnion([name])
    // "index": int.parse('$i')
  };

  ////// to update item already existing
  print(globals.xraysValue);

    if(globals.xraysValue.contains(name)){
      Fluttertoast.showToast(
          backgroundColor: Colors.red,
          textColor: Colors.white,
          msg: "Item already exists",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          fontSize: 16.0
      );
    }
    else {
      postsRef.doc('${globals.user}').update(listDetail);
    }

  // postsRef.doc(name).set(listDetail);


    //////////// to instantly update xrays ////////////////////////

  // globals.xrays.add({
  //   "id": globals.shelfItem[0],
  //   "items": name,
  // });

  ///////////////////////// to create values with random keys for a document ////////////////////////////////////////////

  // var rng = new Random();
  //
  //   DocumentReference documentReference = FirebaseFirestore.instance
  //       .collection("users")
  //       .doc('${globals.user}/shelf/${globals.shelfItem[0]}/items/list');
  //
  //   Map<String, dynamic> userDetail = {
  //     rng.nextInt(1000).toString() : name,
  //     // "index": int.parse('$i')
  //   };
  //
  //   documentReference.update(userDetail).whenComplete(() => print("Item added !!"));
}

deleteItem(name) {

  // final CollectionReference postsRef = FirebaseFirestore.instance
  //     .collection('users/${globals.user}/shelf/${globals.shelfItem[0]}/items/');
  //
  // postsRef.doc(name).delete();

  print(name);

  final CollectionReference postsRef = FirebaseFirestore.instance
      .collection('users');

  Map<String, dynamic> listDetail = {
    globals.shelfItem[0] : FieldValue.arrayRemove([name])
    // "index": int.parse('$i')
  };

  postsRef.doc('${globals.user}').update(listDetail);
  globals.xrays.remove(name);

}

class ShelfItem extends StatefulWidget {
  @override
  _ShelfItemState createState() => _ShelfItemState();
}

class _ShelfItemState extends State<ShelfItem> {
  final TextEditingController itemController = TextEditingController();

  @override
  initState() {
    super.initState();
    getShelfItem();
  }

  @override
  Widget build(BuildContext context) {

    showAlertDialog(BuildContext context) {
      // set up the button
      Widget okButton = FlatButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.pop(context);
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
    return Scaffold(
        appBar: AppBar(
          title: Text("Shelf items"),
          centerTitle: true,
          backgroundColor: Color(0xFF536872),
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: itemController,
                            decoration: InputDecoration(
                              labelText: "Item name",
                            ),
                          ),
                        ),
                        new RaisedButton(
                          child: new Icon(Icons.add, color: Colors.white,
                            size: 20,),
                          color: Color(0xFF536872),
                          onPressed: () {
                            addShelfItem(itemController.text.trim());
                            itemController.clear();
                          },
                        ),
                      ]),
                ),

                SizedBox(height: 20),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc('${globals.user}')
                      // .collection('shelf')
                      // .doc(globals.shelfItem[0])
                      // .collection("items")
                  // .get().asStream(),
                      .snapshots(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      default:
                        return Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data[globals.shelfItem[0]].length,
                            itemBuilder: (context, index) {
                              return Card(
                                color: Color(0xFF96ceb4),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                            snapshot.data[globals.shelfItem[0]][index].toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5,
                                          ),
                                        ),
                                        IconButton(
                                          icon: new Icon(Icons.delete),
                                          onPressed: (){

                                            deleteItem(snapshot.data[globals.shelfItem[0]][index].toString());

                                            },

                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                    }
                  },
                ),
                new RaisedButton(
                  child: Text('Back',  style: TextStyle(color: Colors.white),),
                  color: Color(0xFF536872),
                  onPressed: () {
                    globals.shelfItem = [];
                    globals.xraysValue = [];
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );

                  },
                ),
              ],
            ),
          ),
        ));
  }
}
