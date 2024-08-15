import 'package:cloud_firestore/cloud_firestore.dart';

class TrainerSettingProfileService {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  // Method to create a profile with named parameters
  Future<void> createProfile(String uid, {
    required int age,
    required int experience,
    required List<String> expertise,
    required String name,
    String? profilePictureUrl,
  }) async {
    try {
      // Prepare the profile data
      Map<String, dynamic> profileData = {
        'age': age,
        'experience': experience,
        'expertise': expertise,
        'name': name,
        'profilePictureUrl': profilePictureUrl,
      };

      // Add profile document with the given data
      await usersCollection.doc(uid).collection('TrainerProfile').add(profileData);
      print('Profile created successfully!');
    } catch (e) {
      print('Error creating profile: $e');
      throw Exception('Failed to create profile.');
    }
  }

  // Method to get user profiles
  Future<List<Map<String, dynamic>>> getUserProfiles(String uid) async {
    try {
      QuerySnapshot querySnapshot = await usersCollection
          .doc(uid)
          .collection('TrainerProfile')
          .get();
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error retrieving user profiles: $e');
      throw Exception('Failed to retrieve user profiles.');
    }
  }

  // Method to update the profile or create a default profile if none exists
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
          experience: 0,
          expertise: ['Default Expertise'],
          name: "Default Name",
          profilePictureUrl: null,
        );
        print('Profile created successfully with default values!');
      }
    } catch (e) {
      print('Error updating profile: $e');
      throw Exception('Failed to update profile.');
    }
  }

  // Method to fetch user data
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

  // Method to fetch the user's profile picture URL
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

  // Method to fetch the trainer's experience
  Future<int?> getTrainerExperience(String uid) async {
    try {
      Map<String, dynamic>? userData = await fetchUserData(uid);

      if (userData != null) {
        int? experience = userData['experience'] as int?;
        return experience;
      } else {
        print('No trainer data found for uid: $uid');
        return null;
      }
    } catch (e) {
      print('Error fetching experience: $e');
      throw Exception('Failed to fetch experience.');
    }
  }
}
