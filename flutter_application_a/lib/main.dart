import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

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
  List<int> timerDurations = [10, 30, 40, 60, 300, 600];
  List<int> originalDurations = [];
  List<Timer?> timers = List.filled(6, null);
  // 각 버튼의 배경 색을 저장하는 리스트
  List<Color> buttonColors = List.filled(6, Colors.blue);
  // 상태 변수 추가
  bool isDeleteMode = false; // 삭제 모드 상태 관리

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
        body: Container(
          color: isDeleteMode ? Colors.orange : Colors.white, // 삭제 모드일 때 배경색 변경
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
                  if (isDeleteMode) {
                    // 삭제 모드일 때 버튼 클릭시 리스트에서 해당 타이머 제거
                    setState(() {
                      timerDurations.removeAt(index);
                      buttonColors.removeAt(index); // 버튼 색상 리스트도 업데이트
                    });
                  } else {
                    // 삭제 모드가 아닐 때 기존 로직 수행 (타이머 시작/정지)
                    _startStopTimer(index);
                  }
                },
                onLongPress: () {
                  if (isDeleteMode) {
                    // 삭제 모드일 때 버튼 클릭시 리스트에서 해당 타이머 제거
                    setState(() {
                      timerDurations.removeAt(index);
                      buttonColors.removeAt(index); // 버튼 색상 리스트도 업데이트
                    });
                  } else {
                    // 삭제 모드가 아닐 때 기존 로직 수행 (타이머 시작/정지)
                    _resetTimer(index);
                  }
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
        // 빨간색 Floating Action Button 추가 - 삭제 모드 토글
        floatingActionButton: Stack(
          children: <Widget>[
            Positioned(
              right: 30,
              bottom: 30,
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    isDeleteMode = !isDeleteMode; // 삭제 모드 토글
                  });
                },
                child: Icon(Icons.remove),
                backgroundColor: Colors.red,
              ),
            ),
            // 파란색 Floating Action Button 추가 - 타이머 추가 페이지로 이동
            Positioned(
              left: 30,
              bottom: 30,
              child: FloatingActionButton(
                onPressed: () {
                  // TODO: 타이머 추가 페이지로 이동하는 로직 구현
                },
                child: Icon(Icons.add),
                backgroundColor: Colors.blue,
              ),
            ),
          ],
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
            // 다른 버튼 중 적어도 하나가 Colors.red인 경우 진동 시작
            if (buttonColors.any((color) => color == Colors.red)) {
              Vibration.vibrate(pattern: [500, 1000], repeat: 0);
            }
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
      // 모든 버튼이 Colors.red가 아닌 경우 진동 중단
      if (!buttonColors.any((color) => color == Colors.red)) {
        Vibration.cancel();
      }
    });
  }

  void _stopTimer(int buttonIndex) {
    // 타이머를 정지
    timers[buttonIndex]?.cancel();
    timers[buttonIndex] = null;
  }
}
