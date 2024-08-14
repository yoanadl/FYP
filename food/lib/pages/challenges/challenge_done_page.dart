
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Challenge Completed',
          style: TextStyle(
            fontWeight: FontWeight.w700
          ),),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF031927),
              ),
              child: Text(
                'Back to Challenges',
                style: TextStyle(
                  color: Colors.white
                ),),
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

