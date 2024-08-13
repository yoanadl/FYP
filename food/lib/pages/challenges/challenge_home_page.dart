// import 'package:flutter/material.dart';
// import 'package:food/pages/challenges/create_new_challenge_page.dart';
// import 'package:food/pages/challenges/my_challenge_page.dart';
// import 'package:food/pages/challenges/reward_page.dart';
// import 'package:food/pages/challenges/view_all_challenge_view.dart';
// import 'package:food/services/challenge_service.dart';


// class ChallengeHomePage extends StatefulWidget {
//   @override
//   _ChallengeHomePageState createState() => _ChallengeHomePageState();
// }

// class _ChallengeHomePageState extends State<ChallengeHomePage> {
//   PageController _pageController = PageController(
//     viewportFraction: 0.3, // Adjust the viewportFraction for width
//     initialPage: 1, // Center the initial page
//   );

//   Future<List<Map<String, dynamic>>>? _challengesFuture;

//   @override 
//   void initState() {
//     super.initState();
//     _challengesFuture = ChallengeService().getAllChallenges(); // fetch challenges
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF031927),
//       appBar: AppBar(
//         backgroundColor: Color(0xFF031927),
//         automaticallyImplyLeading: false,
//         centerTitle: true,
//         title: Text(
//           'Challenges',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 30,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(context, MaterialPageRoute(
//                           builder: (context) => MyChallengePage(),
//                         ));
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Color(0xFFC8E0F4),
//                         foregroundColor: Colors.black,
//                       ),
//                       child: Text('My Challenges'),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(context, MaterialPageRoute(
//                           builder: (context) => RewardPage(),
//                         ));
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Color(0xFFC8E0F4),
//                         foregroundColor: Colors.black,
//                       ),
//                       child: Text('My Rewards'),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             height: 565,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(30.0),
//                 topRight: Radius.circular(30.0),
//               )
//             ),
//             padding: EdgeInsets.symmetric(vertical: 16, horizontal: 15),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 SizedBox(height: 10),
//                 Text(
//                   'Join Challenges',
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   'Discover new challenges and \n join to compete with others!',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey[900],
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 20),
//                 FutureBuilder<List<Map<String, dynamic>>>(
//                   future: _challengesFuture,
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return Center(child: CircularProgressIndicator());
//                     } else if (snapshot.hasError) {
//                       return Center(child: Text('Error loading challenges'));
//                     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                       return Center(child: Text('No challenges available'));
//                     } else {
//                       final challenges = snapshot.data!;
//                       return Container(
//                         height: 90,
//                         child: Stack(
//                           children: [
//                             PageView.builder(
//                               controller: _pageController,
//                               itemCount: challenges.length,
//                               itemBuilder: (context, index) {
//                                 final challenge = challenges[index];
//                                 return Container(
//                                   margin: EdgeInsets.symmetric(horizontal: 8.0),
//                                   decoration: BoxDecoration(
//                                     color: Color(0xFFC8E0F4),
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   child: Center(
//                                     child: Text(
//                                       challenge['title'] ?? 'Challenge ${index + 1}',
//                                       style: TextStyle(
//                                         color: Colors.grey[800],
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                             Positioned(
//                               left: 0,
//                               top: 0,
//                               bottom: 0,
//                               child: IconButton(
//                                 icon: Icon(Icons.arrow_back_ios),
//                                 onPressed: () {
//                                   _pageController.previousPage(
//                                     duration: Duration(milliseconds: 300),
//                                     curve: Curves.easeInOut,
//                                   );
//                                 },
//                               ),
//                             ),
//                             Positioned(
//                               right: 0,
//                               top: 0,
//                               bottom: 0,
//                               child: IconButton(
//                                 icon: Icon(Icons.arrow_forward_ios),
//                                 onPressed: () {
//                                   _pageController.nextPage(
//                                     duration: Duration(milliseconds: 300),
//                                     curve: Curves.easeInOut,
//                                   );
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }
//                   },
//                 ),
//                 SizedBox(height: 20,),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 3.0),
//                   child: Center(
//                     child: SizedBox(
//                       width: 100,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(context, MaterialPageRoute(
//                             builder: (context) => ViewAllChallenges(),
//                           ));
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Color(0xFFC8E0F4),
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(9),
//                           ),
//                         ),
//                         child: Text(
//                           'See More',
//                           style: TextStyle(
//                             fontSize: 11,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.grey[900]
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 35),
//                 Text(
//                   'Or \n Create your own challenges',
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   'Set your own goals and \n challenge others to beat them!',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey[900],
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 30),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Center(
//                     child: SizedBox(
//                       width: 190, // Adjust this value to make the button smaller
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(context, MaterialPageRoute(
//                             builder: (context) => CreateNewChallengePage(),
//                           ));
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Color(0xFF031927), // Background color
//                           foregroundColor: Colors.white, // Text color
//                         ),
//                         child: Text(
//                           'Create Challenge',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:food/pages/challenges/challenge_viewer_view_page.dart';
// import 'package:food/pages/challenges/create_new_challenge_page.dart';
// import 'package:food/pages/challenges/my_challenge_page.dart';
// import 'package:food/pages/challenges/reward_page.dart';
// import 'package:food/pages/challenges/view_all_challenge_view.dart';
// import 'package:food/services/challenge_service.dart';
// import 'package:food/pages/challenges/challenge_owner_view_page.dart'; 

// class ChallengeHomePage extends StatefulWidget {
//   @override
//   _ChallengeHomePageState createState() => _ChallengeHomePageState();
// }

// class _ChallengeHomePageState extends State<ChallengeHomePage> {
//   PageController _pageController = PageController(
//     viewportFraction: 0.3,
//     initialPage: 1,
//   );

//   Future<List<Map<String, dynamic>>>? _challengesFuture;
//   String? _currentUserId; // Current user ID for ownership check

//   @override
//   void initState() {
//     super.initState();
//     _challengesFuture = ChallengeService().getAllChallenges();
//     _getCurrentUserId();
//   }

//   Future<void> _getCurrentUserId() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       setState(() {
//         _currentUserId = user.uid;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF031927),
//       appBar: AppBar(
//         backgroundColor: Color(0xFF031927),
//         automaticallyImplyLeading: false,
//         centerTitle: true,
//         title: Text(
//           'Challenges',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 30,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(context, MaterialPageRoute(
//                           builder: (context) => MyChallengePage(),
//                         ));
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Color(0xFFC8E0F4),
//                         foregroundColor: Colors.black,
//                       ),
//                       child: Text('My Challenges'),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(context, MaterialPageRoute(
//                           builder: (context) => RewardPage(),
//                         ));
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Color(0xFFC8E0F4),
//                         foregroundColor: Colors.black,
//                       ),
//                       child: Text('My Rewards'),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             height: 565,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(30.0),
//                 topRight: Radius.circular(30.0),
//               ),
//             ),
//             padding: EdgeInsets.symmetric(vertical: 16, horizontal: 15),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 SizedBox(height: 10),
//                 Text(
//                   'Join Challenges',
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   'Discover new challenges and \n join to compete with others!',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey[900],
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 20),
//                 FutureBuilder<List<Map<String, dynamic>>>(
//                   future: _challengesFuture,
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return Center(child: CircularProgressIndicator());
//                     } else if (snapshot.hasError) {
//                       return Center(child: Text('Error loading challenges'));
//                     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                       return Center(child: Text('No challenges available'));
//                     } else {
//                       final challenges = snapshot.data!;
//                       return Container(
//                         height: 90,
//                         child: Stack(
//                           children: [
//                             PageView.builder(
//                               controller: _pageController,
//                               itemCount: challenges.length,
//                               itemBuilder: (context, index) {
//                                 final challenge = challenges[index];
//                                 return InkWell(
//                                   onTap: () async {
//                                     // Navigate to the correct page based on ownership
//                                     final isOwner = challenge['creatorUid'] == _currentUserId;
//                                     Navigator.push(context, MaterialPageRoute(
//                                       builder: (context) => isOwner
//                                           ? ChallengeOwnerViewPage(challengeId: challenge['id'])
//                                           : ChallengeViewerViewPage(challengeId: challenge['id']),
//                                     ));
//                                   },
//                                   child: Container(
//                                     margin: EdgeInsets.symmetric(horizontal: 8.0),
//                                     decoration: BoxDecoration(
//                                       color: Color(0xFFC8E0F4),
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     child: Center(
//                                       child: Text(
//                                         challenge['title'] ?? 'Challenge ${index + 1}',
//                                         style: TextStyle(
//                                           color: Colors.grey[800],
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         textAlign: TextAlign.center,
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                             Positioned(
//                               left: 0,
//                               top: 0,
//                               bottom: 0,
//                               child: IconButton(
//                                 icon: Icon(Icons.arrow_back_ios),
//                                 onPressed: () {
//                                   _pageController.previousPage(
//                                     duration: Duration(milliseconds: 300),
//                                     curve: Curves.easeInOut,
//                                   );
//                                 },
//                               ),
//                             ),
//                             Positioned(
//                               right: 0,
//                               top: 0,
//                               bottom: 0,
//                               child: IconButton(
//                                 icon: Icon(Icons.arrow_forward_ios),
//                                 onPressed: () {
//                                   _pageController.nextPage(
//                                     duration: Duration(milliseconds: 300),
//                                     curve: Curves.easeInOut,
//                                   );
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }
//                   },
//                 ),
//                 SizedBox(height: 20,),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 3.0),
//                   child: Center(
//                     child: SizedBox(
//                       width: 100,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(context, MaterialPageRoute(
//                             builder: (context) => ViewAllChallenges(),
//                           ));
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Color(0xFFC8E0F4),
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(9),
//                           ),
//                         ),
//                         child: Text(
//                           'See More',
//                           style: TextStyle(
//                             fontSize: 11,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.grey[900]
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 35),
//                 Text(
//                   'Or \n Create your own challenges',
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   'Set your own goals and \n challenge others to beat them!',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey[900],
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 30),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Center(
//                     child: SizedBox(
//                       width: 190,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(context, MaterialPageRoute(
//                             builder: (context) => CreateNewChallengePage(),
//                           ));
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Color(0xFF031927),
//                           foregroundColor: Colors.white,
//                         ),
//                         child: Text(
//                           'Create Challenge',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:food/pages/challenges/challenge_viewer_view_page.dart';
// import 'package:food/pages/challenges/create_new_challenge_page.dart';
// import 'package:food/pages/challenges/my_challenge_page.dart';
// import 'package:food/pages/challenges/reward_page.dart';
// import 'package:food/pages/challenges/view_all_challenge_view.dart';
// import 'package:food/services/challenge_service.dart';
// import 'package:food/pages/challenges/challenge_owner_view_page.dart'; 

// class ChallengeHomePage extends StatefulWidget {
//   @override
//   _ChallengeHomePageState createState() => _ChallengeHomePageState();
// }

// class _ChallengeHomePageState extends State<ChallengeHomePage> {
//   PageController _pageController = PageController(
//     viewportFraction: 0.3,
//     initialPage: 1,
//   );

//   Future<List<Map<String, dynamic>>>? _challengesFuture;
//   String? _currentUserId; // Current user ID for ownership check

//   @override
//   void initState() {
//     super.initState();
//     _challengesFuture = ChallengeService().getAllChallenges();
//     _getCurrentUserId();
//   }

//   Future<void> _getCurrentUserId() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       setState(() {
//         _currentUserId = user.uid;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF031927),
//       appBar: AppBar(
//         backgroundColor: Color(0xFF031927),
//         automaticallyImplyLeading: false,
//         centerTitle: true,
//         title: Text(
//           'Challenges',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 30,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(context, MaterialPageRoute(
//                           builder: (context) => MyChallengePage(),
//                         ));
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Color(0xFFC8E0F4),
//                         foregroundColor: Colors.black,
//                       ),
//                       child: Text('My Challenges'),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(context, MaterialPageRoute(
//                           builder: (context) => RewardPage(),
//                         ));
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Color(0xFFC8E0F4),
//                         foregroundColor: Colors.black,
//                       ),
//                       child: Text('My Rewards'),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             height: 565,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(30.0),
//                 topRight: Radius.circular(30.0),
//               ),
//             ),
//             padding: EdgeInsets.symmetric(vertical: 16, horizontal: 15),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 SizedBox(height: 10),
//                 Text(
//                   'Join Challenges',
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   'Discover new challenges and \n join to compete with others!',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey[900],
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 20),
//                 FutureBuilder<List<Map<String, dynamic>>>(
//                   future: _challengesFuture,
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return Center(child: CircularProgressIndicator());
//                     } else if (snapshot.hasError) {
//                       return Center(child: Text('Error loading challenges'));
//                     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                       return Center(child: Text('No challenges available'));
//                     } else {
//                       final challenges = snapshot.data!;
//                       return Container(
//                         height: 90,
//                         child: Stack(
//                           children: [
//                             PageView.builder(
//                               controller: _pageController,
//                               itemCount: challenges.length,
//                               itemBuilder: (context, index) {
//                                 final challenge = challenges[index];
//                                 final challengeId = challenge['id'] ?? '';
//                                 final creatorUid = challenge['creatorUid'] ?? '';
//                                 final challengeTitle = challenge['title'] ?? 'Challenge ${index + 1}';
//                                 final isOwner = creatorUid == _currentUserId;

//                                 return InkWell(
//                                   onTap: () async {
//                                     // Check if the challenge ID is valid
//                                     final challengeId = challenge['id'];
//                                     if (challengeId == null || challengeId.isEmpty) {
//                                       // Handle error or show message
//                                       print('Challenge ID is null or empty');
//                                       return;
//                                     }
//                                     Navigator.push(context, MaterialPageRoute(
//                                       builder: (context) => isOwner
//                                           ? ChallengeOwnerViewPage(challengeId: challengeId)
//                                           : ChallengeViewerViewPage(challengeId: challengeId),
//                                     ));
//                                   },
//                                   child: Container(
//                                     margin: EdgeInsets.symmetric(horizontal: 8.0),
//                                     decoration: BoxDecoration(
//                                       color: Color(0xFFC8E0F4),
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     child: Center(
//                                       child: Text(
//                                         challengeTitle,
//                                         style: TextStyle(
//                                           color: Colors.grey[800],
//                                           fontSize: 12,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         textAlign: TextAlign.center,
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                             Positioned(
//                               left: 0,
//                               top: 0,
//                               bottom: 0,
//                               child: IconButton(
//                                 icon: Icon(Icons.arrow_back_ios),
//                                 onPressed: () {
//                                   _pageController.previousPage(
//                                     duration: Duration(milliseconds: 300),
//                                     curve: Curves.easeInOut,
//                                   );
//                                 },
//                               ),
//                             ),
//                             Positioned(
//                               right: 0,
//                               top: 0,
//                               bottom: 0,
//                               child: IconButton(
//                                 icon: Icon(Icons.arrow_forward_ios),
//                                 onPressed: () {
//                                   _pageController.nextPage(
//                                     duration: Duration(milliseconds: 300),
//                                     curve: Curves.easeInOut,
//                                   );
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }
//                   },
//                 ),
//                 SizedBox(height: 20,),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 3.0),
//                   child: Center(
//                     child: SizedBox(
//                       width: 100,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(context, MaterialPageRoute(
//                             builder: (context) => ViewAllChallenges(),
//                           ));
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Color(0xFFC8E0F4),
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(9),
//                           ),
//                         ),
//                         child: Text(
//                           'See More',
//                           style: TextStyle(
//                             fontSize: 11,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.grey[900]
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 35),
//                 Text(
//                   'Or \n Create your own challenges',
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   'Set your own goals and \n challenge others to beat them!',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey[900],
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 30),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Center(
//                     child: SizedBox(
//                       width: 190,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(context, MaterialPageRoute(
//                             builder: (context) => CreateNewChallengePage(),
//                           ));
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Color(0xFF031927),
//                           foregroundColor: Colors.white,
//                         ),
//                         child: Text(
//                           'Create Challenge',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food/pages/challenges/challenge_viewer_view_page.dart';
import 'package:food/pages/challenges/create_new_challenge_page.dart';
import 'package:food/pages/challenges/my_challenge_page.dart';
import 'package:food/pages/challenges/reward_page.dart';
import 'package:food/pages/challenges/view_all_challenge_view.dart';
import 'package:food/services/challenge_service.dart';
import 'package:food/pages/challenges/challenge_owner_view_page.dart'; 

class ChallengeHomePage extends StatefulWidget {
  @override
  _ChallengeHomePageState createState() => _ChallengeHomePageState();
}

class _ChallengeHomePageState extends State<ChallengeHomePage> {
  PageController _pageController = PageController(
    viewportFraction: 0.3,
    initialPage: 1,
  );

  Future<List<Map<String, dynamic>>>? _challengesFuture;
  String? _currentUserId; // Current user ID for ownership check

  @override
  void initState() {
    super.initState();
    _challengesFuture = ChallengeService().getAllChallenges();
    _getCurrentUserId();
  }

  Future<void> _getCurrentUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _currentUserId = user.uid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF031927),
      appBar: AppBar(
        backgroundColor: Color(0xFF031927),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Challenges',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => MyChallengePage(),
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFC8E0F4),
                        foregroundColor: Colors.black,
                      ),
                      child: Text('My Challenges'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => RewardPage(),
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFC8E0F4),
                        foregroundColor: Colors.black,
                      ),
                      child: Text('My Rewards'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 565,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 10),
                Text(
                  'Join Challenges',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'Discover new challenges and \n join to compete with others!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[900],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _challengesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error loading challenges'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No challenges available'));
                    } else {
                      final challenges = snapshot.data!;
                      return Container(
                        height: 90,
                        child: Stack(
                          children: [
                            PageView.builder(
                              controller: _pageController,
                              itemCount: challenges.length,
                              itemBuilder: (context, index) {
                                final challenge = challenges[index];
                                final challengeId = challenge['id'] ?? '';
                                final creatorUid = challenge['creatorUid'] ?? '';
                                final challengeTitle = challenge['title'] ?? 'Challenge ${index + 1}';
                                final isOwner = creatorUid == _currentUserId;

                                return InkWell(
                                  onTap: () {
                                    // Handle null or empty challengeId
                                    if (challengeId.isEmpty) {
                                      print('Challenge ID is null or empty');
                                      return;
                                    }
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => isOwner
                                          ? ChallengeOwnerViewPage(challengeId: challengeId)
                                          : ChallengeViewerViewPage(challengeId: challengeId),
                                    ));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFC8E0F4),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        challengeTitle,
                                        style: TextStyle(
                                          color: Colors.grey[800],
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            Positioned(
                              left: 0,
                              top: 0,
                              bottom: 0,
                              child: IconButton(
                                icon: Icon(Icons.arrow_back_ios),
                                onPressed: () {
                                  _pageController.previousPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              bottom: 0,
                              child: IconButton(
                                icon: Icon(Icons.arrow_forward_ios),
                                onPressed: () {
                                  _pageController.nextPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3.0),
                  child: Center(
                    child: SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => ViewAllChallenges(),
                          ));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFC8E0F4),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9),
                          ),
                        ),
                        child: Text(
                          'See More',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[900]
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 35),
                Text(
                  'Or \n Create your own challenges',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'Set your own goals and \n challenge others to beat them!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[900],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Center(
                    child: SizedBox(
                      width: 190,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => CreateNewChallengePage(),
                          ));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF031927),
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          'Create Challenge',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
