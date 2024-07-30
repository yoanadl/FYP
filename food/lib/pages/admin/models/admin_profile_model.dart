import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminProfileModel {
  Future<String> fetchName() async {
    User? user = FirebaseAuth.instance.currentUser;
    
    if (user == null) {
      throw Exception('User is not authenticated');
    }

    try {
      QuerySnapshot profileSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('UserProfile')
        .limit(1)
        .get();

      if (profileSnapshot.docs.isNotEmpty) {
        String documentId = profileSnapshot.docs.first.id;
        DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('UserProfile')
          .doc(documentId)
          .get();

        return doc.exists ? doc['Name'] ?? 'No Name' : 'No Name';
      }

      else {
        return 'No name';
      }
    }

    catch (e) {
      throw Exception('Error fetching user profile: $e');
    }
  }
}