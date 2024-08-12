import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:food/challenge_owner_view_joined_page.dart';
import 'package:food/challenge_viewer_view_joined_page.dart';
import 'package:food/challenge_viewer_view_page.dart';
import 'package:food/create_new_challenge_page.dart';
import 'package:food/my_challenge_page.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:food/pages/challenge_and_reward_page.dart';
import 'package:food/trainer_main_page.dart';
import 'pages/admin/admin_view_all_user_accounts.dart';
import 'pages/admin/admin_create_new_account.dart';
import 'pages/admin/admin_update_account.dart';
import 'friend_list.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePage(),
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
                      MaterialPageRoute(builder: (context) => ChallengeOwnerViewJoinedPage()),
                    );
                  },
                  child: Text('Go to Challenge Owner View Joined Page'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChallengeViewerViewPage()),
                    );
                  },
                  child: Text('Go to Challenge Viewer View Page'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChallengeViewerViewJoinedPage()),
                    );
                  },
                  child: Text('Go to Challenge Viewer View joined Page'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CreateNewChallengePage()),
                    );
                  },
                  child: Text('Go to Create New Challenge Page'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyChallengePage()),
                    );
                  },
                  child: Text('Go to My Challenge Page'),
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
