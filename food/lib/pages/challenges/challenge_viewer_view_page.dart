import 'package:flutter/material.dart';
import 'package:food/pages/challenges/leaderboard.dart';

class ChallengeViewerViewPage extends StatelessWidget {
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
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Challenge Title', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'),
            SizedBox(height: 16),
            Text('Rewards: 00 pts'),
            SizedBox(height: 16),
            _buildActivityList(),
            Spacer(),
            Center(
              child: ElevatedButton(
                child: Text('Start'),
                onPressed: () {
                  // TODO: Implement start logic
                
                },
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
          Text(activity['name']!),
          Text(activity['duration']!),
        ],
      ),
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