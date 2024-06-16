import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food/firebase_options.dart';
import 'package:food/services/auth/auth_gate.dart';

import 'pages/intro_page.dart';

// import 'package:random_color/random_color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // RandomColor _randomColor = RandomColor();
    // Color _color = _randomColor.randomColor();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthGate(), 
    );
  }
}
