import 'package:cloud_firestore/cloud_firestore.dart';

class RequestService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendRequest(String userId, String trainerId, String trainerName) async {
    final requestRef = _firestore.collection('requests').doc();

    // Create the request document
    await requestRef.set({
      'userId': userId,
      'trainerId': trainerId,
      'name': trainerName, // Add the trainer's name to the request
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
