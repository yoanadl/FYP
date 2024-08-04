// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:food/components/navbar.dart';
import 'package:food/pages/profile_setting/delete_account.dart';
import 'package:food/pages/profile_setting/notification_settings.dart';
import 'package:food/pages/profile_setting/password_manager.dart';
import 'package:food/pages/base_page.dart';
import 'package:food/pages/discarded/community_page.dart';
import 'package:food/pages/workout/workout_page.dart';

class RowData{
  final IconData icon;
  final String text;
  final Widget destination;

  const RowData(
    {
      required this.icon, 
      required this.text,
      required this.destination,
    }
  );
}

class SettingsPage extends StatelessWidget {

  
  final List<RowData> rowData = [

    RowData(
      icon: Icons.notifications_active, 
      text: 'Notification',
      destination: NotificationSettings(),
    ),
    RowData(
      icon: Icons.lock, 
      text: 'Change Password',
      destination: PasswordManager()
      ),
    RowData(
      icon: Icons.delete, 
      text: 'Delete Account',
      destination: DeleteAccount(),
    ),
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 30, right: 30),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              SizedBox(height: 50,),

              Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: rowData.length,
                itemBuilder: (context, index) => buildRowItem(context, rowData[index]),
                separatorBuilder: (context, index) => SizedBox(height: 5.0,),
                ),
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

  // function to build each row
  Widget buildRowItem(BuildContext context, RowData data) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => data.destination),
        );
      },
      child: Container(
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
      ),
    );
  }





}
