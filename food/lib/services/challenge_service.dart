import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChallengeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> createChallenge({
    required String title,
    required String details,
    required int points,
    required List<Map<String, String>> activities,
    required String creatorUid,
    required List<String> participants,
    required Timestamp startDate,
    required Timestamp endDate,
    required String duration,
  }) async {
    try {
      // Create a new challenge document
      DocumentReference docRef = await _firestore.collection('challenges').add({
        'title': title,
        'description': details,
        'points': points,
        'activities': activities,
        'createdAt': Timestamp.now(),
        'creatorUid': creatorUid,
        'participants': participants,
        'startDate': startDate,
        'endDate': endDate,
        'duration': duration,
      });

      // Return the document ID
      return docRef.id;
    } catch (e) {
      print("Error creating challenge: $e");
      rethrow;
    }
  }


  Future<void> updateChallenge({
    required String challengeId,
    required String title,
    required String details,
    required int points,
    required List<Map<String, String>> activities,
    required Timestamp startDate,
    required Timestamp endDate,
    required String duration,
  }) async {
    try {
      await _firestore.collection('challenges').doc(challengeId).update({
        'title': title,
        'description': details,
        'points': points,
        'activities': activities,
        'startDate': startDate,
        'endDate': endDate,
        'duration': duration,
      });
    } catch (e) {
      print("Error updating challenge: $e");
      rethrow;
    }
  }

  Future<void> deleteChallenge(String challengeId) async {
    try {
      await _firestore.collection('challenges').doc(challengeId).delete();
    } catch (e) {
      print("Error deleting challenge: $e");
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getAllChallenges() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('challenges').get();
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error getting challenges: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getChallengeDetails(String challengeId) async {
    try {
      // Fetch the challenge document by its ID
      DocumentSnapshot docSnapshot = await _firestore.collection('challenges').doc(challengeId).get();

      if (docSnapshot.exists) {
        // Return the challenge data as a Map if it exists
        return docSnapshot.data() as Map<String, dynamic>?;
      } else {
        // If the document does not exist, return null
        return null;
      }
    } catch (e) {
      print("Error getting challenge details: $e");
      rethrow;
    }
  }

  Future<String?> fetchCreatorName(String userId) async {
    try {
      final DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
      final userProfileCollection = userDoc.reference.collection('UserProfile');
      final userProfileSnapshot = await userProfileCollection.get();

      if (userProfileSnapshot.docs.isNotEmpty) {
        final userProfileData = userProfileSnapshot.docs.first.data();
        return userProfileData['Name'];
      } else {
        return 'Unknown User';
      }
    } catch (e) {
      print('Error fetching creator name: $e');
      return null;
    }
  }




}
