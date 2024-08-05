import 'package:flutter/material.dart';
import 'trainer_client_analytics_page.dart';
import 'package:food/components/trainer_navbar.dart'; 
import 'trainer_base_page.dart';
import 'trainer_workout_plan_page.dart';
import 'trainer_profile_page.dart';

class TrainerMyClientPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false, 
        backgroundColor: Colors.white,
        title: Text('My Clients', style: TextStyle(fontWeight: FontWeight.w600),),
      ),
      body: ListView.builder(
        itemCount: 7, // Example client count
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Client client client #${index + 1}'),
            trailing: PopupMenuButton<String>(
              onSelected: (String result) {
                if (result == 'View Analytics') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TrainerClientAnalyticsPage()),
                  );
                }
                // Handle menu selection
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'View Analytics',
                  child: Text('View Analytics'),
                ),
                const PopupMenuItem<String>(
                  value: 'Delete Client',
                  child: Text('Delete Client'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
