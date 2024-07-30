import 'package:flutter/material.dart';
import 'trainer_client_feedback_detail_page.dart';

class TrainerClientFeedbackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Feedback'),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/profile_picture.png'), // Replace with actual image asset
            ),
            title: Text('Client client client #4'),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 5, // Example feedback count
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Feedback Title #${index + 1}'),
                  subtitle: Text('Lorem ipsum dolor sit amet...'),
                  trailing: PopupMenuButton<String>(
                    onSelected: (String result) {
                      if (result == 'View Details') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TrainerClientFeedbackDetailPage()),
                        );
                      }
                      // Handle menu selection
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'View Details',
                        child: Text('View Details'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Delete Feedback',
                        child: Text('Delete Feedback'),
                      ),
                    ],
                  ),
                );
              },
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
