import 'package:flutter/material.dart';
import 'package:food/components/navbar.dart';
import 'package:food/pages/base_page.dart';
import 'package:food/pages/community_page.dart';
import 'package:food/pages/workout_page.dart';

class ProfileTextField extends StatelessWidget {

  final String label;

  const ProfileTextField({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
        ),

        SizedBox(height: 5.0,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
          child: SizedBox(
            height: 40.0,
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter $label',
              ),
            ),
          ),
        )
      ],
    );
  }

}

class MyProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Text(
              'Profile',
            ),
            Spacer()
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // profile image avatar
            CircleAvatar(
              backgroundColor: Colors.grey[100],
              radius: 50.0,
            ),

            // text fields 
            SizedBox(height: 10.0),

            ProfileTextField(label: 'Name'),
            SizedBox(height: 10.0),

            ProfileTextField(label: 'Email'),
            SizedBox(height: 10.0),

            ProfileTextField(label: 'Gender'),
            SizedBox(height: 10.0),

            ProfileTextField(label: 'Age'),
            SizedBox(height: 10.0),

            ProfileTextField(label: 'Height'),
            SizedBox(height: 10.0),

            ProfileTextField(label: 'Weight'),
            SizedBox(height: 10.0),

            // update profile button
            ElevatedButton(
              onPressed: () {
               
              },
              child: Text('Update Profile'),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Navbar(
        currentIndex: 3,
        onTap: (int index) {
          if (index != 3) {
            Navigator.pop(context);
            switch(index) {
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
        }

      ),
    );
  }
}