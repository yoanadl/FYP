import 'package:flutter/foundation.dart';

@immutable
class WorkoutDoneModel {
  final double caloriesBurned;
  final double averageHeartRate;
  final double maxHeartRate;
  final int steps;
  final DateTime startTime;
  final DateTime endTime;
  final List<String> activities;
  final List<int> durations;

  const WorkoutDoneModel({
    required this.caloriesBurned,
    required this.averageHeartRate,
    required this.maxHeartRate,
    required this.steps,
    required this.startTime,
    required this.endTime,
    required this.activities,
    required this.durations,
  });

  WorkoutDoneModel copyWith({
    double? caloriesBurned,
    double? averageHeartRate,
    double? maxHeartRate,
    int? steps,
    DateTime? startTime,
    DateTime? endTime,
    List<String>? activities,
    List<int>? durations,
  }) {
    return WorkoutDoneModel(
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      averageHeartRate: averageHeartRate ?? this.averageHeartRate,
      maxHeartRate: maxHeartRate ?? this.maxHeartRate,
      steps: steps ?? this.steps,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      activities: activities ?? this.activities,
      durations: durations ?? this.durations,
    );
  }
}
