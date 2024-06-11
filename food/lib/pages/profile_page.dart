
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RowData{
  final IconData icon;
  final String text;

  const RowData(
    {
      required this.icon, 
      required this.text,
    }
  );
}
class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final List<RowData> rowData = [

    RowData(icon: Icons.settings, text: 'Your Profile'),
    RowData(icon: Icons.settings, text: 'My Goals & Dietary Preferences'),
    RowData(icon: Icons.settings, text: 'My BMI'),
    RowData(icon: Icons.settings, text: 'My Membership'),
    RowData(icon: Icons.settings, text: 'Settings'),
    RowData(icon: Icons.settings, text: 'Help Center'),
    RowData(icon: Icons.settings, text: 'Privacy Policy'),
    RowData(icon: Icons.settings, text: 'Terms and Conditions'),
    RowData(icon: Icons.settings, text: 'Log Out'),

  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
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
            
            SizedBox(height: 20.0,),
            // profile image avatar
            CircleAvatar(
              backgroundColor: Colors.grey[100],
              radius: 50.0,
            ),

            // name 
            SizedBox(height: 15.0),
            Text(
              'John Doe',
              style: TextStyle(
                fontSize: 20,
              ),
            ),

            SizedBox(height: 25.0),

            // settings 
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: rowData.length,
                itemBuilder: (context, index) => buildRowItem(rowData[index]),
                separatorBuilder: (context, index) => SizedBox(height: 5.0,),
                ),
            ),

          ],
        ),
      )
    );
  }

 

  // function to build each row
  Widget buildRowItem(RowData data) {
    return Container(
      color: Colors.grey[100],
      margin:const EdgeInsets.symmetric(horizontal: 40.0),

      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Icon(data.icon),
            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                data.text,
                style: TextStyle(
                  fontSize: 20.0,
                )
              ),
            ),
            Spacer(),
            Icon(Icons.arrow_right),
          ],
        ),
      ),
    );
  }
}

