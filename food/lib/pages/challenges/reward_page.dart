// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:food/services/challenge_service.dart';

// class RewardPage extends StatefulWidget {
//   @override
//   _RewardPageState createState() => _RewardPageState();
// }

// class _RewardPageState extends State<RewardPage> {
//   int _totalRewardPoints = 0;
//   ChallengeService challengeService = ChallengeService();

//   final userId = FirebaseAuth.instance.currentUser!.uid;


//   @override
//   void initState() {
//     super.initState();
//     challengeService.calculateAndStoreTotalRewardPoints(userId);
//     _fetchTotalRewardPoints();
//   }

//   Future<void> _fetchTotalRewardPoints() async {
//     final userId = FirebaseAuth.instance.currentUser!.uid;
    
//     try {
//       // Fetch the user's document from Firestore
//       final userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .get();
      
//       if (userDoc.exists) {
//         // Extract totalRewardPoints from the document
//         setState(() {
//           _totalRewardPoints = userDoc.data()?['totalRewardPoints'] ?? 0;
//         });
//       } else {
//         print('User document does not exist.');
//       }
//     } catch (e) {
//       print('Error fetching total reward points: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Text(
//           'Rewards',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: Text(
//                   'Total points: $_totalRewardPoints',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               SizedBox(height: 20),
//               Text('Premium Subscription',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               ListTile(
//                 title: Text('3 Days (350 Points)'),
//                 trailing: ElevatedButton(
//                   onPressed: () {
//                     _showRedeemDialog(context);
//                   },
//                   child: Text('Redeem'),
//                 ),
//               ),
//               ListTile(
//                 title: Text('7 Days (650 Points)'),
//                 trailing: ElevatedButton(
//                   onPressed: () {
//                     _showRedeemDialog(context);
//                   },
//                   child: Text('Redeem'),
//                 ),
//               ),
//               ListTile(
//                 title: Text('1 Month (1,500 Points)'),
//                 trailing: ElevatedButton(
//                   onPressed: () {
//                     _showRedeemDialog(context);
//                   },
//                   child: Text('Redeem'),
//                 ),
//               ),
//               ListTile(
//                 title: Text('3 Months (3,500 Points)'),
//                 trailing: ElevatedButton(
//                   onPressed: () {
//                     _showRedeemDialog(context);
//                   },
//                   child: Text('Redeem'),
//                 ),
//               ),
//               ListTile(
//                 title: Text('6 Months (6,000 Points)'),
//                 trailing: ElevatedButton(
//                   onPressed: () {
//                     _showRedeemDialog(context);
//                   },
//                   child: Text('Redeem'),
//                 ),
//               ),
//               ListTile(
//                 title: Text('1 Year (10,000 Points)'),
//                 trailing: ElevatedButton(
//                   onPressed: () {
//                     _showRedeemDialog(context);
//                   },
//                   child: Text('Redeem'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.fitness_center),
//             label: 'Workout',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.people),
//             label: 'Community',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }

//   void _showRedeemDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           content: Text('Do you wish to redeem this reward?'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Yes'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('No'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'dart:math';
// import 'package:food/services/challenge_service.dart';

// class RewardPage extends StatefulWidget {
//   @override
//   _RewardPageState createState() => _RewardPageState();
// }

// class _RewardPageState extends State<RewardPage> {
//   int _totalRewardPoints = 0;
//   ChallengeService challengeService = ChallengeService();


//   final List<Map<String, String>> _discountCodes = [
//     {'shop': 'FitGear', 'code': 'FIT20'},
//     {'shop': 'HealthHub', 'code': 'HEALTH15'},
//     {'shop': 'GymPro', 'code': 'GYM25'},
//     {'shop': 'PowerLift', 'code': 'POWER30'},
//     {'shop': 'FlexZone', 'code': 'FLEX10'},
//   ];

//   final userId = FirebaseAuth.instance.currentUser!.uid;

//   @override
//   void initState() {
//     super.initState();
//     challengeService.calculateAndStoreTotalRewardPoints(userId);

//     _fetchTotalRewardPoints();
//   }

//   Future<void> _fetchTotalRewardPoints() async {
//     try {
//       final userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .get();
      
//       if (userDoc.exists) {
//         setState(() {
//           _totalRewardPoints = userDoc.data()?['totalRewardPoints'] ?? 0;
//         });
//       } else {
//         print('User document does not exist.');
//       }
//     } catch (e) {
//       print('Error fetching total reward points: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Text(
//           'Rewards',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: Text(
//                   'Total points: $_totalRewardPoints',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               SizedBox(height: 20),
//               Text('Premium Subscription',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               ListTile(
//                 title: Text('3 Days (350 Points)'),
//                 trailing: ElevatedButton(
//                   onPressed: () {
//                     _showRedeemDialog(context);
//                   },
//                   child: Text('Redeem'),
//                 ),
//               ),
//               ListTile(
//                 title: Text('7 Days (650 Points)'),
//                 trailing: ElevatedButton(
//                   onPressed: () {
//                     _showRedeemDialog(context);
//                   },
//                   child: Text('Redeem'),
//                 ),
//               ),
//               ListTile(
//                 title: Text('1 Month (1,500 Points)'),
//                 trailing: ElevatedButton(
//                   onPressed: () {
//                     _showRedeemDialog(context);
//                   },
//                   child: Text('Redeem'),
//                 ),
//               ),
//               ListTile(
//                 title: Text('3 Months (3,500 Points)'),
//                 trailing: ElevatedButton(
//                   onPressed: () {
//                     _showRedeemDialog(context);
//                   },
//                   child: Text('Redeem'),
//                 ),
//               ),
//               ListTile(
//                 title: Text('6 Months (6,000 Points)'),
//                 trailing: ElevatedButton(
//                   onPressed: () {
//                     _showRedeemDialog(context);
//                   },
//                   child: Text('Redeem'),
//                 ),
//               ),
//               ListTile(
//                 title: Text('1 Year (10,000 Points)'),
//                 trailing: ElevatedButton(
//                   onPressed: () {
//                     _showRedeemDialog(context);
//                   },
//                   child: Text('Redeem'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.fitness_center),
//             label: 'Workout',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.people),
//             label: 'Community',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }

