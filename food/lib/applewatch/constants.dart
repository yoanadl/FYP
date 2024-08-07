// import 'package:health/health.dart' show HealthDataAccess, HealthDataType;

// const dataTypesIos = [
//   HealthDataType.STEPS,
// ];
// const permissions = [HealthDataAccess.READ];
// bool auth = ().requestAuithorization();

// if(auth){
  
// }

//allow device

final currentDate = DateTime(
  DateTime.now().year,
  DateTime.now().month,
  DateTime.now().day,
); // start of today (midnight that just passed)

final midNight = currentDate.add(Duration(days: 1));  
