import 'package:flutter/material.dart';
import 'package:food/pages/trainer/presenters/trainer_name_presenter.dart';
import 'package:food/pages/trainer/views/trainer_age_page.dart';
import 'package:google_fonts/google_fonts.dart';

class TrainerNamePage extends StatefulWidget {
  const TrainerNamePage({Key? key}) : super(key: key);

  @override
  TrainerNamePageState createState() => TrainerNamePageState();
}

class TrainerNamePageState extends State<TrainerNamePage> implements TrainerNameView {
  late TrainerNamePresenter _presenter;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _presenter = TrainerNamePresenter(this);
  }

  void _saveProfile() {
    String name = _nameController.text.trim();
    _presenter.setName(name);
    _presenter.saveProfile(name);
  }

  @override
  void navigateToNextPage() {
    // Navigate to the next page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TrainerAgePage(),
      ),
    );
  }

  @override
  void showNameError(String message) {
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
              'What is your name?',
              style: GoogleFonts.roboto(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
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
