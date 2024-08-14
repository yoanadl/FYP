// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:food/pages/challenges/challenge_owner_view_page.dart';
// import 'package:food/pages/challenges/challenge_viewer_view_joined_page.dart'; // Updated import
// import 'package:food/services/challenge_service.dart';

// class MyChallengePage extends StatefulWidget {
//   @override
//   _MyChallengePageState createState() => _MyChallengePageState();
// }

// class _MyChallengePageState extends State<MyChallengePage> {
//   bool isOngoing = true;
//   String sortOption = 'All'; // Default filter option
//   late String currentUserId;
//   ChallengeService challengeService = ChallengeService();
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
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           'My Challenges',
//           style: TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//         elevation: 0,
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
//             icon: Icon(Icons.filter_list, color: Colors.black),
//             onSelected: (String result) {
//               setState(() {
//                 sortOption = result;
//               });
//             },
//             itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
//               PopupMenuItem<String>(
//                 value: 'All',
//                 child: Row(
//                   children: [
//                     Text('All'),
//                     if (sortOption == 'All')
//                       Icon(Icons.check, color: Colors.blue),
//                   ],
//                 ),
//               ),
//               PopupMenuItem<String>(
//                 value: 'own',
//                 child: Row(
//                   children: [
//                     Text('Own'),
//                     if (sortOption == 'own')
//                       Icon(Icons.check, color: Colors.blue),
//                   ],
//                 ),
//               ),
//               PopupMenuItem<String>(
//                 value: 'joined',
//                 child: Row(
//                   children: [
//                     Text('Joined'),
//                     if (sortOption == 'joined')
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
//     return StreamBuilder<DocumentSnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('users')
//           .doc(currentUserId)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }
//         if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }

//         final userDoc = snapshot.data;
//         if (userDoc == null || !userDoc.exists) {
//           return Center(child: Text('User not found.'));
//         }

//         final challenges = userDoc['challenges'] as List<dynamic>? ?? [];
//         if (challenges.isEmpty) {
//           return Center(child: Text('No challenges found.'));
//         }

//         return FutureBuilder<List<Map<String, dynamic>>>(
//           future: _fetchChallengeDetailsFromService(challenges),
//           builder: (context, futureSnapshot) {
//             if (futureSnapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             }
//             if (futureSnapshot.hasError) {
//               return Center(child: Text('Error: ${futureSnapshot.error}'));
//             }

//             final challengeDetails = futureSnapshot.data ?? [];
//             if (challengeDetails.isEmpty) {
//               return Center(child: Text('No challenges found.'));
//             }

//             final filteredChallenges = _filterChallenges(challengeDetails);

//             return ListView.separated(
//               padding: EdgeInsets.all(16),
//               itemCount: filteredChallenges.length,
//               separatorBuilder: (context, index) => SizedBox(height: 16),
//               itemBuilder: (context, index) {
//                 final challenge = filteredChallenges[index];
//                 return _buildChallengeCard(challenge);
//               },
//             );
//           },
//         );
//       },
//     );
//   }

//   Future<List<Map<String, dynamic>>> _fetchChallengeDetailsFromService(List<dynamic> challenges) async {
//     List<Map<String, dynamic>> challengeDetails = [];

//     for (var challenge in challenges) {
//       final challengeId = challenge['challengeId'] as String;
//       final type = challenge['type'] as String;

//       Map<String, dynamic>? details = await challengeService.getChallengeDetails(challengeId);

//       if (details != null) {
//         challengeDetails.add({
//           'challengeId': challengeId,
//           'title': details['title'] ?? 'Challenge Title',
//           'type': type,
//         });
//       }
//     }

//     return challengeDetails;
//   }

//   List<Map<String, dynamic>> _filterChallenges(List<Map<String, dynamic>> challenges) {
//     if (sortOption == 'All') {
//       return challenges;
//     } else {
//       return challenges.where((challenge) => challenge['type'] == sortOption).toList();
//     }
//   }

//   Widget _buildChallengeCard(Map<String, dynamic> challenge) {
//     final challengeId = challenge['challengeId'] ?? '';
//     final title = challenge['title'] ?? 'Challenge Title';
//     final type = challenge['type'] ?? 'own'; // 'own' or 'joined'

