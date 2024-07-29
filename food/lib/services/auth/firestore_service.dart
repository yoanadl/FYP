import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUserDocument(User user, String role) async {
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'email': user.email,
        'role': role,
        'isActive': true,
        'createdAt': Timestamp.now(),
      });
    } catch (e) {
      print('Error creating user document: $e');
    }
  }

  Future<void> updateUserRole(String uid, String role) async {
    await _firestore.collection('users').doc(uid).update({
      'role': role,
    });
  }
}
