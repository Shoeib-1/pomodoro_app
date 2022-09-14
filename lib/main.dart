import 'dart:async';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Pomodoro(),
    );
  }
}

class Pomodoro extends StatefulWidget {
  const Pomodoro({Key? key}) : super(key: key);

  @override
  State<Pomodoro> createState() => _PomodoroState();
}

class _PomodoroState extends State<Pomodoro> {
  Timer? repeatedFunc;
  Duration duration = Duration(minutes: 25);

  startTimer() {
    repeatedFunc = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        int newSecond = duration.inSeconds - 1;
        duration = Duration(seconds: newSecond);
        if (duration.inSeconds == 0) {
          repeatedFunc!.cancel();
          setState(() {
            duration = Duration(minutes: 25);
            isRunning = false;
          });
        }
      });
    });
  }

  bool isRunning = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Pomodoro App",
            style: TextStyle(color: Colors.white, fontSize: 27),
          ),
          backgroundColor: Colors.redAccent,
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularPercentIndicator(
                  backgroundColor: Color.fromARGB(47, 255, 255, 255),
                  progressColor: Colors.red,
                  radius: 140.0,
                  lineWidth: 9.0,
                  percent: duration.inMinutes / 25,
                  animation: true,
                  animateFromLastPercent: true,
                  animationDuration: 250,
                  center: Text(
                    "${duration.inMinutes.remainder(60).toString().padLeft(2, "0")}:${duration.inSeconds.remainder(60).toString().padLeft(2, "0")}",
                    style: TextStyle(color: Colors.red, fontSize: 77),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            isRunning
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (repeatedFunc!.isActive) {
                            setState(() {
                              repeatedFunc!.cancel();
                            });
                          } else {
                            startTimer();
                          }
                        },
                        child: Text(
                          (repeatedFunc!.isActive) ? "Stop " : "Resume",
                          style: TextStyle(fontSize: 19),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.redAccent),
                          padding:
                              MaterialStateProperty.all(EdgeInsets.all(12)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          repeatedFunc!.cancel();
                          setState(() {
                            duration = Duration(minutes: 25);
                            isRunning = false;
                          });
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(fontSize: 19),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.redAccent),
                          padding:
                              MaterialStateProperty.all(EdgeInsets.all(12)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))),
                        ),
                      ),
                    ],
                  )
                : ElevatedButton(
                    onPressed: () {
                      startTimer();
                      setState(() {
                        isRunning = true;
                      });
                    },
                    child: Text(
                      "Start",
                      style: TextStyle(fontSize: 19),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.redAccent),
                      padding: MaterialStateProperty.all(EdgeInsets.all(17)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
