import 'package:food/applewatch/constants.dart' show currentDate, dataTypesIos, midNight, permissions;
import 'package:food/applewatch/injector.dart' show healthFactory;
import 'package:health/health.dart';

class HealthService {

  // today's data

  Future<int?> getSteps() async {

    final bool requested = await healthFactory.requestAuthorization(dataTypesIos, permissions: permissions);
    
    if (requested) {

      try {
        final totalSteps = await healthFactory.getTotalStepsInInterval(currentDate, midNight);
        // print('Fetching steps from $currentDate to $midNight');
        // print('Total steps fetched: $totalSteps');
        return totalSteps;
      }
      catch (e) {
        print('Error fetching steps: $e');
        return -1;
      } 
    } else {
      print('HealthKit authorization not granted');
      return -1;
    }


  }

//   Future<double?> getHeartRate() async {
//   final bool requested = await healthFactory.requestAuthorization(dataTypesIos, permissions: permissions);

//   if (requested) {
//     try {
//       final healthData = await healthFactory.getHealthDataFromTypes(DateTime.now().subtract(Duration(hours: 1)), DateTime.now(), [HealthDataType.HEART_RATE]);

//       // Get the most recent heart rate data point with null checks
//       final heartRateValue = (healthData.last.value as NumericHealthValue).numericValue?.toDouble();
//       return heartRateValue;
//     } catch (e) {
//       print('Error fetching heart rate: $e');
//       return null;
//     }
//   } else {
//     print('Authorization not granted');
//     return null;
//   }
// }

Future<double?> getHeartRate() async {
  final bool requested = await healthFactory.requestAuthorization(dataTypesIos, permissions: permissions);

  if (requested) {
    try {
      final DateTime endTime = DateTime.now();
      final DateTime startTime = endTime.subtract(Duration(minutes: 10));
      final List<HealthDataPoint> healthData = await healthFactory.getHealthDataFromTypes(startTime, endTime, [HealthDataType.HEART_RATE]);

      // Check if health data is not empty
      if (healthData.isNotEmpty) {
        final heartRateValue = (healthData.last.value as NumericHealthValue).numericValue?.toDouble();
        print('Fetched heart rate: $heartRateValue bpm');
        return heartRateValue;
      } else {
        print('No heart rate data available');
        return null;
      }
    } catch (e) {
      print('Error fetching heart rate: $e');
      return null;
    }
  } else {
    print('Authorization not granted');
    return null;
  }
}
  Future<double?> getCalories() async {
    final bool requested = await healthFactory.requestAuthorization(dataTypesIos, permissions: permissions);

    if (requested) {
      try {
        // print('Fetching calories data from $currentDate to $midNight');
        final healthData = await healthFactory.getHealthDataFromTypes(currentDate, midNight, [HealthDataType.ACTIVE_ENERGY_BURNED]);

        if (healthData.isNotEmpty) {
          double totalCalories = 0.0;

          // Iterate over the health data to sum up all the calorie values
          for (var data in healthData) {
            if (data.value is NumericHealthValue) {
              final caloriesValue = (data.value as NumericHealthValue).numericValue?.toDouble() ?? 0.0;
              // print('Fetched Calories Data Point: $caloriesValue');
              totalCalories += caloriesValue;
            } else {
              print('Unexpected value type for calories data: ${data.value.runtimeType}');
            }
          }

          // print('Total Calories Fetched: $totalCalories');
          return totalCalories;
        } else {
          print('No calories data available for the given date range');
          return 0.0; // Return 0.0 if no data is available
        }
      } catch (e) {
        print('Error fetching calories: $e'); 
        return null;
      }
    } else {
      print('HealthKit authorization not granted');
      return null;
    }
  }

