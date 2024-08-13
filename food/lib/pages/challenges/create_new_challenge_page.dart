import 'package:flutter/material.dart';
import 'package:food/components/base_page.dart';
import 'package:food/components/navbar.dart';
import 'package:food/pages/challenges/challenge_owner_view_page.dart';
import 'package:food/services/challenge_service.dart';
import 'package:food/pages/challenges/challenge_activity.dart';

class CreateNewChallengePage extends StatefulWidget {
  @override
  _CreateNewChallengePageState createState() => _CreateNewChallengePageState();
}

class _CreateNewChallengePageState extends State<CreateNewChallengePage> {
  final _titleController = TextEditingController();
  final _detailsController = TextEditingController();
  final _pointsController = TextEditingController();
  bool isFirstPage = true;
  List<ChallengeActivity> activities = List.generate(4, (index) => ChallengeActivity());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Create New Challenge',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: isFirstPage ? _buildFirstPage() : _buildSecondPage(),
      ),
      bottomNavigationBar: Navbar(
        currentIndex: 2,
        onTap: (int index) {
          if (index != 2) {
            Navigator.pop(context);
            switch (index) {
              case 0:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const BasePage(initialIndex: 0,)));
                break;
              case 1:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const BasePage(initialIndex: 1,)));
                break;
              case 3:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const BasePage(initialIndex: 3,)));
                break;
            }
          }
        },
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
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Challenge Title'),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _detailsController,
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
                  controller: _pointsController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  textAlign: TextAlign.right,
                  keyboardType: TextInputType.number,
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
              onPressed: () async {
                String? challengeId = await _createChallenge();
                if (challengeId != null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChallengeOwnerViewPage(
                        challengeId: challengeId,
                        title: _titleController.text,
                        details: _detailsController.text,
                        points: int.tryParse(_pointsController.text) ?? 0,
                        activities: activities,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to create challenge')),
                  );
                }
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
            decoration: InputDecoration(
              labelText: 'Challenge Activity ${index + 1}',
            ),
            onChanged: (value) {
              activities[index].activity = value;
            },
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          flex: 1,
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Duration',
            ),
            onChanged: (value) {
              activities[index].duration = value;
            },
          ),
        ),
      ],
    );
  }

  Future<String?> _createChallenge() async {
    final challengeService = ChallengeService();

    // Convert List<ChallengeActivity> to List<Map<String, String>>
    List<Map<String, String>> activitiesData = activities
        .where((activity) => activity.activity.isNotEmpty && activity.duration.isNotEmpty)
        .map((activity) => {
              'activity': activity.activity,
              'duration': activity.duration,
            })
        .toList();

    try {
      String challengeId = await challengeService.createChallenge(
        title: _titleController.text,
        details: _detailsController.text,
        points: int.tryParse(_pointsController.text) ?? 0,
        activities: activitiesData,
      );
      return challengeId;
    } catch (e) {
      print("Error creating challenge: $e");
      return null;
    }
  }
}
