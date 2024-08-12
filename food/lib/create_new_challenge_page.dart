import 'package:flutter/material.dart';
import 'package:food/challenge_owner_view_page.dart';

class CreateNewChallengePage extends StatefulWidget {
  @override
  _CreateNewChallengePageState createState() => _CreateNewChallengePageState();
}

class _CreateNewChallengePageState extends State<CreateNewChallengePage> {
  bool isFirstPage = true;
  List<ChallengeActivity> activities = List.generate(4, (index) => ChallengeActivity());

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
        title: Text('Create New Challenge'),
      ),
      body: isFirstPage ? _buildFirstPage() : _buildSecondPage(),
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

  Widget _buildFirstPage() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Challenge Title'),
          ),
          SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(labelText: 'Challenge Details'),
            maxLines: 3,
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Points'),
              SizedBox(width: 16),
              SizedBox(
                width: 100,
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          Spacer(),
          Center(
            child: ElevatedButton(
              child: Text('Next'),
              onPressed: () {
                setState(() {
                  isFirstPage = false;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondPage() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: activities.length,
              itemBuilder: (context, index) {
                return _buildActivityInput(index);
              },
            ),
          ),
          Center(
            child: ElevatedButton(
              child: Text('Add another activity'),
              onPressed: () {
                setState(() {
                  activities.add(ChallengeActivity());
                });
              },
            ),
          ),
          SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              child: Text('Create Challenge'),
              onPressed: () {
                // TODO: Implement challenge creation logic
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ChallengeOwnerViewPage()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityInput(int index) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextField(
            decoration: InputDecoration(labelText: 'Challenge Activity ${index + 1}'),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          flex: 1,
          child: TextField(
            decoration: InputDecoration(labelText: 'Duration'),
          ),
        ),
      ],
    );
  }
}

class ChallengeActivity {
  String activity = '';
  String duration = '';
}