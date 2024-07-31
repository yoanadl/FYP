// import 'package:flutter/material.dart';
// import 'package:food/components/navbar.dart';
// import 'package:food/pages/community_page.dart';
// import 'package:food/pages/profile_page.dart';
// import 'package:food/pages/workout/workout_page.dart';
// import 'package:food/services/health_service.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:food/services/SettingProfile_service.dart';
// import 'package:intl/intl.dart';

// class StepsAnalyticsPage extends StatefulWidget {
//   const StepsAnalyticsPage({super.key});

//   @override
//   _StepsAnalyticsPageState createState() => _StepsAnalyticsPageState();
// }

// class _StepsAnalyticsPageState extends State<StepsAnalyticsPage> {

//   final HealthService healthService = HealthService();
//   int steps = 0;
//   double weeklyAverageSteps = 0.0;
//   double monthlyAverageSteps = 0.0;
//   String selectedPeriod = 'Today';
//   String name = '';
//   String? profilePictureUrl;

//   @override
//   void initState() {
//     super.initState();
//     fetchUserProfile();
//     _fetchSteps();
//   }

//   Future<void> fetchUserProfile() async {
//     User? user = FirebaseAuth.instance.currentUser;

//     if (user != null) {
//       try {
//         Map<String, dynamic>? userData =
//             await SettingprofileService().fetchUserData(user.uid);

//         if (userData != null) {
//           setState(() {
//             name = userData['Name'] ?? 'No name';
//             profilePictureUrl = userData['profilePictureUrl'];
//           });
//         } else {
//           print('No user data found for uid: ${user.uid}');
//         }
//       } catch (e) {
//         print('Error fetching user data: $e');
//       }
//     } else {
//       print('No user is currently signed in.');
//     }
//   }

//   Future<void> _fetchSteps() async {
//     DateTime now = DateTime.now();
//     DateTime startDate;

//     switch (selectedPeriod) {
//       case 'Week':
//         startDate = now.subtract(Duration(days: now.weekday - 1));
//         break;
//       case 'Month':
//         startDate = DateTime(now.year, now.month, 1);
//         break;
//       case 'Today':
//       default:
//         startDate = DateTime(now.year, now.month, now.day);
//         break;
//     }

//     try {
//       int? fetchedSteps = await healthService.getSteps(startDate, now);
//       double weeklyAverage = await healthService.getWeeklyAverageSteps();
//       double monthlyAverage = await healthService.getMonthlyAverageSteps();

//       setState(() {
//         steps = fetchedSteps ?? 0;
//         weeklyAverageSteps = weeklyAverage;
//         monthlyAverageSteps = monthlyAverage;
//       });
//     } catch (e) {
//       print('Error fetching steps: $e');
//     }
//   }

//   Widget _buildProfileImage() {
//     return CircleAvatar(
//       radius: 24,
//       backgroundImage: profilePictureUrl != null
//         ? CachedNetworkImageProvider(profilePictureUrl!)
//         : AssetImage('assets/default_profile_picture.png') as ImageProvider, // Placeholder image
//     );
//   }

//   Widget loadProfilePicture(BuildContext context, String uid) {
//     final settingProfileService = SettingprofileService();

//     return FutureBuilder<String?>(
//       future: settingProfileService.fetchProfilePictureUrl(uid),
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           String? url = snapshot.data;
//           return CircleAvatar(
//             radius: 30, 
//             backgroundImage: CachedNetworkImageProvider(url!),
//           );
//         } else if (snapshot.hasError) {
//           print('Error fetching profile picture URL: ${snapshot.error}');
//           return CircularProgressIndicator(); // Show a loading indicator
//         }
//         return CircleAvatar(
//           radius: 30, 
//           child: Icon(Icons.person),
//         ); // Placeholder
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     String formattedDate = DateFormat('EEEE d MMMM').format(DateTime.now());
//     User? user = FirebaseAuth.instance.currentUser;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(80.0),
//         child: AppBar(
//           automaticallyImplyLeading: false,
//           backgroundColor: Colors.white, 
//           centerTitle: false,
//           actions : [
//             // notification icon
//             Padding(
//               padding: const EdgeInsets.all(3.0),
//               child: Container(
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.grey[300],
//                 ),
//                 child: IconButton(
//                   onPressed: () {}, 
//                   icon: Icon(Icons.notifications),
//                   iconSize: 25,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
            
//             //profile icon
//             if (user != null)
//               Padding(
//                 padding: const EdgeInsets.all(4.0),
//                 child: loadProfilePicture(context, user.uid),
//               )
//           ],
//           iconTheme: IconThemeData(color: Colors.white),
//           title: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(left: 17.0),
//                 child: Text(
//                   'Hello, $name!',
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 17.0),
//                 child: Text(
//                   formattedDate,
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'My Statistics',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 _buildPeriodButton('Today'),
//                 SizedBox(width: 8),
//                 _buildPeriodButton('Week'),
//                 SizedBox(width: 8),
//                 _buildPeriodButton('Month'),
//               ],
//             ),
//             SizedBox(height: 16),
//             Text(
//               'Total Steps: $steps',
//               style: TextStyle(
//                 fontSize: 20,
//               ),
//             ),
//             SizedBox(height: 16),
//             if (selectedPeriod == 'Week' || selectedPeriod == 'Month') 
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Weekly Average Steps: ${weeklyAverageSteps.toStringAsFixed(0)}',
//                     style: TextStyle(
//                       fontSize: 18,
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     'Monthly Average Steps: ${monthlyAverageSteps.toStringAsFixed(0)}',
//                     style: TextStyle(
//                       fontSize: 18,
//                     ),
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: Navbar(
//         currentIndex: 0,
//         onTap: (int index) {
//           if (index != 3) {
//             Navigator.pop(context);
//             switch (index) {
//               case 1:
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => const WorkoutPage()));
//                 break;
//               case 2:
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => const CommunityPage()));
//                 break;
//               case 3:
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
//                 break;
//             }
//           }
//         },
//       ),
//     );
//   }

