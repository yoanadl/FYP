import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food/services/workout_service.dart';

class CommunityPageSummary extends StatelessWidget {
  final String communityname;
  final List<String> communityintro;
  final List<int> communitymemberamount;

  CommunityPageSummary({
    required this.communityname,
    required this.communityintro,
    required this.communitymemberamount,
  });

  final WorkoutService _workoutService = WorkoutService();

  Future<void> _addToOngoingWorkouts(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _workoutService.saveUserWorkout(
        user.uid,
        communityname,
        communityintro,
        communitymemberamount, 
        true,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Community added to your joined community')),
      );
      Navigator.pop(context); // Navigate back to previous page
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You need to be logged in to add community')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Community Intro',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          )),
      ),
      body: Padding(
        padding: EdgeInsets.all(35.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              communityname,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'About:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            ...communityintro.asMap().entries.map((entry) {
              int index = entry.key;
              String activity = entry.value;
              return ListTile(
                title: Text(activity),
                subtitle: Text('Members: ${communitymemberamount[index]}'),
              );
            }).toList(),
            SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: () => _addToOngoingWorkouts(context),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff031927), 
                    foregroundColor: Colors.white, 
                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                ),
                child: Text('Join Community'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}