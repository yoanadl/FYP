import 'package:flutter/material.dart';
import 'package:food/components/navbar.dart';
import 'package:food/pages/community_page.dart';
import 'package:food/pages/workout/workout_page.dart';
import 'package:food/pages/profile_page.dart';
import 'package:food/pages/workout/premade_workout_summary.dart';
// import 'workout_summary.dart';

class ExploreWorkoutsPage extends StatefulWidget {
  @override
  _ExploreWorkoutsPageState createState() => _ExploreWorkoutsPageState();
}

class _ExploreWorkoutsPageState extends State<ExploreWorkoutsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Map<String, dynamic>> preMadeWorkouts = [
     {
      'title': 'Upper Body Blast',
      'activities': ['Push-ups', 'Pull-ups', 'Bicep Curls'],
      'durations': [10, 15, 20],
    },
    
    {
      'title': 'Lower Body Strength',
      'activities': ['Squats', 'Lunges', 'Leg Press'],
      'durations': [10, 15, 20]
    },
    {
      'title': 'Cardio Blast',
      'activities': ['Running', 'Cycling', 'Jump Rope'],
      'durations': [20, 15, 10]
    },
    {
      'title': 'Flexibility & Core',
      'activities': ['Yoga', 'Planks', 'Pilates'],
      'durations': [20, 15, 20]
    }
  ];

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredWorkouts = preMadeWorkouts.where((workout) {
      return workout['title'].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Explore Pre-made Workouts',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
          )
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 300,
                  height: 50,
                  child: TextField(
                    controller: _searchController,
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
            child: ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: filteredWorkouts.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> workout = filteredWorkouts[index];
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PreMadeWorkoutSummaryPage(
                            workoutTitle: workout['title'],
                            activities: List<String>.from(workout['activities']),
                            duration: List<int>.from(workout['durations']),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        color: Colors.grey[200],
                      ),
                      child: Center(
                        child: Text(
                          workout['title'] ?? 'Untitled Workout',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
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