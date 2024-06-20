import 'package:flutter/material.dart';

class EditWorkoutPage extends StatelessWidget {
  final String workoutTitle;
  final List<int> durations;
  final List<String> activities;
  final String uid;

  const EditWorkoutPage({
    Key? key,
    required this.workoutTitle,
    required this.durations,
    required this.activities,
    required this.uid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Workout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Text(
              'Workout Title',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter workout title',
                labelText: workoutTitle,
              ),
            ),
            SizedBox(height: 20),
            for (int i = 0; i < activities.length; i++)
              _buildActivityField('Workout Activity ${i + 1}', activities[i]),
            SizedBox(height: 20),
            for (int i = 0; i < durations.length; i++)
              _buildDurationField('Duration', durations[i]),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle save button logic
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityField(String labelText, String initialValue) {
    TextEditingController controller = TextEditingController(text: initialValue);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 20),
        Text(
          labelText,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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

  Widget _buildDurationField(String labelText, int initialValue) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 20, right: 10),
            child: Text(
              labelText,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: DropdownButtonFormField<int>(
              value: initialValue,
              items: List.generate(
                6,
                (index) => DropdownMenuItem(
                  value: (index + 1) * 10,
                  child: Text('${(index + 1) * 10} min'),
                ),
              ),
              onChanged: (int? newValue) {
                if (newValue != null) {
                  // Handle duration change
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
