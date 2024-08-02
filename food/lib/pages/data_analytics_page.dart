import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food/components/navbar.dart';
import 'package:food/pages/base_page.dart';
import 'package:food/services/health_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:food/services/SettingProfile_service.dart';
import 'package:intl/intl.dart';

class DataAnalyticsPage extends StatefulWidget {
  const DataAnalyticsPage({super.key});

  @override
  _DataAnalyticsPageState createState() => _DataAnalyticsPageState();
}

class _DataAnalyticsPageState extends State<DataAnalyticsPage> {
  final HealthService healthService = HealthService();
  int steps = 0;
  double? heartRate;
  double? calories;
  double? averageHeartRate;
  double? maxHeartRate;
  String selectedPeriod = 'Today';
  String name = '';
  String? profilePictureUrl;
  
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
    fetchData();
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

  Future<void> fetchData() async {
    
    DateTime now = DateTime.now();
    DateTime startDate;

    switch (selectedPeriod) {
      case 'Week':
        startDate = now.subtract(Duration(days: now.weekday - 1));
        break;
      case 'Today':
      default:
        startDate = DateTime(now.year, now.month, now.day);
        break;
    }

    try {
      int? fetchedSteps = await healthService.getSteps();
      double? fetchedHeartRate = await healthService.getHeartRate();
      double? fetchedCalories = await healthService.getCalories();
      double? fetchedAverageHeartRate = await healthService.getAverageHeartRateForToday();
      double? fetchedMaxHeartRate = await healthService.getMaximumHeartRateForToday();


      setState(() {
        steps = fetchedSteps ?? 0;
        heartRate = fetchedHeartRate ?? 0.0;
        calories = fetchedCalories ?? 0.0;
        averageHeartRate = fetchedAverageHeartRate ?? 0.0;
        maxHeartRate = fetchedMaxHeartRate ?? 0.0;
      
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  
  Widget _buildProfileImage() {
  return CircleAvatar(
    radius: 24,
    child: profilePictureUrl != null
      ? CachedNetworkImage(
          imageUrl: profilePictureUrl!,
          fit: BoxFit.cover,
        )
      : Icon(Icons.person), // Default profile icon
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
        child: SingleChildScrollView(
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildPeriodButton('Today'),
                  SizedBox(width: 20),
                  _buildPeriodButton('Week'),
                  SizedBox(width: 20),
                  _buildPeriodButton('Month'),
                  SizedBox(width: 20)
                ],
              ),
              SizedBox(height: 16),
              
              Container(
                width: 350,
                height: 190,
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.all(15),
                
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white, 
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey.shade300,
                          )
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Heart Rate \n ${heartRate?.toStringAsFixed(1) ?? 'N/A'} bpm',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 5),
                              Icon(Icons.favorite, color: Color(0xFF508AA8)),
                            ],
                          
                          ),
                        ),
                      ),
                    ),
                   
          
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                              color: Colors.grey.shade300,
                          )
                            ),
                            
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Calories \n ${calories?.toStringAsFixed(1) ?? 'N/A'} kcal',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Icon(Icons.local_fire_department, color: Color(0xFF508AA8)),
                                  
                                  ],
                                ),
                              ),
                            ),
                    
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white, 
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                              color: Colors.grey.shade300,
                          )
                            ),
                    
                              child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Steps \n ${steps?.toString() ?? 'N/A'} steps',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  FaIcon(FontAwesomeIcons.shoePrints, color: Color(0xFF508AA8)),
                                  
                                    ],
                                  ),
                                ),
                              ),
                            ],
                        
                        ),)
                      ],
                      )
                    ),
                SizedBox(height: 15,),
                if (selectedPeriod == 'Today') 
                  Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  child: Column (
                    crossAxisAlignment: CrossAxisAlignment.start,
                    
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Steps',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${steps?.toString() ?? 'N/A'}',
                             style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      Divider(color: Colors.grey.shade400),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Calories Burned',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${calories?.toStringAsFixed(1) ?? 'N/A'} kcal',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      Divider(color: Colors.grey),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Average Heart Rate',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${averageHeartRate?.toStringAsFixed(1) ?? 'N/A'} bpm',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      Divider(color: Colors.grey),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Maximum Heart Rate',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${maxHeartRate?.toStringAsFixed(1) ?? 'N/A'} bpm',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                                  ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Navbar(
        currentIndex: 0,
        onTap: (int index) {
        
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BasePage(initialIndex: index),
            ),
          ) ;
        },
      ),
    );
  }

  Widget _buildPeriodButton(String period) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedPeriod = period;
          fetchData();
        });
      },
      child: Text(period),
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedPeriod == period ? Color(0xFF031927) : Colors.grey.shade200,
        foregroundColor: selectedPeriod == period ? Colors.white: Colors.black,
      ),
    );
  }



}


