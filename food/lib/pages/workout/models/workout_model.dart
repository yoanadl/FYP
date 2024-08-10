
import 'package:food/services/workout_service.dart';


class WorkoutModel {
  final WorkoutService _workoutService = WorkoutService();

  Future<List<Map<String, dynamic>>> getUserWorkouts(String userId) async {
    return await _workoutService.getUserWorkouts(userId);
  }

 

   Future<List<Map<String, dynamic>>> fetchPreMadeWorkouts() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay

    return [
      {
        'title': 'Upper Body Blast',
        'activities': ['Push-ups', 'Pull-ups', 'Bicep Curls'],
        'durations': [10, 15, 20],
        'isPremade': true,
      },
      {
        'title': 'Lower Body Strength',
        'activities': ['Squats', 'Lunges', 'Leg Press'],
        'durations': [10, 15, 20],
        'isPremade': true,
      },
      {
        'title': 'Cardio Blast',
        'activities': ['Running', 'Cycling', 'Jump Rope'],
        'durations': [20, 15, 10],
        'isPremade': true,
      },
      {
        'title': 'Flexibility & Core',
        'activities': ['Yoga', 'Planks', 'Pilates'],
        'durations': [20, 15, 20],
        'isPremade': true,
      }
    ];
  }

}
