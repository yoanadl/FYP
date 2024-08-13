import 'package:cloud_firestore/cloud_firestore.dart';

class ChallengeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
    // Fetch the creator's document
    final userDoc = await _firestore.collection('users').doc(creatorUid).get();
    if (!userDoc.exists) {
      throw Exception('User with ID $creatorUid not found');
    }

    // Fetch the UserProfile subcollection
    final userProfileCollection = userDoc.reference.collection('UserProfile');
    final userProfileSnapshot = await userProfileCollection.get();


    String creatorName = 'Unknown User';
    if (userProfileSnapshot.docs.isNotEmpty) {
      final userProfileData = userProfileSnapshot.docs.first.data();
      creatorName = userProfileData['Name'] ?? 'Unknown User';
    }

    // Create a new challenge document
    DocumentReference docRef = await _firestore.collection('challenges').add({
      'title': title,
      'description': details,
      'points': points,
      'activities': activities,
      'createdAt': Timestamp.now(),
      'creatorUid': creatorUid,
      'creatorName': creatorName,
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
      List<Map<String, dynamic>> challenges = snapshot.docs.map((doc) {
        return {
          'id': doc.id, // Include the challenge ID
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();
      return challenges;
    } catch (e) {
      print("Error fetching challenges: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getChallengeDetails(String challengeId) async {
    
    if (challengeId.isEmpty) {
      throw ArgumentError('Challenge ID cannot be empty');
    }
    
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

  
  Future<String?> fetchCreatorName(String challengeId) async {
  try {
   
    // Fetch the challenge document
    final DocumentSnapshot challengeDoc = await FirebaseFirestore.instance
        .collection('challenges')
        .doc(challengeId)
        .get();

    // Check if the challenge document exists
    if (!challengeDoc.exists) {
      print('Challenge document does not exist.');
      return null;
    }

    // Access the creatorName field
    final challengeData = challengeDoc.data() as Map<String, dynamic>;
    return challengeData['creatorName'] ?? 'Unknown Creator';
  } catch (e) {
    print('Error fetching creator name: $e');
    return null;
  }
}







}
