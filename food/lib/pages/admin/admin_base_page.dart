// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:food/components/admin_navbar.dart';
import 'package:food/pages/admin/views/admin_profile.dart';
import 'package:food/pages/admin/views/admin_view_all_user_accounts.dart';
import 'package:food/pages/admin/admin_view_all_user_profile.dart';

import 'admin_home_page.dart';



class AdminBasePage extends StatefulWidget {
  final int initialIndex;
  const AdminBasePage({Key? key, this.initialIndex = 0}):  super(key: key) ;

  @override
  State<AdminBasePage> createState() => _AdminBasePageState();
}

class _AdminBasePageState extends State<AdminBasePage> {

  // track the currently selected item
  int _selectedIndex = 0;

  // define a list of widgets for each page
  final List<Widget> _pages = [
    AdminHomePage(),
    AdminViewAllUserAccounts(),
    UserProfilePage(),
    AdminProfile(),
  ];

  @override
  void initState() {
    
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        color: Colors.white, 
        child: Center(
          child: _selectedIndex < _pages.length ? _pages[_selectedIndex] : SizedBox(),
        ),
      ),

      bottomNavigationBar: AdminNavbar(
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
            
          },
          );
        }
      ),
    );
  }
}