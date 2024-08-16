import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth; 
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food/components/base_page.dart';
import 'package:food/components/navbar.dart';
import 'package:food/pages/challenges/challenge_activity_page.dart';
import 'package:food/pages/challenges/challenge_results.dart';
import 'package:food/pages/challenges/leaderboard.dart';
import 'package:food/pages/user/model/user_model.dart';
import 'package:food/services/challenge_service.dart';
import 'package:food/pages/challenges/challenge_activity.dart';

class ChallengeOwnerViewPage extends StatefulWidget {
  final String challengeId;

  ChallengeOwnerViewPage({
    required this.challengeId,
  });

  @override
  _ChallengeOwnerViewPageState createState() => _ChallengeOwnerViewPageState();
}

class _ChallengeOwnerViewPageState extends State<ChallengeOwnerViewPage> {
  bool isEditing = false;
  late TextEditingController titleController;
  late TextEditingController detailsController;
  late TextEditingController durationController;
  late TextEditingController startDateController;
  late TextEditingController endDateController;

  List<ChallengeActivity> activities = [];
  bool isLoading = true;
  String? creatorNameText;
  bool canStartChallenge = true;
  bool hasEnded = false; 

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    detailsController = TextEditingController();
    durationController = TextEditingController();
    startDateController = TextEditingController();
    endDateController = TextEditingController();
    _fetchChallengeData();
  }

  Future<void> _fetchChallengeData() async {
    final challengeService = ChallengeService();
    try {
      final challengeData = await challengeService.getChallengeDetails(widget.challengeId);

      if (challengeData != null) {
        setState(() {
          titleController.text = challengeData['title'] ?? '';
          detailsController.text = challengeData['description'] ?? '';
          durationController.text = challengeData['duration'] ?? '';
          activities = (challengeData['activities'] as List<dynamic>)
              .map((activity) => ChallengeActivity(
                    activity: activity['name'] ?? '',
                    duration: activity['duration'] ?? '',
                  ))
              .toList();
          creatorNameText = 'Created by: ${challengeData['creatorName'] ?? 'Unknown'}';
          isLoading = false;

          // Check challenge dates
          final startDate = (challengeData['startDate'] as Timestamp).toDate();
          final endDate = (challengeData['endDate'] as Timestamp).toDate();
          final now = DateTime.now();

          startDateController.text = startDate.toLocal().toString().split(' ')[0];
endDateController.text = endDate.toLocal().toString().split(' ')[0]; 

          if (now.isBefore(startDate)) {
            canStartChallenge = false;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Challenge hasn\'t started yet')),
            );
          } else if (now.isAfter(endDate)) {
            canStartChallenge = false;
            hasEnded = true; // Set flag to true if the challenge has ended
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Challenge has ended')),
            );
          }
        });
      } else {
        print('Challenge data not found');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching challenge data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
        title: isEditing
            ? TextField(controller: titleController)
            : Text(titleController.text, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.emoji_events),
            onPressed: () {
              if (hasEnded) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChallengeResultsPage(challengeId: widget.challengeId)),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LeaderboardPage(challengeId: widget.challengeId)),
                );
              }
            },
          ),
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
        padding: EdgeInsets.all(35.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (creatorNameText != null) ...[
              Text(
                creatorNameText!,
                style: TextStyle(fontSize: 14, color: Colors.grey[900]),
              ),
              SizedBox(height: 25),
            ],
            isEditing
                ? TextField(controller: detailsController, maxLines: 3)
                : Text(detailsController.text),
            SizedBox(height: 25),
              isEditing
          ? TextField(
              controller: startDateController,
              decoration: InputDecoration(labelText: 'Start Date'),
            )
          : Text('Start Date: ${startDateController.text}'),
            SizedBox(height: 25),
            isEditing
                ? TextField(
                    controller: endDateController,
                    decoration: InputDecoration(labelText: 'End Date'),
                  )
                : Text('End Date: ${endDateController.text}'),
             SizedBox(height: 25),
              Text('Rewards: 100 pts per round'),
            SizedBox(height: 25),
            isEditing
                ? TextField(
                    controller: durationController,
                    decoration: InputDecoration(labelText: 'Duration'),
                  )
                : Text('Duration: ${durationController.text}'),
            SizedBox(height: 25),
            Text(
              'Activities', 
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  return _buildActivityItem(activities[index], index);
                },
              ),
            ),
            SizedBox(height: 15), 

            if (isEditing)
              Center(
                child: ElevatedButton(
                  child: Text('Save Changes'),
                  onPressed: () async {
                    await _updateChallenge();
                    await _fetchChallengeData();
                    setState(() {
                      isEditing = false;
                    });
                  },
                ),
              )
            else
              Center(
                child: ElevatedButton(
                  child: Text(
                    'Start Challenge',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF031927),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: canStartChallenge
                      ? () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChallengeActivityPage(challengeId: widget.challengeId),
                          ),
                        )
                      : null,
                ),
              ),
          ],
        ),
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

    List<Map<String, String>> activitiesData = activities
        .where((activity) => activity.activity.isNotEmpty && activity.duration.isNotEmpty)
        .map((activity) => {
              'name': activity.activity,
              'duration': activity.duration,
            })
        .toList();

    try {
      await challengeService.updateChallenge(
        challengeId: widget.challengeId,
        title: titleController.text,
        details: detailsController.text,
        activities: activitiesData,
        startDate: Timestamp.fromDate(DateTime.parse(startDateController.text)), 
        endDate: Timestamp.fromDate(DateTime.parse(endDateController.text)), 
        duration: durationController.text,
      );
    } catch (e) {
      print("Error updating challenge: $e");
    }
  }


  void _showDeleteDialog() {
  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete this challenge?'),
        actions: [
          CupertinoDialogAction(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            child: Text('Delete'),
            onPressed: () async {
              await _deleteChallenge();
              Navigator.of(context).pop(); // Close the dialog
              Navigator.pop(context); // Go back to previous page after deletion
            },
          ),
        ],
      );
    },
  );
}

  Future<void> _deleteChallenge() async {

  final auth.User? user = auth.FirebaseAuth.instance.currentUser;
  
  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('No user is currently signed in.'))
    );
    return;
  }

  final String userId = user.uid;
  final challengeService = ChallengeService();

  try {
    await challengeService.deleteChallenge(widget.challengeId, userId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Challenge deleted'))
    );
  } catch (e) {
    print("Error deleting challenge: $e");
  }
}
  
}
