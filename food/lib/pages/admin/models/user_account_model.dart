import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class UserModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String backendUrl = 'http://localhost:3000';

  Future<List<Map<String, dynamic>>> fetchUsers() async {
  try {
    QuerySnapshot userDocs = await FirebaseFirestore.instance.collection('users').get();
    return userDocs.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      data['userId'] = doc.id; 
      return data;
    }).toList();
  } 
  
  catch (e) {
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

  Future<void> deleteUser(String userId) async {
    try {
      // delete from firestore
      await _firestore.collection('users').doc(userId).delete();

      // call backend to delete from Firebase Auth
      final response = await http.delete(Uri.parse('$backendUrl/deleteUser/$userId'));

      if (response.statusCode != 200) {
        throw Exception('Failed to delete user from Firebase Auth');
      }
    }
    
    catch(e) {
      print('Error deleting user account: $e');
    }
  }
}