//     return GestureDetector(
//       onTap: () {
//         if (challengeId.isNotEmpty) {
//           final route = type == 'own'
//               ? ChallengeOwnerViewPage(challengeId: challengeId)
//               : ChallengeViewerViewJoinedPage(challengeId: challengeId); // Updated route
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => route),
//           );
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Challenge ID is missing.')),
//           );
//         }
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.grey[200],
//           borderRadius: BorderRadius.circular(10),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.2),
//               spreadRadius: 2,
//               blurRadius: 5,
//               offset: Offset(0, 3),
//             ),
//           ],
//         ),
//         padding: EdgeInsets.all(16),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: Text(
//                 title,
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                 ),
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//             SizedBox(width: 8),
//             Text(
//               type == 'own' ? 'Own ' : 'Joined ',
//               style: TextStyle(
//                 color: type == 'own' ? Colors.blue : Colors.green,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
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
import 'package:food/pages/challenges/challenge_viewer_view_joined_page.dart'; 
import 'package:food/services/challenge_service.dart';


class MyChallengePage extends StatefulWidget {
  @override
  _MyChallengePageState createState() => _MyChallengePageState();
}

class _MyChallengePageState extends State<MyChallengePage> {
  bool isOngoing = true;
  String sortOption = 'All'; // Default filter option
  late String currentUserId;
  ChallengeService challengeService = ChallengeService();
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    currentUserId = FirebaseAuth.instance.currentUser!.uid;
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      searchQuery = searchController.text.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My Challenges',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        elevation: 0,
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
              controller: searchController,
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
            icon: Icon(Icons.filter_list, color: Colors.black),
            onSelected: (String result) {
              setState(() {
                sortOption = result;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'All',
                child: Row(
                  children: [
                    Text('All'),
                    if (sortOption == 'All')
                      Icon(Icons.check, color: Colors.blue),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'own',
                child: Row(
                  children: [
                    Text('Own'),
                    if (sortOption == 'own')
                      Icon(Icons.check, color: Colors.blue),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'joined',
                child: Row(
                  children: [
                    Text('Joined'),
                    if (sortOption == 'joined')
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
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final userDoc = snapshot.data;
        if (userDoc == null || !userDoc.exists) {
          return Center(child: Text('User not found.'));
        }

        final challenges = userDoc['challenges'] as List<dynamic>? ?? [];
        if (challenges.isEmpty) {
          return Center(child: Text('No challenges found.'));
        }

        return FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchChallengeDetailsFromService(challenges),
          builder: (context, futureSnapshot) {
            if (futureSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (futureSnapshot.hasError) {
              return Center(child: Text('Error: ${futureSnapshot.error}'));
            }

            final challengeDetails = futureSnapshot.data ?? [];
            if (challengeDetails.isEmpty) {
              return Center(child: Text('No challenges found.'));
            }

            final filteredChallenges = _filterChallenges(challengeDetails);

            return ListView.separated(
              padding: EdgeInsets.all(16),
              itemCount: filteredChallenges.length,
              separatorBuilder: (context, index) => SizedBox(height: 16),
              itemBuilder: (context, index) {
                final challenge = filteredChallenges[index];
                return _buildChallengeCard(challenge);
              },
            );
          },
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> _fetchChallengeDetailsFromService(List<dynamic> challenges) async {
    List<Map<String, dynamic>> challengeDetails = [];

    for (var challenge in challenges) {
      final challengeId = challenge['challengeId'] as String;
      final type = challenge['type'] as String;

      Map<String, dynamic>? details = await challengeService.getChallengeDetails(challengeId);

      if (details != null) {
        challengeDetails.add({
          'challengeId': challengeId,
          'title': details['title'] ?? 'Challenge Title',
          'type': type,
        });
      }
    }

    return challengeDetails;
  }

  List<Map<String, dynamic>> _filterChallenges(List<Map<String, dynamic>> challenges) {
    List<Map<String, dynamic>> filteredChallenges = challenges;

    if (sortOption != 'All') {
      filteredChallenges =
          filteredChallenges.where((challenge) => challenge['type'] == sortOption).toList();
    }

    if (searchQuery.isNotEmpty) {
      filteredChallenges = filteredChallenges.where((challenge) {
        final title = challenge['title'].toString().toLowerCase();
        return title.contains(searchQuery);
      }).toList();
    }

    return filteredChallenges;
  }

  Widget _buildChallengeCard(Map<String, dynamic> challenge) {
    final challengeId = challenge['challengeId'] ?? '';
    final title = challenge['title'] ?? 'Challenge Title';
    final type = challenge['type'] ?? 'own'; // 'own' or 'joined'

    return GestureDetector(
      onTap: () {
        if (challengeId.isNotEmpty) {
          final route = type == 'own'
              ? ChallengeOwnerViewPage(challengeId: challengeId)
              : ChallengeViewerViewJoinedPage(challengeId: challengeId); // Updated route
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => route),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Challenge ID is missing.')),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 8),
            Text(
              type == 'own' ? 'Own ' : 'Joined ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: type == 'own' ? Colors.blue : Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

