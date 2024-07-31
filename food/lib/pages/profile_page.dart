// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food/components/navbar.dart';
import 'package:food/pages/Profile%20Settings/bmi_page.dart';
import 'package:food/pages/Profile%20Settings/goals_preferences.dart';
import 'package:food/pages/Profile%20Settings/help_center_page.dart';
import 'package:food/pages/Profile%20Settings/membership_page.dart';
import 'package:food/pages/Profile%20Settings/my_profile_page.dart';
import 'package:food/pages/Profile%20Settings/privacy_policy_page.dart';
import 'package:food/pages/Profile%20Settings/settings_page.dart';
import 'package:food/pages/Profile%20Settings/terms_conditions_page.dart';
import 'package:food/pages/community_page.dart';
import 'package:food/pages/intro_page.dart';
import 'package:food/pages/upload_profile_page.dart';
import 'package:food/pages/workout/workout_page.dart';
import 'package:food/services/SettingProfile_service.dart';
import 'package:food/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RowData{
  final IconData icon;
  final String text;
  final Widget? destination;

  const RowData(
    {
      required this.icon, 
      required this.text,
      this.destination,
    }
  );
}

class ProfilePage extends StatefulWidget {

  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>  {

  String name = '';
  String? profilePictureUrl = '';

  @override 
  void initState() {
    super.initState();
    fetchUserData();
  }

  Widget _loadProfilePicture() {
  final settingProfileService = SettingprofileService();

  return FutureBuilder<String?>(
    future: settingProfileService.fetchProfilePictureUrl(
        FirebaseAuth.instance.currentUser!.uid),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        String? url = snapshot.data;
        return CircleAvatar(
          radius: 60,
          backgroundImage: CachedNetworkImageProvider(url!),
        );
      } else if (snapshot.hasError) {
        print('Error fetching profile picture URL: ${snapshot.error}');
        return CircularProgressIndicator(); // Show a loading indicator
      }
      return CircleAvatar(
        radius: 60,
        child: Icon(Icons.person),
      ); // Placeholder
    },
  );
}


  Future<void> fetchUserData() async {

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        Map<String, dynamic>? userData =
            await SettingprofileService().fetchUserData(user.uid);

        if (userData != null) {
          setState(() {
            name = userData['Name'] ?? 'No name';
            profilePictureUrl = userData['profilePictureUrl'];
          });
        } else {
          print('No user data found for uid: ${user.uid}');
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    } else {
      print('No user is currently signed in.');
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
    showCupertinoDialog(
      context: context, 
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Text(
            'Are you sure you want to log out?',
            style: TextStyle(
              fontSize: 15
            ),
            textAlign: TextAlign.center,
          ),
          actions: <Widget> [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              }, 
              child: Text('Cancel'),
            ),
            CupertinoDialogAction(
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
      icon: Icons.flag,
      text: 'My Goals & Dietary Preferences',
      destination: GoalsPreferences(),
    ),
    RowData(
      icon: Icons.monitor_weight,
      text: 'My BMI',
      destination: BmiPage(),
    ),
    RowData(
      icon: Icons.card_membership,
      text: 'My Membership',
      destination: MembershipPage(),
    ),
    RowData(
      icon: Icons.settings,
      text: 'Settings',
      destination: SettingsPage(),
    ),
    RowData(
      icon: Icons.help_center,
      text: 'Help Center',
      destination: HelpCenterPage(),
    ),
    RowData(
      icon: Icons.privacy_tip,
      text: 'Privacy Policy',
      destination: PrivacyPolicyPage(),
    ),
    RowData(
      icon: Icons.article,
      text: 'Terms and Conditions',
      destination: TermsConditionsPage(),
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
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
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
            Stack(
              children: [
                _loadProfilePicture(),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UploadProfilePage()),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color: Color(0xFF031927),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 20.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // name
            SizedBox(height: 15.0),
            Text(
              name,
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
                    fontSize: 15.0,
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


