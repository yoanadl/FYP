import 'package:flutter/material.dart';
import 'trainer_client_analytics_page.dart';

class TrainerMyClientPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Clients'),
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
