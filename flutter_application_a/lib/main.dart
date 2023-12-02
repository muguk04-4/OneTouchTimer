import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

// *********** StatefulWidget 으로 바꿔야함 **********
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(),
        body: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 3,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {},
              child: Text("Elevated BUTTON"),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text("Elevated BUTTON"),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text("Elevated BUTTON"),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text("Elevated BUTTON"),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text("Elevated BUTTON"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(shape: CircleBorder()),
              onPressed: () {},
              child: Text(
                //*********** 나중에 값으로 변경 ******/
                "1:00",
                style: TextStyle(fontSize: 30.0),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
