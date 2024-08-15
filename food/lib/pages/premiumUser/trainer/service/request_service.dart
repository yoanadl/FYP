import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RequestService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Send a request
  Future<void> sendRequest(String userId, String trainerId, String trainerName, String profilePictureUrl) async {
    try {
      final requestRef = _firestore.collection('requests').doc();
      await requestRef.set({
        'userId': userId,
        'trainerId': trainerId,
        'name': trainerName,
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
        'profilePictureUrl': profilePictureUrl,
      });
    } catch (e) {
      throw Exception("Failed to send request: $e");
    }
  }

  // Fetch pending requests for a trainer
  Future<List<Map<String, dynamic>>> fetchPendingRequests(String trainerId) async {
    try {
      final snapshot = await _firestore.collection('requests')
          .where('trainerId', isEqualTo: trainerId)
          .where('status', isEqualTo: 'pending')
          .get();

      List<Map<String, dynamic>> requests = [];

      for (var doc in snapshot.docs) {
        final requestData = doc.data();
        final userId = requestData['userId'];

        // Fetch user's profile (name and fitness goals)
        final userProfileSnapshot = await _firestore.collection('users').doc(userId).collection('UserProfile').get();

        if (userProfileSnapshot.docs.isNotEmpty) {
          final userProfile = userProfileSnapshot.docs.first.data();
          requestData['userId'] = userProfile ['userId'];
          requestData['userName'] = userProfile['Name'];
          requestData['fitnessGoals'] = userProfile['fitnessGoals'];
        }

        requestData['requestId'] = doc.id; // Include the request ID for updating status
        requests.add(requestData);
      }

      return requests;
    } catch (e) {
      throw Exception("Failed to fetch pending requests: $e");
    }
  }

  // Update request status
  Future<void> updateRequestStatus(String requestId, String status) async {
    try {
      await _firestore.collection('requests').doc(requestId).update({'status': status});
    } catch (e) {
      throw Exception("Failed to update request status: $e");
    }
  }
}
