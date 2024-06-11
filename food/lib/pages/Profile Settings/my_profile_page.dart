import 'package:flutter/material.dart';

class MyProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: Center(
        child: Column(
          children: [
            // Profile information widgets (e.g., name, email, etc.)
            Text('Name: John Doe'),
            Text('Email: johndoe@example.com'),
            // ... other profile information widgets
            // Edit profile button (optional)
            ElevatedButton(
              onPressed: () {
                // Handle edit profile functionality
              },
              child: Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}