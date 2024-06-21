import 'package:flutter/material.dart';

class CustomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  CustomNavigationBar({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home,
          color: Colors.teal),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle,
          color: Colors.teal),
          label: 'User Account',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list,
          color: Colors.teal),
          label: 'User Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_2,
          color: Colors.teal),
          label: 'Profile',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.amber[800],
      onTap: onItemTapped,
    );
  }
}
