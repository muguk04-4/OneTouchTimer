import 'package:flutter/material.dart';

/// 타이머 담당
class TimerService extends ChangeNotifier {
  List<int> timerList = [
    5, // 더미(dummy) 데이터들
    10,
    30,
    60,
  ];

  List<int> getTimerList() {
    return timerList;
  }

  // 타이머 추가 <- main에서 데이터 받아올 수 있도록 개조
  void createTimer(int duration) {
    timerList.add(duration);
    notifyListeners();
  }

  /// 타이머 삭제
  void deleteTimer(int index) {
    timerList.removeAt(index);
    notifyListeners();
  }
}
