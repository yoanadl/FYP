import 'package:flutter/material.dart';
import 'trainer_workout_plan_detail_page.dart';
import 'trainer_workout_plan_edit_page.dart';
import 'trainer_create_workout_plan_page.dart';

class TrainerWorkoutPlanPage extends StatefulWidget {
  @override
  _TrainerWorkoutPlanPageState createState() => _TrainerWorkoutPlanPageState();
}

class _TrainerWorkoutPlanPageState extends State<TrainerWorkoutPlanPage> {
  String _selectedSortOrder = 'A to Z';
  List<String> _items = [
    'Workout Plan 1',
    'Workout Plan 2',
    'Workout Plan 3',
    'Workout Plan 4',
    'Workout Plan 5',
    'Workout Plan 6',
    'Workout Plan 7'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 0),
          child: Text(
            'Workout Plans',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 25,
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search Workout Plan...',
                  hintStyle: const TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Sort by:',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(width: 10),
                      DropdownButton<String>(
                        value: _selectedSortOrder,
                        items: <String>['A to Z', 'Z to A']
                            .map((String value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                    ),
                                  ),
                                ))
                            .toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedSortOrder = newValue!;
                            _sortItems();
                          });
                        },
                        icon: Icon(Icons.arrow_drop_down),
                        underline: Container(),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateWorkoutPlanPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      minimumSize: Size(100, 40),
                    ),
                    child: const Text(
                      '+ Create',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        color: Color(0XFF031927),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      _items[index],
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditWorkoutPlanPage(
                                workoutPlan: _items[index],
                              ),
                            ),
                          );
                        } else if (result == 'Delete Workout Plan') {
                          _deleteWorkoutPlan(index);
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TrainerWorkoutPlanDetailPage(),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteWorkoutPlan(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Workout Plan'),
          content: Text('Are you sure you want to delete this workout plan?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _items.removeAt(index);
                });
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _sortItems() {
    setState(() {
      if (_selectedSortOrder == 'A to Z') {
        _items.sort((a, b) => a.compareTo(b));
      } else {
        _items.sort((a, b) => b.compareTo(a));
      }
    });
  }
}
