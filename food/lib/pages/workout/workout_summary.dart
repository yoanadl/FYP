import 'package:flutter/material.dart';
import 'package:food/pages/workout/edit_workout_page.dart';
import 'package:food/pages/workout/workout_activity.dart';
import 'package:food/services/workout_service.dart';
import '../../components/navbar.dart';
import '../base_page.dart';
import '../community_page.dart';
import '../profile_page.dart';
import 'workout_page.dart';

class WorkoutSummaryPage extends StatelessWidget {
  final String workoutTitle;
  final List<int> duration;
  final List<String> activities;
  final String userId;
  final String? workoutId; 

  const WorkoutSummaryPage({
    Key? key,
    required this.workoutTitle,
    required this.duration,
    required this.activities,
    required this.userId,
    this.workoutId,
  }) : super(key: key);

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
            onPressed: () {

            }, 
            icon: const Icon(Icons.delete)
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => EditWorkoutPage(
                  userId: userId,
                  workoutId: workoutId ?? '',
                  workoutTitle: workoutTitle,
                  duration: duration,
                  activities: activities,
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
              'Workout Title: $workoutTitle',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Total Duration: ${duration.reduce((a, b) => a + b)} min',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Activities:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: activities.asMap().entries.map((entry) {
                int index = entry.key;
                String activity = entry.value;
                return Text(
                  '- $activity (${duration[index]} min)',
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
                        activityTitle: activities[0],
                        duration: duration[0], 
                        activityIndex: 0, 
                        activities: activities, 
                        durations: duration,
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
