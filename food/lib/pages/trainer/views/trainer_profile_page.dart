import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food/pages/profile_setting/help_center_page.dart';
import 'package:food/pages/trainer/views/trainer_profile_setting_page.dart';
import 'package:food/pages/profile_setting/privacy_policy_page.dart';
import 'package:food/pages/profile_setting/settings_page.dart';
import 'package:food/pages/profile_setting/terms_conditions_page.dart';
import 'package:food/pages/intro_page.dart';
import 'package:food/pages/upload_profile_page.dart';
// import 'package:food/services/setting_trainer_profile_service.dart';
import 'package:food/services/auth/auth_service.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:food/pages/trainer/models/trainer_profile_model.dart';

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

class TrainerProfilePage extends StatefulWidget {
  TrainerProfilePage({Key? key}) : super(key: key);

  @override
  State<TrainerProfilePage> createState() => _TrainerProfilePageState();
}

class _TrainerProfilePageState extends State<TrainerProfilePage> {
  TrainerProfile trainerProfile = TrainerProfile();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    await trainerProfile.fetchUserData();
    setState(() {}); // Update UI after data is fetched
  }

  Widget _loadProfilePicture() {
    return trainerProfile.profilePictureUrl != null
    ? CircleAvatar(
        radius: 60,
        backgroundImage: CachedNetworkImageProvider(trainerProfile.profilePictureUrl!),
      )
    : CircleAvatar(
        radius: 60,
        child: Icon(Icons.person),
      );
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
      destination: TrainerProfileSetting(),
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
            // Profile image avatar
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
                          builder: (context) => UploadProfilePage(),
                        ),
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
            // Name
            SizedBox(height: 15.0),
            Text(
              trainerProfile.name ?? 'No name',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(height: 25.0),
            // Settings
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

  // Function to build each row
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
