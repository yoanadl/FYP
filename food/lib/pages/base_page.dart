// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:food/components/navbar.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'workout_page.dart';
// import 'community_page.dart';
import 'profile_page.dart';
import 'mealPlan_page.dart';
import 'home_page.dart';

class BasePage extends StatefulWidget {
  const BasePage({Key? key});

  @override
  State<BasePage> createState() => _HomePageState();
}

class _HomePageState extends State<BasePage> {

  // track the currently selected item
  int _selectedIndex = 0;

  // define a list of widgets for each page
  final List<Widget> _pages = [
    HomePage(),
    WorkoutPage(),
    ProfilePage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {

    String formattedDate = DateFormat('EEEE d MMMM').format(DateTime.now());

    return Scaffold(

  
      body: Container(
        color: Colors.white, 
        child: Center(
          child: _selectedIndex < _pages.length ? _pages[_selectedIndex] : SizedBox(),
        ),
      ),

      bottomNavigationBar: Navbar(
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
            
          },
          );
        }
      ),
    );
  }
}