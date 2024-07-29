import 'package:flutter/material.dart';

class TrainerNavbar extends StatelessWidget {

  final int currentIndex;
  final Function(int) onTap;

  const TrainerNavbar({
    super.key, 
    required this.currentIndex,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
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
            icon: Icon(Icons.list),
            label : 'Client List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank),
            label : 'Meal Plan',
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