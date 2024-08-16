import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:food/services/health_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';


class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final HealthService healthService = HealthService();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  

  bool _isBreakReminderEnabled = false;

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('flutter_logo');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin.show(
        id, title, body, await notificationDetails());
  }

  Future<void> scheduleDailyNotification(
      {required String title, required String body, required DateTime scheduledTime}) async {
    final tz.TZDateTime tzScheduledTime = tz.TZDateTime.from(
      scheduledTime,
      tz.local,
    );

    await notificationsPlugin.zonedSchedule(
      0,
      title,
      body,
      tzScheduledTime,
      notificationDetails(),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> checkAndNotifyWeeklyWorkoutGoal() async {

    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final userId = user.uid;
      final userDoc = firestore.collection('users').doc(userId);
      final remindersCollection = userDoc.collection('fitnessReminders');
      
      // Fetch the weekly workout goal
      final reminderDoc = await remindersCollection.doc('Weekly workout count').get();
      if (!reminderDoc.exists) return;

      final goalWorkoutCount = int.tryParse(reminderDoc.data()?['value'] ?? '0') ?? 0;

      // Fetch the total workouts for the current week
      final workoutsCollection = userDoc.collection('workouts');
      final now = DateTime.now();
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1)); // Monday
      final endOfWeek = startOfWeek.add(Duration(days: 6, hours: 23, minutes: 59, seconds: 59));

      final querySnapshot = await workoutsCollection
          .where('date', isGreaterThanOrEqualTo: startOfWeek)
          .where('date', isLessThanOrEqualTo: endOfWeek)
          .get();

      int totalWorkoutCount = querySnapshot.docs.length; // Count the number of workouts

      if (totalWorkoutCount < goalWorkoutCount) {
        await showNotification(
          id: 3, // Unique ID for weekly workout reminders
          title: 'Weekly Workout Reminder',
          body: 'You haven\'t reached your weekly workout goal. Keep moving!',
        );
      }
    } catch (e) {
      print('Error checking weekly workout goal: $e');
    }
  }

  // Check if the daily step goal is met and send a notification if not
Future<void> checkDailyStepGoal() async {
  try {
    // Fetch the daily step goal
    final stepGoal = await _fetchStepGoalFromFirestore();

    // Fetch the current step count
    final int? steps = await healthService.getSteps();
    if (steps == null) {
      print('Error fetching steps');
      return;
    }

    // Check if the step goal is met
    if (steps < stepGoal) {
      await showNotification(
        id: 1,
        title: 'Step Goal Alert',
        body: 'You have not reached your step goal for today. Keep moving!',
      );
    }
  } catch (e) {
    print('Error checking daily step goal: $e');
  }
}

