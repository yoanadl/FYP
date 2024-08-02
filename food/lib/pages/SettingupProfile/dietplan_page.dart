import 'package:flutter/material.dart';
import 'package:food/pages/base_page.dart';
import 'package:food/pages/home_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food/services/setting_user_profile_service.dart';

class DietPreferencePage extends StatefulWidget {
  @override
  _DietPreferenceScreenState createState() => _DietPreferenceScreenState();
}

class _DietPreferenceScreenState extends State<DietPreferencePage> {
  String _selecteddiet = 'Low Calorie';

  void _SetDietryPreference() async {
    
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User is not authenticated');
      return;
    }
    try {
      await SettingProfileService().updateSettingProfile(user.uid, {
        'dietry preference': _selecteddiet,
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
                'What is your\ndietary preference?',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 32),
              _buildRadioTile('Low Calorie'),
              _buildRadioTile('High Protien'),
              _buildRadioTile('Lactose Intolerant'),
              _buildRadioTile('Vegetarian'),
              _buildRadioTile('Vegan'),
              SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ElevatedButton(
                  onPressed: _SetDietryPreference,
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
    bool isSelected = _selecteddiet == title;
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
        groupValue: _selecteddiet,
        onChanged: (value) {
          setState(() {
            _selecteddiet = value!;
          });
        },
        activeColor: Color(0xFF031927),
      ),
    );
  }
}
