import 'package:flutter/foundation.dart';

@immutable
class WorkoutDoneModel {
  final double caloriesBurned;
  final int heartRate;
  final int steps;
  final DateTime startTime;
  final DateTime endTime;

  const WorkoutDoneModel({
    required this.caloriesBurned,
    required this.heartRate,
    required this.steps,
    required this.startTime,
    required this.endTime,
  });

  WorkoutDoneModel copyWith({
    double? caloriesBurned,
    int? heartRate,
    int? steps,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    return WorkoutDoneModel(
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      heartRate: heartRate ?? this.heartRate,
      steps: steps ?? this.steps,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}
