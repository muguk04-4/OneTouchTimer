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
  List<int> timerDurations = [30, 60, 90, 120, 300, 600];
  List<int> originalDurations = [];
  List<Timer?> timers = List.filled(6, null);
  // 버튼 색을 저장하는 리스트
  List<Color> buttonColors = List.filled(6, Colors.blue);

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
            crossAxisSpacing: 15.0,
            mainAxisSpacing: 15.0,
          ),
          itemBuilder: (context, index) {
            return ElevatedButton(
              onPressed: () {
                _startStopTimer(index);
              },
              onLongPress: () {
                _resetTimer(index);
              },
              style: ElevatedButton.styleFrom(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.0),
                ),
                backgroundColor: buttonColors[index],
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
          setState(() {
            timers[buttonIndex]?.cancel();
            timers[buttonIndex] = null;
            buttonColors[buttonIndex] = Colors.red;
          });
        }
      });
    } else {
      _stopTimer(buttonIndex);
    }
  }

  void _resetTimer(int buttonIndex) {
    timers[buttonIndex]?.cancel();
    timers[buttonIndex] = null;
    setState(() {
      timerDurations[buttonIndex] = originalDurations[buttonIndex];
      // 버튼의 배경 색을 초기 상태로 돌아가게 만듦
      buttonColors[buttonIndex] = Colors.blue; // 예시로 초기 색상을 파란색으로 설정
    });
  }

  void _stopTimer(int buttonIndex) {
    timers[buttonIndex]?.cancel();
    timers[buttonIndex] = null;
  }
}
