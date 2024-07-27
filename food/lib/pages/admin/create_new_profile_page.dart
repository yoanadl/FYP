import 'package:flutter/material.dart';
import 'admin_view_all_user_profile.dart';

class CreateNewProfilePage extends StatefulWidget {
  @override
  _CreateNewProfilePageState createState() => _CreateNewProfilePageState();
}

class _CreateNewProfilePageState extends State<CreateNewProfilePage> {
  TextEditingController _rolesController = TextEditingController();
  TextEditingController _addedPermissionController = TextEditingController();
  String _selectedPermission = ''; // Variable to hold selected permission

  List<String> _permissions = [
    'Permission A',
    'Permission B',
    'Permission C',
  ]; // List of permissions

  @override
  void dispose() {
    _rolesController.dispose();
    _addedPermissionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Initialize _selectedPermission to the first item in _permissions if not already set
    if (_permissions.isNotEmpty) {
      _selectedPermission = _permissions.first;
    }
  }

  void _submitForm() {
    String roles = _rolesController.text;
    String addedPermission = _addedPermissionController.text;

    //later grab all the values and send them to db
    
    // // Here you can use _selectedPermission for the selected permission value
    // print('Roles: $roles');
    // print('Selected Permission: $_selectedPermission');
    // print('Added Permission: $addedPermission');
    // // Perform further actions with the selected permission

    //go back to User Profile page
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => UserProfilePage()), // Replace with your desired destination page
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Create New Profile'),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              'Roles',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _rolesController,
              decoration: InputDecoration(
                hintText: 'Enter roles',
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 24),

            Text(
              'Permission',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: _selectedPermission,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedPermission = newValue!;
                });
              },
              items: _permissions.map((String permission) {
                return DropdownMenuItem<String>(
                  value: permission,
                  child: Text(permission),
                );
              }).toList(),
            ),

            SizedBox(height: 24),

            Text(
              'Permission Added',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            //might need word limit and change the keyboard to ok instead of enter to make the ux nicer
            TextField(
              controller: _addedPermissionController,
              maxLines: 4, // Adjust this number based on your paragraph size estimation
              decoration: InputDecoration(
                hintText: 'Enter description',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(16.0), // Uniform padding all around the text input
              ),
            ),

            SizedBox(height: 24),

            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

