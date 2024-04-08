import 'dart:async';
import 'package:flutter/material.dart';

//import 'main.dart';

/// 타이머 담당
class TimerService extends ChangeNotifier {
  List<Timer> timerList = [
    Timer(Duration(seconds: 5), () {}), // 더미(dummy) 데이터들
    Timer(Duration(seconds: 10), () {}),
    Timer(Duration(seconds: 30), () {}),
    Timer(Duration(seconds: 60), () {}),
  ];

  void getTimer(List<Timer> timerList) {}

// 실험중.....................................
//   import 'dart:async';

// void main() {
//   List<Timer> timerList = [
//     Timer(Duration(seconds: 5), () {}),
//     Timer(Duration(seconds: 10), () {}),
//     Timer(Duration(seconds: 30), () {}),
//     Timer(Duration(seconds: 60), () {}),
//   ];
  
//   List<int> getTimerDurations(List<Timer> timers){
//     List<int?> durations;
//     for(int i=0 ; i<timers.length ; i++){
//       durations = timerList[i].duration;
//     }
//     return List<int?> durations;
//   }
// }


  // 타이머 추가 <- main에서 데이터 받아올 수 있도록 개조
  void createTimer(Duration duration) {
    timerList.add(Timer(duration, () {
      // 타이머가 완료될 때 실행될 동작을 여기에 추가합니다.
    }));
    notifyListeners();
  }

  /// 타이머 삭제
  void deleteTimer(int index) {
    //timerList[index].cancel(); // 타이머를 취소하고 제거합니다.
    timerList.removeAt(index);
    notifyListeners();
  }
}
