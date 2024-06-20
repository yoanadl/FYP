import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food/services/workout_service.dart';

class PreMadeWorkoutSummaryPage extends StatelessWidget {
  final String workoutTitle;
  final List<String> activities;
  final List<int> duration;

  PreMadeWorkoutSummaryPage({
    required this.workoutTitle,
    required this.activities,
    required this.duration,
  });

  final WorkoutService _workoutService = WorkoutService();

  Future<void> _addToOngoingWorkouts(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _workoutService.saveUserWorkout(
        user.uid,
        workoutTitle,
        activities,
        duration, 
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Workout added to your ongoing workouts')),
      );
      Navigator.pop(context); // Navigate back to previous page
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You need to be logged in to add workouts')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Workout Summary'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              workoutTitle,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Activities:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            ...activities.asMap().entries.map((entry) {
              int index = entry.key;
              String activity = entry.value;
              return ListTile(
                title: Text(activity),
                subtitle: Text('Duration: ${duration[index]} minutes'),
              );
            }).toList(),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _addToOngoingWorkouts(context),
              child: Text('Add to Ongoing Workouts'),
            ),
          ],
        ),
      ),
    );
  }
}
