import 'package:flutter/material.dart';
import 'package:food/pages/profile_page.dart';

import '../../components/navbar.dart';
import '../base_page.dart';
import '../community_page.dart';
import 'workout_page.dart';
import 'workout_summary.dart';

class CreateNewWorkoutPage extends StatefulWidget {
  const CreateNewWorkoutPage({Key? key}) : super(key: key);

  @override
  State<CreateNewWorkoutPage> createState() => _CreateNewWorkoutPageState();
}

class _CreateNewWorkoutPageState extends State<CreateNewWorkoutPage> {
  int selectedDuration = 10;
  TextEditingController workoutTitleController = TextEditingController();
  List<String> workoutActivities = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Create New Workout',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 50, right: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              Text(
                'Workout Title',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              TextField(
                controller: workoutTitleController,
                decoration: InputDecoration(
                  hintText: 'Enter workout title',
                ),
              ),
              SizedBox(height: 20),
              _buildActivityField('Workout Activity 1'),
              _buildDurationField('Duration'),
              _buildActivityField('Workout Activity 2'),
              _buildDurationField('Duration'),
              _buildActivityField('Workout Activity 3'),
              _buildDurationField('Duration'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _createWorkout();
                },
                child: Text('Create Workout'),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Navbar(
        currentIndex: 1,
        onTap: (int index) {
          if (index != 1) {
            Navigator.pop(context);
            switch (index) {
              case 0:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const BasePage()));
                break;
              case 1:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const WorkoutPage()));
                break;
              case 2:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CommunityPage()));
                break;
              case 3:
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
                break;
            }
          }
        },
      ),
    );
  }

  void _createWorkout() {
    // Summarize workout details
    String workoutTitle = workoutTitleController.text;
    List<String> activities = [];
    
    for (String activity in workoutActivities) {
      activities.add(activity);
    }

    // Navigate to summary page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutSummaryPage(
          workoutTitle: workoutTitle,
          duration: selectedDuration,
          activities: activities,
        ),
      ),
    );
  }

  Widget _buildActivityField(String labelText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 20),
        Text(
          labelText,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        TextField(
          onChanged: (value) {
            // Update activity list on change
            workoutActivities.add(value);
          },
          decoration: InputDecoration(
            hintText: 'Enter workout activity',
          ),
        ),
      ],
    );
  }

  Widget _buildDurationField(String labelText) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 20, right: 10),
            child: Text(
              labelText,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: DropdownButtonFormField<int>(
              value: selectedDuration,
              items: List.generate(
                6,
                (index) => DropdownMenuItem(
                  value: (index + 1) * 10,
                  child: Text('${(index + 1) * 10} min'),
                ),
              ),
              onChanged: (int? newValue) {
                setState(() {
                  selectedDuration = newValue!;
                });
              },
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

