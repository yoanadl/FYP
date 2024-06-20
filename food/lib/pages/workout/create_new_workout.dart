import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../components/navbar.dart';
import '../base_page.dart';
import '../community_page.dart';
import '../profile_page.dart';
import 'workout_page.dart';
import 'workout_summary.dart';
import 'package:food/services/workout_service.dart';

class CreateNewWorkoutPage extends StatefulWidget {
  const CreateNewWorkoutPage({Key? key}) : super(key: key);

  @override
  State<CreateNewWorkoutPage> createState() => _CreateNewWorkoutPageState();
}

class _CreateNewWorkoutPageState extends State<CreateNewWorkoutPage> {
  final TextEditingController workoutTitleController = TextEditingController();
  final TextEditingController activity1Controller = TextEditingController();
  final TextEditingController activity2Controller = TextEditingController();
  final TextEditingController activity3Controller = TextEditingController();
  int activity1Duration = 10;
  int activity2Duration = 10;
  int activity3Duration = 10;

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
              _buildActivityField('Workout Activity 1', activity1Controller),
              _buildDurationField('Duration', activity1Duration, (value) {
                setState(() {
                  activity1Duration = value;
                });
              }),
              _buildActivityField('Workout Activity 2', activity2Controller),
              _buildDurationField('Duration', activity2Duration, (value) {
                setState(() {
                  activity2Duration = value;
                });
              }),
              _buildActivityField('Workout Activity 3', activity3Controller),
              _buildDurationField('Duration', activity3Duration, (value) {
                setState(() {
                  activity3Duration = value;
                });
              }),
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

  void _createWorkout() async {
    String workoutTitle = workoutTitleController.text;
    List<String> activities = [
      activity1Controller.text,
      activity2Controller.text,
      activity3Controller.text,
    ];
    List<int> durations = [
      activity1Duration,
      activity2Duration,
      activity3Duration,
    ];

    // Get current user
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('User is not authenticated');
      return;
    }

    // Validate if workout title is filled
    if (workoutTitle.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Please enter a workout title.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Call Firestore service to create workout
    try {
      await WorkoutService().createWorkoutData(user.uid, {
        'title': workoutTitle,
        'activities': activities,
        'durations': durations,
      });

      // Navigate to summary page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WorkoutSummaryPage(
            workoutTitle: workoutTitle,
            duration: durations,
            activities: activities,
          ),
        ),
      );
    } catch (e) {
      print('Failed to create workout: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to create workout. Please try again later.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildActivityField(String labelText, TextEditingController controller) {
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
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter workout activity',
          ),
        ),
      ],
    );
  }

  Widget _buildDurationField(String labelText, int initialDuration, Function(int) onChanged) {
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
              value: initialDuration,
              items: List.generate(
                6,
                (index) => DropdownMenuItem(
                  value: (index + 1) * 10,
                  child: Text('${(index + 1) * 10} min'),
                ),
              ),
              onChanged: (int? newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
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
