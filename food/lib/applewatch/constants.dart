import 'package:health/health.dart' show HealthDataAccess, HealthDataType;

const dataTypesIos = [
  HealthDataType.STEPS,
  HealthDataType.HEART_RATE,
  HealthDataType.ACTIVE_ENERGY_BURNED,
];
const permissions = [
  HealthDataAccess.READ, 
  HealthDataAccess.READ,
  HealthDataAccess.READ
];

final currentDate = DateTime(
  DateTime.now().year,
  DateTime.now().month,
  DateTime.now().day,
); // start of today (midnight that just passed)

final midNight = currentDate.add(Duration(days: 1));  
