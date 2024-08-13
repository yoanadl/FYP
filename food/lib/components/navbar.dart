import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {

  final int currentIndex;
  final Function(int) onTap;

  const Navbar({
    super.key, 
    required this.currentIndex,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem> [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label : 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label : 'Workout',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag_circle),
            label : 'Challenges',
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.sports_mma),
            label : 'Trainer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label : 'Profile',
          ),
        ],
        
        currentIndex: currentIndex,
        selectedItemColor: const Color(0xff031927),
        onTap: onTap,
        backgroundColor: Colors.white,
      
      ),
    );
  }
}