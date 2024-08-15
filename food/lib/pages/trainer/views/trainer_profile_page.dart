import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food/pages/profileSetting/help_center_page.dart';
import 'package:food/pages/trainer/views/trainer_profile_setting_page.dart';
import 'package:food/pages/profileSetting/privacy_policy_page.dart';
import 'package:food/pages/profileSetting/settings_page.dart';
import 'package:food/pages/profileSetting/terms_conditions_page.dart';
import 'package:food/pages/user/view/intro_page.dart';
import 'package:food/services/auth/auth_service.dart';
import 'package:food/pages/trainer/models/trainer_profile_model.dart';
import 'package:food/services/setting_trainer_profile_service.dart';

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

  final TrainerSettingProfileService _profileService = TrainerSettingProfileService();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        Map<String, dynamic>? profileData = await _profileService.fetchUserData(user.uid);
        if (profileData != null) {
          setState(() {
            trainerProfile = TrainerProfile.fromMap(profileData);
          });
        }
      } catch (e) {
        print('Error fetching profile data: $e');
      }
    }
  }

Widget _loadProfilePicture() {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TrainerProfileSetting(), 
        ),
      );
    },
    child: trainerProfile.profilePictureUrl != null
        ? CircleAvatar(
            radius: 60,
           backgroundImage: NetworkImage(trainerProfile.profilePictureUrl!),
          )
        : const CircleAvatar(
            radius: 60,
            child: Icon(Icons.person),
          ),
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

  // void showLogoutConfirmationDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         content: const Text(
  //           'Are you sure you want to log out?',
  //           style: TextStyle(fontSize: 15),
  //           textAlign: TextAlign.center,
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text('Cancel'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               logout(context);
  //             },
  //             child: const Text('Logout'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void showLogoutConfirmationDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Text(
            'Are you sure you want to log out?',
            style: TextStyle(fontSize: 15),
            textAlign: TextAlign.center,
          ),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
              isDefaultAction: true,
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
                logout(context);
              },
              child: Text('Logout'),
              isDestructiveAction: true,
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
    const RowData(
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
        title: const Padding(
          padding: EdgeInsets.only(top: 36),
          child: Row(
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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20.0),
            _loadProfilePicture(),
            SizedBox(height: 10.0),
            Text(
              trainerProfile.name ?? 'No name',
              style: const TextStyle(
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500
              ),
            ),
            const SizedBox(height: 36.0),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: rowData.length,
                itemBuilder: (context, index) => buildRowItem(context, rowData[index]),
                separatorBuilder: (context, index) => SizedBox(height: 5.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
        margin: const EdgeInsets.symmetric(horizontal: 40.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Icon(
                data.icon,
                color: Color(0XFF508AA8),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  data.text,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500
                  ),
                ),
              ),
              Spacer(),
              const Icon(
                Icons.arrow_right,
                color: Color(0XFF508AA8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
