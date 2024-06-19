
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../components/navbar.dart';
import 'community_page.dart';
import 'workout_page.dart';
import 'profile_page.dart';

class MealPlan{
  final String name;
  final List<String> details;

  const MealPlan(
    {
      required this.name, 
      required this.details
    }
  );
}

List<MealPlan> sampleMealPlans = [
  MealPlan(
    name: 'Meal Plan 1',
    details: [
      'Salmon with roasted vegetables',
    ]
  ),

   MealPlan(
    name: 'Meal Plan 2',
    details: [
      'Veggie stir-fry with brown rice',
    ]
  ),

   MealPlan(
    name: 'Meal Plan 3',
    details: [
      'Tuna salad sandwich on whole-wheat bread',
    ]
  ),

];

Widget buildMeanPlanContainer(MealPlan mealPlan) {
  return Container(
    width: 250,
    height: 200,
    margin: EdgeInsets.all(16.0),
    padding: EdgeInsets.all(8.0),
    decoration: BoxDecoration(
      color: Color(0x99C8E0F4),
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          mealPlan.name, 
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(height: 8.0,),
        for (String details in mealPlan.details)
          Text(
            details,
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
      ],
    ),
  );
}

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
            'Meal Plans',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              children: [
                for (MealPlan mealPlan in sampleMealPlans)
                  buildMeanPlanContainer(mealPlan),
              ],
            ),
          ),
        ),
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