// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:food/services/health_service.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'dart:async';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:timezone/timezone.dart' as tz;


// class NotificationService {
//   final FlutterLocalNotificationsPlugin notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   final HealthService healthService = HealthService();
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;

//   // Future<void> initNotification() async {
//   //   final DarwinInitializationSettings initializationSettingsIOS =
//   //       DarwinInitializationSettings(
//   //           requestAlertPermission: true,
//   //           requestBadgePermission: true,
//   //           requestSoundPermission: true,
//   //           onDidReceiveLocalNotification:
//   //               (int id, String? title, String? body, String? payload) async {
//   //             // Handle when the app is in the foreground
//   //           });

//   //   final InitializationSettings initializationSettings = InitializationSettings(
//   //     iOS: initializationSettingsIOS,
//   //   );

//   //   await notificationsPlugin.initialize(
//   //     initializationSettings,
//   //     onDidReceiveNotificationResponse:
//   //         (NotificationResponse notificationResponse) async {
//   //       // Handle notification response
//   //     },
//   //   );
    
//   // }

//   Future<void> initNotification() async {
//   try {
//     final DarwinInitializationSettings initializationSettingsIOS =
//         DarwinInitializationSettings(
//             requestAlertPermission: true,
//             requestBadgePermission: true,
//             requestSoundPermission: true,
//             onDidReceiveLocalNotification:
//                 (int id, String? title, String? body, String? payload) async {
//               // Handle when the app is in the foreground
//             });

//     final InitializationSettings initializationSettings = InitializationSettings(
//       iOS: initializationSettingsIOS,
//     );

//     await notificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse:
//           (NotificationResponse notificationResponse) async {
//         // Handle notification response
//       },
//     );

//     print('Notification service initialized.');
//   } catch (e) {
//     print('Error initializing notification service: $e');
//   }
// }


//   Future<void> showNotification({
//     required int id,
//     required String title,
//     required String body,
//     String? payload,
//   }) async {
//     const NotificationDetails platformChannelSpecifics = NotificationDetails(
//       iOS: DarwinNotificationDetails(
//         sound: 'default', // Specify sound if needed
//         presentAlert: true,
//         presentBadge: true,
//         presentSound: true,
//       ),
//     );

//     await notificationsPlugin.show(
//       id,
//       title,
//       body,
//       platformChannelSpecifics,
//       payload: payload,
//     );
//   }

//   Future<void> checkAndNotifyWeeklyWorkoutGoal() async {
//     try {
//       final User? user = FirebaseAuth.instance.currentUser;
//       if (user == null) return;

//       final userId = user.uid;
//       final userDoc = firestore.collection('users').doc(userId);
//       final remindersCollection = userDoc.collection('fitnessReminders');
      
//       // Fetch the weekly workout goal
//       final reminderDoc = await remindersCollection.doc('Weekly workout count').get();
//       if (!reminderDoc.exists) return;

//       final goalWorkoutCount = int.tryParse(reminderDoc.data()?['value'] ?? '0') ?? 0;

//       // Fetch the total workouts for the current week
//       final workoutsCollection = userDoc.collection('workouts');
//       final now = DateTime.now();
//       final startOfWeek = now.subtract(Duration(days: now.weekday - 1)); // Monday
//       final endOfWeek = startOfWeek.add(Duration(days: 6, hours: 23, minutes: 59, seconds: 59));

//       final querySnapshot = await workoutsCollection
//           .where('date', isGreaterThanOrEqualTo: startOfWeek)
//           .where('date', isLessThanOrEqualTo: endOfWeek)
//           .get();

//       int totalWorkoutCount = querySnapshot.docs.length; // Count the number of workouts

//       if (totalWorkoutCount < goalWorkoutCount) {
//         await showNotification(
//           id: 3, // Unique ID for weekly workout reminders
//           title: 'Weekly Workout Reminder',
//           body: 'You haven\'t reached your weekly workout goal. Keep moving!',
//         );
//       }
//     } catch (e) {
//       print('Error checking weekly workout goal: $e');
//     }
//   }


//   // schedule a daily notification at 5pm 
//   Future<void> scheduleNotifications() async {

//     tz.initializeTimeZones();
//     final now = DateTime.now();
//     final fivePM = DateTime(now.year, now.month, now.day, 17, 0, 0);

//     // schedule daily notifications
//     final Duration initialDelay = now.isBefore(fivePM)
//         ? fivePM.difference(now)
//         : fivePM.add(Duration(days: 1)).difference(now);

//     Timer.periodic(Duration(days: 1), (timer) {
//       print('Checking and notifying if goal not met...');
//       checkAndNotifyIfGoalNotMet(); 
//     });

