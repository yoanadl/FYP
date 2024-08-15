import 'package:flutter/material.dart';

class TrainerNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const TrainerNavbar({
    super.key, 
    required this.currentIndex,
    required this.onTap
  });

//import all the assets from figma as svg then apply to here

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120, // Adjust the height here
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Client List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: currentIndex,
        selectedItemColor: const Color(0xff031927),
        unselectedItemColor: Colors.grey, // Optional: color for unselected items
        onTap: onTap,
        backgroundColor: Colors.white,
        selectedLabelStyle: TextStyle(fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.bold), 
        unselectedLabelStyle: TextStyle(fontSize: 11, fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        
         // Font size for unselected label
      ),
    );
  }
}
