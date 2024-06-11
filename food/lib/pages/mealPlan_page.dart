
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class MealPlanPage extends StatelessWidget {
  const MealPlanPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Plan Page'),
      ),

      body: Center(
        child: Text(
          'Meal Plan Page',
          style: TextStyle(fontSize: 24),
        )
      )
    );

  }
}