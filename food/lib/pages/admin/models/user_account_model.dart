import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';



class UserModel {
  final String backendUrl = 'https://us-central1-fyp-goodgrit-a8601.cloudfunctions.net';
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    try {
      QuerySnapshot userDocs = await _firestore.collection('users').get();
      return userDocs.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['userId'] = doc.id;
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
        return docSnapshot.data() as Map<String, dynamic>?;
      } else {
        print("No user found for userId: $userId");
        return null;
      }
    } catch (e) {
      print('Error fetching user account: $e');
      return null;
    }
  }

  Future<void> updateUser(String userId, Map<String, dynamic> userData) async {
    try {
      await _firestore.collection('users').doc(userId).update(userData);
    } catch (e) {
      print('Error updating user account: $e');
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      final response = await http.delete(Uri.parse('$backendUrl/deleteUser?userId=$userId'));

      if (response.statusCode != 200) {
        throw Exception('Failed to delete user');
      }
    } catch (e) {
      print('Error deleting user account: $e');
    }
  }


  Future<void> createUser(String email, String password) async {
  try {
    final response = await http.post(
      Uri.parse('$backendUrl/createUser'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode != 201) {
      throw Exception('Failed to create user: ${response.body}');
    }
  } catch (e) {
    print('Error creating user account: $e');
  }
}


}
