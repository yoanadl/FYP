// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food/pages/user/view/intro_page.dart';
import 'package:food/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DeleteAccount extends StatefulWidget {

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();

}

class _DeleteAccountState extends State<DeleteAccount> {

  final AuthService _authService = AuthService();

  void _deleteAccount() async {

    try {
      User? user = _authService.getCurrentUser();
      if (user != null) {
        String uid = user.uid;

        // delete the user document from Firestore
        await FirebaseFirestore.instance.collection('users').doc(uid).delete();

        // delete the user from Firebase Auth
        await user.delete();

        // sign out the user
        await _authService.signOut();

        if (!mounted) return;

        // show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Your account has been succesfully deleted.'),
            duration: Duration(seconds: 3),
          ),
        );

        // Navigate to the Intro Page after successful deletion
        Navigator.pushAndRemoveUntil(
          context, 
          MaterialPageRoute(builder: (context) => IntroPage()),
          (Route<dynamic> route) => false, 
        );
      }
    }

    catch (e) {
      print('Error deleting account: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete account. Please try again later.')),
      );
    }

  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Are you sure you want to delete your account? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              }, 
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteAccount();
              },
               child: Text('Delete Account'),
            ),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 40, right: 40),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Text(
                'Delete Account',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 30,),
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
              ),
              SizedBox(height: 20,),
              Text(
                'Placeholder Name',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 30,),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFFC8E0F4).withOpacity(0.4),
                  borderRadius: BorderRadius.circular(8),
                ),

                child: Text (
                  'You are about to delete your account.\nAll information related to this account\nwill be removed.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => _showConfirmationDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff031927),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Delete Account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

              )

              
              
          
          
            ],
          ),
        ),
      ),
    );
  }
}
