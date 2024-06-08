import 'package:flutter/material.dart';

import 'pages/intro_page.dart';

// import 'package:random_color/random_color.dart';

void main() {
  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // RandomColor _randomColor = RandomColor();
    // Color _color = _randomColor.randomColor();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IntroPage(),
    );
  }
}
