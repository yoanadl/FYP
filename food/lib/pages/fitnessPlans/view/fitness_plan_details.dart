import 'package:flutter/material.dart';
import 'package:food/pages/fitnessPlans/model/fitness_plan_model.dart';
import 'package:food/pages/workout/views/workout_activity_view.dart';
import 'package:food/services/workout_service.dart'; 
import 'package:food/pages/workout/models/workout_activity_model.dart';

class FitnessPlanDetailPage extends StatefulWidget {
  final FitnessPlan fitnessPlan;
  final String userId;

  const FitnessPlanDetailPage({
    Key? key,
    required this.fitnessPlan,
    required this.userId,
  }) : super(key: key);

  @override
  _FitnessPlanDetailPageState createState() => _FitnessPlanDetailPageState();
}

class _FitnessPlanDetailPageState extends State<FitnessPlanDetailPage> {
  final WorkoutService _workoutService = WorkoutService(); // Initialize the workout service

  @override
  void initState() {
    super.initState();
  }

  // Function to start a workout, either by finding an existing one or creating a new one
  void startWorkout() async {
    try {
      // Step 1: Check if a workout already exists for this fitness plan
      List<Map<String, dynamic>> workouts = await _workoutService.getUserWorkouts(widget.userId);
      String? existingWorkoutId;

      for (var workout in workouts) {
        if (workout['title'] == widget.fitnessPlan.title) {
          existingWorkoutId = workout['id'];
          break;
        }
      }

      if (existingWorkoutId != null) {
        // Workout exists, navigate to it
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkoutActivityView(
              fitnessPlan: widget.fitnessPlan,
              userId: widget.userId,
              workoutId: existingWorkoutId!,
              model: WorkoutActivityModel(
                activityTitle: widget.fitnessPlan.activities.isNotEmpty ? widget.fitnessPlan.activities[0] : '',
                duration: widget.fitnessPlan.durations.isNotEmpty ? widget.fitnessPlan.durations[0] : 0,
                remainingTimeInSeconds: widget.fitnessPlan.durations.isNotEmpty ? widget.fitnessPlan.durations[0] * 60 : 0,
                activities: widget.fitnessPlan.activities,
                durations: widget.fitnessPlan.durations,
                activityIndex: 0,
                startTime: DateTime.now(),
                endTime: null,
              ),
            ),
          ),
        );
      } else {
        // Step 2: Create a new workout
        String newWorkoutId = await _workoutService.createWorkoutData(
          widget.userId,
          {
            'title': widget.fitnessPlan.title,
            'activities': widget.fitnessPlan.activities,
            'durations': widget.fitnessPlan.durations,
          },
        );

        // Step 3: Navigate to the newly created workout
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkoutActivityView(
              fitnessPlan: widget.fitnessPlan,
              userId: widget.userId,
              workoutId: newWorkoutId,
              model: WorkoutActivityModel(
                activityTitle: widget.fitnessPlan.activities.isNotEmpty ? widget.fitnessPlan.activities[0] : '',
                duration: widget.fitnessPlan.durations.isNotEmpty ? widget.fitnessPlan.durations[0] : 0,
                remainingTimeInSeconds: widget.fitnessPlan.durations.isNotEmpty ? widget.fitnessPlan.durations[0] * 60 : 0,
                activities: widget.fitnessPlan.activities,
                durations: widget.fitnessPlan.durations,
                activityIndex: 0,
                startTime: DateTime.now(),
                endTime: null,
              ),
            ),
          ),
        );
      }
    } catch (e) {
      print('Error starting workout: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to start workout')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final plan = widget.fitnessPlan;

    return Scaffold(
      appBar: AppBar(
        title: Text(plan.title),
        backgroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Goals:',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    plan.goals,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Level:',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    plan.level,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Tags:',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    plan.tags.join(', '),
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Activities:',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Expanded(
                    child: ListView.builder(
                      itemCount: plan.activities.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(plan.activities[index]),
                          subtitle: Text('Duration: ${plan.durations[index]} minutes'),
                          contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                          leading: Icon(Icons.fitness_center),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: startWorkout,
              child: Text(
                'Start',
                style: TextStyle(fontSize: 20.0),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Color(0XFF508AA8), 
                padding: EdgeInsets.symmetric(vertical: 16.0), 
              ),
            ),
          ),
        ],
      ),
    );
  }
}
