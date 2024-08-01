// import 'package:flutter/material.dart';
// import 'package:food/components/navbar.dart';
// import 'package:food/pages/base_page.dart';
// import 'package:food/pages/community_page.dart';
// import 'package:food/pages/profile_page.dart';
// import 'package:food/pages/workout/workout_page.dart';
// import 'package:food/services/health_service.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:food/services/SettingProfile_service.dart';
// import 'package:intl/intl.dart';
// import 'package:fl_chart/fl_chart.dart';

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
//   List<int> weeklySteps = List.filled(7, 0);

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
//           actions: [
//             // Notification icon
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
//                 child: GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context, 
//                       MaterialPageRoute(
//                         builder: (context) => BasePage(initialIndex: 3),
//                       ),
//                     );
//                   },
//                 child: loadProfilePicture(context, user.uid),
//               ),
//             ),
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
//         padding: const EdgeInsets.all(40.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'My Statistics',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 _buildPeriodButton('Today'),
//                 SizedBox(width: 20),
//                 _buildPeriodButton('Week'),
//                 SizedBox(width: 20),
//                 _buildPeriodButton('Month'),
//               ],
//             ),
//             SizedBox(height: 16),
//             Text(
//               'Total Steps: $steps',
//               style: TextStyle(
//                 fontSize: 16,
//               ),
//             ),
//             SizedBox(height: 20),
//             _buildStepsChart(),
//             if (selectedPeriod == 'Week') 
//               Text(
//                 'Weekly Average Steps: ${weeklyAverageSteps.toStringAsFixed(0)}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//               ),
//             if (selectedPeriod == 'Month') 
//               Text(
//                 'Monthly Average Steps: ${monthlyAverageSteps.toStringAsFixed(0)}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
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
//         backgroundColor: selectedPeriod == period ? Color(0xFF031927) : Colors.grey.shade200,
//         foregroundColor: selectedPeriod == period ? Colors.white : Colors.black,
//       ),
//     );
//   }

// Widget _buildStepsChart() {
//   if (steps > 0) {
//     return Container(
//       height: 200, // Adjust height as needed
//       child: LineChart(
//         LineChartData(
//           lineBarsData: [
//             LineChartBarData(
//               spots: [
//                 FlSpot(0, steps.toDouble()), // Starting point
//                 // Add more data points for better visualization
//               ],
//               isCurved: true,
//               color: Colors.blue,
//               dotData: FlDotData(show: true), // Show dots for visibility
//               belowBarData: BarAreaData(show: false),
//             ),
//           ],
//           titlesData: FlTitlesData(show: true), // Show titles for reference
//           borderData: FlBorderData(show: true), // Show borders for clarity
//           lineTouchData: LineTouchData(enabled: false),
//         ),
//       ),
//     );
//   } else {
//     return Text('No steps data available');
//   }
// }

// }

// import 'package:flutter/material.dart';
// import 'package:food/components/navbar.dart';
// import 'package:food/pages/base_page.dart';
// import 'package:food/pages/community_page.dart';
// import 'package:food/pages/profile_page.dart';
// import 'package:food/pages/workout/workout_page.dart';
// import 'package:food/services/health_service.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:food/services/SettingProfile_service.dart';
// import 'package:intl/intl.dart';
// import 'package:fl_chart/fl_chart.dart';

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
//   List<int> weeklySteps = List.filled(7, 0);

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
//       if (selectedPeriod == 'Week') {
//         List<int> stepsList = [];
//         for (int i = 0; i < 7; i++) {
//           DateTime day = startDate.add(Duration(days: i));
//           int? daySteps = await healthService.getSteps(day, day);
//           stepsList.add(daySteps ?? 0);
//         }
//         double weeklyAverage = await healthService.getWeeklyAverageSteps();
//         double monthlyAverage = await healthService.getMonthlyAverageSteps();

//         setState(() {
//           weeklySteps = stepsList;
//           weeklyAverageSteps = weeklyAverage;
//           monthlyAverageSteps = monthlyAverage;
//         });
//       } else {
//         int? fetchedSteps = await healthService.getSteps(startDate, now);
//         double weeklyAverage = await healthService.getWeeklyAverageSteps();
//         double monthlyAverage = await healthService.getMonthlyAverageSteps();

//         setState(() {
//           steps = fetchedSteps ?? 0;
//           weeklyAverageSteps = weeklyAverage;
//           monthlyAverageSteps = monthlyAverage;
//         });
//       }
//     } catch (e) {
//       print('Error fetching steps: $e');
//     }
//   }