  Future<double?> getAverageHeartRateForToday() async {
  // Define the time range: from midnight of today to midnight of tomorrow
  DateTime now = DateTime.now();
  DateTime startDate = DateTime(now.year, now.month, now.day);
  DateTime endDate = startDate.add(Duration(days: 1));

  // Request authorization to access heart rate data
  bool requested = await healthFactory.requestAuthorization([HealthDataType.HEART_RATE]);

  if (requested) {
    // Fetch heart rate data
    List<HealthDataPoint> heartRateData = await healthFactory.getHealthDataFromTypes(
      startDate,
      endDate,
      [HealthDataType.HEART_RATE],
    );

    // Calculate the average heart rate
      
    double totalHeartRate = heartRateData.fold(0.0, (sum, dataPoint) {
      double value = (dataPoint.value as NumericHealthValue).numericValue.toDouble(); 
      return sum + value;
    });

      double averageHeartRate = heartRateData.isNotEmpty ? totalHeartRate / heartRateData.length : 0.0;
      return averageHeartRate;
    }
    
    else {
      print('Authorization not granted.');
      return 0.0;
    }
  } 

  Future<double?> getMaximumHeartRateForToday() async {
    // Define the time range: from midnight of today to midnight of tomorrow
    DateTime now = DateTime.now();
    DateTime startDate = DateTime(now.year, now.month, now.day);
    DateTime endDate = startDate.add(Duration(days: 1));

    // Request authorization to access heart rate data
    bool requested = await healthFactory.requestAuthorization([HealthDataType.HEART_RATE]);

    if (requested) {
      // Fetch heart rate data
      List<HealthDataPoint> heartRateData = await healthFactory.getHealthDataFromTypes(
        startDate,
        endDate,
        [HealthDataType.HEART_RATE],
      );

      // Calculate the maximum heart rate
      double maxHeartRate = 0.0; // Initialize max to 0.0

      for (var dataPoint in heartRateData) {
        double value = (dataPoint.value as NumericHealthValue).numericValue.toDouble();
        if (value > maxHeartRate) {
          maxHeartRate = value;
        }
      }

      return maxHeartRate;
    } else {
      print('Authorization not granted.');
      return null;
    }
  }


// weekly 

  Future<int> getStepsForThatDay(DateTime date) async {
    final startDate = DateTime(date.year, date.month, date.day);
    final endDate = startDate.add(Duration(days: 1));

    try {
      final stepsData = await healthFactory.getTotalStepsInInterval(
        startDate,
        endDate,
      );

      // If stepsData is an int, just return it. No need for fold.
      return stepsData ?? 0; // Handle null or unexpected type
    } catch (e) {
      print('Error fetching steps for $date: $e');
      return 0; // Handle error appropriately
    }
  }

  Future<double> getHeartRateForThatDay(DateTime date) async {
    final startDate = DateTime(date.year, date.month, date.day);
    final endDate = startDate.add(Duration(days: 1));

    try {
      final heartRateData = await healthFactory.getHealthDataFromTypes(
        startDate,
        endDate,
        [HealthDataType.HEART_RATE],
      );

      if (heartRateData.isNotEmpty) {
        // Calculate the average heart rate
        double totalHeartRate = 0.0;
        for (var dataPoint in heartRateData) {
          final value = (dataPoint.value as NumericHealthValue).numericValue?.toDouble() ?? 0.0;
          totalHeartRate += value;
        }
        return (totalHeartRate / heartRateData.length).ceilToDouble();
      } else {
        return 0; // No heart rate data found
      }
    } catch (e) {
      print('Error fetching heart rate for $date: $e');
      return 0; // Handle error appropriately
    }
  }

  Future<double> getCaloriesForThatDay(DateTime date) async {
  final startDate = DateTime(date.year, date.month, date.day);
  final endDate = startDate.add(Duration(days: 1));

  final bool requested = await healthFactory.requestAuthorization([HealthDataType.ACTIVE_ENERGY_BURNED]);

  if (requested) {
    try {
      final healthData = await healthFactory.getHealthDataFromTypes(startDate, endDate, [HealthDataType.ACTIVE_ENERGY_BURNED]);

      if (healthData.isNotEmpty) {
        double totalCalories = 0.0;

        for (var data in healthData) {
          if (data.value is NumericHealthValue) {
            final caloriesValue = (data.value as NumericHealthValue).numericValue?.toDouble() ?? 0.0;
            totalCalories += caloriesValue;
          } else {
            print('Unexpected value type for calories data: ${data.value.runtimeType}');
          }
        }

        return totalCalories.ceilToDouble();
      } else {
        print('No calories data available for the given date range');
        return 0.0; // Return 0.0 if no data is available
      }
    } catch (e) {
      print('Error fetching calories: $e'); // Detailed error message
      return 0.0;
    }
  } else {
    print('HealthKit authorization not granted');
    return 0.0;
  }
}


