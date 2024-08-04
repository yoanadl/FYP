import 'package:flutter/material.dart';
import 'package:food/pages/workout/presenters/workout_done_presenter.dart';
import '../models/workout_done_model.dart';

class WorkoutDoneView extends StatefulWidget {
  final WorkoutDonePresenter presenter;

  WorkoutDoneView({Key? key, required this.presenter}) : super(key: key);

  @override
  _WorkoutDoneViewState createState() => _WorkoutDoneViewState();
}

class _WorkoutDoneViewState extends State<WorkoutDoneView> implements WorkoutDoneViewInterface {
  late WorkoutDoneModel _model;

  @override
  void initState() {
    super.initState();
    
    // Initialize presenter and model
    widget.presenter.setModel(WorkoutDoneModel(
      caloriesBurned: 300, 
      heartRate: 120,    
    ));
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
