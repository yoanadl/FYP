import 'package:flutter/material.dart';
import 'admin_view_all_user_profile.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Edit Profile'),
      ),
      body: Card(
        color: Colors.white,
        margin: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              Text(
                'Roles', // Display profile name
                style: TextStyle(fontSize: 20),
              ),

              TextField(
                // controller: _rolesController,
                  decoration: InputDecoration(
                    hintText: profileName,
                    border: OutlineInputBorder(),
                  ),
                ),


              SizedBox(height: 10),

              Text(
                'Permission', // Display profile permission
                style: TextStyle(fontSize: 20),
              ),

              //later change to the dropdown list
              TextField(
                // controller: _rolesController,
                  decoration: InputDecoration(
                    hintText: profilePermission,
                    border: OutlineInputBorder(),
                  ),
                ),


              SizedBox(height: 10),

              Text(
                'Permission Added', // Display profile description
                style: TextStyle(fontSize: 20),
              ),

              //might need word limit and change the keyboard to ok instead of enter to make the ux nicer
                TextField(
                  // controller: _addedPermissionController,
                  maxLines: 4, // Adjust this number based on your paragraph size estimation
                  decoration: InputDecoration(
                    hintText: profileDescription,
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(16.0), // Uniform padding all around the text input
                  ),
                ),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserProfilePage()), // Replace with your desired destination page
                    );
                  },
                  child: Text('Save Changes'),
                )

                  
            ],
          ),
        ),
      ),
    );
  }
}
