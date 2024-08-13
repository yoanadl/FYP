import 'package:flutter/material.dart';
import 'package:food/components/base_page.dart';
import 'package:food/components/navbar.dart';
import 'package:food/pages/challenges/challenge_activity.dart';
import 'package:food/services/challenge_service.dart';

class ChallengeOwnerViewPage extends StatefulWidget {
  final String challengeId; // Add challengeId parameter
  final String title;
  final String details;
  final int points;
  final List<ChallengeActivity> activities;

  ChallengeOwnerViewPage({
    required this.challengeId,
    required this.title,
    required this.details,
    required this.points,
    required this.activities,
  });

  @override
  _ChallengeOwnerViewPageState createState() => _ChallengeOwnerViewPageState();
}

class _ChallengeOwnerViewPageState extends State<ChallengeOwnerViewPage> {
  bool isEditing = false;
  late TextEditingController titleController;
  late TextEditingController detailsController;
  late List<ChallengeActivity> activities;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.title);
    detailsController = TextEditingController(text: widget.details);
    activities = widget.activities;
  }

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
        title: Text(widget.title),
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
                : Text(widget.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            isEditing
                ? TextField(controller: detailsController, maxLines: 3)
                : Text(widget.details),
            SizedBox(height: 16),
            Text('Rewards: ${widget.points} pts'),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  return _buildActivityItem(activities[index], index);
                },
              ),
            ),
            if (isEditing)
              Center(
                child: ElevatedButton(
                  child: Text('Save Changes'),
                  onPressed: () async {
                    await _updateChallenge();
                    setState(() {
                      isEditing = false;
                    });
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
      bottomNavigationBar: Navbar(
        currentIndex: 2,
        onTap: (int index) {
          if (index != 2) {
            Navigator.pop(context);
            switch(index) {
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
        }
      ),
    );
  }

  Widget _buildActivityItem(ChallengeActivity activity, int index) {
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
                    onChanged: (value) => activities[index].activity = value,
                  )
                : Text(activity.activity),
          ),
          SizedBox(width: 16),
          Expanded(
            flex: 1,
            child: isEditing
                ? TextField(
                    controller: TextEditingController(text: activity.duration),
                    onChanged: (value) => activities[index].duration = value,
                  )
                : Text(activity.duration),
          ),
        ],
      ),
    );
  }

  Future<void> _updateChallenge() async {
    final challengeService = ChallengeService();

    // Convert List<ChallengeActivity> to List<Map<String, String>>
    List<Map<String, String>> activitiesData = activities
        .where((activity) => activity.activity.isNotEmpty && activity.duration.isNotEmpty)
        .map((activity) => {
              'activity': activity.activity,
              'duration': activity.duration,
            })
        .toList();

    await challengeService.updateChallenge(
      challengeId: widget.challengeId,
      title: titleController.text,
      details: detailsController.text,
      points: widget.points, // Assuming points do not change, modify if needed
      activities: activitiesData,
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
              onPressed: () async {
                await _deleteChallenge();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteChallenge() async {
    final challengeService = ChallengeService();

    try {
      await challengeService.deleteChallenge(widget.challengeId);
    } catch (e) {
      print("Error deleting challenge: $e");
    }
  }
}
