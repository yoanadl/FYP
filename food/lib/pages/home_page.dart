// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food/pages/base_page.dart';
import 'package:food/services/SettingProfile_service.dart';
import 'package:food/services/health_service.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'mealPlan_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:food/applewatch/injector.dart' show healthFactory;
import 'package:food/applewatch/constants.dart' show currentDate, dataTypesIos, midNight, permissions;
import 'package:health/health.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int? steps;
  double? heartRate;
  double? calories;
  String name = '';
  String? profilePictureUrl;
  final HealthService healthService = HealthService();
  final SettingprofileService profileService = SettingprofileService();


  @override 
  void initState() {
    super.initState();
    fetchData();
    fetchUserProfile();
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

  Future<void> fetchData() async {
    int? fetchedSteps = await healthService.getSteps();
   

    setState(() {
      
      steps = fetchedSteps ?? 0;
      heartRate = heartRate;
      calories = calories;

    });
  }

  

  Widget _buildProfileImage() {
    return CircleAvatar(
      radius: 30,
      backgroundImage: profilePictureUrl != null
        ? CachedNetworkImageProvider(profilePictureUrl!)
        : null,
    );
  }


  @override
  Widget build(BuildContext context) {

    String formattedDate = DateFormat('EEEE d MMMM').format(DateTime.now());
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,

      // Top App
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          automaticallyImplyLeading: false, // hide the back button
          backgroundColor: Colors.white,
          centerTitle: false,
          actions: [

            // notification icon
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
                child: loadProfilePicture(context, user.uid),
              )
          ],

          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
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
                  overflow: TextOverflow.ellipsis,
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
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

        ),
      ),

      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Today\'s Information',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              
      
              Container(
                width: 350,
                height: 190,
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Color(0x99C8E0F4),
                  borderRadius: BorderRadius.circular(10),
                ),
      
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 5),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white, 
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Heart Rate \n 72 bpm',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
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
                            ),
                            
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Calories \n 350 kcal',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
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
                            ),
      
                             child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Steps \n 10,000',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  FaIcon(FontAwesomeIcons.shoePrints, color: Color(0xFF508AA8)),
                                  
                                  ],
                                ),
                              ),
                          )
                        ],
                      ))
                  ],
      
                )
                
              ),
      
              SizedBox(height: 20),
      
              InkWell(
                onTap: () => Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => BasePage(initialIndex: 1)),
                ),
                child: Container(
                  width: 350,
                  height: 120,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Color(0x99C8E0F4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'lib/images/workout.png',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      Positioned(
                        top: 15,
                        left: 15,
                        child: Text(
                          'Workout Plan', 
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            backgroundColor: Color(0xFF508AA8),
                          ),
                        ),
                      ),
                      ],

                  ),

                  
        
                  
                ),
              ),
      
              SizedBox(height: 20),
      
               InkWell(
                onTap: () => Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => MealPlanPage()),
                ),
                 child: Container(
                  width: 350,
                  height: 120,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Color(0x99C8E0F4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                 
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'lib/images/food.png',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      Positioned(
                        top: 15,
                        left: 15,
                        child: Text(
                          'Meal Plan', 
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            backgroundColor: Color(0xFF508AA8),
                          ),
                        ),
                      ),
                      ],

                  ),
                 ),
               ),

               SizedBox(height: 20),
      
               InkWell(
                onTap: () => Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => MealPlanPage()),
                ),
                 child: Container(
                  width: 350,
                  height: 120,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Color(0x99C8E0F4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                 
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'lib/images/food.png',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      Positioned(
                        top: 15,
                        left: 15,
                        child: Text(
                          'Challenges', 
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            backgroundColor: Color(0xFF508AA8),
                          ),
                        ),
                      ),
                      ],

                  ),
                 ),
               ),
            ],
          ),
        ),
      ),
  
    );
  }
}