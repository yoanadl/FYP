import 'package:flutter/material.dart';
import 'package:food/pages/challenges/leaderboard.dart';

class ChallengeOwnerViewJoinedPage extends StatefulWidget {
  @override
  _ChallengeOwnerViewJoinedPageState createState() => _ChallengeOwnerViewJoinedPageState();
}

class _ChallengeOwnerViewJoinedPageState extends State<ChallengeOwnerViewJoinedPage> {
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Challenge Title'),
        actions: [
          IconButton(
            icon: Icon(Icons.emoji_events),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LeaderboardPage()),
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => setState(() => isEditing = !isEditing),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isEditing
                ? TextField(controller: TextEditingController(text: 'Challenge Title'))
                : Text('Challenge Title', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            isEditing
                ? TextField(
                    controller: TextEditingController(text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'),
                    maxLines: 3,
                  )
                : Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'),
            SizedBox(height: 16),
            Text('Rewards: 00 pts'),
            SizedBox(height: 16),
            _buildActivityList(),
            Spacer(),
            Center(
              child: ElevatedButton(
                child: Text(isEditing ? 'Save Changes' : 'Quit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isEditing ? Colors.blue : Colors.red,
                ),
                onPressed: isEditing
                    ? () {
                        // TODO: Implement save changes logic
                        setState(() => isEditing = false);
                      }
                    : _showQuitDialog,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildActivityList() {
    List<Map<String, String>> activities = [
      {'name': 'Challenge Activity 1', 'duration': '000 reps'},
      {'name': 'Challenge Activity 2', 'duration': '000 mins'},
      {'name': 'Challenge Activity 3', 'duration': '000 reps'},
      {'name': 'Challenge Activity 4', 'duration': '000 mins'},
    ];

    return Column(
      children: activities.map((activity) => _buildActivityItem(activity)).toList(),
    );
  }

  Widget _buildActivityItem(Map<String, String> activity) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: isEditing
                ? TextField(controller: TextEditingController(text: activity['name']))
                : Text(activity['name']!),
          ),
          SizedBox(width: 16),
          Expanded(
            flex: 1,
            child: isEditing
                ? TextField(controller: TextEditingController(text: activity['duration']))
                : Text(activity['duration']!),
          ),
        ],
      ),
    );
  }

  void _showQuitDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Quit Challenge'),
          content: Text('Are you sure you want to quit this challenge?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Quit', style: TextStyle(color: Colors.red)),
              onPressed: () {
                // TODO: Implement quit logic
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 2,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Workout'),
        BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Community'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}