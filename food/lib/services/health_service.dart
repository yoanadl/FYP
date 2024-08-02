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

  Future<double?> getHeartRate() async {
    final bool requested = await healthFactory.requestAuthorization(dataTypesIos, permissions: permissions);

    if (requested) {
      try {
        final DateTime now = DateTime.now();
        final DateTime oneHourAgo = now.subtract(Duration(hours:1));
        final healthData = await healthFactory.getHealthDataFromTypes(oneHourAgo, now, [HealthDataType.HEART_RATE]);

        if (healthData.isNotEmpty) {
          // Get the most recent heart rate data point
          final data = healthData.last;
          if (data.value is NumericHealthValue) {
            final heartRateValue = (data.value as NumericHealthValue).numericValue?.toDouble() ?? 0.0;
            // print('Fetching steps from $oneHourAgo to $now');
            // print('Fetched Current Heart Rate: $heartRateValue');
            return heartRateValue;
          } else {
            print('Unexpected value type for heart rate data: ${data.value.runtimeType}');
            return null;
          }
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
        print('Error fetching calories: $e'); // Detailed error message
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

}
