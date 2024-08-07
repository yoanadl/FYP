
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../../components/navbar.dart';
import 'community_page.dart';
import '../workout/workout_page.dart';
import '../user/view/profile_page.dart';
import 'explore_premade_meal.dart';

class RowData{
  final String text;
  final Widget? destination;

  const RowData(
    { 
      required this.text,
      this.destination,
    }
  );
}

class MealPlanPage extends StatelessWidget {
    MealPlanPage({super.key});

    final List<RowData> rowData = [
    RowData(
      text: 'Monday',
      destination: ExplorePremadeMeal(),
    ),
    RowData(
      text: 'Tuesday',
      destination: ExplorePremadeMeal(),
    ),
    RowData(
      text: 'Wednesday',
      destination: ExplorePremadeMeal(),
    ),
    RowData(
      text: 'Thusday',
      destination: ExplorePremadeMeal(),
    ),
    RowData(
      text: 'Friday',
      destination: ExplorePremadeMeal(),
    ),
    RowData(
      text: 'Saturday',
      destination: ExplorePremadeMeal(),
    ),
    RowData(
      text: 'Sunday',
      destination: ExplorePremadeMeal(),
    )
  ];

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
                margin: const EdgeInsets.only(top: 10,left: 10, right: 10),
                padding: const EdgeInsets.all(15.0),
                height: 500,
                width: 350,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 5),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {

                        },
                        style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff031927),
                              foregroundColor: Colors.white,
                              fixedSize: Size(200, 10)
                            ),
                        child: Text('Monday', 
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          ),),
                      ),
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {

                        },
                        style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff031927),
                              foregroundColor: Colors.white,
                              fixedSize: Size(200, 10)
                            ),
                        child: Text('Tuesday',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          ),),
                      ),
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {

                        },
                        style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff031927),
                              foregroundColor: Colors.white,
                              fixedSize: Size(200, 10)
                            ),
                        child: Text('Wednesday',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          ),),
                      ),
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {

                        },
                        style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff031927),
                              foregroundColor: Colors.white,
                              fixedSize: Size(200, 10)
                            ),
                        child: Text('Thusday',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          ),),
                      ),
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {

                        },
                        style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff031927),
                              foregroundColor: Colors.white,
                              fixedSize: Size(200, 10)
                            ),
                        child: Text('Friday',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          ),),
                      ),
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {

                        },
                        style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff031927),
                              foregroundColor: Colors.white,
                              fixedSize: Size(200, 10)
                            ),
                        child: Text('Saturday',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          ),),
                      ),
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {

                        },
                        style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff031927),
                              foregroundColor: Colors.white,
                              fixedSize: Size(200, 10)
                            ),
                        child: Text('Sunday',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          ),),
                      ),
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {

                        },
                        style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff031927),
                              foregroundColor: Colors.white,
                              fixedSize: Size(200, 10)
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