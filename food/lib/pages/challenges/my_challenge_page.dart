// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class MyChallengePage extends StatefulWidget {
//   @override
//   _MyChallengePageState createState() => _MyChallengePageState();
// }

// class _MyChallengePageState extends State<MyChallengePage> {
//   bool isOngoing = true;
//   String sortOption = 'own challenges';
//   late String currentUserId;
  
//   @override
//   void initState() {
//     super.initState();
//     currentUserId = FirebaseAuth.instance.currentUser!.uid;  
//   }

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
//           'My Challenges',
//           style: TextStyle(
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           _buildTabs(),
//           _buildSearchAndSort(),
//           Expanded(
//             child: _buildChallengeList(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTabs() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Row(
//         children: [
//           Expanded(
//             child: ElevatedButton(
//               child: Text(
//                 'Ongoing',
//                 style: TextStyle(color: isOngoing ? Colors.white : Colors.black),
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: isOngoing ? Colors.black : Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//               ),
//               onPressed: () => setState(() => isOngoing = true),
//             ),
//           ),
//           SizedBox(width: 16),
//           Expanded(
//             child: ElevatedButton(
//               child: Text(
//                 'Completed',
//                 style: TextStyle(color: !isOngoing ? Colors.white : Colors.black),
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: !isOngoing ? Colors.black : Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//               ),
//               onPressed: () => setState(() => isOngoing = false),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchAndSort() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               decoration: InputDecoration(
//                 hintText: 'Search',
//                 prefixIcon: Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(width: 8),
//           PopupMenuButton<String>(
//             icon: Icon(Icons.sort),
//             onSelected: (String result) {
//               setState(() {
//                 sortOption = result;
//               });
//             },
//             itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
//               PopupMenuItem<String>(
//                 value: 'own challenges',
//                 child: Row(
//                   children: [
//                     Text('Own Challenges'),
//                     if (sortOption == 'own challenges')
//                       Icon(Icons.check, color: Colors.blue),
//                   ],
//                 ),
//               ),
//               PopupMenuItem<String>(
//                 value: 'others',
//                 child: Row(
//                   children: [
//                     Text('Others'),
//                     if (sortOption == 'others')
//                       Icon(Icons.check, color: Colors.blue),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildChallengeList() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('challenges')
//           .where('creatorUid', isEqualTo: currentUserId)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }
//         if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }

//         final challenges = snapshot.data?.docs ?? [];
//         if (challenges.isEmpty) {
//           return Center(child: Text('No challenges found.'));
//         }

//         return ListView.separated(
//           padding: EdgeInsets.all(16),
//           itemCount: challenges.length,
//           separatorBuilder: (context, index) => SizedBox(height: 16),
//           itemBuilder: (context, index) {
//             final challengeData = challenges[index].data() as Map<String, dynamic>;
//             return _buildChallengeCard(challengeData);
//           },
//         );
//       },
//     );
//   }

//   Widget _buildChallengeCard(Map<String, dynamic> challengeData) {
//     return GestureDetector(
//       onTap: () {
//         // TODO: Implement navigation to challenge details
//         print('Clicked on challenge: ${challengeData['title']}');
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.grey[200],
//           borderRadius: BorderRadius.circular(10),
//         ),
//         padding: EdgeInsets.all(16),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               challengeData['title'] ?? 'Challenge Title',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//               ),
//             ),
//             Text(
//               'Own Challenge',
//               style: TextStyle(
//                 color: Colors.grey[600],
//                 fontSize: 14,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food/pages/challenges/challenge_owner_view_page.dart';
import 'package:food/pages/challenges/challenge_viewer_view_page.dart';

class MyChallengePage extends StatefulWidget {
  @override
  _MyChallengePageState createState() => _MyChallengePageState();
}

class _MyChallengePageState extends State<MyChallengePage> {
  bool isOngoing = true;
  String sortOption = 'own challenges';
  late String currentUserId;
  
  @override
  void initState() {
    super.initState();
    currentUserId = FirebaseAuth.instance.currentUser!.uid;  
  }

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
          'My Challenges',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildTabs(),
          _buildSearchAndSort(),
          Expanded(
            child: _buildChallengeList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              child: Text(
                'Ongoing',
                style: TextStyle(color: isOngoing ? Colors.white : Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isOngoing ? Colors.black : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () => setState(() => isOngoing = true),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              child: Text(
                'Completed',
                style: TextStyle(color: !isOngoing ? Colors.white : Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: !isOngoing ? Colors.black : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () => setState(() => isOngoing = false),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndSort() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          PopupMenuButton<String>(
            icon: Icon(Icons.sort),
            onSelected: (String result) {
              setState(() {
                sortOption = result;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'own challenges',
                child: Row(
                  children: [
                    Text('Own Challenges'),
                    if (sortOption == 'own challenges')
                      Icon(Icons.check, color: Colors.blue),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'others',
                child: Row(
                  children: [
                    Text('Others'),
                    if (sortOption == 'others')
                      Icon(Icons.check, color: Colors.blue),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('challenges')
          .where('creatorUid', isEqualTo: currentUserId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final challenges = snapshot.data?.docs ?? [];
        if (challenges.isEmpty) {
          return Center(child: Text('No challenges found.'));
        }

        return ListView.separated(
          padding: EdgeInsets.all(16),
          itemCount: challenges.length,
          separatorBuilder: (context, index) => SizedBox(height: 16),
          itemBuilder: (context, index) {
            final challengeData = challenges[index].data() as Map<String, dynamic>;
            return _buildChallengeCard(challenges[index].id, challengeData);
          },
        );
      },
    );
  }

  Widget _buildChallengeCard(String challengeId, Map<String, dynamic> challengeData) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChallengeOwnerViewPage(challengeId: challengeId),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              challengeData['title'] ?? 'Challenge Title',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              'Own Challenge',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
