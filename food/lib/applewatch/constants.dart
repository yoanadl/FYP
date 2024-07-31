import 'package:health/health.dart' show HealthDataAccess, HealthDataType;

const dataTypesIos = [
  HealthDataType.STEPS,
];
const permissions = [HealthDataAccess.READ];

final currentDate = DateTime.now(); // End of today
final midNight = DateTime(
  DateTime.now().year,
  DateTime.now().month,
  DateTime.now().day,
); // Start of today
