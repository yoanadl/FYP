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

  Future<List<Map<String, dynamic>>> getUserProfile(
      String uid) async {
    try {
      QuerySnapshot querySnapshot = await usersCollection
          .doc(uid)
          .collection('UserProfile')
          .get();
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error retrieving user profile: $e');
      throw Exception('Failed to retrieve user profile.');
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

  // fetch user data

  Future<Map<String, dynamic>?> fetchUserData(String uid) async {
    try {
      // Query the 'UserProfile' collection under the specified user document
      QuerySnapshot querySnapshot = await usersCollection
          .doc(uid)
          .collection('UserProfile')
          .get();

      // Check if there's at least one document in the 'UserProfile' collection
      if (querySnapshot.docs.isNotEmpty) {
        // Assuming the first document is the one we need
        DocumentSnapshot docSnapshot = querySnapshot.docs[0];
        return docSnapshot.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      print('Error fetching user data: $e');
      throw Exception('Failed to fetch user data.');
    }
  }

  // fetch the profile picture URL from firestore

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