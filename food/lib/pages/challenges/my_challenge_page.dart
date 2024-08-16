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
                      Icon(Icons.check, color:  Color(0xFF031927)),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'own',
                child: Row(
                  children: [
                    Text('Own'),
                    if (sortOption == 'own')
                      Icon(Icons.check, color:  Color(0xFF031927)),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'joined',
                child: Row(
                  children: [
                    Text('Joined'),
                    if (sortOption == 'joined')
                      Icon(Icons.check, color:  Color(0xFF031927)),
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

        final userData = userDoc.data() as Map<String, dynamic>?;

        if (userData == null || !userData.containsKey('challenges') || userData['challenges'] == null) {
          return Center(child: Text('No challenges created/joined.'));
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

            final ongoingChallenges = filteredChallenges
                .where((challenge) {
                  final endDate = challenge['endDate'];
                  if (endDate is Timestamp) {
                    final endDateTime = endDate.toDate();
                    return endDateTime.isAfter(DateTime.now());
                  }
                  return endDate == null; // No end date means ongoing
                })
                .toList();
            final completedChallenges = filteredChallenges
                .where((challenge) {
                  final endDate = challenge['endDate'];
                  if (endDate is Timestamp) {
                    final endDateTime = endDate.toDate();
                    return endDateTime.isBefore(DateTime.now());
                  }
                  return false; // No end date means ongoing
                })
                .toList();

            final displayChallenges = isOngoing ? ongoingChallenges : completedChallenges;

            return ListView.separated(
              padding: EdgeInsets.all(16),
              itemCount: displayChallenges.length,
              separatorBuilder: (context, index) => SizedBox(height: 16),
              itemBuilder: (context, index) {
                final challenge = displayChallenges[index];
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
          'endDate': details['endDate'], // Ensure endDate is handled correctly
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
    final challengeId = challenge['challengeId'] as String;
    final title = challenge['title'] as String;
    final type = challenge['type'] as String;

    return GestureDetector(
      onTap: () {
        if (challengeId.isNotEmpty) {
          final route = type == 'own'
              ? ChallengeOwnerViewPage(challengeId: challengeId)
              : ChallengeViewerViewJoinedPage(challengeId: challengeId);

          Navigator.push(context, MaterialPageRoute(builder: (context) => route));
        }
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (type == 'own')
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color:  Color(0xFF031927),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Own',
                style: TextStyle(color: Colors.white),
              ),
            ),
            if (type == 'joined')
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFF031927),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Joined',
                  style: TextStyle(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
