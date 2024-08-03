
import 'package:flutter/material.dart';
import 'dart:async';

import 'workout_done.dart';

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
  late int _remainingTime; // Remaining time in seconds
  bool _isPaused = false;
  bool _isBreak = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    if (_isBreak) {
      _remainingTime = 30; // 30-second break
    } else {
      _remainingTime = widget.duration * 60; // Duration in seconds
    }

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0 && !_isPaused) {
        setState(() {
          _remainingTime--;
        });
      } else if (_remainingTime == 0) {
        _timer?.cancel();
        if (_isBreak) {
          // Proceed to next activity
          _isBreak = false;
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
          } 
          
          else {
            // Navigate to WorkoutDonePage when all activities are completed
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => WorkoutDone(),
              ),
            );
          }

        } 
        
        else {
          // Start break timer only if it's not the last activity
          if (widget.activityIndex < widget.activities.length - 1) {
            _isBreak = true;
          _startTimer();
          }

          else {

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => WorkoutDone(),
              ),
            );
          }
          
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
    double progress = 1 - (_remainingTime / (widget.duration * 60)); // Reverse progress for break time
    
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
                _isBreak ? 'Break' : '${widget.activityTitle}',
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
                    '${_remainingTime ~/ 60}:${(_remainingTime % 60).toString().padLeft(2, '0')}',
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
                    _isPaused = !_isPaused;
                  });
                },
                icon: Icon(
                  _isPaused ? Icons.play_arrow : Icons.pause,
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
                    _timer?.cancel();
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
}

