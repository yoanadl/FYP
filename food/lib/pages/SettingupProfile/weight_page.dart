import 'package:flutter/material.dart';
import 'package:food/pages/SettingupProfile/fitness_goals.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food/services/SettingProfile_service.dart';

class WeightPage extends StatefulWidget {
  const WeightPage({Key? key}) : super(key: key);

  @override
  WeightPageState createState() => WeightPageState();
}

class WeightPageState extends State<WeightPage> {
  String? _Weight;
  final TextEditingController _weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _weightController.addListener(_updateWeight);
  }

  @override
  void dispose() {
    _weightController.removeListener(_updateWeight);
    _weightController.dispose();
    super.dispose();
  }

  void _updateWeight() {
    setState(() {
      _Weight = _weightController.text;
    });
  }

  void _SetWeight() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User is not authenticated');
      return;
    }

    if (_Weight == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Please input a valid weight.'),
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
        'Weight(kg)': _Weight,
      });

      // Navigate to FitnessGoal page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FitnessGoalPage(),
        ),
      );
    } catch (e) {
      print('Failed to save Weight: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to save Weight. Please try again later.'),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Spacer(),
            Text(
              'What is your weight? (kg)',
              style: GoogleFonts.roboto(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _weightController,
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
                onPressed: _SetWeight,
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
