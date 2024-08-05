import 'package:flutter/material.dart';
import 'package:food/pages/workout/presenters/workout_done_presenter.dart';
import '../models/workout_done_model.dart';
import 'package:food/services/health_service.dart';

class WorkoutDoneView extends StatefulWidget {
  final WorkoutDonePresenter presenter;
  final DateTime? startTime;
  final DateTime? endTime;

  WorkoutDoneView({
    Key? key,
    required this.presenter,
    this.startTime,
    this.endTime,
  }) : super(key: key);

  @override
  _WorkoutDoneViewState createState() => _WorkoutDoneViewState();
}

class _WorkoutDoneViewState extends State<WorkoutDoneView> implements WorkoutDoneViewInterface {
  late WorkoutDoneModel _model;
  final HealthService _healthService = HealthService();

  @override
  void initState() {
    super.initState();

    DateTime startTime = widget.startTime ?? DateTime.now();
    DateTime endTime = widget.endTime ?? DateTime.now();

    _model = WorkoutDoneModel(
      caloriesBurned: 0,
      heartRate: 120,
      steps: 0,
      startTime: startTime,
      endTime: endTime,
    );

    widget.presenter.setModel(_model);

    _fetchHealthData(startTime, endTime);
  }


  Future<void> _fetchHealthData(DateTime startTime, DateTime endTime) async {
    
    DateTime bufferedStartTime = startTime.subtract(Duration(minutes: 30));
    DateTime bufferedEndTime = endTime.add(Duration(minutes: 30));

    print('Fetching calories burned from $bufferedStartTime to $bufferedEndTime');
    double? caloriesBurned = await _healthService.getCaloriesBurnedForThatWorkout(bufferedStartTime, bufferedEndTime);
    print('Calories burned fetched: $caloriesBurned');

    print('Fetching steps from $bufferedStartTime to $bufferedEndTime');
    int? steps = await _healthService.getStepsForThatWorkout(bufferedStartTime, bufferedEndTime);
    print('Steps fetched: $steps');

    setState(() {
      _model = _model.copyWith(
        caloriesBurned: caloriesBurned,
        steps: steps,
      );
      widget.presenter.updateView(_model);
    });
  }

  @override
  void updateView(WorkoutDoneModel model) {
    setState(() {
      _model = model;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'You did it!',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              _buildStatsRow(
                icon: Icons.local_fire_department,
                text: 'Calories burned: ${_model.caloriesBurned} kcal',
              ),

              SizedBox(height: 30),
              _buildStatsRow(
                icon: Icons.directions_walk,
                text: 'Steps took: ${_model.steps} steps',
              ),
              SizedBox(height: 30),
              _buildStatsRow(
                icon: Icons.favorite,
                text: 'Heart rate: ${_model.heartRate} bpm',
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Exit Workout',
                  style: TextStyle(fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff031927),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow({required IconData icon, required String text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 30),
        SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}
