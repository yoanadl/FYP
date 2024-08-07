import 'package:flutter/material.dart';
import 'package:food/pages/workout/presenters/edit_workout_presenter.dart';
import 'package:food/services/workout_service.dart';

class EditWorkoutView extends StatefulWidget {
  final String userId;
  final String workoutId;
  final String workoutTitle;
  final List<int> duration;
  final List<String> activities;

  EditWorkoutView({
    required this.userId,
    required this.workoutId,
    required this.workoutTitle,
    required this.duration,
    required this.activities,
  });

  @override
  _EditWorkoutViewState createState() => _EditWorkoutViewState();
}

class _EditWorkoutViewState extends State<EditWorkoutView> implements EditWorkoutViewInterface {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final List<TextEditingController> _activityControllers = [];
  final List<TextEditingController> _durationControllers = [];
  late EditWorkoutPresenter _presenter;

  @override
  void initState() {
    super.initState();
    _presenter = EditWorkoutPresenter(WorkoutService());
    _presenter.attachView(this);

    _titleController.text = widget.workoutTitle;
    _activityControllers.addAll(widget.activities.map((activity) => TextEditingController(text: activity)));
    _durationControllers.addAll(widget.duration.map((duration) => TextEditingController(text: duration.toString())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Workout'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Workout Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Column(
                children: List.generate(
                  _activityControllers.length,
                  (index) => Column(
                    children: [
                      _buildActivityField('Workout Activity ${index + 1}', _activityControllers[index]),
                      SizedBox(height: 10),
                      _buildDurationField('Duration', _durationControllers[index]),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _saveWorkout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff031927),
                  foregroundColor: Colors.white,
                ),
                child: Text('Save Workout'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityField(String labelText, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a value';
        }
        return null;
      },
    );
  }

  Widget _buildDurationField(String labelText, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: 'Enter duration in minutes',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a value';
        }
        int? duration = int.tryParse(value);
        if (duration == null || duration <= 0) {
          return 'Please enter a valid duration (positive number)';
        }
        return null;
      },
    );
  }

  void _saveWorkout() {
    if (_formKey.currentState!.validate()) {
      List<String> activities = _activityControllers.map((controller) => controller.text.trim()).toList();
      List<int> durations = _durationControllers.map((controller) => int.tryParse(controller.text.trim()) ?? 0).toList();
      _presenter.saveWorkout(widget.userId, widget.workoutId, _titleController.text, activities, durations);
    }
  }

  @override
  void onSaveSuccess() {
    Navigator.pop(context);
  }

  @override
  void onSaveError(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text('Failed to save workout: $error'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _activityControllers.forEach((controller) => controller.dispose());
    _durationControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }
}
