import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PomodoroScreen(),
    );
  }
}

class PomodoroScreen extends StatefulWidget {
  @override
  _PomodoroScreenState createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  int _minutes = 25;
  int _seconds = 0;
  bool _isRunning = false;
  late Timer _timer;

  void _startTimer() {
    setState(() {
      _isRunning = true;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_minutes == 0 && _seconds == 0) {
        _stopTimer();
        _minutes = 25;
        _seconds = 0;
      } else if (_seconds == 0) {
        setState(() {
          _minutes--;
          _seconds = 59;
        });
      } else {
        setState(() {
          _seconds--;
        });
      }
    });
  }

  void _stopTimer() {
    setState(() {
      _isRunning = false;
    });
    _timer.cancel();
  }

  void _takeaBrake() {
    setState(() {
      _minutes = 5;
      _seconds = 0;
    });
  }

  void _setTimer(int minutes) {
    setState(() {
      _minutes = minutes;
      _seconds = 0;
    });
    if (_isRunning) {
      _stopTimer();
    }
  }

  void _resetTimer() {
    if (_isRunning) {
      _stopTimer();
    }
    setState(() {
      _minutes = 25;
      _seconds = 0;
    });
  }

  void _toggleTimer() {
    if (!_isRunning) _startTimer();
  }

  void _showRunningAlert() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Warning'),
          content: Text(
              'Timer is on. You can\'t leave until alarm goes off. Please stay focused!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _onWillPop() async {
    if (_isRunning) {
      _showRunningAlert();
      return false; // Prevent the back button from closing the app
    }
    return true; // Allow the back button to close the app
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Stay Focused',
            style: TextStyle(color: Colors.white),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: SweepGradient(
                colors: [
                  Color(0xffffffff),
                  Color(0xff1e9ddc),
                  Color(0xff4cd68f)
                ],
                stops: [0, 0.5, 1],
                center: Alignment.bottomLeft,
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFa6a6a6).withOpacity(1),
                  offset: Offset(0, 8),
                  blurRadius: 50,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: SweepGradient(
              colors: [Color(0xff629d96), Color(0xff77c6ee), Color(0xff59a67e)],
              stops: [0, 0.5, 1],
              center: Alignment.center,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF979393).withOpacity(1),
                            offset: Offset(0, 0),
                            blurRadius: 50,
                            spreadRadius: -3,
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _takeaBrake,
                        child: Text('Take a Brake'),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF979393).withOpacity(1),
                            offset: Offset(0, 0),
                            blurRadius: 50,
                            spreadRadius: -3,
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () => _setTimer(15),
                        child: Text('15 min'),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF979393).withOpacity(1),
                            offset: Offset(0, 0),
                            blurRadius: 50,
                            spreadRadius: -3,
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () => _setTimer(30),
                        child: Text('30 min'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  '$_minutes:${_seconds.toString().padLeft(2, '0')}',
                  style: TextStyle(fontSize: 132, color: Colors.white),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (_isRunning) {
                          _showRunningAlert();
                        }
                      },
                      child: AbsorbPointer(
                        absorbing: _isRunning,
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF979393).withOpacity(1),
                                offset: Offset(0, 0),
                                blurRadius: 50,
                                spreadRadius: -3,
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _isRunning ? null : _startTimer,
                            child: Text('Start'),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF979393).withOpacity(1),
                            offset: Offset(0, 0),
                            blurRadius: 50,
                            spreadRadius: -3,
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _resetTimer,
                        child: Text('Reset'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
