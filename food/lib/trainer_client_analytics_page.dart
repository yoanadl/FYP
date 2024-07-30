import 'package:flutter/material.dart';
import 'trainer_client_feedback_page.dart';

class TrainerClientAnalyticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Exercise Analytics', style: TextStyle(fontWeight: FontWeight.w500),),
      ),
      body: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/profile_picture.png'), // Replace with actual image asset
            ),
            title: Text('Client client client #4'),
            trailing: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TrainerClientFeedbackPage()),
                );
              },
              child: Text('Feedback'),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                // Example analytics content
                ListTile(
                  title: Text('Steps'),
                  subtitle: Text('Weekly'),
                  trailing: Text('11,536'),
                ),
                ListTile(
                  title: Text('Average activity time spent'),
                  subtitle: Text('1h 05m'),
                ),
                // Add more analytics widgets here
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workout',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Client List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Meal Plan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
