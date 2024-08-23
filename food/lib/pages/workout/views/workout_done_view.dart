import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:food/applewatch/injector.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:food/pages/workout/presenters/workout_done_presenter.dart';
import 'package:food/services/workout_service.dart';
import '../models/workout_done_model.dart';
import 'package:food/services/health_service.dart';


class WorkoutDoneView extends StatefulWidget {
  final WorkoutDonePresenter presenter;
  final DateTime? startTime;
  final DateTime? endTime;
  final List<String> activities;
  final List<int> durations;
  final String userId;
  final String workoutId;

  WorkoutDoneView({
    Key? key,
    required this.presenter,
    this.startTime,
    this.endTime,
    required this.activities,
    required this.durations,
    required this.userId,
    required this.workoutId
  }) : super(key: key);

  @override
  _WorkoutDoneViewState createState() => _WorkoutDoneViewState();
}

class _WorkoutDoneViewState extends State<WorkoutDoneView> implements WorkoutDoneViewInterface {
  late WorkoutDoneModel _model;
  final HealthService _healthService = HealthService();
  final WorkoutService _workoutService = WorkoutService();
  final GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    print("WorkoutDoneView initialized");

    DateTime startTime = widget.startTime ?? DateTime.now();
    DateTime endTime = widget.endTime ?? DateTime.now();

    _model = WorkoutDoneModel(
      caloriesBurned: 0,
      averageHeartRate: 0.0,
      maxHeartRate: 0.0,
      steps: 0,
      startTime: startTime,
      endTime: endTime,
      activities: widget.activities,
      durations: widget.durations,
    );

    widget.presenter.setModel(_model);
    _fetchHealthData(startTime, endTime);
  }

 
  Future<void> _fetchHealthData(DateTime startTime, DateTime endTime) async {
    print("Fetching health data...");

    // Adjust the start and end times to cover the entire workout period
    DateTime workoutStartTime = startTime.subtract(Duration(minutes: 10));
    DateTime workoutEndTime = endTime;

    double totalCaloriesBurned = 0;
    int totalSteps = 0;
    double averageHeartRate = 0.0;
    double maxHeartRate = 0.0;

    // Fetch total calories burned for the entire workout period
    print('Fetching calories burned from $workoutStartTime to $workoutEndTime');
    double? caloriesBurned = await _healthService.getCaloriesBurnedForThatActivity(workoutStartTime, workoutEndTime);
    if (caloriesBurned != null) {
      totalCaloriesBurned = caloriesBurned;
    }

    // Fetch total steps for the entire workout period
    print('Fetching steps from $workoutStartTime to $workoutEndTime');
    int? steps = await _healthService.getStepsForThatActivity(workoutStartTime, workoutEndTime);

    if (steps != null) {
      totalSteps = steps;
    }

    // Fetch average heart rate for the entire workout period
    print('Fetching average heart rate from $workoutStartTime to $workoutEndTime');
    double? heartRate = await _healthService.getAverageHeartRateForThatActivity(workoutStartTime, workoutEndTime);
    if (heartRate != null) {
      averageHeartRate = heartRate;
    }

    // Fetch maximum heart rate for the entire workout period
    print('Fetching maximum heart rate from $workoutStartTime to $workoutEndTime');
    double? maxHeartRateValue = await _healthService.getMaxHeartRateForThatActivity(workoutStartTime, workoutEndTime);
    if (maxHeartRateValue != null) {
      maxHeartRate = maxHeartRateValue;
    }

    print("Total Calories Burned: $totalCaloriesBurned");
    print("Total Steps: $totalSteps");
    print("Average Heart Rate: $averageHeartRate");


    setState(() {
      _model = _model.copyWith(
        caloriesBurned: totalCaloriesBurned,
        steps: totalSteps,
        averageHeartRate: averageHeartRate,
        maxHeartRate: maxHeartRate,
      );
      widget.presenter.updateView(_model);
    });

    // Save workout data to Firestore
    await _workoutService.saveWorkoutData(
      widget.userId,
      widget.workoutId,
      _model,
    );

  }

  
  Future<void> _shareWorkoutData() async {
  try {
    // Delay to ensure the widget is fully rendered
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



  @override
  void updateView(WorkoutDoneModel model) {
    setState(() {
      _model = model;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: RepaintBoundary(
            key: _globalKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'You did it!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 30),
                _buildStatsRow(
                  icon: Icons.local_fire_department,
                  text: 'Calories burned: ${_model.caloriesBurned} kcal',
                ),
                SizedBox(height: 30),
                _buildStatsRow(
                  icon: Icons.directions_walk,
                  text: 'Steps took: ${_model.steps} steps',
                ),
                SizedBox(height: 30),
                _buildStatsRow(
                  icon: Icons.favorite,
                  text: 'Average Heart rate: ${_model.averageHeartRate} bpm',
                ),
                 SizedBox(height: 30),
                _buildStatsRow(
                  icon: Icons.favorite,
                  text: 'Max Heart rate: ${_model.maxHeartRate} bpm',
                ),
                SizedBox(height: 40),
              
                ElevatedButton(
                  onPressed: _shareWorkoutData, 
                  child: Text(
                    'Share',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:  Color(0xff031927),
                  ),
                ),
                SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Exit Workout',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff031927),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow({required IconData icon, required String text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 30),
        SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}


