// lib/pages/explore_workouts_page.dart

import 'package:flutter/material.dart';
import 'package:food/components/base_page.dart';
import 'package:food/components/navbar.dart';
import 'package:food/pages/workout/views/premade_workout_summary_view.dart';
import '../models/workout_model.dart';
import '../presenters/explore_workouts_presenter.dart';

class ExploreWorkoutsPage extends StatefulWidget {
  @override
  _ExploreWorkoutsPageState createState() => _ExploreWorkoutsPageState();
}

class _ExploreWorkoutsPageState extends State<ExploreWorkoutsPage> {
  final TextEditingController _searchController = TextEditingController();
  final ExploreWorkoutsPresenter _presenter = ExploreWorkoutsPresenter(WorkoutModel());
  List<Map<String, dynamic>> _preMadeWorkouts = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadWorkouts();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  Future<void> _loadWorkouts() async {
    final workouts = await _presenter.getPreMadeWorkouts();
    setState(() {
      _preMadeWorkouts = workouts;
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredWorkouts = _presenter.filterWorkouts(_preMadeWorkouts, _searchQuery);

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
                          builder: (context) => PreMadeWorkoutSummaryView(
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
        currentIndex: 1,
        onTap: (int index) {
          if (index != 1) {
            Navigator.pop(context);
            switch (index) {
              case 0:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const BasePage(initialIndex: 0,)));
                break;
              case 1:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const BasePage(initialIndex: 1,)));
                break;
              case 2:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const BasePage(initialIndex: 2,)));
                break;
              case 3:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const BasePage(initialIndex: 3,)));
                break;
            }
          }
        },
      ),
    );
  }
}
