// import 'package:flutter/material.dart';
// import 'package:food/pages/challenges/my_challenge_page.dart';
// import 'package:food/pages/challenges/reward_page.dart';

// class ChallengeHomePage extends StatelessWidget {
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
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(context, MaterialPageRoute(
//                       builder: (context) => MyChallengePage()
//                       )
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xFFC8E0F4),
//                     foregroundColor: Colors.black,
//                   ),
//                   child: Text('My Challenges'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(context, MaterialPageRoute(
//                       builder: (context) => RewardPage()
//                       )
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xFFC8E0F4),
//                     foregroundColor: Colors.black,
//                   ),
//                   child: Text('My Rewards'),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             color: Colors.white, 
//             height: 565,
//             padding: EdgeInsets.symmetric(vertical: 16, horizontal: 15),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 SizedBox(height: 10,),
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
//                     fontSize: 14, color: Colors.grey[900]),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 20),
//                 Container(
//                   height: 80,
//                   width: 60,
//                   child: PageView.builder(
//                     itemCount: 5, // Number of challenges to show in slideshow
//                     itemBuilder: (context, index) {
//                       return Container(
//                         margin: EdgeInsets.symmetric(horizontal: 8.0),
//                         decoration: BoxDecoration(
//                           color: Colors.blueGrey,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Center(
//                           child: Text(
//                             'Challenge ${index + 1}',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 SizedBox(height: 40),
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
//                   style: TextStyle(fontSize: 14, color: Colors.grey[900]),
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
//                           // TODO: Navigate to Create Challenge page
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Color(0xFF031927), // Background color
//                           foregroundColor: Colors.white, // Text color
//                         ),
//                         child: Text(
//                           'Create Challenge',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600),
//                           ),
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


// import 'package:flutter/material.dart';
// import 'package:food/pages/challenges/my_challenge_page.dart';
// import 'package:food/pages/challenges/reward_page.dart';

// class ChallengeHomePage extends StatefulWidget {
//   @override
//   _ChallengeHomePageState createState() => _ChallengeHomePageState();
// }

// class _ChallengeHomePageState extends State<ChallengeHomePage> {
//   PageController _pageController = PageController(viewportFraction: 0.3); // Adjust the viewportFraction for width

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
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(context, MaterialPageRoute(
//                       builder: (context) => MyChallengePage(),
//                     ));
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xFFC8E0F4),
//                     foregroundColor: Colors.black,
//                   ),
//                   child: Text('My Challenges'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.push(context, MaterialPageRoute(
//                       builder: (context) => RewardPage(),
//                     ));
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xFFC8E0F4),
//                     foregroundColor: Colors.black,
//                   ),
//                   child: Text('My Rewards'),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             color: Colors.white,
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
//                 Container(
//                   height: 100,
//                   width: 80,
//                   child: Stack(
//                     children: [
//                       PageView.builder(
//                         controller: _pageController,
//                         itemCount: 5, // Number of challenges
//                         itemBuilder: (context, index) {
//                           return Container(
//                             margin: EdgeInsets.symmetric(horizontal: 8.0),
//                             decoration: BoxDecoration(
//                               color: Colors.blueGrey,
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Center(
//                               child: Text(
//                                 'Challenge ${index + 1}',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                       Positioned(
//                         left: 0,
//                         top: 0,
//                         bottom: 0,
//                         child: IconButton(
//                           icon: Icon(Icons.arrow_back_ios),
//                           onPressed: () {
//                             _pageController.previousPage(
//                               duration: Duration(milliseconds: 300),
//                               curve: Curves.easeInOut,
//                             );
//                           },
//                         ),
//                       ),
//                       Positioned(
//                         right: 0,
//                         top: 0,
//                         bottom: 0,
//                         child: IconButton(
//                           icon: Icon(Icons.arrow_forward_ios),
//                           onPressed: () {
//                             _pageController.nextPage(
//                               duration: Duration(milliseconds: 300),
//                               curve: Curves.easeInOut,
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 40),
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
//                           // TODO: Navigate to Create Challenge page
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

import 'package:flutter/material.dart';
import 'package:food/pages/challenges/create_new_challenge_page.dart';
import 'package:food/pages/challenges/my_challenge_page.dart';
import 'package:food/pages/challenges/reward_page.dart';

class ChallengeHomePage extends StatefulWidget {
  @override
  _ChallengeHomePageState createState() => _ChallengeHomePageState();
}

class _ChallengeHomePageState extends State<ChallengeHomePage> {
  PageController _pageController = PageController(
    viewportFraction: 0.3, // Adjust the viewportFraction for width
    initialPage: 1, // Center the initial page
  );

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
            child: Row(
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
          ),
          Container(
            height: 565,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              )
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
                Container(
                  height: 90,
                  child: Stack(
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        itemCount: 5, // Number of challenges
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 8.0),
                            decoration: BoxDecoration(
                              color: Color(0xFFC8E0F4),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                'Challenge ${index + 1}',
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
                ),
                SizedBox(height: 55),
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
                      width: 190, // Adjust this value to make the button smaller
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => CreateNewChallengePage(),
                          ));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF031927), // Background color
                          foregroundColor: Colors.white, // Text color
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

