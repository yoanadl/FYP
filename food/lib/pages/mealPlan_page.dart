
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
            'My Meal ',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Title(
                color: Colors.black, 
                child: Text(
                  'My Current Meal',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
          
              Container(
                color: Color(0x59C8E0F4),
                margin: const EdgeInsets.only(top: 70),
                padding: const EdgeInsets.all(5.0),
                height: 400,
                width: 350,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 50),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {

                        },
                        style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff031927),
                              foregroundColor: Colors.white,
                            ),
                        child: Text('Edit'),
                      ),
                    ),
                  ],
                )
              )
            ],
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
                  if (result == 'explore_mealplan') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ExplorePremadeMeal()),
                    );
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
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