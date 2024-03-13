import 'dart:async';
import 'package:flutter/material.dart';

import 'main.dart';

/// 타이머 담당
class TimerService extends ChangeNotifier {
  List<Timer> timerList = [
    Timer(Duration(seconds: 5), () {}), // 더미(dummy) 데이터
  ];

  get timerDurations => null;
  
  // 타이머 추가
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
