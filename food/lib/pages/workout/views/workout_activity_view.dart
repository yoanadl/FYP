import 'package:flutter/material.dart';
import 'package:food/pages/workout/models/workout_activity_model.dart';
import 'package:food/pages/workout/presenters/workout_activity_presenter.dart';
import 'package:food/pages/workout/workout_done.dart';

class WorkoutActivityView extends StatefulWidget {
  final WorkoutActivityModel model;

  const WorkoutActivityView({Key? key, required this.model}) : super(key: key);

  @override
  _WorkoutActivityViewState createState() => _WorkoutActivityViewState();
}

class _WorkoutActivityViewState extends State<WorkoutActivityView> implements WorkoutActivityViewInterface {
  late WorkoutActivityPresenter _presenter;

  @override
  void initState() {
    super.initState();
    _presenter = WorkoutActivityPresenter(this, widget.model);
    _presenter.startTimer();
  }

  @override
  void updateTimer(int remainingTime) {
    setState(() {});
  }

  @override
  void navigateToNextActivity(WorkoutActivityModel model) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutActivityView(model: model),
      ),
    );
  }

  @override
  void navigateToWorkoutDone() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutDone(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double progress = 1 - (widget.model.remainingTimeInSeconds / (widget.model.duration * 60));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _presenter.isBreak ? 'Break' : '${widget.model.activityTitle}',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 10,
                    ),
                  ),
                  Text(
                    '${widget.model.remainingTimeInSeconds ~/ 60}:${(widget.model.remainingTimeInSeconds % 60).toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              IconButton(
                onPressed: () {
                  setState(() {
                    _presenter.togglePause();
                  });
                },
                icon: Icon(
                  _presenter.isPaused ? Icons.play_arrow : Icons.pause,
                  size: 50,
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 50,
                width: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFFBA1200),
                ),
                child: TextButton(
                  onPressed: () {
                    _presenter.stopTimer();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Stop Workout',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _presenter.stopTimer();
    super.dispose();
  }
}
