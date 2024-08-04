// workout_activity_model.dart

class WorkoutActivityModel {
  final String activityTitle;
  final int duration; // Duration in minutes
  final int activityIndex;
  final List<String> activities;
  final List<int> durations;
  final int remainingTimeInSeconds; 

  WorkoutActivityModel({
    required this.activityTitle,
    required this.duration,
    required this.activityIndex,
    required this.activities,
    required this.durations,
    required this.remainingTimeInSeconds, // Initialize this in the constructor
  });

  WorkoutActivityModel copyWith({
    String? activityTitle,
    int? duration,
    int? activityIndex,
    List<String>? activities,
    List<int>? durations,
    int? remainingTimeInSeconds,
  }) {
    return WorkoutActivityModel(
      activityTitle: activityTitle ?? this.activityTitle,
      duration: duration ?? this.duration,
      activityIndex: activityIndex ?? this.activityIndex,
      activities: activities ?? this.activities,
      durations: durations ?? this.durations,
      remainingTimeInSeconds: remainingTimeInSeconds ?? this.remainingTimeInSeconds,
    );
  }
}