//   Widget _buildProfileImage() {
//     return CircleAvatar(
//       radius: 24,
//       backgroundImage: profilePictureUrl != null
//           ? CachedNetworkImageProvider(profilePictureUrl!)
//           : AssetImage('assets/default_profile_picture.png') as ImageProvider, // Placeholder image
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
//           actions: [
//             // Notification icon
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
//                 child: GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => BasePage(initialIndex: 3),
//                       ),
//                     );
//                   },
//                   child: loadProfilePicture(context, user.uid),
//                 ),
//               ),
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
//         padding: const EdgeInsets.all(40.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'My Statistics',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 _buildPeriodButton('Today'),
//                 SizedBox(width: 20),
//                 _buildPeriodButton('Week'),
//                 SizedBox(width: 20),
//                 _buildPeriodButton('Month'),
//               ],
//             ),
//             SizedBox(height: 16),
//             Text(
//               'Total Steps: $steps',
//               style: TextStyle(
//                 fontSize: 16,
//               ),
//             ),
//             SizedBox(height: 16),
//             if (selectedPeriod == 'Today') _buildStepsChart(),
//             if (selectedPeriod == 'Week')
//               Column(
//                 children: [
//                   Text(
//                     'Weekly Average Steps: ${weeklyAverageSteps.toStringAsFixed(0)}',
//                     style: TextStyle(
//                       fontSize: 16,
//                     ),
//                   ),
//                   _buildStepsChart(),
//                 ],
//               ),
//             if (selectedPeriod == 'Month')
//               Text(
//                 'Monthly Average Steps: ${monthlyAverageSteps.toStringAsFixed(0)}',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
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
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const WorkoutPage()));
//                 break;
//               case 2:
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const CommunityPage()));
//                 break;
//               case 3:
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => ProfilePage()));
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
//           _fetchSteps(); // Fetch the steps data for the selected period
//         });
//       },
//       style: ElevatedButton.styleFrom(
//         backgroundColor: selectedPeriod == period ? Colors.blue : Colors.grey,
//       ),
//       child: Text(period),
//     );
//   }

//   Widget _buildStepsChart() {
//     List<FlSpot> spots = [];

//     if (selectedPeriod == 'Week') {
//       for (int i = 0; i < weeklySteps.length; i++) {
//         spots.add(FlSpot(i.toDouble(), weeklySteps[i].toDouble()));
//       }
//     } else {
//       spots.add(FlSpot(0, steps.toDouble()));
//     }

