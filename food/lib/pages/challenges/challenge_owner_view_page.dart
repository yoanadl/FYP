import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food/components/base_page.dart';
import 'package:food/components/navbar.dart';
import 'package:food/pages/challenges/challenge_activity.dart';
import 'package:food/services/challenge_service.dart';

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
  late TextEditingController pointsController;
  late TextEditingController durationController;
  late List<ChallengeActivity> activities;
  bool isLoading = true;
  String? creatorNameText;

  @override
  void initState() {
    super.initState();
    _fetchChallengeData();
  }

  Future<void> _fetchChallengeData() async {
    final challengeService = ChallengeService();
    final challengeData = await challengeService.getChallengeDetails(widget.challengeId);

    if (challengeData != null) {
      setState(() {
        titleController = TextEditingController(text: challengeData['title']);
        detailsController = TextEditingController(text: challengeData['description']);
        pointsController = TextEditingController(text: challengeData['points'].toString());
        durationController = TextEditingController(text: challengeData['duration']);
        activities = (challengeData['activities'] as List<dynamic>)
            .map((activity) => ChallengeActivity(
                  activity: activity['name'],
                  duration: activity['duration'],
                ))
            .toList();
        isLoading = false;
      });

      // Fetch the creator's name
      final creatorName = await challengeService.fetchCreatorName(challengeData['creatorUid']);
      setState(() {
        // Add 'Created by' text with the creator's name
        creatorNameText = 'Created by: $creatorName';
        isLoading = false;
      });

    } else {
      print('Challenge data not found');
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
                : Text(titleController.text, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
                    controller: pointsController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Points'),
                  )
                : Text('Rewards: ${pointsController.text} pts'),
            SizedBox(height: 25),
            isEditing
                ? TextField(
                    controller: durationController,
                    decoration: InputDecoration(labelText: 'Duration'),
                  )
                : Text('Duration: ${durationController.text}'),
            SizedBox(height: 25),
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
            switch (index) {
              case 0:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const BasePage(initialIndex: 0)));
                break;
              case 1:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const BasePage(initialIndex: 1)));
                break;
              case 3:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const BasePage(initialIndex: 3)));
                break;
            }
          }
        },
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
              'name': activity.activity,
              'duration': activity.duration,
            })
        .toList();

    await challengeService.updateChallenge(
      challengeId: widget.challengeId,
      title: titleController.text,
      details: detailsController.text,
      points: int.parse(pointsController.text), // Convert pointsController text to int
      activities: activitiesData,
      startDate: Timestamp.fromDate(DateTime.now()), // Update as needed
      endDate: Timestamp.fromDate(DateTime.now().add(Duration(days: 7))), // Update as needed
      duration: durationController.text,
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
