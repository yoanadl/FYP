import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food/pages/admin/admin_base_page.dart';
import 'package:food/pages/base_page.dart';
import 'package:food/pages/trainer/views/trainer_base_page.dart';
import 'package:food/services/auth/firestore_service.dart';

class AuthService{

  // get instance of firebase auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get current user
  User ? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  // get user role
  Future<String> getUserRole(String uid) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();
      
      if (userDoc.exists) {
        String role = userDoc['role'];
        print('Retrieved role: $role'); // Debug print
        return role;
      }
      else {
        return 'user';

      }
      
    }
   
    catch (e) {
      print('Error retrieving user role: $e');
      return 'user';

    }
  }



  // sign in
  Future<User?> signInWithEmailPassword(BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        String role = await getUserRole(user.uid);

        // Navigate based on user role
        if (role == "admin") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminBasePage()),
          );
        } 

      else if (role == "trainer") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TrainerBasePage()),
        );
      }
        
        
      else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BasePage()),
          );
        }
      }

      return user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }


  // sign up

  Future<UserCredential> signUpWithEmailPassword(String email, String password, {String role = 'user'}) async {
  
  try {
    UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email, 
      password: password,
    );

    User? user = userCredential.user;

    if (user != null) {
      print('Role assigned during sign-up: $role'); // Debug print
      // Only set the role if it’s not 'admin'
      if (email != "goodgrit.staff@gmail.com") {
        await FirestoreService().createUserDocument(user, role);
      } else {
        await FirestoreService().createUserDocument(user, 'admin');
      }
    }

    return userCredential;
  } catch (e) {
    throw Exception(e.toString());
  }
}


  // register trainer
  Future<UserCredential> registerTrainer(String email, String password) async {
    UserCredential userCredential = await signUpWithEmailPassword(email, password, role: 'trainer');
    User? user = userCredential.user;

    if (user != null) {
      await FirestoreService().updateUserRole(user.uid, 'trainer');
    }

    return userCredential;
  }



  // sign out

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();

  }

  

}