//   void _showRedeemDialog(BuildContext context) {
//     // Get a random discount code
//     final random = Random();
//     final randomCode = _discountCodes[random.nextInt(_discountCodes.length)];

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Congratulations!'),
//           content: Text(
//             'You have redeemed your points!\n\n'
//             'Here is a discount code for you:\n'
//             '${randomCode['shop']}: ${randomCode['code']}',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:food/services/challenge_service.dart';

// class RewardPage extends StatefulWidget {
//   @override
//   _RewardPageState createState() => _RewardPageState();
// }

// class _RewardPageState extends State<RewardPage> {
//   int _totalRewardPoints = 0;
//   ChallengeService challengeService = ChallengeService();

//   final userId = FirebaseAuth.instance.currentUser!.uid;


//   @override
//   void initState() {
//     super.initState();
//     challengeService.calculateAndStoreTotalRewardPoints(userId);
//     _fetchTotalRewardPoints();
//   }

//   Future<void> _fetchTotalRewardPoints() async {
//     final userId = FirebaseAuth.instance.currentUser!.uid;
    
//     try {
//       // Fetch the user's document from Firestore
//       final userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .get();
      
//       if (userDoc.exists) {
//         // Extract totalRewardPoints from the document
//         setState(() {
//           _totalRewardPoints = userDoc.data()?['totalRewardPoints'] ?? 0;
//         });
//       } else {
//         print('User document does not exist.');
//       }
//     } catch (e) {
//       print('Error fetching total reward points: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Text(
//           'Rewards',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(35.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: Text(
//                   'Total points: $_totalRewardPoints',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               SizedBox(height: 20),
//               Text('Premium Subscription',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               ListTile(
//                 title: Text('500 Points'),
//                 trailing: ElevatedButton(
//                   onPressed: () {
//                     _showRedeemDialog(context);
//                   },
//                   child: Text('Redeem'),
//                 ),
//               ),
              
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.fitness_center),
//             label: 'Workout',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.people),
//             label: 'Community',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }

//   void _showRedeemDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           content: Text('Do you wish to redeem this reward?'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Yes'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('No'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> updateUserRole(String userId) async {
//     // Reference to the document within the users collection
//     DocumentReference userDocRef = FirebaseFirestore.instance
//         .collection('users') // Main collection
//         .doc(userId); // Specific user document

//     // Update the 'role' field
//     await userDocRef.update({
//       'role': 'premium user', // Update the role field to 'premium user'
//     }).then((_) {
//       print("User role updated successfully!");
//     }).catchError((error) {
//       print("Failed to update user role: $error");
//     });
//   }

// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food/services/challenge_service.dart';

class RewardPage extends StatefulWidget {
  @override
  _RewardPageState createState() => _RewardPageState();
}

class _RewardPageState extends State<RewardPage> {
  int _totalRewardPoints = 0;
  static const int rewardThreshold = 500; // The amount needed to redeem

  ChallengeService challengeService = ChallengeService();
  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    challengeService.calculateAndStoreTotalRewardPoints(userId);
    _fetchTotalRewardPoints();
  }

  Future<void> _fetchTotalRewardPoints() async {
    try {
      // Fetch the user's document from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        // Extract totalRewardPoints from the document
        setState(() {
          _totalRewardPoints = userDoc.data()?['totalRewardPoints'] ?? 0;
        });
      } else {
        print('User document does not exist.');
      }
    } catch (e) {
      print('Error fetching total reward points: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Rewards',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(35.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Total points: $_totalRewardPoints',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              Text('Premium Subscription',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ListTile(
                title: Text('$rewardThreshold Points'),
                trailing: ElevatedButton(
                  onPressed: () {
                    _showRedeemDialog(context);
                  },
                  child: Text('Redeem'),
                ),
              ),
            ],
          ),
        ),
      ),
      
    );
  }

  void _showRedeemDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Do you wish to redeem this reward?'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();

                if (_totalRewardPoints >= rewardThreshold) {
                  // Subtract the points needed
                  int newPoints = _totalRewardPoints - rewardThreshold;
                  
                  // Update points in Firestore
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .update({'totalRewardPoints': newPoints});
                  
                  // Update the user role
                  if (FirebaseAuth.instance.currentUser != null) {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .update({'role': 'premium user'});
                     
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('You are now a Premium user!')),
                    );
                  } else {
                    print('No user is currently signed in.');
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Not enough points to redeem reward.')),
                  );
                }
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }
}

