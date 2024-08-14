import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food/pages/challenges/challenge_done_page.dart';

class ChallengeActivityPage extends StatefulWidget {
  final String challengeId;

  ChallengeActivityPage({required this.challengeId});

  @override
  _ChallengeActivityPageState createState() => _ChallengeActivityPageState();
}

class _ChallengeActivityPageState extends State<ChallengeActivityPage> {
  late String challengeTitle = "Loading...";
  late List<Map<String, dynamic>> activities;
  late int _currentActivityIndex;
  late int _remainingTimeInSeconds;
  bool _isBreak = false;
  bool _isPaused = false;
  Timer? _timer;
  int? _pausedTimeInSeconds;
  bool _dataLoaded = false;

  @override
  void initState() {
    super.initState();
    _fetchChallengeData();
  }

  void _fetchChallengeData() async {
    final challengeSnapshot = await FirebaseFirestore.instance
        .collection('challenges')
        .doc(widget.challengeId)
        .get();

    if (challengeSnapshot.exists) {
      final challengeData = challengeSnapshot.data() as Map<String, dynamic>;
      challengeTitle = challengeData['title'] ?? 'Challenge';
      activities = List<Map<String, dynamic>>.from(challengeData['activities'] ?? []);

      activities = activities.map((activity) {
        return {
          'name': activity['name'] ?? 'Unknown Activity',
          'duration': int.tryParse(activity['duration'].toString()) ?? 0,
        };
      }).toList();

      if (activities.isNotEmpty) {
        setState(() {
          _currentActivityIndex = 0;
          _dataLoaded = true;
          _startActivityTimer();
        });
      } else {
        print('No activities found');
        setState(() {
          _dataLoaded = true;
        });
      }
    } else {
      print('Challenge not found');
    }
  }

  void _startActivityTimer() {
    if (_currentActivityIndex < activities.length) {
      _remainingTimeInSeconds = activities[_currentActivityIndex]['duration'] * 60;
      _isBreak = false;
      _startTimer();
    }
  }

  void _startBreakTimer() {
    _remainingTimeInSeconds = 30;
    _isBreak = true;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_isPaused) return;

      if (_remainingTimeInSeconds > 0) {
        setState(() {
          _remainingTimeInSeconds--;
        });
      } else {
        _timer?.cancel();
        if (_isBreak) {
          _isBreak = false;
          _startNextActivity();
        } else {
          if (_currentActivityIndex < activities.length - 1) {
            _startBreakTimer();
          } else {
            _navigateToChallengeDonePage();
          }
        }
      }
    });
  }

  void _pauseTimer() {
    if (_timer?.isActive ?? false) {
      setState(() {
        _isPaused = true;
        _pausedTimeInSeconds = _remainingTimeInSeconds;
      });
    }
  }

  void _resumeTimer() {
    if (_isPaused) {
      setState(() {
        _isPaused = false;
        _remainingTimeInSeconds = _pausedTimeInSeconds ?? 0;
        _startTimer();
      });
    }
  }

  void _startNextActivity() {
    setState(() {
      _currentActivityIndex++;
      if (_currentActivityIndex < activities.length) {
        _startActivityTimer();
      } else {
        _navigateToChallengeDonePage();
      }
    });
  }

  void _navigateToChallengeDonePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ChallengeDonePage(points: 100),
      ),
    );
  }

  void _stopChallenge() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.white,
  //     appBar: AppBar(
  //       backgroundColor: Colors.white,
  //       title: Text(
  //         challengeTitle,
  //         style: TextStyle(
  //           fontWeight: FontWeight.w700,
  //           fontSize: 23
  //         ),
  //       ),
  //     ),
  //     body: _dataLoaded
  //         ? Padding(
  //             padding: const EdgeInsets.all(16.0),
  //             child: Center(
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Text(
  //                     _isBreak ? 'Break' : challengeTitle,
  //                     style: TextStyle(
  //                       fontSize: 22,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                   SizedBox(height: 30),
  //                   Stack(
  //                     alignment: Alignment.center,
  //                     children: [
  //                       SizedBox(
  //                         width: 150,
  //                         height: 150,
  //                         child: CircularProgressIndicator(
  //                           value: _dataLoaded
  //                             ? (_isBreak
  //                                 ? 1 - (_remainingTimeInSeconds / 30) 
  //                                 : _remainingTimeInSeconds /
  //                                     (activities[_currentActivityIndex]['duration'] * 60))
  //                             : null,
  //                         strokeWidth: 10,
  //                       ),
  //                     ),
  //                        Align(
  //                         alignment: Alignment.center,
  //                         child: Text(
  //                           '${_remainingTimeInSeconds ~/ 60}:${(_remainingTimeInSeconds % 60).toString().padLeft(2, '0')}',
  //                           style: TextStyle(
  //                             fontSize: 20,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                   SizedBox(height: 30),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       ElevatedButton(
  //                         onPressed: _timer?.isActive ?? false
  //                             ? (_isPaused ? _resumeTimer : _pauseTimer)
  //                             : null,
  //                         child: Icon(
  //                           _isPaused ? Icons.play_arrow : Icons.pause,
  //                           size: 24,
  //                         ),
  //                       ),
  //                       SizedBox(width: 16),
  //                     ],
  //                   ),
  //                   SizedBox(height: 20,),
  //                   Container(
  //                     height: 50,
  //                     width: 190,
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(10),
  //                       color: Color(0xFFBA1200),
  //                     ),
  //                     child: TextButton(
  //                       onPressed: _stopChallenge,
  //                       child: Text(
  //                         'Stop Challenge',
  //                         style: TextStyle(
  //                           color: Colors.white,
  //                           fontSize: 18,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           )
  //         : Center(child: CircularProgressIndicator()),
  //   );
  // }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      backgroundColor: Colors.white,
      title: Text(
        challengeTitle,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 23
        ),
      ),
    ),
    body: _dataLoaded
        ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isBreak
                        ? 'Break'
                        : activities.isNotEmpty
                            ? activities[_currentActivityIndex]['name'] ?? 'Unknown Activity'
                            : challengeTitle,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        height: 150,
                        child: CircularProgressIndicator(
                          value: _dataLoaded
                            ? (_isBreak
                                ? 1 - (_remainingTimeInSeconds / 30)
                                : _remainingTimeInSeconds /
                                    (activities[_currentActivityIndex]['duration'] * 60))
                            : null,
                          strokeWidth: 10,
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          '${_remainingTimeInSeconds ~/ 60}:${(_remainingTimeInSeconds % 60).toString().padLeft(2, '0')}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _timer?.isActive ?? false
                            ? (_isPaused ? _resumeTimer : _pauseTimer)
                            : null,
                        child: Icon(
                          _isPaused ? Icons.play_arrow : Icons.pause,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 16),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Container(
                    height: 50,
                    width: 190,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFBA1200),
                    ),
                    child: TextButton(
                      onPressed: _stopChallenge,
                      child: Text(
                        'Stop Challenge',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Center(child: CircularProgressIndicator()),
  );
}

}
