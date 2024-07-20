// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int allUsersCount = 0;
  int activeUsersCount = 0;


  @override 
  void initState() {
    super.initState();
    fetchAllUsersCount();
    fetchActiveUsersCount();
  }

  Future<void> fetchAllUsersCount() async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && await isAdmin(user.uid)) { // Call isAdmin without parameters
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users').get();
      setState(() {
        allUsersCount = snapshot.size;
      });
    } else {
      print('User is not authorized to access all users count');
    }
  } catch (e) {
    print('Error fetching all users count: $e');
  }
}

Future<bool> isAdmin(String uid) async {

  try {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (userDoc.exists) {
      // Cast the data to a Map<String, dynamic> before accessing fields
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      return userData['role'] == 'admin';
    }

    return false;

  }

  catch (e) {
    print('Error checking admin status: $e');
    return false;
  }
}

Future<void> fetchActiveUsersCount() async {
  try {

    final user = FirebaseAuth.instance.currentUser;

    if (user != null && await isAdmin(user.uid)) { 

      QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('status', isEqualTo: 'active')
        .get();
      setState(() {
        activeUsersCount = snapshot.size;
      });
    } else {
      print('User is not authorized to access active users count');
    }
  } catch (e) {
    print('Error fetching active users count: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('EEEE d MMMM').format(DateTime.now());

    return Scaffold(
  
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          automaticallyImplyLeading: false, // hide the back button
          backgroundColor: Colors.white,
          centerTitle: false,
          actions: [
            // notification icon
            Padding(
              padding: const EdgeInsets.all(8.0),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 90,
                height: 90,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                  ),
                ),
              ),
              )

          ],

          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 35.0),
                child: Text(
                  'Hello, Admin!',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 35.0),
                child: Text(
                  formattedDate,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),

        body: Container(
          color: Colors.white,
          child: Center(
            child: Column (
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 55, bottom: 10, top: 30),
                    child: Text(
                      'User Accounts',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                // User Accounts Container
                Container(
                  width: 350,
                  height: 110, 
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Container(
                              width: 160,
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'All Users',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16
                                    ),
                                  ),
                                  Text(
                                    '$allUsersCount',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 10), 
                          Container(
                            width: 160,
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Active Users',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '$activeUsersCount',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      
                    ],
                  ),
                ),
                SizedBox(height: 30), 
                // User Profiles Text
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                          padding: const EdgeInsets.only(left: 55, bottom: 10, top: 30),
                          child: Text(
                            'User Profiles',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ),
                ),
                Container(
                  width: 350,
                  height: 210, 
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Container(
                              width: 160,
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Free Users',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    '200',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 10), 
                          Container(
                            width: 160,
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Premium Users',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '200',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Container(
                              width: 160,
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Trainers',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    '200',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 10), 
                          Container(
                            width: 160,
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Comm Admins',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '200',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
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

    );
    
   

  }
}