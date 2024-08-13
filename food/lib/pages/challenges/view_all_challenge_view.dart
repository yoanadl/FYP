// import 'package:flutter/material.dart';
// import 'package:food/services/challenge_service.dart';

// class ViewAllChallenges extends StatefulWidget {
//   @override
//   _ViewAllChallengesState createState() => _ViewAllChallengesState();
// }

// class _ViewAllChallengesState extends State<ViewAllChallenges> {
//   Future<List<Map<String, dynamic>>>? _challengesFuture;

//   @override
//   void initState() {
//     super.initState();
//     _challengesFuture = ChallengeService().getAllChallenges(); // Fetch challenges
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Join Challenges',
//           style: TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0, // Optional: Remove the shadow under the AppBar
//       ),
//       body: Container(
//         color: Colors.white,
//         padding: const EdgeInsets.only(left: 35.0, right: 35.0, top: 15, bottom: 35.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text(
//               'Discover new challenges and \n join to compete with others!',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey[900],
//               ),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 20),
//             TextField(
//               decoration: InputDecoration(
//                 hintText: 'Search Challenges',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.search),
//               ),
//             ),
//             SizedBox(height: 20),
//             Expanded(
//               child: FutureBuilder<List<Map<String, dynamic>>>(
//                 future: _challengesFuture,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(child: CircularProgressIndicator());
//                   } else if (snapshot.hasError) {
//                     return Center(child: Text('Error loading challenges'));
//                   } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                     return Center(child: Text('No challenges available'));
//                   } else {
//                     final challenges = snapshot.data!;
//                     return GridView.builder(
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2,
//                         crossAxisSpacing: 16,
//                         mainAxisSpacing: 16,
//                       ),
//                       itemCount: challenges.length,
//                       itemBuilder: (context, index) {
//                         final challenge = challenges[index];
//                         return Container(
//                           decoration: BoxDecoration(
//                             color: Color(0xFFC8E0F4),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Center(
//                             child: Text(
//                               challenge['title'] ?? 'Challenge ${index + 1}',
//                               style: TextStyle(
//                                 color: Colors.grey[800],
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
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
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:food/services/challenge_service.dart';

class ViewAllChallenges extends StatefulWidget {
  @override
  _ViewAllChallengesState createState() => _ViewAllChallengesState();
}

class _ViewAllChallengesState extends State<ViewAllChallenges> {
  Future<List<Map<String, dynamic>>>? _challengesFuture;
  List<Map<String, dynamic>> _allChallenges = [];
  List<Map<String, dynamic>> _filteredChallenges = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _challengesFuture = ChallengeService().getAllChallenges();
    _fetchChallenges();
  }

  Future<void> _fetchChallenges() async {
    try {
      final challenges = await ChallengeService().getAllChallenges();
      setState(() {
        _allChallenges = challenges;
        _filteredChallenges = challenges;
      });
    } catch (e) {
      // Handle error
      print('Error fetching challenges: $e');
    }
  }

  void _filterChallenges(String query) {
    setState(() {
      _searchQuery = query;
      _filteredChallenges = _allChallenges.where((challenge) {
        final title = challenge['title']?.toLowerCase() ?? '';
        final searchLower = query.toLowerCase();
        return title.contains(searchLower);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Join Challenges',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0, // Optional: Remove the shadow under the AppBar
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(left: 35.0, right: 35.0, top: 15, bottom: 35.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Discover new challenges and \n join to compete with others!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[900],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              onChanged: _filterChallenges,
              decoration: InputDecoration(
                hintText: 'Search Challenges',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _allChallenges.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: _filteredChallenges.length,
                      itemBuilder: (context, index) {
                        final challenge = _filteredChallenges[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFC8E0F4),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              challenge['title'] ?? 'Challenge ${index + 1}',
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
