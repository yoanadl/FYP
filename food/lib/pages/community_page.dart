
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Plan'),
      ),

      body: Center(
        child: Text(
          'Community Page',
          style: TextStyle(fontSize: 24),
        )
      )
    );

  }
}