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
  int freeUsersCount = 0;
  int premiumUsersCount = 0;
  int trainerCount = 0;

  @override
  void initState() {
    super.initState();
    fetchAllUsersCount();
    fetchFreeUsersCount();
    fetchPremiumUsersCount();
    fetchTrainerCount();
  }

  Future<void> fetchAllUsersCount() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && await isAdmin(user.uid)) {
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
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        return userData['role'] == 'admin';
      }
      return false;
    } catch (e) {
      print('Error checking admin status: $e');
      return false;
    }
  }

    Future<void> fetchFreeUsersCount() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users')
          .where('role', isEqualTo: 'user')
          .get();
      setState(() {
        freeUsersCount = snapshot.size;
      });
    } catch (e) {
      print('Error fetching free users count: $e');
    }
  }

  Future<void> fetchPremiumUsersCount() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users')
          .where('role', isEqualTo: 'premium user')
          .get();
      setState(() {
        premiumUsersCount = snapshot.size;
      });
    } catch (e) {
      print('Error fetching premium users count: $e');
    }
  }

  Future<void> fetchTrainerCount() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users')
          .where('role', isEqualTo: 'trainer')
          .get();
      setState(() {
        trainerCount = snapshot.size;
      });
    } catch (e) {
      print('Error fetching trainer count: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('EEEE d MMMM').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          automaticallyImplyLeading: false, // hide the back button
          backgroundColor: Colors.white,
          centerTitle: false,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 35.0),
              child: SizedBox(
                width: 60,
                height: 60,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200],
                  ),
                   child: Center(
                    child: Icon(
                      Icons.person, 
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 17.0),
                child: Text(
                  'Hello, Admin!',
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
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
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
          child: Column(
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
              SizedBox(height: 25,),

              // User Accounts Container
              Container(
                width: 350,
                height: 240, // Increased height to accommodate two rows
                decoration: BoxDecoration(
                  color: Color(0xFFC8E0F4).withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    // First Row: All Users and Free Users
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildUserTypeContainer('All Users', allUsersCount),
                        _buildUserTypeContainer('Free Users', freeUsersCount),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Second Row: Premium Users and Trainer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildUserTypeContainer('Premium Users', premiumUsersCount),
                        _buildUserTypeContainer('Trainers', trainerCount),
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

  Widget _buildUserTypeContainer(String title, int count) {
    return Container(
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
            title,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            '$count',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

}
