import 'dart:async';
import 'package:food/pages/workout/models/workout_activity_model.dart';

abstract class WorkoutActivityViewInterface {
  void updateTimer(int remainingTime);
  void navigateToNextActivity(WorkoutActivityModel model);
  void navigateToWorkoutDone(WorkoutActivityModel model); // Interface method
}

class WorkoutActivityPresenter {
  final WorkoutActivityViewInterface _view;
  WorkoutActivityModel _model;
  Timer? _timer;

  bool _isPaused = false;
  bool _isBreak = false;

  WorkoutActivityPresenter(this._view, this._model);

  bool get isPaused => _isPaused;
  bool get isBreak => _isBreak;

  void startTimer() {
    if (_isBreak) {
      _model = _model.copyWith(remainingTimeInSeconds: 30); // 30-second break
    } else {
      _model = _model.copyWith(
        remainingTimeInSeconds: _model.duration * 60, // Duration in seconds
        startTime: DateTime.now(), 
        
      );
      print('Workout started at: ${_model.startTime}');
    }

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_model.remainingTimeInSeconds > 0 && !_isPaused) {
        _model = _model.copyWith(remainingTimeInSeconds: _model.remainingTimeInSeconds - 1);
        _view.updateTimer(_model.remainingTimeInSeconds);
      } else if (_model.remainingTimeInSeconds == 0) {
        _timer?.cancel();
        if (_isBreak) {
          _isBreak = false;
          if (_model.activityIndex < _model.activities.length - 1) {
            _view.navigateToNextActivity(
              _model.copyWith(
                activityTitle: _model.activities[_model.activityIndex + 1],
                duration: _model.durations[_model.activityIndex + 1],
                activityIndex: _model.activityIndex + 1,
                endTime: DateTime.now(),
              ),
            );
          } else {
            _model = _model.copyWith(endTime: DateTime.now());
            _view.navigateToWorkoutDone(_model); 
          }
        } else {
          if (_model.activityIndex < _model.activities.length - 1) {
            _isBreak = true;
            startTimer();
          } else {
            _model = _model.copyWith(endTime: DateTime.now()); 
            _view.navigateToWorkoutDone(_model); 
          }
        }
      }
    });
  }

  void togglePause() {
    _isPaused = !_isPaused;
  }

  void stopTimer() {
    _timer?.cancel();
    _model = _model.copyWith(endTime: DateTime.now()); 
    print('Workout ended at: ${_model.endTime}');
    _view.navigateToWorkoutDone(_model);

  }
}
