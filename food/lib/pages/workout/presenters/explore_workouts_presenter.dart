
import '../models/workout_model.dart';

class ExploreWorkoutsPresenter {
  final WorkoutModel _model;

  ExploreWorkoutsPresenter(this._model);

  Future<List<Map<String, dynamic>>> getPreMadeWorkouts() {
    return _model.fetchPreMadeWorkouts();
  }

  List<Map<String, dynamic>> filterWorkouts(List<Map<String, dynamic>> workouts, String query) {
    return workouts.where((workout) {
      return workout['title'].toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
