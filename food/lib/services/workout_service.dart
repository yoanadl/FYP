import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:food/pages/workout/models/workout_done_model.dart';

class WorkoutService {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  // Create a new workout and return its ID
  Future<String> createWorkoutData(
      String uid, Map<String, dynamic> workoutData) async {
    try {
      DocumentReference workoutRef = await usersCollection
          .doc(uid)
          .collection('workouts')
          .add(workoutData);

      return workoutRef.id;
    } catch (e) {
      print('Error creating workout: $e');
      throw Exception('Failed to create workout.');
    }
  }

  // Retrieve all workouts for a given user
  Future<List<Map<String, dynamic>>> getUserWorkouts(String uid) async {
    try {
      QuerySnapshot querySnapshot = await usersCollection
          .doc(uid)
          .collection('workouts')
          .get();

      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Include the document ID in the map
        return data;
      }).toList();
    } catch (e) {
      print('Error retrieving user workouts: $e');
      throw Exception('Failed to retrieve user workouts.');
    }
  }

  // Save workout details created by the user
  Future<void> saveUserWorkout(
      String uid,
      String workoutTitle,
      List<String> activities,
      List<int> duration,
      bool isPremade) async {
    try {
      await usersCollection
          .doc(uid)
          .collection('workouts')
          .add({
        'title': workoutTitle,
        'activities': activities,
        'durations': duration,
        'isPremade': isPremade,
      });
    } catch (e) {
      print('Error saving workout: $e');
      throw Exception('Failed to save workout.');
    }
  }

  // Update workout data for a specific workout
  Future<void> updateWorkoutData(
      String uid, String workoutId, Map<String, dynamic> newData) async {
    try {
      await usersCollection
          .doc(uid)
          .collection('workouts')
          .doc(workoutId)
          .set(newData, SetOptions(merge: true)); 

    } catch (e) {
      print('Error updating workout: $e');
      throw Exception('Failed to update workout.');
    }
  }

  // Delete a workout
  Future<void> deleteWorkout(String userId, String workoutId) async {
    try {
      await usersCollection
          .doc(userId)
          .collection('workouts')
          .doc(workoutId)
          .delete();
    } catch (e) {
      print('Error deleting workout: $e');
      throw Exception('Failed to delete workout.');
    }
  }

  // Save workout data from an external source
  Future<void> saveWorkoutData(String userId, String workoutId, WorkoutDoneModel model) async {
    try {
      final instanceId = DateTime.now().toIso8601String();

      await usersCollection
          .doc(userId)
          .collection('workouts')
          .doc(workoutId)
          .collection('instances')
          .doc(instanceId)
          .set({
            'startTime': Timestamp.fromDate(model.startTime),
            'endTime': Timestamp.fromDate(model.endTime),
            'calories': model.caloriesBurned,
            'steps': model.steps,
            'averageHeartRate': model.averageHeartRate,
            'maxHeartRate': model.maxHeartRate,
          });

      print("Workout data saved successfully");

      // Check and send notification
      final workoutService = WorkoutService();
      await workoutService.checkAndSendNotification(userId);

    } catch (e) {
      print("Error saving workout data: $e");
    }
  }

  // Retrieve workout data instances
  Future<List<Map<String, dynamic>>> getWorkoutDataInstances(String userId, String workoutId) async {
    try {
      QuerySnapshot querySnapshot = await usersCollection
          .doc(userId)
          .collection('workouts')
          .doc(workoutId)
          .collection('instances')
          .get();

      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Include the document ID in the map
        return data;
      }).toList();
    } catch (e) {
      print('Error retrieving workout data instances: $e');
      throw Exception('Failed to retrieve workout data instances.');
    }
  }


  Future<int> getWorkoutCountForCurrentWeek(String userId) async {
  try {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(Duration(days: 6));

    print('Fetching workouts from $startOfWeek to $endOfWeek');

    // Get all workout documents for the user
    final workoutsSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('workouts')
        .get();

    int workoutCount = 0;

    for (var workoutDoc in workoutsSnapshot.docs) {
      // For each workout document, query the 'instances' subcollection
      final instancesSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('workouts')
          .doc(workoutDoc.id)
          .collection('instances')
          .where('startTime', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfWeek))
          .where('startTime', isLessThanOrEqualTo: Timestamp.fromDate(endOfWeek))
          .get();

      workoutCount += instancesSnapshot.docs.length;
    }

    print('Number of workouts completed this week: $workoutCount');
    return workoutCount;
  } catch (e) {
    print('Error retrieving workout count: $e');
    return 0;
  }
}

  Future<void> sendWorkoutsCompletedNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'workouts_channel_id',
      'Workouts Channel',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await _flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      'Congratulations!',
      'You have completed 10 workouts this week! Take a break and keep up the great work!',
      notificationDetails,
      payload: 'workout_done',
    );
  }


  Future<void> checkAndSendNotification(String userId) async {
  try {
    final workoutCount = await getWorkoutCountForCurrentWeek(userId);

    // Debug statement to print the workout count
    print('Workout count for current week: $workoutCount');

    if (workoutCount > 10) {
      print('User has completed more than 10 workouts. Sending notification...');
      await sendWorkoutsCompletedNotification();
    } else {
      print('User has not completed more than 10 workouts. No notification sent.');
    }
  } catch (e) {
    print('Error checking and sending notification: $e');
  }
}


}

