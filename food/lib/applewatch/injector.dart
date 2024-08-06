import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;
import 'package:health/health.dart' show HealthFactory;

late HealthFactory healthFactory;

initializeDependencies() {
  WidgetsFlutterBinding.ensureInitialized();
  healthFactory = HealthFactory(useHealthConnectIfAvailable: true);
}
