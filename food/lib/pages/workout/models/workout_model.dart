
import 'package:food/services/workout_service.dart';

class WorkoutModel {
  final WorkoutService _workoutService = WorkoutService();

  Future<List<Map<String, dynamic>>> getUserWorkouts(String userId) async {
    return await _workoutService.getUserWorkouts(userId);
  }
}
