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
  // 타이머 초기 설정 값과 타이머 배열
  List<int> timerDurations = [5, 10, 30, 60];
  List<int> originalDurations = [];
  List<Timer?> timers = List.filled(12, null);
  // 각 버튼의 배경 색을 저장하는 리스트
  List<Color> buttonColors = List.filled(12, Colors.blue);
  // 삭제 모드 상태 관리
  bool isDeleteMode = false;

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
                    // 삭제 모드면 클릭시 리스트에서 해당 타이머 제거
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
                    // 삭제 모드가 아닐 때
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
                    // 시간 표기 방식 00:00:00로 바꿔야함***************
                    '${timerDurations[index]}초',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              );
            },
            itemCount: timerDurations.length,
          ),
        ),
        floatingActionButton: Stack(
          children: <Widget>[
            // 삭제 모드 토글 버튼
            Positioned(
              right: 30,
              bottom: 30,
              child: FloatingActionButton(
                onPressed: () {
                  // 삭제 모드 진입 제한
                  if (_isAnyTimerActive() ||
                      buttonColors.any((color) => color == Colors.red)) {
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
            // 타이머 추가 페이지 버튼
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
          // 초당 타이머 시간 감소
          setState(() {
            timerDurations[buttonIndex]--;
          });
        } else {
          setState(() {
            timers[buttonIndex]?.cancel();
            timers[buttonIndex] = null;
            // 0초가 되면 버튼 색 변경
            buttonColors[buttonIndex] = Colors.red;
            // 버튼 하나라도 Colors.red(타이머 끝)인 경우 진동 시작
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

  // 타이머를 정지
  void _stopTimer(int buttonIndex) {
    timers[buttonIndex]?.cancel();
    timers[buttonIndex] = null;
  }

  // 타이머를 정지, 초기화 및 버튼 색 초기화
  void _resetTimer(int buttonIndex) {
    timers[buttonIndex]?.cancel();
    timers[buttonIndex] = null;
    setState(() {
      timerDurations[buttonIndex] = originalDurations[buttonIndex];
      buttonColors[buttonIndex] = Colors.blue; // 예시: 파란색으로 초기화
      // Colors.red(타이머 끝)버튼이 없으면 진동 중단
      if (!buttonColors.any((color) => color == Colors.red)) {
        Vibration.cancel();
      }
    });
  }

  // 작동중인 타이머가 있는지 확인
  bool _isAnyTimerActive() {
    return timers.any((timer) => timer != null);
  }

  // Toast 형식의 경고 메시지 표시
  void _showAlert(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

// 버튼 삭제경고창
//   void _showDeleteConfirmationDialog(int buttonIndex) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text("경고"),
//         content: Text("이 버튼을 삭제하시겠습니까?"),
//         actions: <Widget>[
//           TextButton(
//             child: Text("취소"),
//             onPressed: () {
//               Navigator.of(context).pop(); // 다이얼로그 닫기
//             },
//           ),
//           TextButton(
//             child: Text("삭제"),
//             onPressed: () {
//               // 버튼 삭제 로직
//               setState(() {
//                 timerDurations.removeAt(buttonIndex);
//                 buttonColors.removeAt(buttonIndex);
//               });
//               Navigator.of(context).pop(); // 다이얼로그 닫기
//             },
//           ),
//         ],
//       );
//     },
//   );
// }
}
