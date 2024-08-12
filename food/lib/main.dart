import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:food/firebase_options.dart';
import 'package:food/services/notification_service.dart';
import 'pages/user/view/intro_page.dart';
import 'package:food/applewatch/injector.dart' show initializeDependencies;
import 'package:health/health.dart';
import 'package:timezone/data/latest.dart' as tz; 


// initialize the HealthFactory globally
final HealthFactory healthFactory = HealthFactory();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    initializeDependencies();
    Stripe.publishableKey = "pk_test_51Pa6OlGwNxjo4qONIEwyIRRlgb2XX0QtOi1be81uw5s3UkWHqfx8q02QEhipq7Lo12dRFUdbxE2dXvMg5LXcRUi400ohnfhYtk";
    Stripe.instance.applySettings();
    
    await requestHealthKitAuthorization();

    // final notificationService = NotificationService();
    // await notificationService.initNotification();
    // await notificationService.scheduleNotifications();

    NotificationService().initNotification();
    tz.initializeTimeZones();
  } catch (e) {
    print('Initialization failed: $e');
  }

  runApp(const MyApp());
}


Future<void> requestHealthKitAuthorization() async {
  final bool requested = await healthFactory.requestAuthorization(
    [HealthDataType.STEPS],
    permissions: [HealthDataAccess.READ],
  );
  
  if (!requested) {
    print('HealthKit authorization failed.');
  } else {
    print('HealthKit authorization granted.');
  }


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

class HomePage extends StatelessWidget {
  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Flutter is fun"),
      ),
      body: RepaintBoundary(
        key: _globalKey,
        child: Container(
          color: Colors.green,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdminViewAllUserAccounts()),
                    );
                  },
                  child: Text('Go to View All User Accounts Page'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdminCreateNewAccount()),
                    );
                  },
                  child: Text('Go to Create New Account Page'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdminUpdateAccount()),
                    );
                  },
                  child: Text('Go to Update Account Page'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChallengePage()),
                    );
                  },
                  child: Text('Go to Trainer Main Page'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _takeScreenshotAndShare(context),
                  child: Text('Share To Social Media'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _takeScreenshotAndShare(BuildContext context) async {
    try {
      // Delay to ensure the widget is fully rendered
      await Future.delayed(Duration(milliseconds: 100));

      RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();

        final directory = await getApplicationDocumentsDirectory();
        final imagePath = await File('${directory.path}/screenshot.png').create();
        await imagePath.writeAsBytes(pngBytes);

        await Share.shareFiles([imagePath.path]).catchError((error) {
          print('Error sharing: $error');
        });
      }
    } catch (e) {
      print('Error taking screenshot: $e');
    }
  }
}
