import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food/components/base_page.dart';
import 'package:food/components/navbar.dart';

class ChallengeResultsPage extends StatefulWidget {
  final String challengeId;

  ChallengeResultsPage({required this.challengeId});

  @override
  State<ChallengeResultsPage> createState() => _ChallengeResultsPageState();
}

class _ChallengeResultsPageState extends State<ChallengeResultsPage> {

  final GlobalKey _globalKey = GlobalKey();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 40),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'Challenge Results',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.emoji_events),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: _shareResults,
          ),
          SizedBox(width: 16),
        ],
      ),
      body: RepaintBoundary(
        key: _globalKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              FutureBuilder<String>(
                future: _fetchChallengeTitle(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    print('Error: ${snapshot.error}');
                    return Center(child: Text('Error loading challenge title'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    print('No challenge title available');
                    return Center(child: Text('No challenge title available'));
                  } else {
                    final challengeTitle = snapshot.data!;
                    return Text(
                      challengeTitle,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    );
                  }
                },
              ),
              SizedBox(height: 16),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _fetchChallengeResults(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      print('Error: ${snapshot.error}');
                      return Center(child: Text('Error loading challenge results'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      print('No data available or empty challenge results');
                      return Center(child: Text('No data available'));
                    } else {
                      final results = snapshot.data!;
                      return ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final entry = results[index];
                          return Card(
                            child: ListTile(
                              title: Text(entry['displayName'] ?? 'No username'),
                              trailing: Text('${entry['totalPoints']} pts'),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Navbar(
        currentIndex: 2,
        onTap: (int index) {
          if (index != 2) {
            Navigator.pop(context);
            switch (index) {
              case 0:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const BasePage(initialIndex: 0)));
                break;
              case 1:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const BasePage(initialIndex: 1)));
                break;
              case 3:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const BasePage(initialIndex: 3)));
                break;
            }
          }
        },
      ),
    );
  }

  Future<String> _fetchChallengeTitle() async {
    try {
      final challengeDoc = await FirebaseFirestore.instance
          .collection('challenges')
          .doc(widget.challengeId)
          .get();

      if (challengeDoc.exists) {
        final challengeData = challengeDoc.data();
        return challengeData?['title'] ?? 'No Title'; // Assuming 'title' is the field for challenge title
      } else {
        print('Challenge document does not exist');
        return 'No Title';
      }
    } catch (e) {
      print('Error fetching challenge title: $e');
      return 'No Title';
    }
  }

  Future<List<Map<String, dynamic>>> _fetchChallengeResults() async {
    final results = <Map<String, dynamic>>[];

    try {
      final challengeDoc = await FirebaseFirestore.instance
          .collection('challenges')
          .doc(widget.challengeId)
          .get();

      if (!challengeDoc.exists) {
        print('Challenge document does not exist');
        return results;
      }

      final participants = List<Map<String, dynamic>>.from(challengeDoc.data()?['participants'] ?? []);
     
      for (var participant in participants) {
        final displayName = participant['displayName'] ?? 'Anonymous';
        final totalPoints = participant['totalPoints'] ?? 0;

        results.add({
          'displayName': displayName,
          'totalPoints': totalPoints,
        });
      }

      results.sort((a, b) {
        return b['totalPoints'] - a['totalPoints'];
      });

    } catch (e) {
      print('Error fetching challenge results: $e');
    }

    return results;
  }

  Future<void> _shareResults() async {
    try {
      await Future.delayed(Duration(milliseconds: 100));

      RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();

        final directory = await getApplicationDocumentsDirectory();
        final imagePath = '${directory.path}/screenshot.png';
        final imageFile = File(imagePath);
        await imageFile.writeAsBytes(pngBytes);

        if (await imageFile.exists()) {
          print('File exists at $imagePath');
          final result = await Share.shareXFiles(
            [XFile(imagePath)],
          ).catchError((error) {
            print('Error sharing: $error');
          });

          if (result.status == ShareResultStatus.success) {
            print('Thank you for sharing the picture!');
          } else if (result.status == ShareResultStatus.dismissed) {
            print('Share was dismissed.');
          }
        } else {
          print('File does not exist at $imagePath');
        }
      } else {
        print('Error: ByteData is null');
      }
    } catch (e) {
      print('Error taking screenshot: $e');
    }
  }
}
