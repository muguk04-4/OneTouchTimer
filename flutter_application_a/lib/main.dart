import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

// 타이머 데이터 관리용
import 'timerService.dart';
//타이머 추가 페이지
import 'timerAddPage.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TimerService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late TimerService timerS;
  List<int> timerDurations = [];
  List<int> originalDurations = []; // 리셋용 백업 리스트
  List<Timer?> timers = List.filled(12, null);
  // 각 버튼의 배경 색을 저장하는 리스트
  List<Color> buttonColors = List.filled(12, Colors.blue);
  // 삭제 모드 상태 관리
  bool isDeleteMode = false;

  // _resetTimer 사용을 위한 변수를 미리 저장하는 코드같음!
  @override
  void initState() {
    super.initState();
    timerS = TimerService();
    timerDurations = List.from(timerS.getTimerList());
    originalDurations = List.from(timerDurations);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
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
                    _deleteTimer(index);
                  } else {
                    buttonColors[index] == Colors.red
                        ? _resetTimer(index)
                        : _startTimer(index);
                  }
                },
                onLongPress: () {
                  if (isDeleteMode) {
                    // 삭제 모드면 클릭시 리스트에서 해당 타이머 제거
                    _deleteTimer(index);
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
                    _formatDuration(Duration(seconds: timerDurations[index])),
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              );
            },
            itemCount: timerDurations.length,
          ),
        ),
        floatingActionButton: Builder(
          builder: (context) => Stack(
            children: <Widget>[
              Positioned(
                right: 0,
                bottom: 10,
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
                bottom: 10,
                child: FloatingActionButton(
                  heroTag: "addButton",
                  onPressed: () async {
                    // 변경된 부분: Navigator.push로 타이머 추가 값을 받아서 TimerService에 추가합니다.
                    final int? newTimerDuration = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TimerAddPage(),
                      ),
                    );

                    if (newTimerDuration != null) {
                      setState(() {
                        timerDurations =
                            context.read<TimerService>().getTimerList();
                        originalDurations =
                            context.read<TimerService>().getTimerList();
                      });
                    }
                  },
                  child: Icon(Icons.add),
                  backgroundColor: Colors.blue,
                ),
              ),
            ],
          ),
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
    _stopTimer(buttonIndex);
    setState(() {
      timerDurations[buttonIndex] = originalDurations[buttonIndex];
      buttonColors[buttonIndex] = Colors.blue; // 예시: 파란색으로 초기화
      // Colors.red(타이머 끝)버튼이 없으면 진동 중단
      if (!buttonColors.any((color) => color == Colors.red)) {
        Vibration.cancel();
      }
    });
  }

  void _deleteTimer(int buttonIndex) {
    print("$buttonIndex");
    context.read<TimerService>().deleteTimer(buttonIndex);
    setState(() {
      timerDurations.removeAt(buttonIndex);
      originalDurations.removeAt(buttonIndex);
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

//표기 형식을 00:00:00로 변경
  String _formatDuration(Duration duration) {
    String twoDigits(int n) {
      return n.toString().padLeft(2, '0');
    }

    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));

    return "$hours:$minutes:$seconds";
  }
}
