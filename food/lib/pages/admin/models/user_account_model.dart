// lib/models/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Future<List<Map<String, dynamic>>> fetchUsers() async {
  //   try {
  //     QuerySnapshot querySnapshot = await _firestore.collection('users').get();
  //     return querySnapshot.docs
  //         .map((doc) => doc.data() as Map<String, dynamic>)
  //         .toList();
  //   } catch (e) {
  //     print('Error fetching user accounts: $e');
  //     return [];
  //   }
  // }

  Future<List<Map<String, dynamic>>> fetchUsers() async {
  try {
    QuerySnapshot userDocs = await FirebaseFirestore.instance.collection('users').get();
    return userDocs.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      data['userId'] = doc.id; // Ensure userId is set correctly
      return data;
    }).toList();
  } catch (e) {
    print("Error fetching users: $e");
    return [];
  }
}


  Future<Map<String, dynamic>?> fetchUser(String userId) async {

    try {
      DocumentSnapshot docSnapshot = await _firestore.collection('users').doc(userId).get();
      
      
      if (docSnapshot.exists) {
      print("User data from Firestore: ${docSnapshot.data()}"); // Debug print
      return docSnapshot.data() as Map<String, dynamic>?;
    } 
    else {
      print("No user found for userId: $userId");
      return null;
    }

      

    }

    catch(e) {
      print('Error fetching user account: $e');
      return null;
    }

  }

  Future<void> updateUser(String userId, Map<String, dynamic> userData) async {

    try {
      await _firestore.collection('users').doc(userId).update(userData);
    }

    catch(e) {
      print('Error updating user account: $e');
    }
  }
}
