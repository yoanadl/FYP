import 'package:flutter/material.dart';
import 'package:food/pages/SettingupProfile/gender_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food/services/SettingProfile_service.dart';

class NamePage extends StatefulWidget {
  const NamePage({Key? key}) : super(key: key);

  @override
  NamePageState createState() => NamePageState();
}

class NamePageState extends State<NamePage> {
  String? _Name;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateAge);
  }

  @override
  void dispose() {
    _nameController.removeListener(_updateAge);
    _nameController.dispose();
    super.dispose();
  }

  void _updateAge() {
    setState(() {
      _Name = _nameController.text;
    });
  }

  void _SetName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User is not authenticated');
      return;
    }

    if (_Name == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Please input your Name.'),
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
      await SettingprofileService().createProfile(user.uid,  {
        'Name': _Name,
      });

      // Navigate to Height page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GenderSelectionScreen(),
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
              keyboardType: TextInputType.name,
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
                onPressed: _SetName,
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
