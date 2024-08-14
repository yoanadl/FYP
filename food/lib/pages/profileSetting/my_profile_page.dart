import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food/services/setting_user_profile_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food/pages/user/view/upload_profile_page.dart';

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

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController genderController;
  late TextEditingController ageController;
  late TextEditingController heightController;
  late TextEditingController weightController;

  Map<String, dynamic> profileData = {
    'Name': '',
    'gender': '',
    'Age': '',
    'Height(cm)': '',
    'Weight(kg)': '',
  };

  Map<String, dynamic> profileData_1 = {
    'Email': '',
  };

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: profileData['Name'] ?? '');
    emailController = TextEditingController(text: profileData_1['Email'] ?? '');
    genderController = TextEditingController(text: profileData['gender'] ?? '');
    ageController = TextEditingController(text: profileData['Age'] ?? '');
    heightController = TextEditingController(text: profileData['Height(cm)'] ?? '');
    weightController = TextEditingController(text: profileData['Weight(kg)'] ?? '');

    fetchProfileData();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    genderController.dispose();
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();

    super.dispose();
  }

  void fetchProfileData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User is not authenticated');
      return;
    }
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('UserProfile')
          .get();

      Map<String, dynamic> data = {};
      querySnapshot.docs.forEach((doc) {
        data.addAll(doc.data() as Map<String, dynamic>);
      });

      setState(() {
        profileData = data;
        profileData_1['Email'] = user.email ?? '';
        nameController.text = profileData['Name'] ?? '';
        emailController.text = profileData_1['Email'] ?? '';
        genderController.text = profileData['gender'] ?? '';
        ageController.text = profileData['Age'] ?? '';
        heightController.text = profileData['Height(cm)'] ?? '';
        weightController.text = profileData['Weight(kg)'] ?? '';
      });
    } catch (e) {
      print('Error fetching profile data: $e');
    }
  }

  void updateProfileData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User is not authenticated');
      return;
    }
    try {
      await SettingProfileService().updateSettingProfile(user.uid, profileData);
      print('Profile updated successfully!');
    } catch (e) {
      print('Failed to update profile: $e');
    }
  }

  Widget _loadUserProfilePicture() {
    // Placeholder for a profile picture using a default icon
    return CircleAvatar(
      radius: 60,
      backgroundColor: Colors.grey[100],
      child: Icon(Icons.person, size: 60),
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
                  _loadUserProfilePicture(),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        // Handle profile picture upload
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
                label: 'Email',
                controller: emailController,
                onChanged: (value) {
                  setState(() {
                    profileData_1['Email'] = value;
                  });
                },
              ),
              SizedBox(height: 10.0),
              ProfileTextField(
                label: 'Gender',
                controller: genderController,
                onChanged: (value) {
                  setState(() {
                    profileData['gender'] = value;
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
                label: 'Height(cm)',
                controller: heightController,
                onChanged: (value) {
                  setState(() {
                    profileData['Height(cm)'] = value;
                  });
                },
              ),
              SizedBox(height: 10.0),
              ProfileTextField(
                label: 'Weight(kg)',
                controller: weightController,
                onChanged: (value) {
                  setState(() {
                    profileData['Weight(kg)'] = value;
                  });
                },
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: updateProfileData,
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
