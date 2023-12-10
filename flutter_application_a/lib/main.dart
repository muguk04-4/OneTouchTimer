import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OneTouchTimerApp(),
    );
  }
}

class OneTouchTimerApp extends StatefulWidget {
  @override
  _OneTouchTimerAppState createState() => _OneTouchTimerAppState();
}

class _OneTouchTimerAppState extends State<OneTouchTimerApp> {
  List<int> timerDurations = [10, 20, 30, 40, 50, 60];
  List<int> originalDurations = [];
  List<Timer?> timers = List.filled(6, null);

  @override
  void initState() {
    super.initState();
    originalDurations = List.from(timerDurations);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OneTouchTimer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 15.0, // 버튼 사이의 가로 여백
            mainAxisSpacing: 15.0, // 버튼 사이의 세로 여백
          ),
          itemBuilder: (context, index) {
            return ElevatedButton(
              onPressed: () {
                _startStopTimer(index);
              },
              style: ElevatedButton.styleFrom(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.0),
                ),
              ),
              child: Center(
                child: Text(
                  '${timerDurations[index]}s',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            );
          },
          itemCount: timerDurations.length,
        ),
      ),
    );
  }

  void _startStopTimer(int buttonIndex) {
    if (timers[buttonIndex] == null) {
      timers[buttonIndex] = Timer.periodic(Duration(seconds: 1), (timer) {
        if (timerDurations[buttonIndex] > 0) {
          setState(() {
            timerDurations[buttonIndex]--;
          });
        } else {
          _stopTimer(buttonIndex);
        }
      });
    } else {
      _resetTimer(buttonIndex);
    }
  }

  void _resetTimer(int buttonIndex) {
    timers[buttonIndex]?.cancel();
    timers[buttonIndex] = null;
    setState(() {
      timerDurations[buttonIndex] = originalDurations[buttonIndex];
    });
  }

  void _stopTimer(int buttonIndex) {
    timers[buttonIndex]?.cancel();
    timers[buttonIndex] = null;
  }
}
