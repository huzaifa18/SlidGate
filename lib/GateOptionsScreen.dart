import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';
import 'package:analytics/analytics.dart';

import 'SettingScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(GateOptionsPage());
}

class GateOptionsPage extends StatefulWidget {
  @override
  _GateOptionsPageState createState() => _GateOptionsPageState();
}

class _GateOptionsPageState extends State<GateOptionsPage>
    with TickerProviderStateMixin {
  var close = 0;
  var open = 100;
  var openForOne = 75;
  var openForThree = 25;
  var _value = 100.0;
  var _status = "Closed";
  var _statusColor = Colors.red;
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final fdb = FirebaseDatabase.instance.reference();

  AnimationController _animationController;
  Animation _animation;

  var xAxisStart = 0.0;
  var xAxisEnd = 0.01;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    _animation =
        Tween<Offset>(begin: Offset(xAxisStart, 0), end: Offset(xAxisEnd, 0))
            .animate(_animationController);
    _animationController.forward().whenComplete(() {
      // when animation completes, put your code here
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GATE Options'),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.chevron_left,
              color: Colors.white,
            )),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: RaisedButton.icon(
                onPressed: () {
                  setGateStatus(openForOne);
                  _value = 75.0;
                  _status = 'Open (${_value.round()})';
                  _statusColor = Colors.green;
                  xAxisStart = -0.25;
                  xAxisEnd = 0.0;
                  _animationController = AnimationController(
                      vsync: this, duration: Duration(seconds: 3));
                  _animation = Tween<Offset>(
                          begin: Offset(xAxisStart, 0),
                          end: Offset(xAxisEnd, 0))
                      .animate(_animationController);
                  setState(() {});
                },
                color: Colors.lightBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                icon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                label: Text(
                  'Open for 1 person',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Align(
              alignment: Alignment.center,
              child: RaisedButton.icon(
                materialTapTargetSize: MaterialTapTargetSize.padded,
                onPressed: () {
                  setGateStatus(openForThree);
                  _value = 25.0;
                  _status = 'Open (${_value.round()})';
                  _statusColor = Colors.green;
                  xAxisStart = -0.75;
                  xAxisEnd = 0.0;
                  _animationController = AnimationController(
                      vsync: this, duration: Duration(seconds: 3));
                  _animation = Tween<Offset>(
                          begin: Offset(xAxisStart, 0),
                          end: Offset(xAxisEnd, 0))
                      .animate(_animationController);
                  setState(() {});
                },
                color: Colors.lightBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                icon: Icon(
                  Icons.people_alt_outlined,
                  color: Colors.white,
                ),
                label: Text(
                  'Open for 3 person',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Align(
              alignment: Alignment.center,
              child: RaisedButton.icon(
                materialTapTargetSize: MaterialTapTargetSize.padded,
                onPressed: () {
                  setGateStatus(open);
                  _value = 0.0;
                  _status = 'Open (${_value.round()})';
                  _statusColor = Colors.green;
                  xAxisStart = -0.9;
                  xAxisEnd = 0.0;
                  _animationController = AnimationController(
                      vsync: this, duration: Duration(seconds: 3));
                  _animation = Tween<Offset>(
                          begin: Offset(xAxisStart, 0),
                          end: Offset(xAxisEnd, 0))
                      .animate(_animationController);
                  setState(() {});
                },
                color: Colors.lightBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                icon: Icon(
                  Icons.open_in_full,
                  color: Colors.white,
                ),
                label: Text(
                  'Full Gate Open',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Align(
              alignment: Alignment.center,
              child: RaisedButton.icon(
                materialTapTargetSize: MaterialTapTargetSize.padded,
                onPressed: () {
                  setGateStatus(close);
                  _value = 100.0;
                  _status = 'Close (${_value.round()})';
                  _statusColor = Colors.red;
                  xAxisStart = 0.0;
                  xAxisEnd = 0.0;
                  _animationController = AnimationController(
                      vsync: this, duration: Duration(seconds: 3));
                  _animation = Tween<Offset>(
                          begin: Offset(xAxisStart, 0),
                          end: Offset(xAxisEnd, 0))
                      .animate(_animationController);
                  setState(() {});
                },
                color: Colors.lightBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                icon: Icon(
                  Icons.close_fullscreen,
                  color: Colors.white,
                ),
                label: Text(
                  'Close The Door',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Align(
              alignment: Alignment.center,
              child: SlideTransition(
                position: _animation,
                child: AnimatedContainer(
                  alignment: Alignment.topLeft,
                  duration: Duration(seconds: 0),
                  child: Image(
                    image: AssetImage('assets/sliding_gate.png'),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Align(
              alignment: Alignment.center,
              child: SliderTheme(
                  data: SliderThemeData(
                    thumbColor: Colors.blue.withOpacity(0.5),
                    activeTrackColor: Colors.blue.withOpacity(0.5),
                    inactiveTrackColor: Colors.blueGrey.withOpacity(0.5),
                  ),
                  child: Slider(
                    min: 0.0,
                    max: 100.0,
                    value: _value,
                    divisions: 4,
                    onChanged: (value) {
                      setState(() {
                        _value = value;
                        _status = 'Open (${_value.round()})';
                        _statusColor = Colors.green;
                      });
                    },
                    onChangeStart: (value) {
                      setState(() {
                        _status = 'Open';
                        _statusColor = Colors.lightGreen;
                      });
                    },
                    onChangeEnd: (value) {
                      setState(() {
                        setGateStatus(value.toInt());
                        if (value == 0.0) {
                          _status = 'Open';
                          _statusColor = Colors.green;
                          xAxisStart = -0.9;
                          xAxisEnd = 0.0;
                          _animationController = AnimationController(
                              vsync: this, duration: Duration(seconds: 3));
                          _animation = Tween<Offset>(
                                  begin: Offset(xAxisStart, 0),
                                  end: Offset(xAxisEnd, 0))
                              .animate(_animationController);
                        } else if (value == 100.0) {
                          _status = 'Closed';
                          _statusColor = Colors.red;
                          xAxisStart = 0.0;
                          xAxisEnd = 0.0;
                          _animationController = AnimationController(
                              vsync: this, duration: Duration(seconds: 3));
                          _animation = Tween<Offset>(
                                  begin: Offset(xAxisStart, 0),
                                  end: Offset(xAxisEnd, 0))
                              .animate(_animationController);
                        } else {
                          _status = 'Open ${value.round()}%';
                          _statusColor = Colors.blue;
                          xAxisStart = -(100 - value.round()) / 100;
                          xAxisEnd = 0.0;
                          _animationController = AnimationController(
                              vsync: this, duration: Duration(seconds: 3));
                          _animation = Tween<Offset>(
                                  begin: Offset(xAxisStart, 0),
                                  end: Offset(xAxisEnd, 0))
                              .animate(_animationController);
                        }
                      });
                    },
                  )),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Status: $_status',
                style: TextStyle(color: _statusColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void setGateStatus(int status) async {
    await fdb.set({
      "Gate": {"GateStatus": status, "RetakePhoto": false}
    });
  }
}
