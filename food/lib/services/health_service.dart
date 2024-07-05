

import 'package:food/applewatch/constants.dart' show currentDate, dataTypesIos, midNight, permissions;
import 'package:food/applewatch/injector.dart' show healthFactory;
import 'package:health/health.dart';


class HealthService {

  Future<int?> getSteps() async {
    final bool requested = await healthFactory
        .requestAuthorization(dataTypesIos, permissions: permissions);
    if (requested) {
      return healthFactory.getTotalStepsInInterval(currentDate, midNight);
    }
    return -1;
  }

  Future<double?> getHeartRate() async {
    final bool requested = await healthFactory.requestAuthorization(dataTypesIos, permissions: permissions);
    if (requested) {
      final healthData = await healthFactory.getHealthDataFromTypes(currentDate.subtract(Duration(days: 1)), currentDate, [HealthDataType.HEART_RATE]);
      if (healthData.isNotEmpty) {
        return double.parse(healthData.first.value.toString());
      }
    }
    return -1;
  }

  Future<double?> getCalories() async {
    final bool requested = await healthFactory.requestAuthorization(dataTypesIos, permissions: permissions);
    if (requested) {
      final healthData = await healthFactory.getHealthDataFromTypes(currentDate.subtract(Duration(days: 1)), currentDate, [HealthDataType.ACTIVE_ENERGY_BURNED]);
      if (healthData.isNotEmpty) {
        return double.parse(healthData.first.value.toString());
      }
    }
    return -1;
  }
}