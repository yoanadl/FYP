// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:food/components/navbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // track the currently selected item
  int _seletectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),

      body: Center(
        child: Text('Home Page Content'),
      ),

      bottomNavigationBar: Navbar(
        currentIndex: _seletectedIndex,
        onTap: (int index) {
          setState(() {
            _seletectedIndex = index;
          });
        }
      ),
    );
  }
}