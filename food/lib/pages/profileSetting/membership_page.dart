import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:food/components/base_page.dart';
import 'package:food/pages/premiumUser/premiumplan_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import 'bmi_reports_page.dart';

class MembershipPage extends StatefulWidget {
  @override
  _MembershipPageState createState() => _MembershipPageState();
}

class _MembershipPageState extends State<MembershipPage> {
  String? role;
  String? startDate;
  String? endDate;
  String? plan;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      setState(() {
        role = userDoc['role']; // Assuming role is stored in user document
      });

      if (role == 'premium user') {
        await _fetchSubscriptionDetails(user.email!);
      }

      

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _updateUserRole(String userId, String newRole) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'role': newRole});
      
      // Update the local role variable
      setState(() {
        role = newRole;
        startDate = null; // Reset subscription details
        endDate = null;
        plan = null;
      });
      
      print('User role updated to $newRole');
    } catch (error) {
      print('Error updating user role: $error');
    }
  }

  Future<void> _fetchSubscriptionDetails(String email) async {
    try {
      final response = await http.post(
        Uri.parse('https://us-central1-fyp-goodgrit-a8601.cloudfunctions.net/stripeInfo'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        if (data.isNotEmpty) {
          // Assuming you want the first subscription's details
          final subscription = data[0];

          int startDateMillis = subscription['startDate'] is int
              ? subscription['startDate']
              : int.tryParse(subscription['startDate'].toString()) ?? 0;
          int endDateMillis = subscription['endDate'] is int
              ? subscription['endDate']
              : int.tryParse(subscription['endDate'].toString()) ?? 0;

          setState(() {
            startDate = DateTime.fromMillisecondsSinceEpoch(startDateMillis * 1000)
                .toLocal()
                .toString();
            endDate = DateTime.fromMillisecondsSinceEpoch(endDateMillis * 1000)
                .toLocal()
                .toString();
            plan = subscription['plan'];
          });
        } else {
          print('No subscriptions found.');
        }
      } else {
        print('Failed to fetch subscription details: ${response.body}');
      }
    } catch (error) {
      print('Error fetching subscription details: $error');
    }
  }

  void _unsubscribe() async {
  // Show a confirmation dialog
  final confirm = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm Unsubscription'),
        content: Text('Are you sure you want to unsubscribe from GoodGrit?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(false); // User cancelled
            },
          ),
          TextButton(
            child: Text('Unsubscribe'),
            onPressed: () {
              Navigator.of(context).pop(true); // User confirmed
            },
          ),
        ],
      );
    },
  );

  // If the user confirmed, proceed with the unsubscription
  if (confirm == true) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        print('Email sent to unsubscribe: ${user.email}'); // Log email

        // Call your backend API to unsubscribe
        final response = await http.post(
          Uri.parse('https://us-central1-fyp-goodgrit-a8601.cloudfunctions.net/UnsubStripe'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': user.email}),
        );

        // Log the response from the server
        print('Response from unsubscribe request: ${response.body}');

        if (response.statusCode == 200) {
          // Handle successful unsubscription
          print('User successfully unsubscribed from the product');

          // Update user role in Firestore to 'user'
          await _updateUserRole(user.uid, 'user'); // Directly update role to 'user'
          
          // Reset subscription details
          setState(() {
            startDate = null;
            endDate = null;
            plan = null;
          });

          
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BasePage()),
          );
        } else {
          print('Failed to unsubscribe: ${response.body}'); // Print the error message
        }
      } catch (error) {
        print('Error unsubscribing: $error');
      }
    } else {
      print('No user is currently signed in.');
    }
  } else {
    print('User cancelled the unsubscription.');
  }
}


 @override
Widget build(BuildContext context) {
  if (isLoading) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Center(child: CircularProgressIndicator()),
    );
  }

  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.white,
    ),
    backgroundColor: Colors.white,
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Title(
              color: Colors.black,
              child: Text(
                'Your Membership',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
              ),
            ),
            MembershipCard(
              title: 'Basic',
              price: 'Free',
              features: [
                'recommended workout plans',
                'workout history',
                'challenges',
              ],
              isCurrentPlan: role == 'user', // Highlight if the role is user
              buttonColor: role == 'user' ? Colors.grey : Colors.blue,
              buttonTextColor: Colors.white,
              buttonText: role == 'user' ? 'Current Plan' : 'Unsubscribe from Premium Plan',
              titleColor: Colors.black,
              borderColor: role == 'user' ? Colors.blue : Colors.grey, // Highlight border if user
              checkIconColor: Colors.blue,
              onPressed: role == 'user' ? null : _unsubscribe, // Disable action if user
            ),
            SizedBox(height: 16.0),
            MembershipCard(
              title: 'Premium',
              price: role == 'premium user' && plan != null ? '$plan' : '9.9 SGD/mth or 109.9 SGD/yr',
              features: [
                'contact verified trainers',
                'personalized feedback',
                if (role == 'premium user' && startDate != null && endDate != null) ...[
                  'Subscription Start: $startDate',
                  'Subscription End: $endDate',
                ],
              ],
              isCurrentPlan: role == 'premium user', // Highlight if the role is premium
              buttonColor: role == 'premium user' ? Colors.grey : Colors.blue, // Grey if premium user
              buttonTextColor: role == 'premium user' ? Colors.black : Colors.white,
              buttonText: role == 'premium user' ? 'Current Plan' : 'Upgrade Now',
              titleColor: Colors.black,
              borderColor: role == 'premium user' ? Colors.blue : Colors.transparent, // Highlight border if premium
              checkIconColor: Colors.blue,
              onPressed: role == 'premium user' ? null : () {
               Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PremiumPlanPage()),
                );
              }, 
            ),
          ],
        ),
      ),
    ),
  );
}

}
class MembershipCard extends StatelessWidget {
  final String title;
  final String price;
  final List<String> features;
  final bool isCurrentPlan;
  final Color buttonColor;
  final Color buttonTextColor;
  final String buttonText;
  final Color titleColor;
  final Color borderColor;
  final Color checkIconColor;
  final VoidCallback? onPressed;

  MembershipCard({
    required this.title,
    required this.price,
    required this.features,
    required this.isCurrentPlan,
    required this.buttonColor,
    required this.buttonTextColor,
    required this.buttonText,
    required this.titleColor,
    required this.borderColor,
    required this.checkIconColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: borderColor, width: 1.5),
      ),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: titleColor,
                    ),
                  ),
                  if (isCurrentPlan)
                    Icon(Icons.check_circle, color: checkIconColor, size: 24.0),
                ],
              ),
              SizedBox(height: 8.0),
              Text(
                price,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 8.0),
              ...features.map((feature) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text(
                  '• $feature',
                  style: TextStyle(fontSize: 16.0),
                ),
              )),
              SizedBox(height: 8.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: buttonTextColor,
                    textStyle: TextStyle(
                      color: buttonTextColor,
                    ),
                  ),
                  onPressed: onPressed,
                  child: Text(buttonText, style: TextStyle(color: buttonTextColor)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
