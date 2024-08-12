import 'package:flutter/material.dart';

class ChallengeOwnerViewPage extends StatefulWidget {
  @override
  _ChallengeOwnerViewPageState createState() => _ChallengeOwnerViewPageState();
}

class _ChallengeOwnerViewPageState extends State<ChallengeOwnerViewPage> {
  bool isEditing = false;
  TextEditingController titleController = TextEditingController(text: 'Challenge Title');
  TextEditingController detailsController = TextEditingController(text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.');

  List<ChallengeActivity> activities = [
    ChallengeActivity(activity: 'Challenge Activity 1', duration: '000 reps'),
    ChallengeActivity(activity: 'Challenge Activity 2', duration: '000 mins'),
    ChallengeActivity(activity: 'Challenge Activity 3', duration: '000 reps'),
    ChallengeActivity(activity: 'Challenge Activity 4', duration: '000 mins'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Challenge Title'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _showDeleteDialog,
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isEditing
                ? TextField(controller: titleController)
                : Text(titleController.text, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            isEditing
                ? TextField(controller: detailsController, maxLines: 3)
                : Text(detailsController.text),
            SizedBox(height: 16),
            Text('Rewards: 00 pts'),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  return _buildActivityItem(activities[index]);
                },
              ),
            ),
            if (isEditing)
              Center(
                child: ElevatedButton(
                  child: Text('Save Changes'),
                  onPressed: () {
                    setState(() {
                      isEditing = false;
                    });
                    // TODO: Implement save changes logic
                  },
                ),
              )
            else
              Center(
                child: ElevatedButton(
                  child: Text('Start'),
                  onPressed: () {
                    // TODO: Implement start challenge logic
                  },
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Workout'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Community'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildActivityItem(ChallengeActivity activity) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: isEditing
                ? TextField(
                    controller: TextEditingController(text: activity.activity),
                    onChanged: (value) => activity.activity = value,
                  )
                : Text(activity.activity),
          ),
          SizedBox(width: 16),
          Expanded(
            flex: 1,
            child: isEditing
                ? TextField(
                    controller: TextEditingController(text: activity.duration),
                    onChanged: (value) => activity.duration = value,
                  )
                : Text(activity.duration),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Challenge'),
          content: Text('Are you sure you want to delete this challenge?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                // TODO: Implement delete logic
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class ChallengeActivity {
  String activity;
  String duration;

  ChallengeActivity({required this.activity, required this.duration});
}