// import 'package:food/applewatch/constants.dart' show currentDate, dataTypesIos, midNight, permissions;
// import 'package:food/applewatch/injector.dart' show healthFactory;
// import 'package:health/health.dart';

// class HealthService {

//   // Future<int?> getSteps() async {
//   //   try {
//   //     final bool requested = await healthFactory.requestAuthorization(dataTypesIos, permissions: permissions);
//   //     if (requested) {
//   //       print('Fetching steps from $midNight to $currentDate');
//   //       int? totalSteps = await healthFactory.getTotalStepsInInterval(midNight, currentDate);
//   //       print('Total steps fetched: $totalSteps');
//   //       return totalSteps;
//   //     } else {
//   //       print('HealthKit authorization not granted');
//   //     }
//   //   } catch (e) {
//   //     print('Error fetching steps: $e');
//   //   }
//   //   return -1;
//   // }

//   Future<int?> getSteps(DateTime startDate, DateTime endDate) async {
//     try {
//       final bool requested = await healthFactory.requestAuthorization(dataTypesIos, permissions: permissions);
//       if (requested) {
//         print('Fetching steps from $startDate to $endDate');
//         int? totalSteps = await healthFactory.getTotalStepsInInterval(startDate, endDate);
//         print('Total steps fetched: $totalSteps');
//         return totalSteps;
//       } else {
//         print('HealthKit authorization not granted');
//       }
//     } catch (e) {
//       print('Error fetching steps: $e');
//     }
//     return null;
//   }

//   Future<double> getWeeklyAverageSteps() async {
//     try {
//       DateTime now = DateTime.now();
//       DateTime startDate = now.subtract(Duration(days: now.weekday - 1));
//       DateTime endDate = now;

//       int? totalSteps = await getSteps(startDate, endDate);
//       if (totalSteps == null || totalSteps == -1) return 0.0;

//       int daysCount = now.weekday;
//       return totalSteps / daysCount;
//     } catch (e) {
//       print('Error fetching weekly average steps: $e');
//       return 0.0;
//     }
//   }

  

//   Future<double> getMonthlyAverageSteps() async {
//     try {
//       DateTime now = DateTime.now();
//       DateTime startDate = DateTime(now.year, now.month, 1);
//       DateTime endDate = now;

//       int? totalSteps = await getSteps(startDate, endDate);
//       if (totalSteps == null || totalSteps == -1) return 0.0;

//       int daysInMonth = DateTime(now.year, now.month + 1, 0).day;
//       // Only calculate average if there are days in the month
//       return daysInMonth > 0 ? totalSteps / daysInMonth : 0.0;
//     } catch (e) {
//       print('Error fetching monthly average steps: $e');
//       return 0.0;
//     }
//   }

  

// }

import 'package:food/applewatch/constants.dart' show currentDate, dataTypesIos, midNight, permissions;
import 'package:food/applewatch/injector.dart' show healthFactory;
import 'package:health/health.dart';

class HealthService {

  Future<int?> getSteps(DateTime startDate, DateTime endDate) async {
    try {
      final bool requested = await healthFactory.requestAuthorization(dataTypesIos, permissions: permissions);
      if (requested) {
        print('Fetching steps from $startDate to $endDate');
        int? totalSteps = await healthFactory.getTotalStepsInInterval(startDate, endDate);
        print('Total steps fetched: $totalSteps');
        return totalSteps;
      } else {
        print('HealthKit authorization not granted');
      }
    } catch (e) {
      print('Error fetching steps: $e');
    }
    return null; // Explicitly returning null to signify an error occurred
  }

  Future<double> getWeeklyAverageSteps() async {
    try {
      DateTime now = DateTime.now();
      DateTime startDate = now.subtract(Duration(days: now.weekday - 1)); // Start of the week
      DateTime endDate = now; // Today

      int? totalSteps = await getSteps(startDate, endDate);
      if (totalSteps == null) return 0.0; // No steps data available

      int daysCount = now.weekday; // Number of days in the week
      return daysCount > 0 ? totalSteps / daysCount : 0.0; // Avoid division by zero
    } catch (e) {
      print('Error fetching weekly average steps: $e');
      return 0.0;
    }
  }

  Future<double> getMonthlyAverageSteps() async {
    try {
      DateTime now = DateTime.now();
      DateTime startDate = DateTime(now.year, now.month, 1); // Start of the month
      DateTime endDate = now; // Today

      int? totalSteps = await getSteps(startDate, endDate);
      if (totalSteps == null) return 0.0; // No steps data available

      int daysInMonth = DateTime(now.year, now.month + 1, 0).day; // Total days in the month
      return daysInMonth > 0 ? totalSteps / daysInMonth : 0.0; // Avoid division by zero
    } catch (e) {
      print('Error fetching monthly average steps: $e');
      return 0.0;
    }
  }

  
}
