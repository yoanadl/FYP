import 'package:food/applewatch/constants.dart' show currentDate, dataTypesIos, midNight, permissions;
import 'package:food/applewatch/injector.dart' show healthFactory;
import 'package:health/health.dart';

class HealthService {

  // Future<int?> getSteps() async {
  //   try {
  //     final bool requested = await healthFactory.requestAuthorization(dataTypesIos, permissions: permissions);
  //     if (requested) {
  //       print('Fetching steps from $midNight to $currentDate');
  //       int? totalSteps = await healthFactory.getTotalStepsInInterval(midNight, currentDate);
  //       print('Total steps fetched: $totalSteps');
  //       return totalSteps;
  //     } else {
  //       print('HealthKit authorization not granted');
  //     }
  //   } catch (e) {
  //     print('Error fetching steps: $e');
  //   }
  //   return -1;
  // }

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
    return -1;
  }

  Future<double> getWeeklyAverageSteps() async {
    try {
      DateTime now = DateTime.now();
      DateTime startDate = now.subtract(Duration(days: now.weekday - 1));
      DateTime endDate = now;

      int? totalSteps = await getSteps(startDate, endDate);
      if (totalSteps == null || totalSteps == -1) return 0.0;

      int daysCount = now.weekday;
      return totalSteps / daysCount;
    } catch (e) {
      print('Error fetching weekly average steps: $e');
      return 0.0;
    }
  }

  Future<double> getMonthlyAverageSteps() async {
    try {
      DateTime now = DateTime.now();
      DateTime startDate = DateTime(now.year, now.month, 1);
      DateTime endDate = now;

      int? totalSteps = await getSteps(startDate, endDate);
      if (totalSteps == null || totalSteps == -1) return 0.0;

      int daysInMonth = DateTime(now.year, now.month + 1, 0).day;
      return totalSteps / daysInMonth;
    } catch (e) {
      print('Error fetching monthly average steps: $e');
      return 0.0;
    }
  }





}
