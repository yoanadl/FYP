import 'package:food/services/workout_service.dart';


abstract class EditWorkoutViewInterface {
  void onSaveSuccess();
  void onSaveError(String error);
}

class EditWorkoutPresenter {
  final WorkoutService _workoutService;
  late EditWorkoutViewInterface _view;

  EditWorkoutPresenter(this._workoutService);

  void attachView(EditWorkoutViewInterface view) {
    _view = view;
  }

  void saveWorkout(String userId, String workoutId, String title, List<String> activities, List<int> durations) async {
    Map<String, dynamic> newData = {
      'title': title,
      'activities': activities,
      'duration': durations,
    };

    try {
      await _workoutService.updateWorkoutData(userId, workoutId, newData);
      _view.onSaveSuccess();
    } catch (e) {
      _view.onSaveError(e.toString());
    }
  }
}
