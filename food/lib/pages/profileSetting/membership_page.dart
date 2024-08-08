// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:food/components/navbar.dart';
import 'package:food/components/base_page.dart';
import 'package:food/pages/discarded/community_page.dart';
import 'package:food/pages/premiumUser/premiumplan_page.dart';
import 'package:food/pages/workout/views/workout_page_view.dart';

import 'bmi_reports_page.dart';

class MembershipPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ),
              MembershipCard(
                title: 'Basic',
                price: 'Free',
                features: [
                  'limited workout plan',
                  'limited meal plan',
                  'analytics & workout history',
                  'communities',
                ],
                isCurrentPlan: true,
                buttonColor: Colors.white,
                buttonTextColor: Colors.black,
                buttonText: 'Current Plan',
                titleColor: Colors.black,
                borderColor: Colors.blue,
                checkIconColor: Colors.blue,
              ),
              SizedBox(height: 16.0),
              MembershipCard(
                title: 'Premium',
                price: '9.9 SGD/mth or 109.9 SGD/yr',
                features: [
                  'access to all workout plan',
                  'access to all meal plan',
                  'contact verified trainers',
                  'personalized feedback and plans',
                ],
                isCurrentPlan: false,
                buttonColor: Colors.blue,
                buttonTextColor: Colors.white,
                buttonText: 'Upgrade Now',
                titleColor: Colors.black,
                borderColor: Colors.transparent,
                checkIconColor: Colors.blue,
              ),
            ],
          ),
        ),
      ),
       bottomNavigationBar: Navbar(
        currentIndex: 3,
        onTap: (int index) {
          if (index != 3) {
            Navigator.pop(context);
            switch (index) {
              case 0:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const BasePage()));
                break;
              case 1:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const WorkoutPage()));
                break;
              case 2:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CommunityPage()));
                break;
            }
          }
        },
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
                    foregroundColor: buttonTextColor, // For the text color
                    textStyle: TextStyle(
                      color: buttonTextColor,
                    ),
                  ),
                  onPressed: isCurrentPlan ? null : () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PremiumPlanPage()));
                  },
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
/*
class MembershipPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 40, right: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Membership',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ),

            // Basic Plan
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: EdgeInsets.all(16.0),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 15),
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Basic',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text('• Feature #1'),
                              Text('• Feature #2'),
                              Text('• Feature #3'),
                              Text('• Feature #4'),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Free',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Icon(
                                Icons.check,
                                color: Colors.green,
                                size: 30,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),


                  Positioned(
                    bottom: -5,
                    right: 30,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      color: Color(0xff031927),
                      child: Text(
                        'Current Plan',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Premium Plan

            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: EdgeInsets.all(16.0),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 15),
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Premium',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text('• Feature #1'),
                              Text('• Feature #2'),
                              Text('• Feature #3'),
                              Text('• Feature #4'),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '9.9 SGD monthly/ \n 109.9 SGD annually',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Icon(
                                Icons.check,
                                color: Colors.green,
                                size: 30,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),


                  Positioned(
                    bottom: -9,
                    right: 30,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff031927),
                      ),
                      onPressed: () {
                          
                      },
                      child: Text(
                        'Upgrade Now',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),



          ],
        ),
      ),
      bottomNavigationBar: Navbar(
        currentIndex: 3,
        onTap: (int index) {
          if (index != 3) {
            Navigator.pop(context);
            switch (index) {
              case 0:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const BasePage()));
                break;
              case 1:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const WorkoutPage()));
                break;
              case 2:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CommunityPage()));
                break;
            }
          }
        },
      ),
    );
  }
}*/
