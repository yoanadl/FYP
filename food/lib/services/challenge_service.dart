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
  }) async {
    try {
      // Create a new challenge document
      DocumentReference docRef = await _firestore.collection('challenges').add({
        'title': title,
        'details': details,
        'points': points,
        'activities': activities,
        'createdAt': Timestamp.now(),
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
  }) async {
    try {
      await _firestore.collection('challenges').doc(challengeId).update({
        'title': title,
        'description': details,
        'points': points,
        'activities': activities,
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
  
}
