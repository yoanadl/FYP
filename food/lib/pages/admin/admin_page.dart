import 'package:flutter/material.dart';
import 'package:food/pages/admin/admin_view_all_user_accounts.dart';
import 'admin_homepage.dart';
import 'user_account_page.dart';
import 'user_profile_page.dart';
import 'admin_profilepage.dart';
import 'admin_navbar.dart'; // Import the custom navigation bar

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  late PageController _pageController;
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    AdminHomePage(), // Correctly instantiate your page widgets
    AdminViewAllUserAccounts(),
    UserProfilePage(),
    AdminProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getAppBarTitle(),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 25.0,
            fontFamily: 'Poppins',
            color: Colors.black,
          ),
        ),
        toolbarHeight: 50,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _widgetOptions,
      ),
      bottomNavigationBar: CustomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  String _getAppBarTitle() {
    //later need to be fixed
    switch (_selectedIndex) {
      case 0:
        return 'Admin Home'; // Return appropriate titles for each page
      case 1:
        return 'User Account';
      case 2:
        return 'User Profile';
      case 3:
        return 'Admin Profile';
      default:
        return 'Admin Page';
    }
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Admin Page',
    home: AdminPage(),
  ));
}
