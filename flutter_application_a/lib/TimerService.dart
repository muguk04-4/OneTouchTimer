import 'dart:async';
import 'package:flutter/material.dart';

import 'main.dart';

/// 타이머 담당
class TimerService extends ChangeNotifier {
  List<Timer?> timerList = [
    Timer(null), // 더미(dummy) 데이터
  ];
  

  /// 타이머 추가
  void createTimer(int t) {
    timerList.add(Timer(t));
    notifyListeners();
  }

  /// 타이머 삭제
  void deleteTimer(int index) {
    timerList.removeAt(index);
    notifyListeners();
  }
}
