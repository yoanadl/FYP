import 'package:food/applewatch/constants.dart' show currentDate, dataTypesIos, midNight, permissions;
import 'package:food/applewatch/injector.dart' show healthFactory;
import 'package:health/health.dart';

class HealthService {

  Future<int?> getSteps() async {
    try {
      final bool requested = await healthFactory.requestAuthorization(dataTypesIos, permissions: permissions);
      if (requested) {
        print('Fetching steps from $midNight to $currentDate');
        int? totalSteps = await healthFactory.getTotalStepsInInterval(midNight, currentDate);
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
}



// }