  Future<void> getWeeklyStepsIncludingToday() async {
    final bool requested = await healthFactory.requestAuthorization(dataTypesIos, permissions: permissions);

    if (requested) {
      try {
        // Define the start and end dates
        final DateTime now = DateTime.now();
        final DateTime start = DateTime(now.year, now.month, now.day).subtract(Duration(days: 6)); // Start 7 days ago
        final DateTime end = DateTime(now.year, now.month, now.day).add(Duration(days: 1)); // End of today

        // Fetch and print steps for each day in the range
        for (DateTime date = start; date.isBefore(end); date = date.add(Duration(days: 1))) {
          final DateTime intervalStart = DateTime(date.year, date.month, date.day);
          final DateTime intervalEnd = intervalStart.add(Duration(days: 1));
          
          final totalHeartRate = await healthFactory.getHealthDataFromTypes(intervalStart, intervalEnd, [HealthDataType.STEPS]) ?? 0;
          
          // Print the number of steps for each day
          print('Heart Rate on ${intervalStart.toLocal().toString().split(' ')[0]}: $totalHeartRate');
        }
      } catch (e) {
        print('Error fetching heart rate: $e');
      }
    } else {
      print('HealthKit authorization not granted');
    }
  
  }

  Future<void> getWeeklyHeartRateIncludingToday() async {
    final bool requested = await healthFactory.requestAuthorization(dataTypesIos, permissions: permissions);

    if (requested) {
      try {
        // Define the start and end dates
        final DateTime now = DateTime.now();
        final DateTime start = DateTime(now.year, now.month, now.day).subtract(Duration(days: 6)); // Start 7 days ago
        final DateTime end = DateTime(now.year, now.month, now.day).add(Duration(days: 1)); // End of today

        // Fetch and print steps for each day in the range
        for (DateTime date = start; date.isBefore(end); date = date.add(Duration(days: 1))) {
          final DateTime intervalStart = DateTime(date.year, date.month, date.day);
          final DateTime intervalEnd = intervalStart.add(Duration(days: 1));
          
          final totalHeartRate = await healthFactory.getHealthDataFromTypes(intervalStart, intervalEnd, [HealthDataType.HEART_RATE]) ?? 0;
          
          // Print the number of steps for each day
          print('Heart Rate on ${intervalStart.toLocal().toString().split(' ')[0]}: $totalHeartRate');
        }
      } catch (e) {
        print('Error fetching heart rate: $e');
      }
    } else {
      print('HealthKit authorization not granted');
    }
  } 

  Future<void> getWeeklyCaloriesIncludingToday() async {
    final bool requested = await healthFactory.requestAuthorization(dataTypesIos, permissions: permissions);

    if (requested) {
      try {
        // Define the start and end dates
        final DateTime now = DateTime.now();
        final DateTime start = DateTime(now.year, now.month, now.day).subtract(Duration(days: 6)); // Start 7 days ago
        final DateTime end = DateTime(now.year, now.month, now.day).add(Duration(days: 1)); // End of today

        // Fetch and print steps for each day in the range
        for (DateTime date = start; date.isBefore(end); date = date.add(Duration(days: 1))) {
          final DateTime intervalStart = DateTime(date.year, date.month, date.day);
          final DateTime intervalEnd = intervalStart.add(Duration(days: 1));
          
          final totalHeartRate = await healthFactory.getHealthDataFromTypes(intervalStart, intervalEnd, [HealthDataType.ACTIVE_ENERGY_BURNED]) ?? 0;
          
          // Print the number of steps for each day
          print('Calories Burned on ${intervalStart.toLocal().toString().split(' ')[0]}: $totalHeartRate');
        }
      } catch (e) {
        print('Error fetching calories: $e');
      }
    } else {
      print('HealthKit authorization not granted');
    }
  }

