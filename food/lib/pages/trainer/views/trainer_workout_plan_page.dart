import 'package:flutter/material.dart';
import 'trainer_workout_plan_detail_page.dart';

class TrainerWorkoutPlanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 20),),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Workout Plan...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Sort by:'),
                DropdownButton<String>(
                  value: 'A to Z',
                  items: <String>['A to Z', 'Z to A']
                      .map((String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                      .toList(),
                  onChanged: (String? newValue) {
                    // Handle sort change
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle create new workout plan action
                  },
                  child: Text('+ Create'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 7, // Example workout plan count
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Workout Plan ${index + 1}'),
                  trailing: PopupMenuButton<String>(
                    onSelected: (String result) {
                      if (result == 'View Details') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TrainerWorkoutPlanDetailPage(),
                          ),
                        );
                      } else if (result == 'Edit Workout Plan') {
                        // Handle edit workout plan action
                      } else if (result == 'Delete Workout Plan') {
                        // Handle delete workout plan action
                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'View Details',
                        child: Text('View Details'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Edit Workout Plan',
                        child: Text('Edit Workout Plan'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Delete Workout Plan',
                        child: Text('Delete Workout Plan'),
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
