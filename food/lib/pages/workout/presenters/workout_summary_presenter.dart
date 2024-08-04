import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:food/services/workout_service.dart';

class WorkoutSummaryPresenter {
  final String workoutTitle;
  final List<int> duration;
  final List<String> activities;
  final String userId;
  final String? workoutId;
  final VoidCallback? onDelete;

  WorkoutSummaryPresenter({
    required this.workoutTitle,
    required this.duration,
    required this.activities,
    required this.userId,
    this.workoutId,
    this.onDelete,
  });

  int get totalDuration => duration.reduce((a, b) => a + b);

  Future<void> confirmDelete(BuildContext context) async {
    showCupertinoDialog(
      context: context, 
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Delete Workout'),
          content: Text('Are you sure you want to delete this workout?'),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              }, 
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text(
                'Delete', 
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await deleteWorkout(context);
              },
              )
            ],
          );
      },
    );
  }

  Future<void> deleteWorkout(BuildContext context) async {
    if (workoutId != null && workoutId!.isNotEmpty) {
      try {
        await WorkoutService().deleteWorkout(userId, workoutId!);
        onDelete?.call(); // call the callback to refresh the workout list
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('The selected workout has been successfully deleted')),
        );
        Navigator.pop(context); // Go back to the previous screen
      } 
      catch (e) {
        // Handle error
        print('Failed to delete workout: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete workout')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid workout ID')),
      );
    }
  }
}