  Future<double?> getAverageWeeklyHeartRate() async {
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: 6)); // Start 6 days ago (beginning of the week)
    final endDate = now.add(Duration(days: 1)); // End of today (inclusive)

    // Request authorization to access heart rate data
    final bool requested = await healthFactory.requestAuthorization([HealthDataType.HEART_RATE]);

    if (requested) {
      try {
        // Initialize variables
        double totalHeartRate = 0.0;
        int dataPoints = 0;

        // Iterate over each day in the week
        for (DateTime date = startDate; date.isBefore(endDate); date = date.add(Duration(days: 1))) {
          final dailyHeartRate = await getHeartRateForThatDay(date);
          if (dailyHeartRate != null) {
            totalHeartRate += dailyHeartRate;
            dataPoints++;
          } else {
            print('No heart rate data found for ${date.toLocal()}');
          }
        }

        // Calculate and return average heart rate (if data is available)
        return dataPoints > 0 ? totalHeartRate / dataPoints : null;
      } catch (e) {
        print('Error fetching heart rate data: $e');
        return null;  // Handle error appropriately (e.g., return null or throw exception)
      }
    } else {
      print('HealthKit authorization not granted');
      return null;  // Handle authorization failure (e.g., return null or throw exception)
    }
  }

  Future<int?> getAverageWeeklySteps() async {
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: 6)); // Start of the week

    double totalSteps = 0;
    int daysWithSteps = 0;

    for (int i = 0; i < 7; i++) {
      final day = startDate.add(Duration(days: i));
      final steps = await getStepsForThatDay(day);
      if (steps != null && steps > 0) {
        totalSteps += steps;
        daysWithSteps++;
      }
    }

    if (daysWithSteps > 0) {
      return (totalSteps / daysWithSteps).round();
    } else {
      return null;
    }
  }


  Future<double?> getAverageWeeklyCalories() async {
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: 6)); // Start of the week

    double totalCalories = 0;
    int daysWithCalories = 0;

    for (int i = 0; i < 7; i++) {
      final day = startDate.add(Duration(days: i));
      final calories = await getCaloriesForThatDay(day);
      if (calories != null && calories > 0) {
        totalCalories += calories;
        daysWithCalories++;
      }
    }

    return daysWithCalories > 0 ? (totalCalories / daysWithCalories).ceilToDouble() : null;
  }






  // MONTH DATA

  Future<int> getStepsForThatMonth(DateTime month) async {
    // Define the start and end dates for the specified month
    final startDate = DateTime(month.year, month.month, 1);
    final endDate = DateTime(month.year, month.month + 1, 1).subtract(Duration(seconds: 1));

    final bool requested = await healthFactory.requestAuthorization([HealthDataType.STEPS], permissions: [HealthDataAccess.READ]);

    if (requested) {
      try {
        int totalSteps = 0;

        // Iterate over each day of the month
        DateTime currentDay = startDate;
        while (currentDay.isBefore(endDate)) {
          DateTime nextDay = currentDay.add(Duration(days: 1));

          final steps = await healthFactory.getTotalStepsInInterval(currentDay, nextDay);
          totalSteps += steps ?? 0;

          currentDay = nextDay;
        }

        print('Total steps for month: $totalSteps'); // Debugging line
        return totalSteps;
      } catch (e) {
        print('Error fetching steps for $month: $e');
        return 0; // Return 0 in case of an error
      }
    } else {
      print('HealthKit authorization not granted');
      return 0; // Return 0 if authorization is not granted
    }
  }

  Future<double> getCaloriesForThatMonth(DateTime month) async {
    // Define the start and end dates for the specified month (avoiding seconds truncation)
    final startDate = DateTime(month.year, month.month, 1);
    final endDate = DateTime(month.year, month.month + 1, 0); // Last day of month, 00:00:00

    final bool requested = await healthFactory.requestAuthorization(
        [HealthDataType.ACTIVE_ENERGY_BURNED], permissions: [HealthDataAccess.READ]);

    if (requested) {
      try {
        double totalCalories = 0.0;

        // Iterate over each day of the month
        DateTime currentDay = startDate;
        while (currentDay.isBefore(endDate)) {
          DateTime nextDay = currentDay.add(Duration(days: 1));

          final calories = await _getCaloriesForDay(currentDay, nextDay);
          if (calories != null) {
            totalCalories += calories;
          } else {
            print('No calories data found for $currentDay');
          }

          currentDay = nextDay;
        }

        return totalCalories;
      } catch (e) {
        print('Error fetching calories for $month: $e');
        return 0.0; // Handle error appropriately (e.g., return null or throw exception)
      }
    } else {
      print('HealthKit authorization not granted');
      return 0.0; // Handle authorization failure (e.g., return null or throw exception)
    }
  }

  Future<double?> _getCaloriesForDay(DateTime startDate, DateTime endDate) async {
    final healthData = await healthFactory.getHealthDataFromTypes(startDate, endDate, [HealthDataType.ACTIVE_ENERGY_BURNED]);

    if (healthData.isNotEmpty) {
      double dailyCalories = 0.0;
      for (var data in healthData) {
        if (data.value is NumericHealthValue) {
          final calorieValue = (data.value as NumericHealthValue).numericValue?.toDouble() ?? 0.0;
          dailyCalories += calorieValue;
        } else {
          print('Unexpected value type for calories data: ${data.value.runtimeType}');
        }
      }
      return dailyCalories;
    } else {
      return null; 
    }
  }


  Future<double?> getAverageMonthlyHeartRate(DateTime month) async {
    // Define the time range: from the first day of the month to the last day of the month
    DateTime startDate = DateTime(month.year, month.month, 1);
    DateTime endDate = DateTime(month.year, month.month + 1, 1).subtract(Duration(seconds: 1)); // Last second of the month

    // Request authorization to access heart rate data
    bool requested = await healthFactory.requestAuthorization([HealthDataType.HEART_RATE]);

    if (requested) {
      // Fetch heart rate data
      List<HealthDataPoint> heartRateData = await healthFactory.getHealthDataFromTypes(
        startDate,
        endDate,
        [HealthDataType.HEART_RATE],
      );

      // Calculate the average heart rate
      double totalHeartRate = heartRateData.fold(0.0, (sum, dataPoint) {
        double value = (dataPoint.value as NumericHealthValue).numericValue.toDouble();
        return sum + value;
      });

      double averageHeartRate = heartRateData.isNotEmpty ? totalHeartRate / heartRateData.length : 0.0;
      return averageHeartRate;
    } else {
      print('Authorization not granted.');
      return 0.0;
    }
  } 

  Future<double?> getMaximumHeartRateForMonth(DateTime month) async {

    DateTime startDate = DateTime(month.year, month.month, 1);
    DateTime endDate = DateTime(month.year, month.month + 1, 1).subtract(Duration(seconds: 1)); // Last second of the month

    // Request authorization to access heart rate data
    bool requested = await healthFactory.requestAuthorization([HealthDataType.HEART_RATE]);

    if (requested) {
      // Fetch heart rate data
      List<HealthDataPoint> heartRateData = await healthFactory.getHealthDataFromTypes(
        startDate,
        endDate,
        [HealthDataType.HEART_RATE],
      );

      // Calculate the maximum heart rate
      double maxHeartRate = 0.0; // Initialize max to 0.0

      for (var dataPoint in heartRateData) {
        double value = (dataPoint.value as NumericHealthValue).numericValue.toDouble();
        if (value > maxHeartRate) {
          maxHeartRate = value;
        }
      }

      return heartRateData.isNotEmpty ? maxHeartRate : null;
    } else {
      print('Authorization not granted.');
      return null;
    }
  }

  // workout done
  // Future<int> getCaloriesBurned(DateTime startTime, DateTime endTime) async {
 
  //   // Request permissions for these data types
  //   bool requested = await healthFactory.requestAuthorization([HealthDataType.ACTIVE_ENERGY_BURNED]);
    
  //   if (requested) {
  //     // Fetch health data
  //     List<HealthDataPoint> healthData = await healthFactory.getHealthDataFromTypes(startTime, endTime, [HealthDataType.ACTIVE_ENERGY_BURNED]);
  //     print('Health data fetched: ${healthData.length} data points');

  //     // Filter and sum the calories burned data
  //     int totalCaloriesBurned = healthData
  //         .where((dataPoint) => dataPoint.type == HealthDataType.ACTIVE_ENERGY_BURNED)
  //         .fold(0, (sum, dataPoint) => sum + (dataPoint.value as num).toInt());

  //     print('Total calories burned: $totalCaloriesBurned');
  //     return totalCaloriesBurned;
  //   } else {
  //     print('Authorization not granted');
  //     return 0;
  //   }
  // }

  // Future<int> getCaloriesBurnedForThatWorkout(DateTime startTime, DateTime endTime) async {

  //   final bool requested = await healthFactory.requestAuthorization(dataTypesIos, permissions: permissions);

  //   if (!requested) {
  //     print('Authorization not granted');
  //     return 0;
  //   }

  //   print('Authorization granted, fetching data...');

  //   final types = [HealthDataType.ACTIVE_ENERGY_BURNED];
    
  //   List<HealthDataPoint> healthData = await healthFactory.getHealthDataFromTypes(startTime, endTime, types);

  //   if (healthData.isEmpty) {
  //     print('Health data fetched: 0 data points');
  //     return 0;
  //   }

  //   int totalCalories = 0;
  //   for (var dataPoint in healthData) {
  //     if (dataPoint.type == HealthDataType.ACTIVE_ENERGY_BURNED) {
  //       totalCalories += (dataPoint.value as NumericHealthValue).numericValue.toInt();
  //     }
  //   }

  //   print('Total calories burned: $totalCalories');
  //   return totalCalories;
  // }

