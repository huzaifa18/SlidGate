import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageScreen extends StatefulWidget {
  final String imageUrl;
  ImageScreen({Key key, @required this.imageUrl}) : super(key: key);
  @override
  _ImageScreenPageState createState() => _ImageScreenPageState(imageUrl: imageUrl);
}

class _ImageScreenPageState extends State<ImageScreen> {

  final String imageUrl;
  _ImageScreenPageState({Key key, @required this.imageUrl});

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final fdb = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    print("URL: $imageUrl");
    return new Scaffold(
      appBar: AppBar(
        title: const Text('Image'),
        centerTitle: true,
        leading:  IconButton(
            onPressed:() {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.chevron_left,
              color: Colors.white,
            )
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height-100,
        width: MediaQuery.of(context).size.width-10,
        child: Column(
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.contain,
              height: MediaQuery.of(context).size.height-200,
              width: MediaQuery.of(context).size.width-20,
              alignment: Alignment.center,
            ),
            Align(
              alignment: Alignment.center,
              child: RaisedButton.icon(
                onPressed: () {
                  fdb.child('Gate').child('RetakePhoto').set(true);
                  Future.delayed(Duration(seconds: 3), () {
                    setState(() {
                      //fdb.child('Gate').child('RetakePhoto').set(false);
                    });
                  });
                },
                color: Colors.lightBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                icon: Icon(
                  Icons.photo_camera_outlined,
                  color: Colors.white,
                ),
                label: Text(
                  'Retake',
                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}