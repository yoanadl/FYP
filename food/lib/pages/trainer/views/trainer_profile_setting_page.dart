import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food/services/setting_trainer_profile_service.dart';
import 'package:food/services/setting_user_profile_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:food/pages/user/view/upload_profile_page.dart';
import 'package:food/pages/trainer/models/trainer_profile_model.dart';

class ProfileTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Function(String) onChanged;

  const ProfileTextField({
    Key? key,
    required this.label,
    required this.controller,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
        ),
        SizedBox(height: 8.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 5.0),
          child: SizedBox(
            height: 48.0,
            child: TextFormField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 8.0),
                border: OutlineInputBorder(),
                hintText: 'Enter $label',
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontFamily: 'Poppins',
                  fontSize: 14.0,
                ),
              ),
              style: const TextStyle(
                color: Colors.black,
                fontFamily: 'Poppins',
                fontSize: 16.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TrainerProfileSetting extends StatefulWidget {
  @override
  _TrainerProfileSettingState createState() => _TrainerProfileSettingState();
}

class _TrainerProfileSettingState extends State<TrainerProfileSetting> {
  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController experienceController;
  late TextEditingController expertiseController;
  late TextEditingController profilePictureUrlController; // Added this

  Map<String, dynamic> profileData = {
    'Name': '',
    'Age': '',
    'Experience': '',
    'Expertise': [],
  };

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: profileData['Name'] ?? '');
    ageController = TextEditingController(text: profileData['Age'] ?? '');
    experienceController = TextEditingController(text: profileData['Experience'] ?? '');
    expertiseController = TextEditingController(text: (profileData['Expertise'] as List<dynamic>).join(', ') ?? '');
    profilePictureUrlController = TextEditingController(); // Initialize here

    fetchTrainerProfileData();
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    experienceController.dispose();
    expertiseController.dispose();
    profilePictureUrlController.dispose(); // Dispose here

    super.dispose();
  }
void fetchTrainerProfileData() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    print('User is not authenticated');
    return;
  }

  try {
    // Fetch profile data from the TrainerProfile subcollection
    QuerySnapshot profileSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('TrainerProfile')
        .get();

    Map<String, dynamic> profileData = {};
    profileSnapshot.docs.forEach((doc) {
      Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
      profileData.addAll(docData);
    });

    // Fetch profile picture URL from the users collection
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
    String? profilePictureUrl = userData?['profilePictureUrl'];

    // Update state with fetched data
    setState(() {
      this.profileData = profileData;
      nameController.text = profileData['Name']?.toString() ?? '';
      ageController.text = profileData['Age']?.toString() ?? '';
      experienceController.text = profileData['Experience']?.toString() ?? '';
      expertiseController.text = (profileData['Expertise'] as List<dynamic>?)?.join(', ') ?? '';
      profilePictureUrlController.text = profilePictureUrl ?? '';
    });
  } catch (e) {
    print('Error fetching profile data: $e');
  }
}
  void updateTrainerProfileData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User is not authenticated');
      return;
    }
    try {
      List<String> expertiseList = expertiseController.text.split(',').map((e) => e.trim()).toList();
      Map<String, dynamic> updatedProfileData = {
        'Name': nameController.text,
        'Age': ageController.text,
        'Experience': experienceController.text,
        'Expertise': expertiseList,
      };

      await TrainerSettingProfileService().updateSettingProfile(user.uid, updatedProfileData);
      print('Profile updated successfully!');
    } catch (e) {
      print('Failed to update profile: $e');
    }
  }

  Widget _loadTrainerProfilePicture() {
    return profilePictureUrlController.text.isNotEmpty
        ? CircleAvatar(
            radius: 60,
            backgroundImage: CachedNetworkImageProvider(profilePictureUrlController.text),
          )
        : const CircleAvatar(
            radius: 60,
            child: Icon(Icons.person),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Poppins',
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  _loadTrainerProfilePicture(),
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
                        decoration: const BoxDecoration(
                          color: Color(0xFF031927),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              ProfileTextField(
                label: 'Name',
                controller: nameController,
                onChanged: (value) {
                  setState(() {
                    profileData['Name'] = value;
                  });
                },
              ),
              SizedBox(height: 10.0),
              ProfileTextField(
                label: 'Age',
                controller: ageController,
                onChanged: (value) {
                  setState(() {
                    profileData['Age'] = value;
                  });
                },
              ),
              SizedBox(height: 10.0),
              ProfileTextField(
                label: 'Experience',
                controller: experienceController,
                onChanged: (value) {
                  setState(() {
                    profileData['Experience'] = value;
                  });
                },
              ),
              SizedBox(height: 10.0),
              ProfileTextField(
                label: 'Expertise',
                controller: expertiseController,
                onChanged: (value) {
                  setState(() {
                    profileData['Expertise'] = value.split(',').map((e) => e.trim()).toList();
                  });
                },
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: updateTrainerProfileData,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0XFF031927),
                  minimumSize: Size(150, 50),
                ),
                child: const Text(
                  'Update Profile',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
