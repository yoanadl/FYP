// pre_made_workout_summary_view.dart
import 'package:flutter/material.dart';
import 'package:food/pages/workout/presenters/premade_workout_summary_presenter.dart';

class PreMadeWorkoutSummaryView extends StatelessWidget {
  final PreMadeWorkoutSummaryPresenter presenter;

  PreMadeWorkoutSummaryView({
    required String workoutTitle,
    required List<String> activities,
    required List<int> duration,
  }) : presenter = PreMadeWorkoutSummaryPresenter(
          workoutTitle: workoutTitle,
          activities: activities,
          duration: duration,
        );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Workout Summary',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(35.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              presenter.workoutTitle,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Activities:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            ...presenter.activities.asMap().entries.map((entry) {
              int index = entry.key;
              String activity = entry.value;
              return ListTile(
                title: Text(activity),
                subtitle: Text('Duration: ${presenter.duration[index]} minutes'),
              );
            }).toList(),
            SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: () => presenter.addToOngoingWorkouts(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff031927),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                ),
                child: Text('Add to My Workouts'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
