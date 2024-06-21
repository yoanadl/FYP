import 'package:flutter/material.dart';
import 'package:food/pages/SettingupProfile/height_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food/services/SettingProfile_service.dart';

class AgePage extends StatefulWidget {
  const AgePage({Key? key}) : super(key: key);

  @override
  AgePageState createState() => AgePageState();
}

class AgePageState extends State<AgePage> {
  int? _Age;
  final TextEditingController _ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ageController.addListener(_updateAge);
  }

  @override
  void dispose() {
    _ageController.removeListener(_updateAge);
    _ageController.dispose();
    super.dispose();
  }

  void _updateAge() {
    setState(() {
      _Age = int.tryParse(_ageController.text);
    });
  }

  void _SetAge() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User is not authenticated');
      return;
    }

    if (_Age == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Please input your Age.'),
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
      await SettingprofileService().updateSettingProfile(user.uid,  {
        'Age': _Age,
      });

      // Navigate to Height page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HeightPage(),
        ),
      );
    } catch (e) {
      print('Failed to save Age: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to save Age. Please try again later.'),
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
                onPressed: _SetAge,
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
