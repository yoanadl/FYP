// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:food/components/base_page.dart';
// import 'package:food/components/navbar.dart';

// class LeaderboardPage extends StatelessWidget {
//   final String challengeId;

//   LeaderboardPage({required this.challengeId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           'Leaderboard',
//           style: TextStyle(
//             fontSize: 23,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.emoji_events),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Text(
//               'Challenge Title',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
//             ),
//             SizedBox(height: 16),
//             Expanded(
//               child: FutureBuilder<List<Map<String, dynamic>>>(
//                 future: _fetchLeaderboard(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(child: CircularProgressIndicator());
//                   } else if (snapshot.hasError) {
//                     print('Error: ${snapshot.error}');
//                     return Center(child: Text('Error loading leaderboard'));
//                   } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                     print('No data available or empty leaderboard');
//                     return Center(child: Text('No data available'));
//                   } else {
//                     final leaderboard = snapshot.data!;
//                     print('Leaderboard loaded successfully: $leaderboard');
//                     return ListView.builder(
//                       itemCount: leaderboard.length,
//                       itemBuilder: (context, index) {
//                         final entry = leaderboard[index];
//                         return Card(
//                           child: ListTile(
//                             title: Text(entry['displayName'] ?? 'No username'),
//                             trailing: Text('Points: ${entry['totalPoints']}'),
//                           ),
//                         );
//                       },
//                     );
//                   }
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: Navbar(
//         currentIndex: 2,
//         onTap: (int index) {
//           if (index != 2) {
//             Navigator.pop(context);
//             switch (index) {
//               case 0:
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => const BasePage(initialIndex: 0)));
//                 break;
//               case 1:
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => const BasePage(initialIndex: 1)));
//                 break;
//               case 3:
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => const BasePage(initialIndex: 3)));
//                 break;
//             }
//           }
//         },
//       ),
//     );
//   }

//   Future<List<Map<String, dynamic>>> _fetchLeaderboard() async {
//     final leaderboard = <Map<String, dynamic>>[];

//     try {
//       // Fetch the challenge document to get the participants array
//       final challengeDoc = await FirebaseFirestore.instance
//           .collection('challenges')
//           .doc(challengeId)
//           .get();

//       if (!challengeDoc.exists) {
//         print('Challenge document does not exist');
//         return leaderboard;
//       }

//       print('Challenge document: ${challengeDoc.data()}');

//       final participants = List<Map<String, dynamic>>.from(challengeDoc.data()?['participants'] ?? []);
//       print('Participants: $participants');

//       // Build the leaderboard using the displayName from the participants array
//       for (var participant in participants) {
//         final displayName = participant['displayName'] ?? 'Anonymous';
//         final totalPoints = participant['totalPoints'] ?? 0;

//         leaderboard.add({
//           'displayName': displayName,
//           'totalPoints': totalPoints,
//         });
//       }

//       // Sort the leaderboard by totalPoints (descending)
//       leaderboard.sort((a, b) {
//         return b['totalPoints'] - a['totalPoints'];
//       });

//       print('Sorted leaderboard: $leaderboard');
//     } catch (e) {
//       print('Error fetching leaderboard: $e');
//     }

//     return leaderboard;
//   }

// }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food/components/base_page.dart';
import 'package:food/components/navbar.dart';

class LeaderboardPage extends StatelessWidget {
  final String challengeId;

  LeaderboardPage({required this.challengeId});

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
        title: Text(
          'Leaderboard',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.emoji_events),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            FutureBuilder<String>(
              future: _fetchChallengeTitle(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  print('Error: ${snapshot.error}');
                  return Center(child: Text('Error loading challenge title'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  print('No challenge title available');
                  return Center(child: Text('No challenge title available'));
                } else {
                  final challengeTitle = snapshot.data!;
                  return Text(
                    challengeTitle,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  );
                }
              },
            ),
            SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _fetchLeaderboard(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    print('Error: ${snapshot.error}');
                    return Center(child: Text('Error loading leaderboard'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    print('No data available or empty leaderboard');
                    return Center(child: Text('No data available'));
                  } else {
                    final leaderboard = snapshot.data!;
                    print('Leaderboard loaded successfully: $leaderboard');
                    return ListView.builder(
                      itemCount: leaderboard.length,
                      itemBuilder: (context, index) {
                        final entry = leaderboard[index];
                        return Card(
                          child: ListTile(
                            title: Text(entry['displayName'] ?? 'No username'),
                            trailing: Text('Points: ${entry['totalPoints']}'),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
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

  Future<String> _fetchChallengeTitle() async {
    try {
      final challengeDoc = await FirebaseFirestore.instance
          .collection('challenges')
          .doc(challengeId)
          .get();

      if (challengeDoc.exists) {
        final challengeData = challengeDoc.data();
        return challengeData?['title'] ?? 'No Title'; // Assuming 'title' is the field for challenge title
      } else {
        print('Challenge document does not exist');
        return 'No Title';
      }
    } catch (e) {
      print('Error fetching challenge title: $e');
      return 'No Title';
    }
  }

  Future<List<Map<String, dynamic>>> _fetchLeaderboard() async {
    final leaderboard = <Map<String, dynamic>>[];

    try {
      // Fetch the challenge document to get the participants array
      final challengeDoc = await FirebaseFirestore.instance
          .collection('challenges')
          .doc(challengeId)
          .get();

      if (!challengeDoc.exists) {
        print('Challenge document does not exist');
        return leaderboard;
      }

      print('Challenge document: ${challengeDoc.data()}');

      final participants = List<Map<String, dynamic>>.from(challengeDoc.data()?['participants'] ?? []);
      print('Participants: $participants');

      // Build the leaderboard using the displayName from the participants array
      for (var participant in participants) {
        final displayName = participant['displayName'] ?? 'Anonymous';
        final totalPoints = participant['totalPoints'] ?? 0;

        leaderboard.add({
          'displayName': displayName,
          'totalPoints': totalPoints,
        });
      }

      // Sort the leaderboard by totalPoints (descending)
      leaderboard.sort((a, b) {
        return b['totalPoints'] - a['totalPoints'];
      });

      print('Sorted leaderboard: $leaderboard');
    } catch (e) {
      print('Error fetching leaderboard: $e');
    }

    return leaderboard;
  }
}
