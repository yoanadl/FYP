// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:food/pages/challenges/challenge_owner_view_joined_page.dart';
import 'package:food/pages/challenges/challenge_owner_view_page.dart';
import 'package:food/pages/challenges/challenge_viewer_view_joined_page.dart';
import 'package:food/pages/challenges/challenge_viewer_view_page.dart';
import 'package:food/components/navbar.dart';
import 'package:food/pages/challenges/my_challenge_page.dart';
import 'package:food/pages/challenges/challenge_home_page.dart';
import 'package:food/pages/workout/views/workout_page_view.dart';
import '../pages/user/view/profile_page.dart';
import '../pages/user/view/home_page.dart';

class BasePage extends StatefulWidget {
  final int initialIndex;
  const BasePage({Key? key, this.initialIndex = 0}):  super(key: key) ;

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
    ChallengeHomePage(),
    ProfilePage(),
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


