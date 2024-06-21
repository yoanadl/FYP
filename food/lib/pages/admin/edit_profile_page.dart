import 'package:flutter/material.dart';

class EditProfilePage extends StatelessWidget {
  final int profileIndex; // Declare variable to hold profile index
  final String profileName; // Declare variable to hold profile name
  final String profilePermission; // Declare variable to hold profile permission
  final String profileDescription; // Declare variable to hold profile description

  // Constructor to receive profile details
  EditProfilePage({
    required this.profileIndex,
    required this.profileName,
    required this.profilePermission, // Make sure it's required
    this.profileDescription = '', // Default empty description
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Card(
        margin: EdgeInsets.all(16.0),
        elevation: 5,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              Text(
                'Name: $profileName', // Display profile name
                style: TextStyle(fontSize: 20),
              ),

              SizedBox(height: 10),

              Text(
                'Permission: $profilePermission', // Display profile permission
                style: TextStyle(fontSize: 20),
              ),

              SizedBox(height: 10),

              Text(
                'Description: $profileDescription', // Display profile description
                style: TextStyle(fontSize: 20),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
