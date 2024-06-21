import 'package:cloud_firestore/cloud_firestore.dart';

class SettingprofileService {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> createProfile(
      String uid, Map<String, dynamic> profile) async {
    try {
      await usersCollection
          .doc(uid)
          .collection('UserProfile')
          .add(profile);
    } catch (e) {
      print('Error creating profile: $e');
      throw Exception('Failed to create profile.');
    }
  }

  Future<List<Map<String, dynamic>>> getUserWorkouts(
      String uid) async {
    try {
      QuerySnapshot querySnapshot = await usersCollection
          .doc(uid)
          .collection('workouts')
          .get();
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
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

  Future<void> updateSettingProfile(
  String uid, Map<String, dynamic> newData) async {
  try {
    // Query Firestore to find UserProfile document based on uid
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('UserProfile')
        .get();

    // Assuming there's only one document per user (or you have logic to handle multiple)
    if (querySnapshot.docs.isNotEmpty) {
      String userprofileId = querySnapshot.docs[0].id;

      // Update the document using userprofileId
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('UserProfile')
          .doc(userprofileId)
          .update(newData);
      print('Profile updated successfully!');
    } else {
      print('No user profile found for uid: $uid');
      throw Exception('No user profile found.');
    }
  } catch (e) {
    print('Error updating profile: $e');
    throw Exception('Failed to update profile.');
  }
}
}