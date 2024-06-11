// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class WorkoutPage extends StatelessWidget {
  const WorkoutPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Plan'),
      ),

      body: Center(
        child: Text(
          'Workout Page',
          style: TextStyle(fontSize: 24),
        )
      )
    );

  }
}