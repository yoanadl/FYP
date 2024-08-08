import 'package:food/pages/workout/models/workout_model.dart';
import 'package:food/pages/workout/views/workout_page_view.dart';

class WorkoutPresenter {
  final WorkoutModel _model;
  final WorkoutPageView _view; 

  WorkoutPresenter(this._model, this._view);

  Future<List<Map<String, dynamic>>> loadWorkouts(String userId) async {
  try {
    final workouts = await _model.getUserWorkouts(userId);
    return workouts;
  } catch (e) {
    _view.onError(e.toString());
    return []; // Return an empty list on error
  }
}


  void searchWorkouts(String query, List<Map<String, dynamic>> workouts) {
    final filteredWorkouts = workouts.where((workout) {
      final title = workout['title'] ?? 'Untitled Workout';
      return title.toLowerCase().contains(query.toLowerCase());
    }).toList();
    _view.onWorkoutsSearched(filteredWorkouts);
  }
}
