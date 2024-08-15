import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food/pages/profileSetting/my_profile_page.dart';
import 'package:food/services/setting_trainer_profile_service.dart';
import 'package:food/pages/trainer/models/trainer_profile_model.dart';
import 'package:food/pages/user/view/upload_profile_page.dart';

class TrainerProfileSetting extends StatefulWidget {
  @override
  _TrainerProfileSettingState createState() => _TrainerProfileSettingState();
}

class _TrainerProfileSettingState extends State<TrainerProfileSetting> {
  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController experienceController;

  TrainerProfile trainerProfile = TrainerProfile();

  final List<String> _expertiseOptions = [
    'Strength Training',
    'Cardio Training',
    'HIIT',
    'Weight Loss',
    'Muscle Gain',
    'Sports Performance',
    'Flexibility and Mobility',
    'Injury Rehabilitation',
    'Yoga',
    'Nutrition Counseling'
  ];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    ageController = TextEditingController();
    experienceController = TextEditingController();

    fetchTrainerProfileData();
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    experienceController.dispose();
    super.dispose();
  }

  void fetchTrainerProfileData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User is not authenticated');
      return;
    }
    try {
      Map<String, dynamic>? profileData = await TrainerSettingProfileService().fetchUserData(user.uid);

      if (profileData != null) {
        setState(() {
          trainerProfile = TrainerProfile.fromMap(profileData);
          nameController.text = trainerProfile.name ?? '';
          ageController.text = trainerProfile.age?.toString() ?? '';
          experienceController.text = trainerProfile.experience?.toString() ?? '';

          // Initialize selected expertise options based on fetched data
          trainerProfile.expertise = trainerProfile.expertise ?? [];
        });
      }
    } catch (e) {
      print('Failed to fetch profile data: $e');
    }
  }

  void updateTrainerProfileData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User is not authenticated');
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      Map<String, dynamic> profileData = trainerProfile.toMap();
      profileData['name'] = nameController.text;
      profileData['age'] = int.tryParse(ageController.text);
      profileData['experience'] = int.tryParse(experienceController.text);
      profileData['expertise'] = trainerProfile.expertise; // Save selected expertise options

      await TrainerSettingProfileService().updateSettingProfile(user.uid, profileData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildExpertiseCheckboxList() {
    return Column(
      children: _expertiseOptions.map((option) {
        return CheckboxListTile(
          title: Text(option,
          style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
          ),
          value: trainerProfile.expertise?.contains(option) ?? false,
          onChanged: (bool? selected) {
            if (selected == true) {
              setState(() {
                trainerProfile.expertise?.add(option);
              });
            } else {
              setState(() {
                trainerProfile.expertise?.remove(option);
              });
            }
          },
        );
      }).toList(),
    );
  }

  Widget _loadUserProfilePicture() {
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
          'Profile Settings',
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
                    trainerProfile.name = value;
                  });
                },
                hintText: trainerProfile.name,
              ),
              SizedBox(height: 10.0),
              ProfileTextField(
                label: 'Age',
                controller: ageController,
                onChanged: (value) {
                  setState(() {
                    trainerProfile.age = int.tryParse(value);
                  });
                },
                hintText: trainerProfile.age?.toString(),
              ),
              SizedBox(height: 10.0),
              ProfileTextField(
                label: 'Experience',
                controller: experienceController,
                onChanged: (value) {
                  setState(() {
                    trainerProfile.experience = int.tryParse(value);
                  });
                },
                hintText: trainerProfile.experience?.toString(),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Expertise',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    _buildExpertiseCheckboxList(),
                  ],
                ),
              ),
              SizedBox(height: 36.0),
              isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
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
              SizedBox(height: 64.0),
            ],
          ),
        ),
      ),
    );
  }
}
