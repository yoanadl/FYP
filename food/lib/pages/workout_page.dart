// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class WorkoutPage extends StatelessWidget {
  const WorkoutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Text(
              'My Workouts',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold
              ),
            ),
            Spacer()
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        child: DefaultTabController(
          length: 2, // Number of tabs
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(50),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xff031927),
                ),
                child: TabBar(
                  labelStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white,
                  tabs: [
                    Tab(
                      text: 'Ongoing',
                    ),
                    Tab(text: 'Completed'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // Ongoing tab content
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 300,
                            height: 180,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: Colors.grey[200],
                            ),
                            child: Center(child: Text('Ongoing Workout 1')),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: 300,
                            height: 180,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: Colors.grey[200],
                            ),
                            child: Center(child: Text('Ongoing Workout 2')),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: 300,
                            height: 180,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: Colors.grey[200],
                            ),
                            child: Center(child: Text('Ongoing Workout 3')),
                          ),
                        ],
                      ),
                    ),
                    // Completed tab content
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 300,
                            height: 180,
                           decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: Colors.grey[200],
                            ),
                            child: Center(child: Text('Completed Workout 1')),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: 300,
                            height: 180,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: Colors.grey[200],
                            ),
                            child: Center(child: Text('Completed Workout 2')),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: 300,
                            height: 180,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: Colors.grey[200],
                            ),
                            child: Center(child: Text('Completed Workout 3')),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

