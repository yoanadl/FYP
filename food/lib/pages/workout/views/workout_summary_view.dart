import 'package:flutter/material.dart';
import 'package:food/components/navbar.dart';
import 'package:food/pages/base_page.dart';
import 'package:food/pages/community_page.dart';
import 'package:food/pages/profile_page.dart';
import 'package:food/pages/workout/edit_workout_page.dart';
import 'package:food/pages/workout/presenters/workout_summary_presenter.dart';
import 'package:food/pages/workout/views/edit_workout_view.dart';
import 'package:food/pages/workout/workout_activity.dart';
import 'package:food/pages/workout/workout_page.dart';

class WorkoutSummaryView extends StatelessWidget {
  final WorkoutSummaryPresenter presenter;

  const WorkoutSummaryView({Key? key, required this.presenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Workout Summary',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => presenter.confirmDelete(context),
            icon: const Icon(Icons.delete)
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => EditWorkoutView(
                    userId: presenter.userId,
                    workoutId: presenter.workoutId ?? '',
                    workoutTitle: presenter.workoutTitle,
                    duration: presenter.duration,
                    activities: presenter.activities,
                  ),
                ),
              );
            }, 
            icon: const Icon(Icons.edit)
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Workout Title: ${presenter.workoutTitle}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Total Duration: ${presenter.totalDuration} min',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Activities:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: presenter.activities.asMap().entries.map((entry) {
                int index = entry.key;
                String activity = entry.value;
                return Text(
                  '- $activity (${presenter.duration[index]} min)',
                  style: TextStyle(fontSize: 14),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => WorkoutActivityPage(
                        activityTitle: presenter.activities[0],
                        duration: presenter.duration[0], 
                        activityIndex: 0, 
                        activities: presenter.activities, 
                        durations: presenter.duration,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff031927), 
                  foregroundColor: Colors.white, 
                ),
                child: Text('Start Workout'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Navbar(
        currentIndex: 1,
        onTap: (int index) {
          if (index != 1) {
            Navigator.pop(context);
            switch (index) {
              case 0:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const BasePage()));
                break;
              case 1:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const WorkoutPage()));
                break;
              case 2:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CommunityPage()));
                break;
              case 3:
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
                break;
            }
          }
        },
      ),
    );
  }
}
