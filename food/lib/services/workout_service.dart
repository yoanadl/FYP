import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutService {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> createWorkoutData(
      String uid, Map<String, dynamic> workoutData) async {
    try {

      // Access the Firestore collection 'workouts' under the user's document identified by 'uid'
      await usersCollection
          .doc(uid) // Get the document reference for the user using 'uid'
          .collection('workouts') // Access the subcollection 'workouts' under the user document
          .add(workoutData); // Add a new document with workoutData to the 'workouts' collection
    } catch (e) {
      print('Error creating workout: $e');
      throw Exception('Failed to create workout.');
    }
  }

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

  Future<void> deleteWorkout(String userId, String workoutId) async {
    try {
      await usersCollection
        .doc(userId)
        .collection('workouts')
        .doc(workoutId)
        .delete();
    }

    catch(e) {
      print('Error deleting workout: $e');
      throw Exception('Failed to delete workout.');
    }
  }
}
