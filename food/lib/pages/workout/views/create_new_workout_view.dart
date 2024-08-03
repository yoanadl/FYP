import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food/components/navbar.dart';
import 'package:food/pages/base_page.dart';
import 'package:food/pages/workout/workout_summary.dart';
import 'package:food/services/workout_service.dart'; // Import your workout service

class CreateNewWorkoutView extends StatefulWidget {
  const CreateNewWorkoutView({Key? key}) : super(key: key);

  @override
  State<CreateNewWorkoutView> createState() => _CreateNewWorkoutViewState();
}

class _CreateNewWorkoutViewState extends State<CreateNewWorkoutView> {
  final TextEditingController workoutTitleController = TextEditingController();
  List<TextEditingController> activityControllers = [TextEditingController()];
  List<TextEditingController> durationControllers = [TextEditingController(text: '10')];

  final WorkoutService workoutService = WorkoutService(); // Initialize WorkoutService

  void _addActivityField() {
    setState(() {
      activityControllers.add(TextEditingController());
      durationControllers.add(TextEditingController(text: '10'));
    });
  }

  List<Widget> _buildActivityFields() {
    List<Widget> fields = [];
    for (int i = 0; i < activityControllers.length; i++) {
      fields.add(_buildActivityField('Workout Activity ${i + 1}', activityControllers[i]));
      fields.add(_buildDurationField('Duration', durationControllers[i]));
      if (i == activityControllers.length - 1) {
        fields.add(SizedBox(height: 20));
        fields.add(
          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: _addActivityField,
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFFC8E0F4),
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                minimumSize: Size(160, 36), // Adjust the width and height here
              ),
              child: Text(
                'Add another activity',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        );
      }
    }
    return fields;
  }

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
              ..._buildActivityFields(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final uid = FirebaseAuth.instance.currentUser!.uid;
                    final workoutData = {
                      'title': workoutTitleController.text,
                      'activities': activityControllers.map((controller) => controller.text).toList(),
                      'durations': durationControllers.map((controller) => int.parse(controller.text)).toList(),
                    };
                    await workoutService.createWorkoutData(uid, workoutData);
                    // Show success message and navigate to WorkoutSummaryPage
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Workout created successfully!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WorkoutSummaryPage(
                          workoutTitle: workoutTitleController.text,
                          duration: durationControllers.map((controller) => int.parse(controller.text)).toList(),
                          activities: activityControllers.map((controller) => controller.text).toList(),
                          userId: uid,
                          workoutId: '', // Optionally, you might want to fetch or pass the workoutId
                        ),
                      ),
                    );
                  } catch (e) {
                    // Handle the error
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to create workout: $e'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff031927),
                  foregroundColor: Colors.white,
                ),
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => const BasePage(initialIndex: 0,)));
                break;
              case 1:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const BasePage(initialIndex: 1,)));
                break;
              case 2:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const BasePage(initialIndex: 2,)));
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

  Widget _buildDurationField(String labelText, TextEditingController controller) {
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
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter duration in minutes',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
