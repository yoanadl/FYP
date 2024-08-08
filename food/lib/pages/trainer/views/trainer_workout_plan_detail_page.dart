import 'package:flutter/material.dart';

class TrainerWorkoutPlanDetailPage extends StatefulWidget {
  @override
  _TrainerWorkoutPlanDetailPageState createState() => _TrainerWorkoutPlanDetailPageState();
}

class _TrainerWorkoutPlanDetailPageState extends State<TrainerWorkoutPlanDetailPage> {
  bool isEditing = false;
  int _selectedDayIndex = -1; // -1 indicates no day is selected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            'Workout Plan',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              fontSize: 25,
            ),
          ),
        ),
        actions: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  setState(() {
                    isEditing = !isEditing;
                  });
                },
              ),
              const SizedBox(width: 4),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Are you sure you want to delete this workout plan?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              // Handle delete action
                              Navigator.of(context).pop();
                            },
                            child: Text('Yes'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('No'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              const SizedBox(width: 16), // Add some padding to the right
            ],
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(16, 24, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Days',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              height: 48.0, // Set a fixed height for the horizontal list
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(7, (index) {
                    bool isSelected = _selectedDayIndex == index;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedDayIndex = index;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: isSelected ? Colors.white : Colors.black54,
                          backgroundColor: isSelected ? Color(0XFF9DD1F1) : Colors.grey[300],
                          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.black : Colors.black54,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: 1, // Example workout activity count
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(
                        child: TextField(
                          enabled: isEditing,
                          decoration: InputDecoration(
                            hintText: 'Workout Activity ${index + 1}',
                          ),
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: TextField(
                          enabled: isEditing,
                          decoration: InputDecoration(
                            hintText: 'Duration',
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            if (isEditing)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Handle save changes action
                  },
                  child: Text('Save Changes'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
