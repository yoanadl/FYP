import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food/services/workout_service.dart';

class PreMadeWorkoutSummaryPresenter {
  final String workoutTitle;
  final List<String> activities;
  final List<int> duration;
  final WorkoutService _workoutService = WorkoutService();

  PreMadeWorkoutSummaryPresenter({
    required this.workoutTitle,
    required this.activities,
    required this.duration,
  });

  Future<void> addToOngoingWorkouts(BuildContext context) async {
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
}
