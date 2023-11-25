import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'GridView',
        home: Scaffold(
            appBar: AppBar(title: const Text('GridView')),
            backgroundColor: Colors.indigo.shade100,
            body: const Home()));
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sizeX = MediaQuery.of(context).size.width;
    final sizeY = MediaQuery.of(context).size.height;
    return Container(
        width: sizeX,
        height: sizeY,
        child: GridView.count(
          scrollDirection: Axis.vertical,
          crossAxisCount: 3,
          mainAxisSpacing: 5.0,
          crossAxisSpacing: 5.0,
          padding: const EdgeInsets.all(5.0),
        ));
  }
}
