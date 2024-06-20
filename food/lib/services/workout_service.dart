import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutService {
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  Future<void> createWorkoutData(String uid, Map<String, dynamic> workoutData) async {
    try {
      await usersCollection.doc(uid).collection('workouts').add(workoutData);
    } catch (e) {
      print('Error creating workout: $e');
      throw Exception('Failed to create workout.');
    }
  }

  Future<List<Map<String, dynamic>>> getUserWorkouts(String uid) async {
    try {
      QuerySnapshot querySnapshot = await usersCollection.doc(uid).collection('workouts').get();
      return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error retrieving user workouts: $e');
      throw Exception('Failed to retrieve user workouts.');
    }
  }
  
  Future<void> updateWorkoutData(String uid, String workoutId, Map<String, dynamic> newData) async {
    try {
      await usersCollection.doc(uid).collection('workouts').doc(workoutId).update(newData);
    } catch (e) {
      print('Error updating workout: $e');
      throw Exception('Failed to update workout.');
    }
  }
}
