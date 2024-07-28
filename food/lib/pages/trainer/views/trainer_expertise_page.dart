import 'package:flutter/material.dart';
import 'package:food/pages/trainer/presenters/trainer_base_page.dart';
import 'package:food/pages/trainer/presenters/trainer_expertise_presenter.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainerExpertisePage extends StatefulWidget {
  const TrainerExpertisePage({Key? key}) : super(key: key);

  @override
  _TrainerExpertisePageState createState() => _TrainerExpertisePageState();
}

class _TrainerExpertisePageState extends State<TrainerExpertisePage> implements TrainerExpertiseView {
  late TrainerExpertisePresenter _presenter;
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
  final Set<String> _selectedExpertise = {};

  @override
  void initState() {
    super.initState();
    _presenter = TrainerExpertisePresenter(this);
  }

  void _toggleExpertise(String expertise) {
    setState(() {
      if (_selectedExpertise.contains(expertise)) {
        _selectedExpertise.remove(expertise);
      } else {
        _selectedExpertise.add(expertise);
      }
    });
  }

  void _saveExpertise() {
    if (_selectedExpertise.isEmpty) {
      showError('Please select at least one area of expertise.');
      return;
    }
    _presenter.saveExpertise(_selectedExpertise.toList());
  }

  @override
  void onExpertiseSaved() {
    // Navigate to the trainer base page
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => TrainerBasePage())
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
              'Areas of Expertise',
              style: GoogleFonts.roboto(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: ListView(
                children: _expertiseOptions.map((expertise) {
                  return CheckboxListTile(
                    title: Text(expertise),
                    value: _selectedExpertise.contains(expertise),
                    onChanged: (bool? value) {
                      if (value != null) {
                        _toggleExpertise(expertise);
                      }
                    },
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: ElevatedButton(
                onPressed: _saveExpertise,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF031927),
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'Save',
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
