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

  void startWorkout() async {
    // Workout logic...
  }

  @override
  Widget build(BuildContext context) {
    final plan = widget.fitnessPlan;

    return Scaffold(
      appBar: AppBar(
        title: Text(plan.title, style: TextStyle(fontFamily: 'Poppins')),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
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
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      plan.goals,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Level:',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      plan.level,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Tags:',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      plan.tags.join(', '),
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Activities:',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Expanded(
                      child: ListView.builder(
                        itemCount: plan.activities.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              plan.activities[index],
                              style: TextStyle(fontFamily: 'Poppins'),
                            ),
                            subtitle: Text(
                              'Duration: ${plan.durations[index]} minutes',
                              style: TextStyle(fontFamily: 'Poppins'),
                            ),
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
                  style: TextStyle(fontSize: 20.0, fontFamily: 'Poppins'),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0XFF508AA8),
                  padding: EdgeInsets.symmetric(vertical: 16.0), 
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
