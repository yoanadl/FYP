import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food/components/base_page.dart';
import 'package:food/components/navbar.dart';
import 'package:food/pages/challenges/challenge_activity.dart';
import 'package:food/pages/challenges/challenge_owner_view_page.dart';
import 'package:food/services/challenge_service.dart';
import 'package:flutter/services.dart'; // Import this for TextInputFormatter


class CreateNewChallengePage extends StatefulWidget {
  @override
  _CreateNewChallengePageState createState() => _CreateNewChallengePageState();
}

class _CreateNewChallengePageState extends State<CreateNewChallengePage> {
  final _titleController = TextEditingController();
  final _detailsController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
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
  return Scaffold(
    backgroundColor: Colors.white,
    body: SingleChildScrollView(
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
          TextField(
            controller: TextEditingController(text: _calculateDuration()), // Non-editable duration
            decoration: InputDecoration(labelText: 'Challenge Duration'),
            readOnly: true,
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text('Start Date: ${_startDate != null ? _startDate!.toLocal().toString().split(' ')[0] : 'Select'}'),
              ),
              ElevatedButton(
                onPressed: () async {
                  DateTime? selectedDate = await _showIOSDatePicker(_startDate, true);
                  if (selectedDate != null) {
                    setState(() {
                      _startDate = selectedDate;
                    });
                  }
                },
                child: Text('Pick Start Date'),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text('End Date: ${_endDate != null ? _endDate!.toLocal().toString().split(' ')[0] : 'Select'}'),
              ),
              ElevatedButton(
                onPressed: () async {
                  DateTime? selectedDate = await _showIOSDatePicker(_endDate, false);
                  if (selectedDate != null) {
                    setState(() {
                      _endDate = selectedDate;
                    });
                  }
                },
                child: Text('Pick End Date'),
              ),
            ],
          ),
          SizedBox(height: 24), // Add some spacing
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
          SizedBox(height: 24), // Add some spacing
        ],
      ),
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
                   ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Challenge created successfully!'),
                    ),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChallengeOwnerViewPage(
                        challengeId: challengeId,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildActivityInput(int index) {
  //   return Card(
  //     color: Colors.white,
  //     margin: EdgeInsets.symmetric(vertical: 8),
  //     child: Padding(
  //       padding: EdgeInsets.all(16.0),
  //       child: Row(
  //         children: [
  //           Expanded(
  //             flex: 3,
  //             child: TextField(
  //               decoration: InputDecoration(labelText: 'Challenge Activity ${index + 1}'),
  //               onChanged: (value) {
  //                 setState(() {
  //                   activities[index].activity = value;
  //                 });
  //               },
  //             ),
  //           ),
  //           SizedBox(width: 16),
  //           Expanded(
  //             flex: 1,
  //             child: TextField(
  //               decoration: InputDecoration(labelText: 'Duration'),
  //               keyboardType: TextInputType.number,
  //               onChanged: (value) {
  //                 setState(() {
  //                   activities[index].duration = value;
  //                 });
  //               },
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildActivityInput(int index) {
  return Card(
    color: Colors.white,
    margin: EdgeInsets.symmetric(vertical: 8),
    child: Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextField(
              decoration: InputDecoration(labelText: 'Challenge Activity ${index + 1}'),
              onChanged: (value) {
                setState(() {
                  activities[index].activity = value;
                });
              },
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            flex: 1,
            child: TextField(
              decoration: InputDecoration(labelText: 'Duration'),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Allow only digits
              onChanged: (value) {
                setState(() {
                  activities[index].duration = value;
                });
              },
            ),
          ),
        ],
      ),
    ),
  );
}

  Future<String?> _createChallenge() async {
    final challengeService = ChallengeService();
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return null;

    final creatorUid = user.uid;
    final participants = <String>[creatorUid]; 

    final challengeId = await challengeService.createChallenge(
      title: _titleController.text,
      details: _detailsController.text,
      activities: activities
          .map((activity) => {'name': activity.activity, 'duration': activity.duration})
          .toList(),
      creatorUid: creatorUid,
      participants: participants,
      startDate: Timestamp.fromDate(_startDate ?? DateTime.now()),
      endDate: Timestamp.fromDate(_endDate ?? DateTime.now()),
      duration: _calculateDuration(), // Use calculated duration
    );

    // Add the challenge ID to the user's document with type 'own'
    if (challengeId != null) {
      await challengeService.addOwnChallengeToUserDoc(creatorUid, challengeId);
    }

    return challengeId;
  }

  Future<DateTime?> _showIOSDatePicker(DateTime? initialDate, bool isStartDate) async {
    DateTime currentDate = DateTime.now();

    return showModalBottomSheet<DateTime>(
      context: context,
      builder: (context) => Container(
        height: 300,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.date,
          initialDateTime: initialDate ?? currentDate,
          minimumDate: isStartDate ? currentDate : null,
          onDateTimeChanged: (dateTime) {
            if (isStartDate && dateTime.isBefore(currentDate)) {
              // Ensure the start date is not before today
              dateTime = currentDate;
            }
            if (!isStartDate && (dateTime.isBefore(_startDate ?? currentDate))) {
              // Ensure the end date is not before the start date
              dateTime = _startDate ?? currentDate;
            }
            setState(() {
              // Update the relevant state variable (startDate/endDate)
              if (isStartDate) {
                _startDate = dateTime;
              } else {
                _endDate = dateTime;
              }
            });
          },
        ),
      ),
    ).then((dateTime) {
      if (dateTime != null) {
        Navigator.pop(context, dateTime);
      }
    });
  }

  String _calculateDuration() {
    if (_startDate != null && _endDate != null) {
      final duration = _endDate!.difference(_startDate!);
      return '${duration.inDays} days';
    }
    return '0 days';
  }
}


