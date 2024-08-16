import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food/pages/workout/models/workout_activity_model.dart';
import 'package:food/pages/workout/presenters/workout_activity_presenter.dart';
import 'package:food/pages/workout/presenters/workout_done_presenter.dart';
import 'package:food/pages/workout/views/workout_done_view.dart';
import 'package:food/pages/workout/models/workout_done_model.dart';
import 'package:food/pages/fitnessPlans/model/fitness_plan_model.dart';
import 'package:food/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';


class WorkoutActivityView extends StatefulWidget {
  final FitnessPlan? fitnessPlan;
  final WorkoutActivityModel model;
  final String userId;
  final String workoutId;

  const WorkoutActivityView({
    Key? key,
    this.fitnessPlan,
    required this.model,
    required this.userId,
    required this.workoutId,
  }) : super(key: key);

  @override
  _WorkoutActivityViewState createState() => _WorkoutActivityViewState();
}

class _WorkoutActivityViewState extends State<WorkoutActivityView>
    implements WorkoutActivityViewInterface {
  late WorkoutActivityPresenter _presenter;
  late WorkoutActivityModel _currentModel;
  bool _isTimerRunning = false; // Track if the timer is running
  NotificationService notificationService = NotificationService();
   bool _isBreakReminderEnabled = false; // Toggle state


  @override
  void initState() {
    super.initState();
    _initializeToggleState();

    // Initialize model
    if (widget.fitnessPlan != null) {
      _currentModel = convertFitnessPlanToWorkoutActivityModel(widget.fitnessPlan!);
    } else {
      _currentModel = widget.model;
    }

    _presenter = WorkoutActivityPresenter(this, _currentModel);
    _presenter.startTimer();
    _isTimerRunning = true;

    _startWorkout();
  }

  void _initializeToggleState() async {
    // Retrieve the toggle state from SharedPreferences
    final bool isBreakReminderEnabled = await notificationService.getBreakReminderStatus();
    setState(() {
       _isBreakReminderEnabled = isBreakReminderEnabled;
    });
  }

  void _startWorkout() async {
    // Capture the start time
    DateTime workoutStartTime = DateTime.now();
      print('Workout Start Time in _Startworkout: $workoutStartTime');

    // if (_isBreakReminderEnabled) {
      print('Scheduling Break Reminder Notification');
      // Schedule break reminder notification based on start time
      notificationService.scheduleBreakReminderNotification(workoutStartTime);
    // }
  }

  @override
  void updateTimer(int remainingTime) {
    if (mounted) {
      setState(() {
        _currentModel = _currentModel.copyWith(remainingTimeInSeconds: remainingTime);
      });

      // Check if timer has reached 0
      if (remainingTime == 0) {
        _presenter.stopTimer();
        _isTimerRunning = false;
        navigateToWorkoutDone(_currentModel);
      }
    }
  }

  @override
  void navigateToNextActivity(WorkoutActivityModel model) {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WorkoutActivityView(
            model: model,
            userId: widget.userId,
            workoutId: widget.workoutId,
          ),
        ),
      );
    }
  }

  @override
  void showNotification(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void navigateToWorkoutDone(WorkoutActivityModel model) {
    if (model.startTime == null || model.endTime == null) {
      print('Start time or end time is null');
      return;
    }

    if (mounted) {
      // Use a context that's definitely valid
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => WorkoutDoneView(
                presenter: WorkoutDonePresenter(WorkoutDoneViewImplementation()),
                startTime: model.startTime!,
                endTime: model.endTime!,
                activities: model.activities,
                durations: model.durations,
                userId: widget.userId,
                workoutId: widget.workoutId,
              ),
            ),
          );
        }
      });
    }
  }

  
  // Converting fitness plan to workout model
  WorkoutActivityModel convertFitnessPlanToWorkoutActivityModel(FitnessPlan plan) {
    return WorkoutActivityModel(
      activityTitle: plan.activities.isNotEmpty ? plan.activities[0] : '',
      duration: plan.durations.isNotEmpty ? plan.durations[0] : 0,
      remainingTimeInSeconds: plan.durations.isNotEmpty ? plan.durations[0] * 60 : 0,
      activities: plan.activities,
      durations: plan.durations,
      activityIndex: 0,
      startTime: DateTime.now(),
      endTime: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    double progress = 1 - (_currentModel.remainingTimeInSeconds / (_currentModel.duration * 60));

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
                _presenter.isBreak ? 'Break' : '${_currentModel.activityTitle}',
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
                    '${_currentModel.remainingTimeInSeconds ~/ 60}:${(_currentModel.remainingTimeInSeconds % 60).toString().padLeft(2, '0')}',
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

class WorkoutDoneViewImplementation implements WorkoutDoneViewInterface {
  @override
  void updateView(WorkoutDoneModel model) {
    // Update view logic
  }
}
