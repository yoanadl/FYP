import 'package:flutter/material.dart';
import 'package:food/pages/trainer/presenters/trainer_experience_presenter.dart';
import 'package:food/pages/trainer/views/trainer_expertise_page.dart';
import 'package:google_fonts/google_fonts.dart';


class TrainerExperiencePage extends StatefulWidget {
  const TrainerExperiencePage({Key? key}) : super(key: key);

  @override
  TrainerExperiencePageState createState() => TrainerExperiencePageState();
}

class TrainerExperiencePageState extends State<TrainerExperiencePage> implements TrainerExperienceView {
  final TextEditingController _experienceController = TextEditingController();
  late TrainerExperiencePresenter _presenter;

  @override
  void initState() {
    super.initState();
    _presenter = TrainerExperiencePresenter(this);
    _experienceController.addListener(_updateExperience);
  }

  @override
  void dispose() {
    _experienceController.removeListener(_updateExperience);
    _experienceController.dispose();
    super.dispose();
  }

  void _updateExperience() {
    _presenter.updateExperience(_experienceController.text);
  }

  @override
  void showExperienceError(String message) {
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
  void navigateToNextPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TrainerExpertisePage(),
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
              'Years of Experience?',
              style: GoogleFonts.roboto(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _experienceController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              style: TextStyle(fontSize: 18.0),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  _presenter.setExperience();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF031927), // Updated background color parameter
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
