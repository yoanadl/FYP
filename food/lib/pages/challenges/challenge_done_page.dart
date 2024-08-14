// // import 'package:flutter/material.dart';

// // class ChallengeDonePage extends StatelessWidget {
// //   final int points;

// //   ChallengeDonePage({required this.points});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       appBar: AppBar(
// //         backgroundColor: Colors.white,
// //         title: Text('Challenge Complete',
// //           style: TextStyle(
// //             fontSize: 22,
// //             fontWeight: FontWeight.w700,
// //           ),),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(35.0),
// //         child: Center(
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               Text(
// //                 'You completed the challenge!',
// //                 style: TextStyle(
// //                   fontSize: 20,
// //                   fontWeight: FontWeight.bold,
// //                 ),
// //               ),
// //               SizedBox(height: 20),
// //               Text(
// //                 'You gained $points points!',
// //                 style: TextStyle(
// //                   fontSize: 19,
// //                   fontWeight: FontWeight.w500,
// //                 ),
// //               ),
// //               SizedBox(height: 30),
// //               ElevatedButton(
// //                 onPressed: () {
// //                   // Here you can add the logic to update the user's points in Firestore
// //                   Navigator.pop(context);
// //                 },
// //                 style: ElevatedButton.styleFrom(
// //                       backgroundColor: Color(0xFF031927),
// //                       foregroundColor: Colors.white),
// //                 child: Text('Finish'),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }


// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';

// // class ChallengeDonePage extends StatelessWidget {
// //   final String challengeId; // Add challengeId
// //   final int points;
// //   final int roundsCompleted; // Add roundsCompleted

// //   ChallengeDonePage({
// //     required this.challengeId,
// //     required this.points,
// //     required this.roundsCompleted,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       appBar: AppBar(
// //         backgroundColor: Colors.white,
// //         title: Text(
// //           'Challenge Complete',
// //           style: TextStyle(
// //             fontSize: 22,
// //             fontWeight: FontWeight.w700,
// //           ),
// //         ),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(35.0),
// //         child: Center(
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               Text(
// //                 'You completed the challenge!',
// //                 style: TextStyle(
// //                   fontSize: 20,
// //                   fontWeight: FontWeight.bold,
// //                 ),
// //               ),
// //               SizedBox(height: 20),
// //               Text(
// //                 'You gained $points points!',
// //                 style: TextStyle(
// //                   fontSize: 19,
// //                   fontWeight: FontWeight.w500,
// //                 ),
// //               ),
// //               SizedBox(height: 30),
// //               ElevatedButton(
// //                 onPressed: () async {
// //                   String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

// //                   if (userId.isEmpty) {
// //                     ScaffoldMessenger.of(context).showSnackBar(
// //                       SnackBar(content: Text('User not authenticated')),
// //                     );
// //                     return;
// //                   }

// //                   try {
// //                     // Update the user's points
// //                     await FirebaseFirestore.instance.collection('users').doc(userId).update({
// //                       'totalPoints': FieldValue.increment(100), // Add 100 points
// //                       'challenges.$challengeId.roundsCompleted': roundsCompleted + 1, // Increment roundsCompleted
// //                     });

// //                     // Show success SnackBar
// //                     ScaffoldMessenger.of(context).showSnackBar(
// //                       SnackBar(content: Text('Points added and challenge updated')),
// //                     );

// //                     Navigator.pop(context);
// //                   } catch (e) {
// //                     // Handle error
// //                     ScaffoldMessenger.of(context).showSnackBar(
// //                       SnackBar(content: Text('Failed to update challenge')),
// //                     );
// //                   }
// //                 },
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: Color(0xFF031927),
// //                   foregroundColor: Colors.white,
// //                 ),
// //                 child: Text('Finish'),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }



// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ChallengeDonePage extends StatelessWidget {
//   final int points;
//   final String challengeId;

//   ChallengeDonePage({required this.points, required this.challengeId});

  

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Challenge Completed'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Congratulations!',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             Text(
//               'You have earned $points points!',
//               style: TextStyle(fontSize: 18),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 await _updateChallengeStats();
//                 Navigator.pop(context);
//               },
//               child: Text('Back to Challenges'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _updateChallengeStats() async {

//     // Get the current user ID from Firebase Authentication
//     User? currentUser = FirebaseAuth.instance.currentUser;

//     if (currentUser != null) {
//       final userId = currentUser.uid;
//     // Fetch the current user document
//     DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

//     if (userDoc.exists) {
//       final data = userDoc.data() as Map<String, dynamic>;
//       final challenges = List<Map<String, dynamic>>.from(data['challenges'] ?? []);

//       // Find the index of the challenge to update
//       final challengeIndex = challenges.indexWhere((challenge) => challenge['challengeId'] == challengeId);

//       if (challengeIndex != -1) {
//         final challenge = challenges[challengeIndex];
//         final currentPoints = challenge['totalPoints'] ?? 0;
//         final roundsCompleted = challenge['roundsCompleted'] ?? 0;

//         // Update challenge data
//         challenge['totalPoints'] = (currentPoints as int) + points;
//         challenge['roundsCompleted'] = roundsCompleted + 1;

//         // Replace the old challenge data with the updated challenge data
//         challenges[challengeIndex] = challenge;

//         // Update the user's document with the new challenges array
//         await FirebaseFirestore.instance.collection('users').doc(userId).update({
//           'challenges': challenges,
//         });
//       } else {
//         // If the challengeId is not found in the challenges array, add it
//         challenges.add({
//           'challengeId': challengeId,
//           'totalPoints': points,
//           'roundsCompleted': 1,
//         });

//         // Update the user's document with the new challenges array
//         await FirebaseFirestore.instance.collection('users').doc(userId).update({
//           'challenges': challenges,
//         });
//       }
//     } else {
//       print('User document not found');
//       }
//     }
//   }

// }


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChallengeDonePage extends StatelessWidget {
  final int points;
  final String challengeId;

  ChallengeDonePage({required this.points, required this.challengeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Challenge Completed'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Congratulations!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'You have earned $points points!',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _updateChallengeStats();
                Navigator.pop(context);
              },
              child: Text('Back to Challenges'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateChallengeStats() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      final userId = currentUser.uid;
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

      if (userDoc.exists) {
    
        final challengeDocRef = FirebaseFirestore.instance.collection('challenges').doc(challengeId);
        final challengeDoc = await challengeDocRef.get();

        if (challengeDoc.exists) {
          final participants = List<Map<String, dynamic>>.from(challengeDoc.data()?['participants'] ?? []);

          // Check if user already exists in participants
          final participantIndex = participants.indexWhere((participant) => participant['userId'] == userId);

          if (participantIndex != -1) {
            // Update the existing participant's data
            participants[participantIndex]['totalPoints'] = (participants[participantIndex]['totalPoints'] ?? 0) + points;
            participants[participantIndex]['roundsCompleted'] = (participants[participantIndex]['roundsCompleted'] ?? 0) + 1;
          } 
          else {
            print("No data found");
          }

          // Update the challenge document with the new participants array
          await challengeDocRef.update({'participants': participants});
        } else {
          print('Challenge document not found');
        }
      } else {
        print('User document not found');
      }
    } else {
      print('User not authenticated');
    }
  }
}

