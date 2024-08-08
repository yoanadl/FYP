// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:food/components/navbar.dart';
import 'package:food/components/base_page.dart';
import 'package:food/pages/discarded/community_page.dart';
import 'package:food/pages/workout/views/workout_page_view.dart';



class BmiReportsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      
      appBar: AppBar(
        backgroundColor: Colors.white,
        
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 50, right: 50),
        child: Column(
          children: [
            Text(
              'BMI Reports' ,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                ),
              ),
              
              Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.all(8.0),
                color: Color(0x59C8E0F4),
                child: Table(
                   children: [
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Date', 
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                              textAlign: TextAlign.center,
                              ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'BMI', 
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                              textAlign: TextAlign.center,
                              ),
                          ),
                        ],
                      ),
                
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '01-01-2024', 
                              textAlign: TextAlign.center,),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '20',
                              textAlign: TextAlign.center,),
                          ),
                        ],
                      ),
                
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '01-02-2024',
                              textAlign: TextAlign.center,),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '21',
                              textAlign: TextAlign.center,),
                          ),
                        ],
                      ),
                
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '01-03-2024',
                              textAlign: TextAlign.center,),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '19',
                              textAlign: TextAlign.center,),
                          ),
                        ],
                      ),
                
                
                    ],
                ),
              )
          ],
        ),

      ),

      bottomNavigationBar: Navbar(
        currentIndex: 3,
        onTap: (int index) {
          if (index != 3) {
            Navigator.pop(context);
            switch(index) {
              case 0:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const BasePage()));
                break;
              case 1:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const WorkoutPage()));
                break;
              case 2:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CommunityPage()));
                break;
            }
          }
        }

      ),
    );
  }
}