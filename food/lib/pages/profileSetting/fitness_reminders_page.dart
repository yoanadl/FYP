import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food/services/notification_service.dart'; 
import 'dart:async';
import 'dart:math';

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
  final NotificationService _notificationService = NotificationService();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Flag to track if the notification has been sent
  bool _notificationSent = false;

  Timer? _notificationTimer;

  @override
  void initState() {
    super.initState();
    _loadSavedReminders();
  }

  void _schedulePeriodicChecks() {
  print("inside periodic checks");

  try {

    _notificationTimer?.cancel(); // Cancel any existing timer

    // default check every 3 hours
    _notificationTimer = Timer.periodic(Duration(hours: 3), (timer) {
      print("Timer triggered at ${DateTime.now()}");
      _checkAndNotifyGoals();
    });
  } catch (e) {
    print("Error scheduling periodic checks: $e");
  }
}

  Future<void> _checkAndNotifyGoals() async {
    try {
      print("Checking and notifying goals...");
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final userId = user.uid;
      final userDoc = firestore.collection('users').doc(userId);
      final remindersCollection = userDoc.collection('fitnessReminders');

      if (!_notificationSent) {
        // Check if the daily step goal reminder exists
        final stepGoalDoc = await remindersCollection.doc('Daily step count').get();
        if (stepGoalDoc.exists) {
          await _notificationService.checkDailyStepGoal(); // Check if the daily step goal is met
        }

        // Check if the daily exercise duration reminder exists
        final exerciseGoalDoc = await remindersCollection.doc('Daily exercise duration').get();
        if (exerciseGoalDoc.exists) {
          await _notificationService.checkDailyExerciseGoal(); // Check if the daily exercise duration goal is met
        }

        // Check if the weekly exercise count reminder exists
        final weeklyGoalDoc = await remindersCollection.doc('Weekly workout count').get();
        if (weeklyGoalDoc.exists) {
          await _notificationService.checkAndNotifyWeeklyWorkoutGoal(); // Check if the weekly exercise count goal is met
        }

        // Mark notification as sent
        setState(() {
          _notificationSent = true;
        });

      }

    } catch (e) {
      print('Error checking and notifying goals: $e');
    }
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load reminders: $e")),
      );
    }
  }

  @override
  void dispose() {
    _notificationTimer?.cancel();
    super.dispose();
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
        // Example validation (e.g., ensure it's a valid number)
        final parsedValue = int.tryParse(value);
        if (parsedValue != null) {
          await remindersCollection.doc(goal).set({
            'goal': goal,
            'value': value,
          });
        } else {
          print('Invalid value for $goal');
        }
      }
    });

    setState(() {
      savedReminders = Map.from(reminders);
    });

    _schedulePeriodicChecks();
    print('calling schedule periodic checks');

    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reminders saved: ${reminders.toString()}'),
        duration: Duration(seconds: 2), // Adjust duration as needed
      ),
    );
  }
}