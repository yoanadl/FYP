import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FitnessReminders extends StatefulWidget {
  @override
  _FitnessRemindersState createState() => _FitnessRemindersState();
}

class _FitnessRemindersState extends State<FitnessReminders> {
  final List<String> predefinedGoals = [
    'Daily step count',
    'Weekly workout count',
    'Daily exercise duration',
  ];

  final Map<String, String> reminders = {
    'Daily step count': '',
    'Weekly workout count': '',
    'Daily exercise duration': '',
  };

  final List<String> selectedGoals = [];
  Map<String, String> savedReminders = {};

  @override
  void initState() {
    super.initState();
    _loadSavedReminders();
  }

  void _loadSavedReminders() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;

     if (userId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("User not logged in")),
    );
    return;
  }
    try {
      final remindersCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('fitnessReminders');

      final remindersSnapshot = await remindersCollection.get();

      final Map<String, String> loadedReminders = {};
      remindersSnapshot.docs.forEach((doc) {
        loadedReminders[doc.id] = doc['value'] ?? '';
      });

      setState(() {
        savedReminders = loadedReminders;
        selectedGoals.addAll(savedReminders.keys);
        reminders.addAll(savedReminders);
      });
    }

    catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load reminders: $e")),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Fitness Reminders',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Fitness Reminders:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              ...predefinedGoals.map((goal) => CheckboxListTile(
                    title: Text(goal),
                    value: selectedGoals.contains(goal),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          selectedGoals.add(goal);
                        } else {
                          selectedGoals.remove(goal);
                          reminders[goal] = '';
                        }
                      });
                    },
                  )),
              SizedBox(height: 20),
              Text(
                'Set Reminder Details:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 15),
              ...selectedGoals.map((goal) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 40.0,
                            child: TextFormField(
                              initialValue: reminders[goal],
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10.0),
                                labelText: goal,
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  reminders[goal] = value;
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          _getUnitForGoal(goal),
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  )),
              SizedBox(height: 15),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _saveReminders();
                  },
                  child: Text('Save'),
                ),
              ),
              SizedBox(height: 20),
              if (savedReminders.isNotEmpty) ...[
                Text(
                  'Saved Fitness Reminders:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 10),
                ...savedReminders.entries.map((entry) => ListTile(
                      title: Text('${entry.key}: ${entry.value} ${_getUnitForGoal(entry.key)}'),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          setState(() {
                            // check if the goal is already in the selectedGoals list
                            if (!selectedGoals.contains(entry.key)) {
                              selectedGoals.add(entry.key);
                            }
                            reminders[entry.key] = entry.value;
                          });
                        },
                      ),
                    )),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _getUnitForGoal(String goal) {
    switch (goal) {
      case 'Daily step count':
        return 'steps';
      case 'Weekly workout count':
        return 'workouts';
      case 'Daily exercise duration':
        return 'minutes';
      default:
        return '';
    }
  }

  void _saveReminders() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;

    if (userId == null) {
      print("User not logged in");
      return;
    }

    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
    final remindersCollection = userDoc.collection('fitnessReminders');

    reminders.forEach((goal, value) async {
      if (value.isNotEmpty) {
        await remindersCollection.doc(goal).set({
          'goal': goal,
          'value': value,
        });
      }
    });

    setState(() {
      savedReminders = Map.from(reminders);
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reminders Saved'),
        content: Text('Reminders: ${reminders.toString()}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
