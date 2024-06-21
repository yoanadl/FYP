import 'package:flutter/material.dart';
import 'package:food/pages/SettingupProfile/age_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food/services/SettingProfile_service.dart';

class GenderSelectionScreen extends StatefulWidget {
  const GenderSelectionScreen({Key? key}) : super(key: key);

  @override
  _GenderSelectionScreenState createState() => _GenderSelectionScreenState();
}

class _GenderSelectionScreenState extends State<GenderSelectionScreen> {
  String? _selectedGender;

  void _handleGenderSelection(String gender) {
    setState(() {
      _selectedGender = gender;
    });
  }



  void _Setgender() async {
    
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User is not authenticated');
      return;
    }
    
    if (_selectedGender == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Please choose a gender.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }
    try {
      await SettingprofileService().updateSettingProfile(user.uid, {
        'gender': _selectedGender,
      });

      // Navigate to age page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AgePage(),
        ),
      );
    } catch (e) {
      print('Failed to save gender: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to save gender. Please try again later.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setup Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Tell us about yourself',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'To ensure we provide the best possible experience,\nwe\'d like to know a bit more about you.\nCould you please let us know your gender?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 32),
            GenderSelectionButton(
              icon: Icons.male,
              label: 'Male',
              isSelected: _selectedGender == 'Male',
              onTap: () => _handleGenderSelection('Male'),
            ),
            SizedBox(height: 16),
            GenderSelectionButton(
              icon: Icons.female,
              label: 'Female',
              isSelected: _selectedGender == 'Female',
              onTap: () => _handleGenderSelection('Female'),
            ),
            SizedBox(height: 32),
            GestureDetector(
              onTap: _Setgender,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF031927),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Container(
                  width: 320,
                  padding: EdgeInsets.fromLTRB(1, 19, 0, 19),
                  child: Text(
                    'Next',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.getFont(
                      'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      height: 1.1,
                      letterSpacing: -0.4,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GenderSelectionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const GenderSelectionButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 125,
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.lightBlue[50],
          shape: BoxShape.circle,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: isSelected ? Colors.white : Colors.black,
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

