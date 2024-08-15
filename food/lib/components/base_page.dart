import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food/components/navbar.dart';
import 'package:food/pages/challenges/challenge_home_page.dart';
import 'package:food/pages/premiumUser/trainer/trainer_page.dart';
import 'package:food/pages/workout/views/workout_page_view.dart';
import '../pages/user/view/profile_page.dart';
import '../pages/user/view/home_page.dart';
import 'package:food/components/navbar.dart';

class BasePage extends StatefulWidget {
  final int initialIndex;
  const BasePage({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    WorkoutPage(),
    ChallengeHomePage(),
    TrainersPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  Future<void> _handleNavigation(int index) async {
    if (index == 3) { // TrainersPage index
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
          final role = userDoc.data()?['role'];

          if (role == 'premium user') {
            setState(() {
              _selectedIndex = index;
            });
          } else {
            _showSubscriptionPrompt();
          }
        } catch (e) {
          print('Error fetching user role: $e');
        }
      } else {
        // Handle the case when the user is not logged in
        // Optionally show an alert or redirect to login page
      }
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _showSubscriptionPrompt() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Access Restricted'),
        content: Text('Please subscribe to GoodGrit to access this feature.'),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
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
      bottomNavigationBar: Navbar(
        currentIndex: _selectedIndex,
        onTap: (int index) {
          _handleNavigation(index);
        },
      ),
    );
  }
}


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:food/components/navbar.dart';
// import 'package:food/pages/challenges/challenge_home_page.dart';
// import 'package:food/pages/premiumUser/trainer/trainer_page.dart';
// import 'package:food/pages/workout/views/workout_page_view.dart';
// import '../pages/user/view/profile_page.dart'; // Ensure this import is correct
// import '../pages/user/view/home_page.dart';

// class BasePage extends StatefulWidget {
//   final int initialIndex;
//   const BasePage({Key? key, this.initialIndex = 0}) : super(key: key);

//   @override
//   State<BasePage> createState() => _BasePageState();
// }

// class _BasePageState extends State<BasePage> {
//   int _selectedIndex = 0;

//   final List<Widget> _pages = [
//     HomePage(),
//     WorkoutPage(),
//     ChallengeHomePage(),
//     TrainersPage()
//     ProfilePage(), // Ensure this is the correct page
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _selectedIndex = widget.initialIndex;
//   }

//   Future<void> _handleNavigation(int index) async {
//     if (index == 3) { // ProfilePage index
//       final user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         try {
//           final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
//           final role = userDoc.data()?['role'];

//           if (role == 'premium user') {
//             setState(() {
//               _selectedIndex = index;
//             });
//           } else {
//             _showSubscriptionPrompt();
//           }
//         } catch (e) {
//           print('Error fetching user role: $e');
//         }
//       } else {
//         // Handle the case when the user is not logged in
//         // Optionally show an alert or redirect to login page
//       }
//     } else {
//       setState(() {
//         _selectedIndex = index;
//       });
//     }
//   }

//   void _showSubscriptionPrompt() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Access Restricted'),
//         content: Text('Please subscribe to GoodGrit to access this feature.'),
//         actions: [
//           TextButton(
//             child: Text('OK'),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color: Colors.white,
//         child: Center(
//           child: _pages[_selectedIndex], // Display the correct page
//         ),
//       ),
//       bottomNavigationBar: Navbar(
//         currentIndex: _selectedIndex,
//         onTap: (int index) {
//           _handleNavigation(index); // Handle navigation
//         },
//       ),
//     );
//   }
// }
