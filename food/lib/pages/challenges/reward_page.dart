import 'package:flutter/cupertino.dart';
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
              SizedBox(height: 30),
              Text('Premium Subscription',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
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
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
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

                   // Update the state to reflect the new points immediately
                  setState(() {
                    _totalRewardPoints = newPoints;
                  });
                  
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

