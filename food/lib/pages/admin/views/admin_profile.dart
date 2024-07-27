import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food/pages/Profile%20Settings/my_profile_page.dart';
import 'package:food/pages/Profile%20Settings/settings_page.dart';
import 'package:food/pages/intro_page.dart';
import 'package:food/services/auth/auth_service.dart';

class RowData {
  final IconData icon;
  final String text;
  final Widget? destination;

  const RowData({
    required this.icon,
    required this.text,
    this.destination,
  });
}

class AdminProfile extends StatefulWidget {
  AdminProfile({super.key});

  @override
  _AdminProfileState createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {

  String userName = 'Loading...';
  String documentId = '';

  @override
  void initState() {
    super.initState();
    fetchName();
  }

  void fetchName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User is not authenticated');
      return;
    }
    try {
      // Fetch the profile document ID
      QuerySnapshot profileSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('UserProfile')
          .limit(1) // Fetch only one document if you assume there's only one
          .get();

      if (profileSnapshot.docs.isNotEmpty) {
        // Get the first document ID (assuming there's only one)
        documentId = profileSnapshot.docs.first.id;

        // Now fetch the profile data using the document ID
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('UserProfile')
            .doc(documentId) // Use the fetched document ID
            .get();

        if (doc.exists) {
          setState(() {
            userName = doc['Name'] ?? 'No Name';
          });
        } else {
          setState(() {
            userName = 'No Name';
          });
        }
      } else {
        print('No profile document found');
        setState(() {
          userName = 'No Name';
        });
      }
    } catch (e) {
      print('Error fetching user profile: $e');
      setState(() {
        userName = 'Error fetching name';
      });
    }
  }

  void logout(BuildContext context) async {
    final authService = AuthService();
    try {
      await authService.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => IntroPage()),
      );
    } catch (error) {
      // Handle errors from signOut
      print('Error logging out: $error');
    }
  }

  void showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            'Are you sure you want to log out?',
            style: TextStyle(fontSize: 15),
            textAlign: TextAlign.center,
          ),
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
                logout(context);
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  final List<RowData> rowData = [
    RowData(
      icon: Icons.person,
      text: 'Your Profile',
      destination: MyProfilePage(),
    ),
    RowData(
      icon: Icons.settings,
      text: 'Settings',
      destination: SettingsPage(),
    ),
    RowData(
      icon: Icons.logout,
      text: 'Log Out',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Text(
              'Profile',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Spacer(),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20.0),
            // profile image avatar
            CircleAvatar(
              backgroundColor: Colors.grey[100],
              radius: 50.0,
            ),
            // name
            SizedBox(height: 15.0),
            Text(
              userName,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(height: 25.0),
            // settings
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: rowData.length,
                itemBuilder: (context, index) =>
                    buildRowItem(context, rowData[index]),
                separatorBuilder: (context, index) => SizedBox(height: 5.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // function to build each row
  Widget buildRowItem(BuildContext context, RowData data) {
    return InkWell(
      onTap: () {
        if (data.text == 'Log Out') {
          showLogoutConfirmationDialog(context);
        } else if (data.destination != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => data.destination!),
          );
        }
      },
      child: Container(
        color: Colors.grey[100],
        margin: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Icon(data.icon),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  data.text,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
              Spacer(),
              Icon(Icons.arrow_right),
            ],
          ),
        ),
      ),
    );
  }
}
