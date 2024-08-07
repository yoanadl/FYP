import 'package:flutter/material.dart';

class EditWorkoutPlanPage extends StatefulWidget {
  final String workoutPlan;

  EditWorkoutPlanPage({required this.workoutPlan});

  @override
  _EditWorkoutPlanPageState createState() => _EditWorkoutPlanPageState();
}

class _EditWorkoutPlanPageState extends State<EditWorkoutPlanPage> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.workoutPlan);
    _descriptionController = TextEditingController();
    // You can initialize other controllers if you have more fields.
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Workout Plan',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Workout Plan Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              style: TextStyle(fontFamily: 'Poppins', fontSize: 18),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              style: TextStyle(fontFamily: 'Poppins', fontSize: 18),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle save action here
                // For example, update the workout plan in the database
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), 
                backgroundColor: Colors.blue,
              ),
              child: Text(
                'Save',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
