import 'package:flutter/material.dart';
import 'package:food/pages/admin/models/admin_profile_model.dart';
import 'package:food/pages/admin/views/admin_profile_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food/pages/intro_page.dart';

class AdminProfilePresenter {
  final AdminProfileModel model;
  final AdminProfileView view;

  AdminProfilePresenter({required this.model, required this.view});

  void fetchUserName() async {
    try {
      String userName = await model.fetchName();
      view.updateName(userName);
    } catch (e) {
      view.updateName('Error fetching name');
    }
  }

  void logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => IntroPage()),
      );
    } catch (error) {
      print('Error logging out: $error');
    }
  }
}