//     return Container(
//       height: 200,
//       child: LineChart(
//         LineChartData(
//           borderData: FlBorderData(show: false),
//           lineBarsData: [
//             LineChartBarData(
//               spots: spots,
//               isCurved: true,
//               color:Colors.blue,
//               barWidth: 3,
//               isStrokeCapRound: true,
//               dotData: FlDotData(show: false),
//             ),
//           ],
//           titlesData: FlTitlesData(
//             bottomTitles: AxisTitles(
//               sideTitles: SideTitles(
//               showTitles: true,
//               getTitlesWidget: (value, meta) {
//                 List<String> weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
//                 return SideTitleWidget(
//                   axisSide: meta.axisSide,
//                   child: Text(weekdays[value.toInt() % weekdays.length]),
//                 );
//               },
//             ),
//           ),
//             leftTitles: AxisTitles(
//               sideTitles: SideTitles(showTitles: true)),
//           ),
//         ),
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
import 'package:fl_chart/fl_chart.dart';

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
  List<int> weeklySteps = List.filled(7, 0);

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
      if (selectedPeriod == 'Week') {
        List<int> stepsList = [];
        for (int i = 0; i < 7; i++) {
          DateTime day = startDate.add(Duration(days: i));
          int? daySteps = await healthService.getSteps(day, day);
          stepsList.add(daySteps ?? 0);
        }
        double weeklyAverage = await healthService.getWeeklyAverageSteps();
        double monthlyAverage = await healthService.getMonthlyAverageSteps();

        setState(() {
          weeklySteps = stepsList;
          weeklyAverageSteps = weeklyAverage;
          monthlyAverageSteps = monthlyAverage;
        });
      } else {
        int? fetchedSteps = await healthService.getSteps(startDate, now);
        double weeklyAverage = await healthService.getWeeklyAverageSteps();
        double monthlyAverage = await healthService.getMonthlyAverageSteps();

        setState(() {
          steps = fetchedSteps ?? 0;
          weeklyAverageSteps = weeklyAverage;
          monthlyAverageSteps = monthlyAverage;
        });
      }
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
        padding: const EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Statistics',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPeriodButton('Today'),
                SizedBox(width: 20),
                _buildPeriodButton('Week'),
                SizedBox(width: 20),
                _buildPeriodButton('Month'),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Total Steps: $steps',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            _buildStepsChart(),
            if (selectedPeriod == 'Week') 
              Text(
                'Weekly Average Steps: ${weeklyAverageSteps.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            if (selectedPeriod == 'Month') 
              Text(
                'Monthly Average Steps: ${monthlyAverageSteps.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 16,
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
        backgroundColor: selectedPeriod == period ? Color(0xFF031927) : Colors.grey.shade200,
        foregroundColor: selectedPeriod == period ? Colors.white : Colors.black,
      ),
    );
  }

  // Widget _buildStepsChart() {

  //   if (steps > 0 || weeklySteps.any((step) => step > 0)) {
  //     return Container(
  //       height: 300,
  //       child: LineChart(
  //         LineChartData(
  //           titlesData: FlTitlesData(
  //             bottomTitles: AxisTitles(
  //               sideTitles: SideTitles(
  //                 showTitles: true,
  //                 getTitlesWidget: (value, meta) {
  //                   String label;
  //                   if (selectedPeriod == 'Today') {
  //                     label = 'Today';
  //                   } else if (selectedPeriod == 'Week') {
  //                     int dayIndex = value.toInt();
  //                     label = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][dayIndex % 7];
  //                   } else {
  //                     label = (value.toInt() + 1).toString();
  //                   }
  //                   return Text(label, style: TextStyle(color: Colors.black));
  //                 },
  //               ),
  //             ),
  //             leftTitles: AxisTitles(
  //               sideTitles: SideTitles(
  //                 showTitles: true,
  //                 getTitlesWidget: (value, meta) {
  //                   return Text(value.toInt().toString(), style: TextStyle(color: Colors.black));
  //                 },
  //               ),
  //             ),
  //           ),
  //           borderData: FlBorderData(
  //             show: true,
  //             border: Border.all(color: Colors.black),
  //           ),
  //           lineBarsData: [
  //             LineChartBarData(
  //               spots: selectedPeriod == 'Today'
  //                   ? [FlSpot(0, steps.toDouble())]
  //                   : selectedPeriod == 'Week'
  //                       ? List.generate(7, (index) => FlSpot(index.toDouble(), weeklySteps[index].toDouble()))
  //                       : List.generate(
  //                           DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day,
  //                           (index) => FlSpot(index.toDouble(), (index % 7 + 1) * 1000.0),
  //                         ),
  //               isCurved: true,
  //               barWidth: 4,
  //               color: Color(0xFF031927),
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  //   } else {
  //     return Center(
  //       child: Text('No step data available.'),
  //     );
  //   }
  // }


  Widget _buildStepsChart() {
  // Ensure there's data to display
  if (selectedPeriod == 'Today') {
    if (steps > 0) {
      return Container(
        height: 300,
        child: LineChart(
          LineChartData(
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text('Today', style: TextStyle(color: Colors.black));
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(value.toInt().toString(), style: TextStyle(color: Colors.black));
                  },
                ),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: Colors.black),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: [FlSpot(0, steps.toDouble())],
                isCurved: true,
                barWidth: 4,
                color: Color(0xFF031927),
              ),
            ],
          ),
        ),
      );
    }
  } else if (selectedPeriod == 'Week') {
    if (weeklySteps.any((step) => step > 0)) {
      return Container(
        height: 300,
        child: LineChart(
          LineChartData(
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    int dayIndex = value.toInt();
                    return Text(['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][dayIndex % 7], style: TextStyle(color: Colors.black));
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(value.toInt().toString(), style: TextStyle(color: Colors.black));
                  },
                ),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: Colors.black),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: List.generate(7, (index) => FlSpot(index.toDouble(), weeklySteps[index].toDouble())),
                isCurved: true,
                barWidth: 4,
                color: Color(0xFF031927),
              ),
            ],
          ),
        ),
      );
    }
  } else if (selectedPeriod == 'Month') {
    // Assume a reasonable number of days for the month
    int daysInMonth = DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day;
    List<FlSpot> spots = List.generate(daysInMonth, (index) {
      return FlSpot(index.toDouble(), 0); // Replace 0 with real data if available
    });

    return Container(
      height: 300,
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text((value.toInt() + 1).toString(), style: TextStyle(color: Colors.black));
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(value.toInt().toString(), style: TextStyle(color: Colors.black));
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.black),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              barWidth: 4,
              color: Color(0xFF031927),
            ),
          ],
        ),
      ),
    );
  }

  // Default case if no data available
  return Center(
    child: Text('No step data available.'),
  );
}

}

