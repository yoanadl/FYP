import 'package:flutter/material.dart';
import 'dart:async';

class WorkoutActivityPage extends StatefulWidget {
  final String activityTitle;
  final int duration; // duration in minutes
  final int activityIndex;
  final List<String> activities;
  final List<int> durations;

  const WorkoutActivityPage({
    Key? key,
    required this.activityTitle,
    required this.duration,
    required this.activityIndex,
    required this.activities,
    required this.durations,
  }) : super(key: key);

  @override
  _WorkoutActivityPageState createState() => _WorkoutActivityPageState();
}

class _WorkoutActivityPageState extends State<WorkoutActivityPage> {
  Timer? _timer;
  late int _remainingTime = widget.duration * 60; // convert minutes to seconds
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0 && !_isPaused) {
        setState(() {
          _remainingTime--;
        });
      } else if (_remainingTime == 0) {
        _timer?.cancel();
        if (widget.activityIndex < widget.activities.length - 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => WorkoutActivityPage(
                activityTitle: widget.activities[widget.activityIndex + 1],
                duration: widget.durations[widget.activityIndex + 1],
                activityIndex: widget.activityIndex + 1,
                activities: widget.activities,
                durations: widget.durations,
              ),
            ),
          );
        } else {
          Navigator.pop(context);
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = _remainingTime / (widget.duration * 60);
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.activityTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${widget.activityTitle}',
                style: TextStyle(
                  fontSize: 30, 
                  fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
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
                    '${_remainingTime ~/ 60}:${(_remainingTime % 60).toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontSize: 30, 
                      fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                '12 kcal burnt',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                'Your goal: 100 kcal',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isPaused = !_isPaused;
                  });
                },
                child: Text(_isPaused ? 'Resume Workout' : 'Pause Workout'),
              ),
              ElevatedButton(
                onPressed: () {
                  _timer?.cancel();
                  Navigator.pop(context);
                },
                child: Text('Stop Workout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
