import 'package:flutter/material.dart';
import './view_userprof_page.dart'; // Adjust import path based on your project structure

void main1() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minimal App',
      home: ViewUserProfilePage(),
    );
  }
}
