import 'package:flutter/material.dart';

class TrainerWorkoutPlanDetailPage extends StatefulWidget {
  @override
  _TrainerWorkoutPlanDetailPageState createState() => _TrainerWorkoutPlanDetailPageState();
}

class _TrainerWorkoutPlanDetailPageState extends State<TrainerWorkoutPlanDetailPage> {
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Workout Plan', style: TextStyle(fontWeight: FontWeight.w600),),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Are you sure you want to delete this workout plan?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          // Handle delete action
                          Navigator.of(context).pop();
                        },
                        child: Text('Yes'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('No'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Horizontally scrollable list of days
            Container(
              height: 48.0, // Set a fixed height for the horizontal list
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(7, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle day change
                        },
                        child: Text('${index + 1}'),
                      ),
                    );
                  }),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 4, // Example workout activity count
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(
                        child: TextField(
                          enabled: isEditing,
                          decoration: InputDecoration(
                            hintText: 'Workout Activity ${index + 1}',
                          ),
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: TextField(
                          enabled: isEditing,
                          decoration: InputDecoration(
                            hintText: 'Duration',
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            if (isEditing)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Handle save changes action
                  },
                  child: Text('Save Changes'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