//   Future<double?> getCaloriesBurnedForThatActivity(DateTime startTime, DateTime endTime) async {

//     final bool requested = await healthFactory.requestAuthorization(dataTypesIos, permissions: permissions);

//     if (requested) {

//       try {
//         final healthData = await healthFactory.getHealthDataFromTypes(startTime, endTime, [HealthDataType.ACTIVE_ENERGY_BURNED]);
//         print('Fetching calories data from $startTime to $endTime');

//         if (healthData.isNotEmpty) {
//           double totalCalories = 0.0;

//           // iterate over the health data to sum up all the calorie values
//           for (var data in healthData) {
//             if (data.value is NumericHealthValue) {
//               final caloriesValue = (data.value as NumericHealthValue).numericValue?.toDouble() ?? 0.0;
//               print('Fetched Calories Data Point: $caloriesValue');
//               (totalCalories += caloriesValue).ceilToDouble();
//             }
//             else {
//               print('Unexpected value type for calories data: ${data.value.runtimeType}');
//             }
//           }
//           print('Total Calories Fetched: $totalCalories');
//           return totalCalories;
//         }

//         else {
//           print('No calories data available for the given date range');
//           return 0.0; // Return 0.0 if no data is available
//         }
//       }
//       catch (e) {
//         print('Error fetching calories: $e'); 
//         return null;
//       }
//     }
    
