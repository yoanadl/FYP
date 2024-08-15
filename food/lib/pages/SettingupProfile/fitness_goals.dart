import 'package:flutter/material.dart';
import 'package:food/components/base_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food/services/setting_user_profile_service.dart';

class FitnessGoalPage extends StatefulWidget {
  @override
  _FitnessGoalScreenState createState() => _FitnessGoalScreenState();
}

class _FitnessGoalScreenState extends State<FitnessGoalPage> {
  String _selectedGoal = 'Lose Weight';

  void _Setfitnessgoals() async {
    
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User is not authenticated');
      return;
    }
    try {
      await SettingProfileService().updateSettingProfile(user.uid, {
        'fitnessGoals': _selectedGoal,
      });

      // Navigate to age page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BasePage(),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'What is your\nfitness goal?',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 32),
              _buildRadioTile('Lose Weight'),
              _buildRadioTile('Gain Weight'),
              _buildRadioTile('Gain Muscle'),
              _buildRadioTile('Improve Endurance'),
              _buildRadioTile('Keep Fit'),
              SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ElevatedButton(
                  onPressed: _Setfitnessgoals,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF031927),
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    'Next',
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadioTile(String title) {
    bool isSelected = _selectedGoal == title;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: isSelected ? Colors.lightBlue[100] : Colors.lightBlue[50],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.lightBlue, width: 1),
      ),
      child: RadioListTile<String>(
        title: Text(
          title,
          style: GoogleFonts.roboto(fontSize: 18),
        ),
        value: title,
        groupValue: _selectedGoal,
        onChanged: (value) {
          setState(() {
            _selectedGoal = value!;
          });
        },
        activeColor: Color(0xFF031927),
      ),
    );
  }
}
