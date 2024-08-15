import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:food/firebase_options.dart';
import 'package:food/services/notification_service.dart';
import 'pages/user/view/intro_page.dart';
// import 'package:food/applewatch/injector.dart' show initializeDependencies;
import 'package:health/health.dart';
import 'package:timezone/data/latest.dart' as tz; 


// initialize the HealthFactory globally
// final HealthFactory healthFactory = HealthFactory();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    initializeDependencies();
    Stripe.publishableKey = "pk_test_51Pa6OlGwNxjo4qONIEwyIRRlgb2XX0QtOi1be81uw5s3UkWHqfx8q02QEhipq7Lo12dRFUdbxE2dXvMg5LXcRUi400ohnfhYtk";
    Stripe.instance.applySettings();
    
    await requestHealthKitAuthorization();

    NotificationService().initNotification();
    tz.initializeTimeZones();
  } catch (e) {
    print('Initialization failed: $e');
  }

  runApp(const MyApp());
}


Future<void> requestHealthKitAuthorization() async {
  // final bool requested = await healthFactory.requestAuthorization(
  //   [HealthDataType.STEPS],
  //   permissions: [HealthDataAccess.READ],
  // );
  
  // if (!requested) {
  //   print('HealthKit authorization failed.');
  // } else {
  //   print('HealthKit authorization granted.');
  // }


}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const IntroPage(), 
    );
  }
}




