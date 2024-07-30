import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:food/firebase_options.dart';
import 'pages/intro_page.dart';
import 'package:food/applewatch/injector.dart' show initializeDependencies;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  initializeDependencies();
  Stripe.publishableKey = "pk_test_51Pa6OlGwNxjo4qONIEwyIRRlgb2XX0QtOi1be81uw5s3UkWHqfx8q02QEhipq7Lo12dRFUdbxE2dXvMg5LXcRUi400ohnfhYtk";
  Stripe.instance.applySettings();
  runApp( const MyApp());
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