
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:food/pages/Profile%20Settings/bmi_page.dart';
import 'package:food/pages/Profile%20Settings/goals_preferences.dart';
import 'package:food/pages/Profile%20Settings/help_center_page.dart';
import 'package:food/pages/Profile%20Settings/membership_page.dart';
import 'package:food/pages/Profile%20Settings/my_profile_page.dart';
import 'package:food/pages/Profile%20Settings/privacy_policy_page.dart';
import 'package:food/pages/Profile%20Settings/settings_page.dart';
import 'package:food/pages/Profile%20Settings/terms_conditions_page.dart';
import 'package:food/pages/intro_page.dart';
import 'package:food/pages/login_page.dart';
import 'package:food/services/auth/auth_service.dart';

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

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

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

  void handleLogout(BuildContext context) {
    logout(context);
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
              'John Doe',
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
          handleLogout(context);
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
                    fontSize: 20.0,
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


