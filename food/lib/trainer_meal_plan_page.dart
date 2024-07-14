import 'package:flutter/material.dart';

class TrainerMealPlanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Plans'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Meal Plan...',
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
                    // Handle create new meal plan action
                  },
                  child: Text('+ Create'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 7, // Example meal plan count
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Meal Plan ${index + 1}'),
                  trailing: PopupMenuButton<String>(
                    onSelected: (String result) {
                      // Handle menu selection
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'View Details',
                        child: Text('View Details'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Edit Meal Plan',
                        child: Text('Edit Meal Plan'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Delete Meal Plan',
                        child: Text('Delete Meal Plan'),
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
