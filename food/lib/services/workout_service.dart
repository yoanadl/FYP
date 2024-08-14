import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food/pages/workout/models/workout_done_model.dart';

class WorkoutService {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

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
      List<int> duration) async {
    try {
      await usersCollection
          .doc(uid)
          .collection('workouts')
          .add({
        'title': workoutTitle,
        'activities': activities,
        'durations': duration,
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
          .update(newData);
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
}