//   Widget _buildPeriodButton(String period) {
//     return ElevatedButton(
//       onPressed: () {
//         setState(() {
//           selectedPeriod = period;
//           _fetchSteps();
//         });
//       },
//       child: Text(period),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: selectedPeriod == period ? Colors.blue : Colors.grey,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:food/components/navbar.dart';
import 'package:food/pages/base_page.dart';
import 'package:food/pages/community_page.dart';
import 'package:food/pages/profile_page.dart';
import 'package:food/pages/workout/workout_page.dart';
import 'package:food/services/health_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:food/services/SettingProfile_service.dart';
import 'package:intl/intl.dart';

class StepsAnalyticsPage extends StatefulWidget {
  const StepsAnalyticsPage({super.key});

  @override
  _StepsAnalyticsPageState createState() => _StepsAnalyticsPageState();
}

class _StepsAnalyticsPageState extends State<StepsAnalyticsPage> {
  final HealthService healthService = HealthService();
  int steps = 0;
  double weeklyAverageSteps = 0.0;
  double monthlyAverageSteps = 0.0;
  String selectedPeriod = 'Today';
  String name = '';
  String? profilePictureUrl;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
    _fetchSteps();
  }

  Future<void> fetchUserProfile() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        Map<String, dynamic>? userData =
            await SettingprofileService().fetchUserData(user.uid);

        if (userData != null) {
          setState(() {
            name = userData['Name'] ?? 'No name';
            profilePictureUrl = userData['profilePictureUrl'];
          });
        } else {
          print('No user data found for uid: ${user.uid}');
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    } else {
      print('No user is currently signed in.');
    }
  }

  Future<void> _fetchSteps() async {
    DateTime now = DateTime.now();
    DateTime startDate;

    switch (selectedPeriod) {
      case 'Week':
        startDate = now.subtract(Duration(days: now.weekday - 1));
        break;
      case 'Month':
        startDate = DateTime(now.year, now.month, 1);
        break;
      case 'Today':
      default:
        startDate = DateTime(now.year, now.month, now.day);
        break;
    }

    try {
      int? fetchedSteps = await healthService.getSteps(startDate, now);
      double weeklyAverage = await healthService.getWeeklyAverageSteps();
      double monthlyAverage = await healthService.getMonthlyAverageSteps();

      setState(() {
        steps = fetchedSteps ?? 0;
        weeklyAverageSteps = weeklyAverage;
        monthlyAverageSteps = monthlyAverage;
      });
    } catch (e) {
      print('Error fetching steps: $e');
    }
  }

  Widget _buildProfileImage() {
    return CircleAvatar(
      radius: 24,
      backgroundImage: profilePictureUrl != null
        ? CachedNetworkImageProvider(profilePictureUrl!)
        : AssetImage('assets/default_profile_picture.png') as ImageProvider, // Placeholder image
    );
  }

  Widget loadProfilePicture(BuildContext context, String uid) {
    final settingProfileService = SettingprofileService();

    return FutureBuilder<String?>(
      future: settingProfileService.fetchProfilePictureUrl(uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String? url = snapshot.data;
          return CircleAvatar(
            radius: 30, 
            backgroundImage: CachedNetworkImageProvider(url!),
          );
        } else if (snapshot.hasError) {
          print('Error fetching profile picture URL: ${snapshot.error}');
          return CircularProgressIndicator(); // Show a loading indicator
        }
        return CircleAvatar(
          radius: 30, 
          child: Icon(Icons.person),
        ); // Placeholder
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('EEEE d MMMM').format(DateTime.now());
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white, 
          centerTitle: false,
          actions: [
            // Notification icon
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[300],
                ),
                child: IconButton(
                  onPressed: () {}, 
                  icon: Icon(Icons.notifications),
                  iconSize: 25,
                  color: Colors.black,
                ),
              ),
            ),
            
      
            //profile icon
            if (user != null)
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => BasePage(initialIndex: 3),
                      ),
                    );
                  },
                child: loadProfilePicture(context, user.uid),
              ),
            ),
          ],
          iconTheme: IconThemeData(color: Colors.white),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 17.0),
                child: Text(
                  'Hello, $name!',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 17.0),
                child: Text(
                  formattedDate,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Statistics',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildPeriodButton('Today'),
                SizedBox(width: 8),
                _buildPeriodButton('Week'),
                SizedBox(width: 8),
                _buildPeriodButton('Month'),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Total Steps: $steps',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(height: 16),
            if (selectedPeriod == 'Week') 
              Text(
                'Weekly Average Steps: ${weeklyAverageSteps.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            if (selectedPeriod == 'Month') 
              Text(
                'Monthly Average Steps: ${monthlyAverageSteps.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Navbar(
        currentIndex: 0,
        onTap: (int index) {
          if (index != 3) {
            Navigator.pop(context);
            switch (index) {
              case 1:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const WorkoutPage()));
                break;
              case 2:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CommunityPage()));
                break;
              case 3:
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
                break;
            }
          }
        },
      ),
    );
  }

  Widget _buildPeriodButton(String period) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedPeriod = period;
          _fetchSteps();
        });
      },
      child: Text(period),
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedPeriod == period ? Colors.blue : Colors.grey,
      ),
    );
  }
}
