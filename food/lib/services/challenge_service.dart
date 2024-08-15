import 'package:cloud_firestore/cloud_firestore.dart';

class ChallengeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createChallenge({
  required String title,
  required String details,
  required List<Map<String, String>> activities,
  required String creatorUid,
  required List<Map<String, String>> participants, 
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
    required List<Map<String, String>> activities,
    required Timestamp startDate,
    required Timestamp endDate,
    required String duration,
  }) async {
    try {
      await _firestore.collection('challenges').doc(challengeId).update({
        'title': title,
        'description': details,
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

  
  Future<void> deleteChallenge(String challengeId, String userId) async {

    try {
     
      // Start a Firestore batch write
      WriteBatch batch = FirebaseFirestore.instance.batch();

      // Delete the challenge document from the 'challenges' collection
      DocumentReference challengeRef = FirebaseFirestore.instance.collection('challenges').doc(challengeId);
      batch.delete(challengeRef);
      
      // Reference to the user's document
      DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(userId);

      // Fetch the user's document to check if the challenges array contains the challengeId
      DocumentSnapshot userDocSnapshot = await userRef.get();
      if (userDocSnapshot.exists) {
        List<dynamic> challenges = userDocSnapshot.get('challenges');
        
        // Find the specific challenge object with the matching challengeId
        var challengeToRemove;
        for (var challenge in challenges) {
          if (challenge['challengeId'] == challengeId) {
            challengeToRemove = challenge;
            break;
          }
        }

        if (challengeToRemove != null) {
        
          // Update the user's 'challenges' array to remove the specific challenge object
          batch.update(userRef, {
            'challenges': FieldValue.arrayRemove([challengeToRemove])
          });
          
        } else {
          print('Challenge ID $challengeId not found in user $userId\'s challenges array.');
        }
      } else {
        print('User document does not exist for userId: $userId');
      }

      // Commit the batch
      await batch.commit();
    } catch (e) {
      print("Error deleting challenge for user $userId: $e");
      rethrow;
    }
  }
  Future<void> quitChallenge(String challengeId, String userId) async {
    try {
      
      // Start a Firestore batch write
      WriteBatch batch = _firestore.batch();

      // Reference to the user's document
      DocumentReference userRef = _firestore.collection('users').doc(userId);

      // Fetch the user's document to check if the challenges array contains the challengeId
      DocumentSnapshot userDocSnapshot = await userRef.get();
      if (userDocSnapshot.exists) {
        List<dynamic> challenges = userDocSnapshot.get('challenges');
      
        // Find the specific challenge object with the matching challengeId
        Map<String, dynamic>? challengeToRemove;
        for (var challenge in challenges) {
          if (challenge['challengeId'] == challengeId) {
            challengeToRemove = challenge as Map<String, dynamic>;
            break;
          }
        }

        if (challengeToRemove != null) {
          
          // Update the user's 'challenges' array to remove the specific challenge object
          batch.update(userRef, {
            'challenges': FieldValue.arrayRemove([challengeToRemove])
          });
          
        } else {
          print('Challenge ID $challengeId not found in user $userId\'s challenges array.');
        }
      } else {
        print('User document does not exist for userId: $userId');
      }

      // Commit the batch
      await batch.commit();
  
    } catch (e) {
      print("Error quitting challenge for user $userId: $e");
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

  Future<void> joinChallenge({
    required String userId,
    required String challengeId,
  }) async {
    try {
      // Add the challenge to the user's challenges
      await addOtherChallengeIdToUserDoc(userId, challengeId, 'joined');

      // Update the challenge's participants list
      await _firestore.collection('challenges').doc(challengeId).update({
        'participants': FieldValue.arrayUnion([userId]),
      });
    } catch (e) {
      print("Error joining challenge: $e");
      rethrow;
    }
  }

  Future<void> addOtherChallengeIdToUserDoc(String userId, String challengeId, String type) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'challenges': FieldValue.arrayUnion([
          {
            'challengeId': challengeId,
            'type': type,
          }
        ]),
      });
    } catch (e) {
      print("Error updating user challenges: $e");
      rethrow;
    }
  }

  Future<void> addOwnChallengeToUserDoc(String userId, String challengeId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'challenges': FieldValue.arrayUnion([
          {
            'challengeId': challengeId,
            'type': 'own',
          }
        ]),
      });
    } catch (e) {
      print("Error updating user challenges: $e");
      rethrow;
    }
  }


  Future<void> calculateAndStoreTotalRewardPoints(String userId) async {
  try {
    int totalPoints = 0;

  
    // Fetch all challenge documents where the user is a participant
    final querySnapshot = await FirebaseFirestore.instance
        .collection('challenges')
        .get();


    for (var doc in querySnapshot.docs) {
    
      final participants = List<Map<String, dynamic>>.from(doc['participants'] ?? []);
   
      for (var participant in participants) {
        if (participant['userId'] == userId) {
          int points = (participant['totalPoints'] ?? 0) as int;
          totalPoints += points;
          break; // Break the loop since we found the user in this challenge
        }
      }
    }

    print('Total points calculated for user $userId: $totalPoints');

    // Store total points in the user's document
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({'totalRewardPoints': totalPoints});

  
  } catch (e) {
    print('Error calculating total reward points for user $userId: $e');
  }
}









}








