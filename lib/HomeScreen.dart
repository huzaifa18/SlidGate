import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:analytics/analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'SettingScreen.dart';
import 'GateOptionsScreen.dart';
import 'ImageScreen.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  var gateSpeed = "Medium";
  var status1="on";
  var status2="off";
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final fdb = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {

    FirebaseAuth.instance
        .authStateChanges()
        .listen((User user) {
      if (user == null) {
        print('User is currently signed out!');
        Navigator.pop(context);
      } else {
        print('User is signed in!');
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('GATE APP'),
        centerTitle: true,
        leading:  IconButton(
            onPressed:() {
              showAlertDialog(context);
            },
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            )
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(height: 20.0),
            /*Align(
              alignment: Alignment.topLeft,
              child: RaisedButton.icon(
                materialTapTargetSize: MaterialTapTargetSize.padded,
                onPressed: () {
                  //fdb.child('Gate').child('GateStatus').set(status2);
                  //print(status2);
                },
                color: Colors.blueGrey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                label: Text(
                  'Logout',
                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                ),
              ),
            ),*/
            SizedBox(height: 100.0),
            Align(
              alignment: Alignment.center,
              child: RaisedButton.icon(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => GateOptionsPage()),);
                },
                color: Colors.lightBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                icon: Icon(
                  Icons.sensor_door_outlined,
                  color: Colors.white,
                ),
                label: Text(
                  'Gate Options',
                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Align(
              alignment: Alignment.center,
              child: RaisedButton.icon(
                materialTapTargetSize: MaterialTapTargetSize.padded,
                onPressed: () {
                  //fdb.child('Gate').child('GateStatus').set(status2);
                  getImage(context);
                  //print(status2);
                },
                color: Colors.lightBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                icon: Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white,
                ),
                label: Text(
                  'Image',
                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Signout"),
      onPressed:  () {
        _signOut();
        Navigator.pop(context);
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pop(context);
        });
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text("Are you sure you want to signout?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}

void getImage(BuildContext context) async {
  final ref = FirebaseStorage.instance.ref().child('gate_image.PNG');
  var url = await ref.getDownloadURL();

  if (url!=null){
    Navigator.push(context, new MaterialPageRoute(builder: (context) => new ImageScreen(imageUrl: url)));
  }
  print(url);
}