//     else {
//       print('HealthKit authorization not granted');
//     }
//     return null;
//   }

//   Future<int?> getStepsForThatActivity(DateTime startTime, DateTime endTime) async {

//     final bool requested = await healthFactory.requestAuthorization(dataTypesIos, permissions: permissions);
    
//     if (requested) {

//       try {
//         final totalSteps = await healthFactory.getTotalStepsInInterval(startTime, endTime);
//         print('Fetching steps from $startTime to $endTime');
//         print('Total steps fetched: $totalSteps');
//         return totalSteps;
//       }
//       catch (e) {
//         print('Error fetching steps: $e');
//         return -1;
//       } 
//     } else {
//       print('HealthKit authorization not granted');
//       return -1;
//     }

//   }

  Future<double?> getCaloriesBurnedForThatActivity(DateTime startTime, DateTime endTime) async {
  final bool requested = await healthFactory.requestAuthorization(dataTypesIos, permissions: permissions);

  if (requested) {
    try {
      final healthData = await healthFactory.getHealthDataFromTypes(startTime, endTime, [HealthDataType.ACTIVE_ENERGY_BURNED]);
      print('Fetching calories data from $startTime to $endTime');

      if (healthData.isNotEmpty) {
        double totalCalories = 0.0;

        // Sum up all the calorie values
        for (var data in healthData) {
          if (data.value is NumericHealthValue) {
            final caloriesValue = (data.value as NumericHealthValue).numericValue?.toDouble() ?? 0.0;
            print('Fetched Calories Data Point: $caloriesValue');
            totalCalories += caloriesValue;
          } else {
            print('Unexpected value type for calories data: ${data.value.runtimeType}');
          }
        }
        print('Total Calories Fetched: $totalCalories');
        return totalCalories.ceilToDouble();
      } else {
        print('No calories data available for the given date range');
        return 0.0; // Return 0.0 if no data is available
      }
    } catch (e) {
      print('Error fetching calories: $e');
      return null;
    }
  } else {
    print('HealthKit authorization not granted');
    return null;
  }
}

