import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class EditWorkoutPage extends StatefulWidget {
  
  final String userId;
  final String workoutId;
  final String workoutTitle;
  final List<int> duration;
  final List<String> activities;

  EditWorkoutPage({
    required this.userId,
    required this.workoutId,
    required this.workoutTitle,
    required this.duration,
    required this.activities,
  });

  @override
  _EditWorkoutPageState createState() => _EditWorkoutPageState();
}

class _EditWorkoutPageState extends State<EditWorkoutPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _activitiesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadWorkoutDetails();
  }

  void _loadWorkoutDetails() {
    // Load workout details from Firestore using workoutId
    // and set the text controllers with the loaded data.
    Example:
    _titleController.text = widget.workoutTitle;
    _durationController.text =  widget.duration.join(', ');
    _activitiesController.text = widget.activities.join(', ');
  }

  void _saveWorkout() {
    if (_formKey.currentState!.validate()) {
      // Save edited workout details to Firestore
      try {
        List<int> durations = _durationController.text.split(',').map((e) => int.parse(e.trim())).toList();
        List<String> activities = _activitiesController.text.split(',').map((e) => e.trim()).toList();

        FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('workouts')
          .doc(widget.workoutId)
          .update({
            'title': _titleController.text,
            'duration': durations,
            'activities': activities,
          });

        // After saving, you can navigate back or show a success message.
        Navigator.pop(context);
      } catch (e) {
        print('Error saving workout: $e');
        // Handle error saving workout
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Workout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _durationController,
                decoration: InputDecoration(labelText: 'Duration'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a duration';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _activitiesController,
                decoration: InputDecoration(labelText: 'Activities'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter activities';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveWorkout,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    _activitiesController.dispose();
    super.dispose();
  }
}
