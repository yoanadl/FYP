// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:food/components/trainer_navbar.dart';
import 'package:food/pages/trainer/trainer_main_page.dart';
import 'package:food/pages/trainer/trainer_meal_plan_page.dart';
import 'package:food/pages/trainer/trainer_my_client_page.dart';
import 'package:food/pages/trainer/trainer_profile_page.dart';
import 'package:food/pages/trainer/trainer_workout_plan_page.dart';

class TrainerBasePage extends StatefulWidget {
  final int initialIndex;
  const TrainerBasePage({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<TrainerBasePage> createState() => _HomePageState();
}

class _HomePageState extends State<TrainerBasePage> {
  // track the currently selected item
  int _selectedIndex = 0;

  // define a list of widgets for each page
  final List<Widget> _pages = [
    TrainerMainPage(),
    TrainerWorkoutPlanPage(),
    TrainerMyClientPage(),
    TrainerMealPlanPage(),
    TrainerProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Center(
              child: _selectedIndex < _pages.length ? _pages[_selectedIndex] : SizedBox(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: TrainerNavbar(
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        
      ),
    );
  }
}
