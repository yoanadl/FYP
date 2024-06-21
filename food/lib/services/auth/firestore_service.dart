import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUserDocument(User user, String role) async {
    // Construct the user document data
    Map<String, dynamic> userData = {
      'uid': user.uid,
      'email': user.email,
      'role': role,
      'createdAt': FieldValue.serverTimestamp(),
      'isActive': true,
    };

    // Create or update the user document
    await _firestore.collection('users').doc(user.uid).set(userData);
  }
  
}
