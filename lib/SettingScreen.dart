import 'package:flutter/material.dart';

import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreen createState() => _SettingScreen();
}
class _SettingScreen extends State<SettingScreen> {
  var gateSpeed = "Medium";
  var status1="on";
  var status2="off";
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final fdb = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

      appBar: AppBar(
        title: const Text('Setting'),
        centerTitle: true,

      ),
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/17545.jpg'),
              fit:BoxFit.cover,
            )

        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DropdownButton<String>(

              value: gateSpeed,
              style: const TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.bold),
              underline: Container(
                height: 2,
                color: Colors.lightGreen,
              ),
              onChanged: (String newValue) {
                setState(() {
                  gateSpeed = newValue;
                  print(newValue);
                });
              },
              items: <String>["Low", "Medium", "Fast"]
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text("Speed: $value"),
                );
              }).toList(),
            ),
            RaisedButton.icon(
              onPressed: () async{
                fdb.child('Gate').child('GateSpeed').set(gateSpeed);
                FirebaseDatabase database = FirebaseDatabase.instance;
                DatabaseReference myRef = database.reference();

                myRef.child('GateSpeed').set("Hello, World!");

                print(gateSpeed);

              },
              color: Colors.lightBlue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              icon: Icon(
                Icons.shutter_speed,
                color: Colors.white,
              ),
              label: Text(
                'Set Speed',
                style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 100.0),


          ],
        ),
      ),
    );
  }
}
