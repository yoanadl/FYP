
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../components/navbar.dart';

class CommunityPage extends StatelessWidget {

  final int selectedIndex;
  final Function(int) onTap;

  const CommunityPage({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Community Page'),
      ),

      body: Center(
        child: Text(
          'Community Page',
          style: TextStyle(fontSize: 24),
        )
      ),


      bottomNavigationBar: Navbar(
        currentIndex: selectedIndex,
        onTap: onTap,
      ),
    );

  }
}