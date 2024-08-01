import 'package:food/applewatch/constants.dart' show currentDate, dataTypesIos, midNight, permissions;
import 'package:food/applewatch/injector.dart' show healthFactory;
import 'package:health/health.dart';

class HealthService {

  Future<int?> getSteps() async {

    final bool requested = await healthFactory.requestAuthorization(dataTypesIos, permissions: permissions);
    
    if (requested) {

      try {
        final totalSteps = await healthFactory.getTotalStepsInInterval(currentDate, midNight);
        print('Fetching steps from $currentDate to $midNight');
        print('Total steps fetched: $totalSteps');
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
            print('Fetching steps from $oneHourAgo to $now');
            print('Fetched Current Heart Rate: $heartRateValue');
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

  // Future<double?> getCalories() async {

  //   final bool requested = await healthFactory.requestAuthorization(dataTypesIos, permissions: permissions);

  //   if (requested) {
  //     try {
  //       final healthData = await healthFactory.getHealthDataFromTypes(currentDate, midNight, [HealthDataType.ACTIVE_ENERGY_BURNED]);

  //       if (healthData.isNotEmpty) {
  //         final data = healthData.last;

  //         if (data.value is NumericHealthValue) {
  //           final caloriesValue = (data.value as NumericHealthValue).numericValue?.toDouble() ?? 0.0;
  //           print('Fetching steps from $currentDate to $midNight');
  //           print('Fetched Current Calories: $caloriesValue');
  //           return caloriesValue;
  //         } else {
  //           print('Unexpected value type for calories data: ${data.value.runtimeType}');
  //           return null;
  //         }
  //       }

  //       else {
  //         print('NO calories data available');
  //       }

  //     }

  //     catch (e) {
  //       print('Authorization not granted');
  //       return null;

  //     }
  //   }
  // }

  Future<double?> getCalories() async {
  final bool requested = await healthFactory.requestAuthorization(dataTypesIos, permissions: permissions);

  if (requested) {
    try {
      print('Fetching calories data from $currentDate to $midNight');
      final healthData = await healthFactory.getHealthDataFromTypes(currentDate, midNight, [HealthDataType.ACTIVE_ENERGY_BURNED]);

      print('Health Data: $healthData'); // Print health data for debugging

      if (healthData.isNotEmpty) {
        double totalCalories = 0.0;

        // Iterate over the health data to sum up all the calorie values
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





}