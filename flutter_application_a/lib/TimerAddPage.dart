import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'timerService.dart'; // TimerService를 가져옵니다.

class TimerAddPage extends StatefulWidget {
  const TimerAddPage({Key? key}) : super(key: key);

  @override
  State<TimerAddPage> createState() => _TimerAddPageState();
}

class _TimerAddPageState extends State<TimerAddPage> {
  TextEditingController textController = TextEditingController();
  String? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("타이머 추가"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: textController,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: InputDecoration(
                hintText: "초 단위로 시간을 입력하세요",
                errorText: error,
              ),
            ),
            SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                child: Text(
                  "추가하기",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                onPressed: () {
                  String input = textController.text;
                  int? duration = int.tryParse(input); // 입력 값을 정수로 변환

                  if (duration == null || duration <= 0) {
                    setState(() {
                      error = "유효한 시간을 입력해주세요."; // 유효하지 않은 경우 에러 메시지
                    });
                  } else {
                    setState(() {
                      error = null; // 에러 메시지 숨기기
                    });
                    Provider.of<TimerService>(context, listen: false).createTimer(duration); // TimerService에 새 타이머 추가
                    Navigator.pop(context, duration); // 페이지 종료
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
