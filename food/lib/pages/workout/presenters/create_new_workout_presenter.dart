import 'package:firebase_auth/firebase_auth.dart';
import 'package:food/pages/workout/views/create_new_workout_view.dart';
import 'package:food/pages/workout/views/create_new_workout_view_interface.dart';
import 'package:food/services/workout_service.dart';

class CreateNewWorkoutPresenter {
  final CreateNewWorkoutViewInterface view;

  CreateNewWorkoutPresenter(this.view);

  Future<void> createWorkout(String workoutTitle, List<String> activities, List<int> durations) async {
    // Get current user
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      view.onError('User is not authenticated');
      return;
    }

    // Validate if workout title is filled
    if (workoutTitle.isEmpty) {
      view.onError('Please enter a workout title.');
      return;
    }

    // Call Firestore service to create workout
    try {
      await WorkoutService().createWorkoutData(user.uid, {
        'title': workoutTitle,
        'activities': activities,
        'durations': durations,
      });
      view.onWorkoutCreated();
    } catch (e) {
      view.onError('Failed to create workout. Please try again later.');
    }
  }
}
