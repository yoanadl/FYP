import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food/components/base_page.dart';
import 'package:food/components/navbar.dart';
import 'package:food/pages/challenges/challenge_activity_page.dart';
import 'package:food/pages/challenges/challenge_results.dart';
import 'package:food/pages/challenges/leaderboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:food/services/challenge_service.dart';

class ChallengeViewerViewJoinedPage extends StatelessWidget {
  final String challengeId;

  ChallengeViewerViewJoinedPage({required this.challengeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('challenges').doc(challengeId).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading...');
            }
            if (snapshot.hasError) {
              return Text('Error');
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Text('No Title');
            }

            final challengeData = snapshot.data!.data() as Map<String, dynamic>;
            final title = challengeData['title'] ?? 'No Title';

            return Text(title, style: TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.bold
            ));
          },
        ),
        actions: [
          FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('challenges').doc(challengeId).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Icon(Icons.error);
              }
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return Icon(Icons.error);
              }

              final challengeData = snapshot.data!.data() as Map<String, dynamic>;
              final endDate = (challengeData['endDate'] as Timestamp).toDate();
              // final now = DateTime.now();
              final now = DateTime(2024, 8, 20);

              return IconButton(
                icon: Icon(Icons.emoji_events),
                onPressed: () {
                  if (now.isAfter(endDate)) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChallengeResultsPage(challengeId: challengeId)),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LeaderboardPage(challengeId: challengeId)),
                    );
                  }
                },
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              bool? shouldQuit = await showCupertinoDialog<bool>(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: Text('Confirm Quit'),
                    content: Text('Are you sure you want to quit this challenge?'),
                    actions: [
                      CupertinoDialogAction(
                        child: Text('Cancel'),
                        onPressed: () => Navigator.pop(context, false),
                      ),
                      CupertinoDialogAction(
                        child: Text('Quit'),
                        onPressed: () => Navigator.pop(context, true),
                      ),
                    ],
                  );
                },
              );

              if (shouldQuit == true) {
                String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
                final challengeService = ChallengeService();

                try {
                  // Call quitChallenge from ChallengeService
                  await challengeService.quitChallenge(challengeId, userId);

                  // Show success SnackBar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('You have quit the challenge')),
                  );

                  // Navigate back to previous screen or refresh the current page
                  Navigator.pop(context);
                } catch (e) {
                  // Handle error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to quit the challenge')),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('challenges').doc(challengeId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Challenge not found.'));
          }

          final challengeData = snapshot.data!.data() as Map<String, dynamic>;
          final creator = challengeData['creatorName'] ?? 'Unknown Creator';
          final description = challengeData['description'] ?? 'No Description';
          final duration = challengeData['duration'] ?? 'Unknown Duration';
          final activities = challengeData['activities'] as List<dynamic>? ?? [];
          final startDate = (challengeData['startDate'] as Timestamp).toDate();
          final endDate = (challengeData['endDate'] as Timestamp).toDate();

          return Padding(
            padding: EdgeInsets.all(35.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Created by: $creator', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                Text(description),
                SizedBox(height: 16),
                Text('Rewards: 100 pts'),
                SizedBox(height: 16),
                Text('Duration: $duration'),
                SizedBox(height: 16),
                Text('Start Date: ${startDate.toLocal().toString().split(' ')[0]}'),
                SizedBox(height: 8),
                Text('End Date: ${endDate.toLocal().toString().split(' ')[0]}'),
                SizedBox(height: 16),
                Text('Activities', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                _buildActivityList(activities),
                
                SizedBox(height: 20,),
                Center(
                  child: ElevatedButton(
                    child: Text(
                      'Start Challenge',
                      style: TextStyle(
                        fontSize: 18
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF031927),
                      foregroundColor: Colors.white),
                    // onPressed: () => Navigator.push(
                    //   context, 
                    //   MaterialPageRoute(
                    //     builder: (context) => ChallengeActivityPage(challengeId: challengeId),
                    //   ),
                    // )
                    onPressed: endDate.isBefore(DateTime.now()) 
                    ? null // Disable the button if the challenge has ended
                    : () => Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => ChallengeActivityPage(challengeId: challengeId),
                        ),
                      ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Navbar(
        currentIndex: 2,
        onTap: (int index) {
          if (index != 2) {
            Navigator.pop(context);
            switch (index) {
              case 0:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const BasePage(initialIndex: 0)));
                break;
              case 1:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const BasePage(initialIndex: 1)));
                break;
              case 3:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const BasePage(initialIndex: 3)));
                break;
            }
          }
        },
      ),
    );
  }

  Widget _buildActivityList(List<dynamic> activities) {
    return Column(
      children: activities.map((activity) {
        final activityName = activity['name'] ?? 'Unknown Activity';
        final duration = activity['duration'] ?? 'Unknown Duration';
        return _buildActivityItem(activityName, duration);
      }).toList(),
    );
  }

  Widget _buildActivityItem(String name, String duration) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name),
          Text(duration),
        ],
      ),
    );
  }
}
