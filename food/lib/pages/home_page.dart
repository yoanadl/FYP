// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:food/components/navbar.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'workout_page.dart';
import 'mealPlan_page.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    String formattedDate = DateFormat('EEEE d MMMM').format(DateTime.now());

    return Scaffold(

      // Top App
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          automaticallyImplyLeading: false, // hide the back button
          backgroundColor: Colors.white,
          centerTitle: false,
          actions: [

            // sync to smart watch icon

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),

                child: IconButton(
                  onPressed: () {}, 
                  icon: Icon(Icons.sync),
                  iconSize: 25,
                  color: Colors.black,
                ),
              ),
            ),


            // notification icon
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[300],
                ),

                child: IconButton(
                  onPressed: () {}, 
                  icon: Icon(Icons.notifications),
                  iconSize: 25,
                  color: Colors.black,
                ),
              ),
            ),
            
            //profile icon
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: SizedBox(
                width: 100,
                height: 100,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                  ),
                ),
              ),
              )

          ],

          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 17.0),
                child: Text(
                  'Hello, Username!',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 17.0),
                child: Text(
                  formattedDate,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

        ),
      ),

      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
      
            
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Today\'s Information',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              
      
              Container(
                width: 350,
                height: 190,
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Color(0x99C8E0F4),
                  borderRadius: BorderRadius.circular(10),
                ),
      
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white, 
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Heart Rate \n 72 bpm',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 5),
                              Icon(Icons.favorite, color: Color(0xFF508AA8)),
                            ],
                          
                          ),
                        ),
                      ),
                    ),
      
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Calories \n 350 kcal',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Icon(Icons.local_fire_department, color: Color(0xFF508AA8)),
                                  
                                  ],
                                ),
                              ),
                            ),
      
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white, 
                              borderRadius: BorderRadius.circular(10),
                            ),
      
                             child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Steps \n 10,000',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  FaIcon(FontAwesomeIcons.shoePrints, color: Color(0xFF508AA8)),
                                  
                                  ],
                                ),
                              ),
                          )
                        ],
                      ))
                  ],
      
                )
                
              ),
      
              SizedBox(height: 30),
      
              InkWell(
                onTap: () => Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => WorkoutPage()),
                ),
                child: Container(
                  width: 350,
                  height: 190,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Color(0x99C8E0F4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                
                  child: Text(
                    'Workout Plan', 
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                
                  
                ),
              ),
      
              SizedBox(height: 30),
      
               InkWell(
                onTap: () => Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => MealPlanPage()),
                ),
                 child: Container(
                  width: 350,
                  height: 190,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Color(0x99C8E0F4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                 
                  child: Text(
                    'Meal Plan', 
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                               ),
               ),
            ],
          ),
        ),
      ),
  
    );
  }
}