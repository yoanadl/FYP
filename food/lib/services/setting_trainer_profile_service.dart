import 'package:cloud_firestore/cloud_firestore.dart';

class TrainerSettingProfileService {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> createProfile(String uid, {
    required int age,
    required int height,
    required int weight,
    required String name,
    required String fitnessGoals,
    required String gender,
  }) async {
    try {
      // Prepare the profile data
      Map<String, dynamic> profileData = {
        'age': age,
        'height': height,
        'name': name,
        'weight': weight,
        'fitnessGoals': fitnessGoals,
        'gender': gender,
      };

      // Add profile document with the given data
      await usersCollection.doc(uid).collection('TrainerProfile').add(profileData);
      print('Profile created successfully!');
    } catch (e) {
      print('Error creating profile: $e');
      throw Exception('Failed to create profile.');
    }
  }

  Future<List<Map<String, dynamic>>> getUserProfile(String uid) async {
    try {
      QuerySnapshot querySnapshot = await usersCollection
          .doc(uid)
          .collection('TrainerProfile')
          .get();
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error retrieving user profile: $e');
      throw Exception('Failed to retrieve user profile.');
    }
  }

  Future<void> updateSettingProfile(String uid, Map<String, dynamic> newData) async {
    try {
      QuerySnapshot querySnapshot = await usersCollection
          .doc(uid)
          .collection('TrainerProfile')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Update the existing profile
        String profileId = querySnapshot.docs[0].id;
        await usersCollection
            .doc(uid)
            .collection('TrainerProfile')
            .doc(profileId)
            .update(newData);
        print('Profile updated successfully!');
      } else {
        print('No trainer profile found for uid: $uid');
        // Create a default profile if it doesn't exist
        await createProfile(
          uid,
          age: 0,
          height: 0,
          weight: 0,
          name: "Default Name",
          fitnessGoals: "Default Goals",
          gender: "Unspecified",
        );
        print('Profile created successfully with default values!');
      }
    } catch (e) {
      print('Error updating profile: $e');
      throw Exception('Failed to update profile.');
    }
  }

  Future<Map<String, dynamic>?> fetchUserData(String uid) async {
    try {
      QuerySnapshot querySnapshot = await usersCollection
          .doc(uid)
          .collection('TrainerProfile')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot docSnapshot = querySnapshot.docs[0];
        return docSnapshot.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      print('Error fetching user data: $e');
      throw Exception('Failed to fetch user data.');
    }
  }

  Future<String?> fetchProfilePictureUrl(String uid) async {
    try {
      DocumentSnapshot userDoc = await usersCollection.doc(uid).get();
      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
      return userData?['profilePictureUrl'];
    } catch (e) {
      print('Error fetching profile picture URL: $e');
      return null;
    }
  }
}
