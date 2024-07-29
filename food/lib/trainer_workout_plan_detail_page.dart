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
      appBar: AppBar(
        title: Text('Workout Plan'),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
            Expanded(
              child: ListView.builder(
                itemCount: 4, // Example workout activity count
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              ElevatedButton(
                onPressed: () {
                  // Handle save changes action
                },
                child: Text('Save Changes'),
              ),
          ],
        ),
      ),
    );
  }
}
