import 'package:flutter/material.dart';
import 'package:food/pages/trainer/models/trainer_profile_model.dart';
import 'package:food/pages/trainer/presenters/trainer_gender_presenter.dart';
import 'package:food/pages/trainer/views/trainer_age_page.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainerGenderPage extends StatefulWidget {
  const TrainerGenderPage({Key? key}) : super(key: key);

  @override
  GenderSelectionScreenState createState() => GenderSelectionScreenState();
}

class GenderSelectionScreenState extends State<TrainerGenderPage> implements GenderSelectionView {
  late TrainerGenderPresenter _presenter;
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _presenter = TrainerGenderPresenter(TrainerProfile());
    _presenter.attachView(this);
  }

  void _setGender(String gender) {
    setState(() {
      _selectedGender = gender;
    });
    _presenter.setGender(gender);
  }

  void _saveProfile() {
    if (_selectedGender == null) {
      showError('Please select a gender.');
      return;
    }
    _presenter.saveProfile();
  }

  @override
  void onProfileSaved() {
    // Navigate to the next page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TrainerAgePage(),
      ),
    );
  }

  @override
  void showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Spacer(),
            Text(
              'What is your gender?',
              style: GoogleFonts.roboto(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            ListTile(
              title: const Text('Male'),
              leading: Radio<String>(
                value: 'Male',
                groupValue: _selectedGender,
                onChanged: (String? value) {
                  if (value != null) {
                    _setGender(value);
                  }
                },
              ),
            ),
            ListTile(
              title: const Text('Female'),
              leading: Radio<String>(
                value: 'Female',
                groupValue: _selectedGender,
                onChanged: (String? value) {
                  if (value != null) {
                    _setGender(value);
                  }
                },
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: ElevatedButton(
                onPressed: _saveProfile,
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
    );
  }
}
