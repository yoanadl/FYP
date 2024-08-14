import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food/components/base_page.dart';
import 'package:food/components/navbar.dart';
import 'package:food/services/challenge_service.dart';

class ChallengeViewerViewPage extends StatelessWidget {
  final String challengeId;

  ChallengeViewerViewPage({required this.challengeId});

  @override
  Widget build(BuildContext context) {
    final ChallengeService challengeService = ChallengeService();
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
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Text('Challenge Details');
            }
            var challengeData = snapshot.data!.data() as Map<String, dynamic>;
            return Text(
              challengeData['title'] ?? 'No title',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            );
          },
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('challenges').doc(challengeId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Challenge not found'));
          }

          var challengeData = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: EdgeInsets.all(35.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder<String?>(
                  future: challengeService.fetchCreatorName(challengeId),
                  builder: (context, creatorSnapshot) {
                    if (creatorSnapshot.connectionState == ConnectionState.waiting) {
                      return Text('Loading creator name...');
                    }
                    if (!creatorSnapshot.hasData || creatorSnapshot.data == null) {
                      return Text('Created by: Unknown');
                    }
                    return Text(
                      'Created by: ${creatorSnapshot.data}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[900]),
                    );
                  },
                ),
                SizedBox(height: 25),
                Text(
                  challengeData['description'] ?? 'No description',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 25),
                Text(
                  'Rewards: 100 pts per round',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  'Duration: ${challengeData['duration'] ?? 'Not specified'}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  'Activities:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: (challengeData['activities'] as List<dynamic>?)?.length ?? 0,
                    itemBuilder: (context, index) {
                      var activity = (challengeData['activities'] as List<dynamic>)[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                activity['name'] ?? 'No activity name',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              flex: 1,
                              child: Text(
                                '${activity['duration'] ?? 'Not specified'} ',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: 16,),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      

                     String userId = FirebaseAuth.instance.currentUser?.uid ?? '';


                      try {
                        // Update the user's challenges in Firestore
                        FirebaseFirestore.instance.collection('users').doc(userId).update({
                          'challenges': FieldValue.arrayUnion([
                            {
                              'challengeId': challengeId,
                              'type': 'joined'
                            }
                          ])
                        });

                        // Show success SnackBar
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Challenge added')),
                        );

                    } catch (e) {

                      // Handle error
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to join the challenge')),
                        );
                      }
                    },
                    child: Text('Join Challenge')
                  ),
                )
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
}
