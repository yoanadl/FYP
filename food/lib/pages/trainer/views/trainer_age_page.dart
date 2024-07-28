import 'package:flutter/material.dart';
import 'package:food/pages/trainer/presenters/trainer_age_presenter.dart';
import 'package:food/pages/trainer/views/trainer_experience_page.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainerAgePage extends StatefulWidget {
  const TrainerAgePage({Key? key}) : super(key: key);

  @override
  TrainerAgePageState createState() => TrainerAgePageState();
}

class TrainerAgePageState extends State<TrainerAgePage> implements TrainerAgeView {
  final TextEditingController _ageController = TextEditingController();
  late TrainerAgePresenter _presenter;

  @override
  void initState() {
    super.initState();
    _presenter = TrainerAgePresenter(this);
    _ageController.addListener(_updateAge);
  }

  @override
  void dispose() {
    _ageController.removeListener(_updateAge);
    _ageController.dispose();
    super.dispose();
  }

  void _updateAge() {
    _presenter.updateAge(_ageController.text);
  }

  @override
  void showAgeError(String message) {
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
        builder: (context) => const TrainerExperiencePage(),
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
              'How old are you?',
              style: GoogleFonts.roboto(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _ageController,
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
                  _presenter.setAge();
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