Future<int?> getStepsForThatActivity(DateTime startTime, DateTime endTime) async {
  final bool requested = await healthFactory.requestAuthorization(dataTypesIos, permissions: permissions);

  if (requested) {
    try {
      final totalSteps = await healthFactory.getTotalStepsInInterval(startTime, endTime);
      print('Fetching steps from $startTime to $endTime');
      print('Total steps fetched: $totalSteps');
      return totalSteps;
    } catch (e) {
      print('Error fetching steps: $e');
      return null;
    }
  } else {
    print('HealthKit authorization not granted');
    return null;
  }
}

Future<int?> getHeartRateForThatActivity(DateTime startTime, DateTime endTime) async {
  final bool requested = await healthFactory.requestAuthorization(dataTypesIos, permissions: permissions);

  if (requested) {
    try {
      final totalSteps = await healthFactory.getTotalStepsInInterval(startTime, endTime);
      print('Fetching steps from $startTime to $endTime');
      print('Total steps fetched: $totalSteps');
      return totalSteps;
    } catch (e) {
      print('Error fetching steps: $e');
      return null;
    }
  } else {
    print('HealthKit authorization not granted');
    return null;
  }
}

Future<double?> getAverageHeartRateForThatActivity(DateTime startTime, DateTime endTime) async {
    final bool requested = await healthFactory.requestAuthorization(dataTypesIos, permissions: permissions);

    if (requested) {
      try {
        // Fetch the heart rate data for the specified time interval
        final healthData = await healthFactory.getHealthDataFromTypes(startTime, endTime, [HealthDataType.HEART_RATE]);
        print('Fetching heart rate data from $startTime to $endTime');

        if (healthData.isNotEmpty) {
          double totalHeartRate = 0.0;
          int count = 0;

          // Iterate over the health data to sum up all the heart rate values
          for (var data in healthData) {
            if (data.value is NumericHealthValue) {
              final heartRateValue = (data.value as NumericHealthValue).numericValue?.toDouble() ?? 0.0;
              print('Fetched Heart Rate Data Point: $heartRateValue');
              totalHeartRate += heartRateValue;
              count++;
            } else {
              print('Unexpected value type for heart rate data: ${data.value.runtimeType}');
            }
          }

          if (count > 0) {
            double averageHeartRate = totalHeartRate / count;
            print('Average Heart Rate: $averageHeartRate');
            return averageHeartRate.ceilToDouble();
          } else {
            print('No heart rate data available for the given date range');
            return 0.0; // Return 0.0 if no data is available
          }
        } else {
          print('No heart rate data available for the given date range');
          return 0.0; // Return 0.0 if no data is available
        }
      } catch (e) {
        print('Error fetching heart rate: $e');
        return null;
      }
    } else {
      print('HealthKit authorization not granted');
      return null;
    }
  }
  Future<double?> getMaxHeartRateForThatActivity(DateTime startTime, DateTime endTime) async {
    
    final bool requested = await healthFactory.requestAuthorization(dataTypesIos, permissions: permissions);

    if (requested) {
      try {
        final healthData = await healthFactory.getHealthDataFromTypes(startTime, endTime, [HealthDataType.HEART_RATE]);
        print('Fetching heart rate data from $startTime to $endTime');

        if (healthData.isNotEmpty) {
          double maxHeartRate = 0.0;

          // Iterate over the health data to find the maximum heart rate value
          for (var data in healthData) {
            if (data.value is NumericHealthValue) {
              final heartRateValue = (data.value as NumericHealthValue).numericValue?.toDouble() ?? 0.0;
              if (heartRateValue > maxHeartRate) {
                maxHeartRate = heartRateValue;
              }
            } else {
              print('Unexpected value type for heart rate data: ${data.value.runtimeType}');
            }
          }

          print('Max Heart Rate Fetched: $maxHeartRate');
          return maxHeartRate.ceilToDouble();
        } else {
          print('No heart rate data available for the given date range');
          return null; // Return null if no data is available
        }
      } catch (e) {
        print('Error fetching max heart rate: $e');
        return null;
      }
    } else {
      print('HealthKit authorization not granted');
      return null;
    }
  }

  // filter - select any time period

  Future<Map<String, dynamic>> getFilterHealthData(DateTime fromDate, DateTime toDate) async {
    
    try {
      
      final bool requested = await healthFactory.requestAuthorization(dataTypesIos, permissions: permissions);

      if (requested) {
        final healthData = await Future.wait([
          healthFactory.getHealthDataFromTypes(fromDate, toDate, [HealthDataType.STEPS]),
          healthFactory.getHealthDataFromTypes(fromDate, toDate, [HealthDataType.ACTIVE_ENERGY_BURNED]),
          healthFactory.getHealthDataFromTypes(fromDate, toDate, [HealthDataType.HEART_RATE]),
        ]);

        // extract data
        final stepsData = healthData[0];
        final caloriesData = healthData[1];
        final heartRateData = healthData[2];

        // calculate total steps
        int totalSteps = stepsData.fold(0, (sum, data) {
          if (data.value is NumericHealthValue) {
            return sum + ((data.value as NumericHealthValue).numericValue?.toInt() ?? 0);
          }
          return sum;
        });

        // calculate total calories burned
        double totalCalories = caloriesData.fold(0.0, (sum, data) {
          if (data.value is NumericHealthValue) {
            return sum + ((data.value as NumericHealthValue).numericValue?.toDouble() ?? 0.0);
          }
          return sum;
        });

        // Calculate average heart rate
        List<double> heartRateValues = heartRateData
            .where((data) => data.value is NumericHealthValue)
            .map((data) => (data.value as NumericHealthValue).numericValue?.toDouble() ?? 0.0)
            .toList();

        double averageHeartRate = heartRateValues.isNotEmpty
            ? heartRateValues.reduce((a, b) => a + b) / heartRateValues.length
            : 0.0;

        // Calculate maximum heart rate
        double maxHeartRate = heartRateValues.isNotEmpty ? heartRateValues.reduce((a, b) => a > b ? a : b) : 0.0;

        return {
          'totalSteps': totalSteps,
          'totalCalories': totalCalories,
          'averageHeartRate': averageHeartRate,
          'maxHeartRate': maxHeartRate,
        };
      }

      else {
        throw Exception('HealthKit authorixation not granted');
      }
    
    }
    catch (e) {
      print('Error fetching health data: $e');
      
      return {
        'totalSteps': 0,
        'totalCalories': 0.0,
        'averageHeartRate': 0.0,
        'maxHeartRate': 0.0,
      };
    }
  }



}