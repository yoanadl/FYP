
import 'package:food/pages/workout/models/workout_done_model.dart';


abstract class WorkoutDoneViewInterface {
  void updateView(WorkoutDoneModel model);
}

class WorkoutDonePresenter {
  final WorkoutDoneViewInterface view;
  late WorkoutDoneModel _model;

  WorkoutDonePresenter(this.view);

  void setModel(WorkoutDoneModel model) {
    _model = model;
    view.updateView(_model);
  }
}