// Check if the daily exercise duration goal is met and send a notification if not
Future<void> checkDailyExerciseGoal() async {
  try {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userId = user.uid;
    final userDoc = firestore.collection('users').doc(userId);
    final remindersCollection = userDoc.collection('fitnessReminders');

    final reminderDoc = await remindersCollection.doc('Daily exercise duration').get();
    if (!reminderDoc.exists) return;

    final goalDuration = int.tryParse(reminderDoc.data()?['value'] ?? '0') ?? 0;

    // Fetch the total exercise duration for today
    final workoutsCollection = userDoc.collection('workouts');
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

    final querySnapshot = await workoutsCollection
        .where('date', isGreaterThanOrEqualTo: startOfDay)
        .where('date', isLessThanOrEqualTo: endOfDay)
        .get();

    int totalDuration = 0;

    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      final durationList = List<int>.from(data['durations'] ?? []);
      totalDuration += durationList.reduce((a, b) => a + b);
    }

    // Check if the exercise goal is met
    if (totalDuration < goalDuration) {
      await showNotification(
        id: 2, // Unique ID for exercise reminders
        title: 'Exercise Reminder',
        body: 'You haven\'t reached your exercise goal for today. Keep going!',
      );
    }
  } catch (e) {
    print('Error checking daily exercise goal: $e');
  }
}


  Future<int> _fetchStepGoalFromFirestore() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      final userId = user?.uid;
      if (userId == null) return 10000; // Default value if no user is logged in

      final userDoc = firestore.collection('users').doc(userId);
      final remindersCollection = userDoc.collection('fitnessReminders');
      final snapshot = await remindersCollection.doc('dailyStepsGoal').get();

      if (snapshot.exists) {
        final data = snapshot.data();
        final stepGoal = int.tryParse(data?['value'] ?? '10000') ?? 10000; // Default to 10000 if parsing fails
        return stepGoal;
      } else {
        return 10000; // Default value if document doesn't exist
      }
    } catch (e) {
      print('Error fetching step goal: $e');
      return 10000; // Default value in case of error
    }
  }


  //for testing purposes
  Future<void> scheduleBreakReminderNotification(DateTime startTime) async {
    print('inside scheudle break reminder notification');
    // Schedule the break reminder notification
    final tz.TZDateTime reminderTime = tz.TZDateTime.from(startTime.add(Duration(minutes: 1)), tz.local);

    print('Reminder Time:  ${reminderTime.toLocal()}');

    await notificationsPlugin.zonedSchedule(
      1,
      'Break Reminder',
      'It\'s time to take a break from your workout!',
      reminderTime,
      notificationDetails(),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }



  Future<void> cancelBreakReminderNotification() async {
    await notificationsPlugin.cancel(1);
  }

   // Method to set break reminder status
  Future<void> setBreakReminderStatus(bool isEnabled) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('break_reminder_enabled', isEnabled);
  }

  Future<bool> getBreakReminderStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('break_reminder_enabled') ?? false;
  }

  // Future<void> scheduleBreakReminderNotification() async {
  //   // Schedule the break reminder notification
  //   await notificationsPlugin.zonedSchedule(
  //     1,
  //     'Break Reminder',
  //     'You\'ve been exercising for one hour. Time to take a break!',
  //     _calculateBreakReminderTime(),
  //     notificationDetails(),
  //     androidAllowWhileIdle: true,
  //     uiLocalNotificationDateInterpretation:
  //         UILocalNotificationDateInterpretation.absoluteTime,
  //   );
  // }

  // tz.TZDateTime _calculateBreakReminderTime() {
  //   // Calculate the time for the break reminder (e.g., 1 hour from now)
  //   final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  //   return now.add(const Duration(hours: 1));
  // }

  // for testing purposes
  tz.TZDateTime _calculateBreakReminderTime() {
    // Calculate the time for the break reminder (e.g., 5 minutes from now)
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    return now.add(const Duration(minutes: 1));
  }


//   Future<void> checkExerciseDuration(String uid) async {
//   try {
//     final workoutsSnapshot = await usersCollection
//         .doc(uid)
//         .collection('workouts')
//         .get();

//     DateTime now = DateTime.now();
//     DateTime lastExerciseTime;

//     if (workoutsSnapshot.docs.isNotEmpty) {
//       // Fetch the most recent workout instance
//       final latestWorkoutDoc = await usersCollection
//           .doc(uid)
//           .collection('workouts')
//           .doc(workoutsSnapshot.docs.last.id)
//           .collection('instances')
//           .orderBy('timestamp', descending: true)
//           .limit(1)
//           .get();

//       if (latestWorkoutDoc.docs.isNotEmpty) {
//         lastExerciseTime = (latestWorkoutDoc.docs.first['timestamp'] as Timestamp).toDate();

//         // Calculate time difference
//         Duration difference = now.difference(lastExerciseTime);

//         // Schedule break reminder if more than an hour has passed
//         if (difference.inMinutes >= 60 && _isBreakReminderEnabled) {
//           scheduleBreakReminderNotification();
//         }
//       }
//     }
//   } catch (e) {
//     print('Error checking exercise duration: $e');
//   }
// }

}
