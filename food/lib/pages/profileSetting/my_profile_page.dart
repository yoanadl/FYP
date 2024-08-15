import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food/services/setting_user_profile_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food/pages/user/view/upload_profile_page.dart';

class ProfileTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Function(String) onChanged;
  final bool isEnabled;

  const ProfileTextField({
    Key? key,
    required this.label,
    required this.controller,
    required this.onChanged,
    this.isEnabled = true, // Added parameter to control field enablement
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
              enabled: isEnabled, // Control whether the field is editable
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

class ProfileDropdownField extends StatelessWidget {
  final String label;
  final String? selectedValue;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  const ProfileDropdownField({
    Key? key,
    required this.label,
    required this.selectedValue,
    required this.options,
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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Color(0XFF031927), width: 1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: DropdownButtonFormField<String>(
                value: selectedValue,
                onChanged: onChanged,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Select $label',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontFamily: 'Poppins',
                    fontSize: 14.0,
                  ),
                ),
                items: options.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
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
  
  // Add this for fitness goals
  String? selectedGoal;
  final List<String> fitnessGoals = [
    'Lose Weight',
    'Build Muscle',
    'Improve Endurance',
    'Gain Weight',
    'Keep Fit'
  ];

  Map<String, dynamic> profileData = {
    'Name': '',
    'gender': '',
    'Age': '',
    'Height(cm)': '',
    'Weight(kg)': '',
    'fitnessGoals': '',
  };

  Map<String, dynamic> profileData_1 = {
    'Email': '',
  };

  bool isLoading = false; // Track loading state

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: profileData['Name'] ?? '');
    emailController = TextEditingController(text: profileData_1['Email'] ?? '');
    genderController = TextEditingController(text: profileData['gender'] ?? '');
    ageController = TextEditingController(text: profileData['Age'] ?? '');
    heightController = TextEditingController(text: profileData['Height(cm)'] ?? '');
    weightController = TextEditingController(text: profileData['Weight(kg)'] ?? '');
    selectedGoal = profileData['fitnessGoals'] as String?;

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
        selectedGoal = profileData['fitnessGoals'] as String?;
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
    setState(() {
      isLoading = true; // Show loading indicator
    });
    try {
      profileData['fitnessGoals'] = selectedGoal;
      await SettingProfileService().updateSettingProfile(user.uid, profileData);
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false; // Hide loading indicator
      });
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
            fontSize: 23,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10),
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
              SizedBox(height: 16.0),
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
                isEnabled: false, // Email field is not changeable
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
              SizedBox(height: 10.0),
              ProfileDropdownField(
                label: 'Fitness Goal',
                selectedValue: selectedGoal,
                options: fitnessGoals,
                onChanged: (value) {
                  setState(() {
                    selectedGoal = value;
                    profileData['fitnessGoals'] = value;
                  });
                },
              ),
              SizedBox(height: 36.0),
              isLoading // Display loading indicator or button
                  ? CircularProgressIndicator()
                  : ElevatedButton(
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
              SizedBox(height: 64.0),
            ],
          ),
        ),
      ),
    );
  }
}
