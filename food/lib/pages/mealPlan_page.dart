
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../components/navbar.dart';
import 'community_page.dart';
import 'workout/workout_page.dart';
import 'profile_page.dart';

import 'explore_premade_meal.dart';

class MealPlanPage extends StatelessWidget {
  const MealPlanPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Your Meal Plans',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),

      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 20,
            right: 20,
            child: Theme(
              data: Theme.of(context).copyWith(
                popupMenuTheme: PopupMenuThemeData(
                  color: Color(0xff031927),
                ),
              ),
              child: PopupMenuButton<String>(
                onSelected: (String result) {
                  if (result == 'new_mealplan') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MealPlanPage()),
                    );
                  } else if (result == 'explore_mealplan') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ExplorePremadeMeal()),
                    );
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'new_mealplan',
                    child: Row(
                      children: [
                        Icon(Icons.add, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          'Create New Mealplan',
                          style: TextStyle(
                            color: Colors.white
                          )
                          ,),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'explore_mealplan',
                    child: Row(
                      children: [
                        Icon(Icons.explore, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          'Explore Pre-made Mealplan',
                          style: TextStyle(
                            color: Colors.white)),
                      ],
                    ),
                  ),
                ],
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.add, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),


      bottomNavigationBar: Navbar(
        currentIndex: 0,
        onTap: (int index) {
          if (index != 3) {
            Navigator.pop(context);
            switch (index) {
              case 1:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const WorkoutPage()));
                break;
              case 2:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CommunityPage()));
                break;
              case 3:
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  ProfilePage()));
                break;
            }
          }
        },
      ),
    );

  }
}