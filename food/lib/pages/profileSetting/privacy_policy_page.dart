// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:food/components/navbar.dart';
import 'package:food/components/base_page.dart';
import 'package:food/pages/discarded/community_page.dart';
import 'package:food/pages/workout/workout_page.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        //margin: EdgeInsets.only(left: 40, right: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Privacy Policy',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            SizedBox(height: 30),
            Container(
              color: Colors.grey[100],
              height: 600,
              width: 350,
              padding: const EdgeInsets.all(25.0),
              child: Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Pretium nibh ipsum consequat nisl vel pretium lectus quam. Egestas pretium aenean pharetra magna ac. Consequat ac felis donec et odio pellentesque diam volutpat commodo. Massa placerat duis ultricies lacus sed turpis tincidunt id. Tellus molestie nunc non blandit massa enim. Tortor pretium viverra suspendisse potenti nullam ac tortor. Ultrices eros in cursus turpis massa tincidunt dui ut ornare. Enim tortor at auctor urna. Et tortor at risus viverra adipiscing at in tellus. Elit eget gravida cum sociis natoque penatibus et. Elementum curabitur vitae nunc sed velit dignissim sodales ut. Urna nunc id cursus metus aliquam eleifend mi in.',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              
            )


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
}
