import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'admin_homepage.dart';
import 'useraccount_page.dart';
import 'userprofile_page.dart';
import 'admin_profilepage.dart';
import 'admin_navbar.dart'; // Import the custom navigation bar

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    AdminHomePage(),
    UserAccountPage(),
    UserProfilePage(), 
    AdminProfilePage()// Use the new page widgets
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            
            Expanded(
              child: Text(
                'Hello Admin',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 25.0,
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),

      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Admin Page',
    home: AdminPage(),
  ));
}
