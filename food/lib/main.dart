import 'package:flutter/material.dart';
// import 'package:random_color/random_color.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // RandomColor _randomColor = RandomColor();
    // Color _color = _randomColor.randomColor();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.green, title: const Text("Flutter is fun")),
        body: Container(
          child: Text('test hiiigg djrdjjdrgrtrent'),
          color: Colors.green,
        ),//trrrttr
        



        )
      );
    
  }
}
