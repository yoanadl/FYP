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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Spacer(),
            Text(
              'My Workouts',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
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
                margin: EdgeInsets.all(20),
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
              // search bar and filter icon row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 300,
                      height: 50,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search Workouts',
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    IconButton(
                      icon: Icon(Icons.filter_list),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // Ongoing tab content
                    ListView(
                      padding: EdgeInsets.all(16.0),
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                            width: double.infinity,
                            height: 180,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: Colors.grey[200],
                            ),
                            child: Center(child: Text('Ongoing Workout 1')),
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                            width: double.infinity,
                            height: 180,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: Colors.grey[200],
                            ),
                            child: Center(child: Text('Ongoing Workout 2')),
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                            width: double.infinity,
                            height: 180,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: Colors.grey[200],
                            ),
                            child: Center(child: Text('Ongoing Workout 3')),
                          ),
                        ),
                      ],
                    ),
                    // Completed tab content
                    ListView(
                      padding: EdgeInsets.all(16.0),
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                            width: double.infinity,
                            height: 180,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: Colors.grey[200],
                            ),
                            child: Center(child: Text('Completed Workout 1')),
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                            width: double.infinity,
                            height: 180,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: Colors.grey[200],
                            ),
                            child: Center(child: Text('Completed Workout 2')),
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                            width: double.infinity,
                            height: 180,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: Colors.grey[200],
                            ),
                            child: Center(child: Text('Completed Workout 3')),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 20,
            right: 20,
            child: PopupMenuButton<String>(
              onSelected: (String result) {
                if (result == 'new_workout') {
                  // Handle create new workout
                } else if (result == 'explore_workouts') {
                  // Handle explore pre-made workouts
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'new_workout',
                  child: Row(
                    children: [
                      Icon(Icons.add, color: Colors.black),
                      SizedBox(width: 10),
                      Text('Create New Workout'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'explore_workouts',
                  child: Row(
                    children: [
                      Icon(Icons.explore, color: Colors.black),
                      SizedBox(width: 10),
                      Text('Explore Pre-made Workouts'),
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
        ],
      ),



    );
  }
}
