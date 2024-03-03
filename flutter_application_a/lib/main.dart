import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vibration/vibration.dart';

// import 'TimerAddPage.dart';
// import 'TimerService.dart';

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
  List<int> timerDurations = [5, 10, 30, 60];
  List<int> originalDurations = [];
  List<Timer?> timers = List.filled(12, null);
  // 각 버튼의 배경 색을 저장하는 리스트
  List<Color> buttonColors = List.filled(12, Colors.blue);
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
                      buttonColors.removeAt(index);
                    });
                  } else {
                    buttonColors[index] == Colors.red
                        ? _resetTimer(index)
                        : _startTimer(index);
                  }
                },
                onLongPress: () {
                  if (isDeleteMode) {
                    // 삭제 모드일 때 버튼 클릭시 리스트에서 해당 타이머 제거
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
                  if (_isAnyTimerActive()) {
                    // 타이머가 진행 중일 때 삭제 모드로 진입 제한
                    _showAlert("타이머가 진행 중입니다. 삭제 모드로 진입할 수 없습니다.");
                  } else {
                    setState(() {
                      isDeleteMode = !isDeleteMode; // 삭제 모드 토글
                    });
                  }
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

  void _startTimer(int buttonIndex) {
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

  void _stopTimer(int buttonIndex) {
    // 타이머를 정지
    timers[buttonIndex]?.cancel();
    timers[buttonIndex] = null;
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

  bool _isAnyTimerActive() {
    // 활성화된 타이머가 있는지 확인
    return timers.any((timer) => timer != null);
  }

  void _showAlert(String message) {
    // Toast 형식의 경고 메시지 표시
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