//     await Future.delayed(initialDelay, () {
//       print('Checking and notifying if goal not met...');
//       checkAndNotifyIfGoalNotMet(); //
//     });

//     // schedule weekly notifications
//     final int daysUntilNextSunday = (7 - now.weekday) % 7;
//     final nextSunday = now.add(Duration(days: daysUntilNextSunday)).subtract(Duration(hours: now.hour, minutes: now.minute, seconds: now.second, milliseconds: now.millisecond, microseconds: now.microsecond));
//     final sundayFivePM = DateTime(nextSunday.year, nextSunday.month, nextSunday.day, 17, 0, 0);

//     final Duration weeklyInitialDelay = sundayFivePM.difference(now);

//     Timer.periodic(Duration(days: 7), (timer) {
//       print('Checking and notifying weekly workout goal...');
//       checkAndNotifyWeeklyWorkoutGoal(); 
//     });

//     await Future.delayed(weeklyInitialDelay, () {
//       print('Checking and notifying weekly workout goal...');
//       checkAndNotifyWeeklyWorkoutGoal(); 
//     });
    
//   }



//   // check if the daily step goal is met and send a notification if not
//   Future<void> checkAndNotifyIfGoalNotMet() async {


//     // check for daily step count
//     final stepGoal = await _fetchStepGoalFromFirestore();
//     final int? steps = await healthService.getSteps();

//     if (steps == null) {
//       print('Error fetching steps');
//       return;
//     }

//     if (steps < stepGoal) {
//       await showNotification(
//         id: 1,
//         title: 'Step Goal Alert',
//         body: 'You have not reached your step goal for today. Keep moving!',
//       );
//     }

//     // check for daily exercise duration
//     try {
//       final User? user = FirebaseAuth.instance.currentUser;
//       if (user == null) return;

//       final userId = user.uid;
//       final userDoc = firestore.collection('users').doc(userId);
//       final remindersCollection = userDoc.collection('fitnessReminders');
      
//       final reminderDoc = await remindersCollection.doc('Daily exercise duration').get();
//       if (!reminderDoc.exists) return;

//       final goalDuration = int.tryParse(reminderDoc.data()?['value'] ?? '0') ?? 0;

//       // Fetch the total exercise duration for today
//       final workoutsCollection = userDoc.collection('workouts');
//       final today = DateTime.now();
//       final startOfDay = DateTime(today.year, today.month, today.day);
//       final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

//       final querySnapshot = await workoutsCollection
//           .where('date', isGreaterThanOrEqualTo: startOfDay)
//           .where('date', isLessThanOrEqualTo: endOfDay)
//           .get();

//       int totalDuration = 0;

//       for (var doc in querySnapshot.docs) {
//         final data = doc.data();
//         final durationList = List<int>.from(data['durations'] ?? []);
//         totalDuration += durationList.reduce((a, b) => a + b);
//       }

//       if (totalDuration < goalDuration) {
//         await showNotification(
//           id: 2, // Unique ID for exercise reminders
//           title: 'Exercise Reminder',
//           body: 'You haven\'t reached your exercise goal for today. Keep going!',
//         );
//       }
//     } catch (e) {
//       print('Error checking exercise goal: $e');
//     }


//   }

//   Future<int> _fetchStepGoalFromFirestore() async {

//     try {
//       final User? user = FirebaseAuth.instance.currentUser;
//       final userId = user?.uid;
//       final userDoc = firestore.collection('users').doc(userId);
//       final remindersCollection = userDoc.collection('fitnessReminders');
//       final snapshot = await remindersCollection.doc('dailyStepsGoal').get();

//       if (snapshot.exists) {
//         final data = snapshot.data();
//         final stepGoal = data?['value'] ?? 10000; // Default to 10000 if not found
//         return stepGoal as int;
//       } else {
//         return 10000; // Default value if document doesn't exist
//       }
//     } catch (e) {
//       print('Error fetching step goal: $e');
//       return 10000; // Default value in case of error
//     }
//   }




// }

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    tz.initializeTimeZones();

    final InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('app_icon'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {
          // Handle when the app is in the foreground
        },
      ),
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
        // Handle notification response
      },
    );
  }

  Future<void> scheduleDailyNotification() async {
    const DarwinNotificationDetails iOSPlatformChannelSpecifics = DarwinNotificationDetails(
      sound: 'default',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Daily Reminder',
      'Time to check your fitness goals!',
      _nextInstanceOfFivePM(),
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  tz.TZDateTime _nextInstanceOfFivePM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    final tz.TZDateTime fivePM = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      17,
      0,
    );

    if (now.isBefore(fivePM)) {
      return fivePM;
    } else {
      return fivePM.add(Duration(days: 1));
    }
  }
}
