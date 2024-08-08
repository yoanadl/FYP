import 'package:flutter/foundation.dart';

@immutable
class WorkoutActivityModel {
  final String activityTitle;
  final int duration; // Duration in minutes
  final int remainingTimeInSeconds; // Remaining time in seconds
  final List<String> activities;
  final List<int> durations;
  final int activityIndex;
  final DateTime? startTime;
  final DateTime? endTime;

  const WorkoutActivityModel({
    required this.activityTitle,
    required this.duration,
    required this.remainingTimeInSeconds,
    required this.activities,
    required this.durations,
    required this.activityIndex,
    this.startTime,
    this.endTime,
  });

  WorkoutActivityModel copyWith({
    String? activityTitle,
    int? duration,
    int? remainingTimeInSeconds,
    List<String>? activities,
    List<int>? durations,
    int? activityIndex,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    return WorkoutActivityModel(
      activityTitle: activityTitle ?? this.activityTitle,
      duration: duration ?? this.duration,
      remainingTimeInSeconds: remainingTimeInSeconds ?? this.remainingTimeInSeconds,
      activities: activities ?? this.activities,
      durations: durations ?? this.durations,
      activityIndex: activityIndex ?? this.activityIndex,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}
