// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class WorkoutDone extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar (
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'You did it!',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 30),
            
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_fire_department, size: 30),
                  SizedBox(width: 10,),
                  Text(
                    'Calories burned: 300 kcal',
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
              SizedBox(height: 30,),
                
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_fire_department, size: 30),
                  SizedBox(width: 10,),
                  Text(
                    'Heart rate: 120 bpm',
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
                
              SizedBox(height: 40,),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                }, 
                child: Text(
                  'Exit Workout',
                  style: TextStyle(
                    fontSize: 20
                  ),),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff031927), 
                    foregroundColor: Colors.white, 
                  ),
              ),
                
            ],
          )
        ),
      )
    );
  }


}