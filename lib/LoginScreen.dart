import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'HomeScreen.dart';

/*Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}*/

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GATE APP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'LOGIN'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextStyle style = TextStyle(fontFamily: "JosefinSans", fontSize: 20.0);

  TextEditingController emailController;
  TextEditingController passwordController;
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {

    FirebaseAuth.instance
        .authStateChanges()
        .listen((User user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
        Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage()),);
      }
    });

    final emailField = TextField(
      controller: emailController,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Email",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final passwordField = TextField(
      controller: passwordController,
      obscureText: true,
      style: style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Password",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.lightBlue,
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () {
            if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
              loginFirebaseUser(emailController.text,passwordController.text);
           }
          },
          child: Text("LOGIN",
              textAlign: TextAlign.center,
              style: style.copyWith(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ));

    return Scaffold(
      backgroundColor: Colors.white,
      body:Container(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(36.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.sensor_door_outlined,
                color: Colors.black,
                size: 80,
              ),
              SizedBox(height: 20.0),
              Text(
                'SlidGate',
                style: TextStyle(color: Colors.lightBlue,fontWeight: FontWeight.bold,fontSize: 30),
              ),
              SizedBox(height: 40.0),
              emailField,
              SizedBox(height: 20.0),
              passwordField,
              SizedBox(height: 40.0),
              loginButton,
            ],
          ),
        ),
      ),
    );

  }

  loginFirebaseUser(String userName, String password) async {
    try {
      print("userName $userName");
      print("password $password");
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: userName.trim(),
          password: password.trim()
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        Fluttertoast.showToast(msg: "No user found for that email.");
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        Fluttertoast.showToast(msg: "Wrong password provided for that user.");
      } else {
        print("Error: ${e.code} $e");
        Fluttertoast.showToast(msg: "${e.message}");
      }
    }
  }

}
