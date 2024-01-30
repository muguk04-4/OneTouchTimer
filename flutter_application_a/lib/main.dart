import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // 타이머 초기 설정 값
  List<int> timerDurations = [30, 60, 90, 120, 300, 600];
  List<int> originalDurations = [];
  List<Timer?> timers = List.filled(6, null);
  // 각 버튼의 배경 색을 저장하는 리스트
  List<Color> buttonColors = List.filled(6, Colors.blue);

  @override
  void initState() {
    super.initState();
    originalDurations = List.from(timerDurations);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('OneTouchTimer'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 15.0,
              mainAxisSpacing: 15.0,
            ),
            itemBuilder: (context, index) {
              return ElevatedButton(
                onPressed: () {
                  // 버튼의 현재 상태에 따라 타이머 시작 또는 정지
                  _startStopTimer(index);
                },
                onLongPress: () {
                  // 버튼을 길게 누르면 타이머 초기화
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
                    '${timerDurations[index]}초',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              );
            },
            itemCount: timerDurations.length,
          ),
        ),
      ),
    );
  }

  void _startStopTimer(int buttonIndex) {
    if (timers[buttonIndex] == null) {
      // 타이머가 실행 중이 아니라면 시작
      timers[buttonIndex] = Timer.periodic(Duration(seconds: 1), (timer) {
        if (timerDurations[buttonIndex] > 0) {
          // 매 초마다 타이머 시간 감소
          setState(() {
            timerDurations[buttonIndex]--;
          });
        } else {
          // 타이머가 0이 되면 정지하고 버튼 색 변경
          setState(() {
            timers[buttonIndex]?.cancel();
            timers[buttonIndex] = null;
            buttonColors[buttonIndex] = Colors.red;
          });
        }   
      });
    } else {
      // 타이머가 실행 중이라면 정지
      _stopTimer(buttonIndex);
    }
  }

  void _resetTimer(int buttonIndex) {
    // 타이머를 정지하고 초기 설정 값으로 초기화, 버튼 색 초기화
    timers[buttonIndex]?.cancel();
    timers[buttonIndex] = null;
    setState(() {
      timerDurations[buttonIndex] = originalDurations[buttonIndex];
      buttonColors[buttonIndex] = Colors.blue; // 예시: 파란색으로 초기화
    });
  }

  void _stopTimer(int buttonIndex) {
    // 타이머를 정지
    timers[buttonIndex]?.cancel();
    timers[buttonIndex] = null;
  }
}
