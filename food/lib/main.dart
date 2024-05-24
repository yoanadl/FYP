import 'package:flutter/material.dart';
import 'login_page.dart';
// import 'package:random_color/random_color.dart';


void main (){
    runApp( MyApp() );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}