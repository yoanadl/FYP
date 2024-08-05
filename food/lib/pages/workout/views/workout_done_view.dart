// import 'package:flutter/material.dart';
// import 'package:food/pages/workout/presenters/workout_done_presenter.dart';
// import '../models/workout_done_model.dart';
// import 'package:food/services/health_service.dart';

// class WorkoutDoneView extends StatefulWidget {
//   final WorkoutDonePresenter presenter;
//   final DateTime? startTime;
//   final DateTime? endTime;

//   WorkoutDoneView({
//     Key? key,
//     required this.presenter,
//     this.startTime,
//     this.endTime,
//   }) : super(key: key);

//   @override
//   _WorkoutDoneViewState createState() => _WorkoutDoneViewState();
// }

// class _WorkoutDoneViewState extends State<WorkoutDoneView> implements WorkoutDoneViewInterface {
//   late WorkoutDoneModel _model;
//   final HealthService _healthService = HealthService();
//   late WorkoutDoneModel _currentModel;

//   @override
//   void initState() {
//     super.initState();

//     DateTime startTime = widget.startTime ?? DateTime.now();
//     DateTime endTime = widget.endTime ?? DateTime.now();

//     _model = WorkoutDoneModel(
//       caloriesBurned: 0,
//       heartRate: 0,
//       steps: 0,
//       startTime: startTime,
//       endTime: endTime,
//       activities: const [],
//       durations: const [],
//     );

//     widget.presenter.setModel(_model);

//     _fetchHealthData(startTime, endTime);
//   }

//   // works for one activity per workout
//   // Future<void> _fetchHealthData(DateTime startTime, DateTime endTime) async {
    
//   //   DateTime bufferedStartTime = startTime.subtract(Duration(minutes: 5));
//   //   DateTime bufferedEndTime = endTime.add(Duration(minutes: 5));

//   //   print('Fetching calories burned from $bufferedStartTime to $bufferedEndTime');
//   //   double? caloriesBurned = await _healthService.getCaloriesBurnedForThatActivity(bufferedStartTime, bufferedEndTime);
//   //   print('Calories burned fetched: $caloriesBurned');

//   //   print('Fetching steps from $bufferedStartTime to $bufferedEndTime');
//   //   int? steps = await _healthService.getStepsForThatActivity(bufferedStartTime, bufferedEndTime);
//   //   print('Steps fetched: $steps');

//   //   setState(() {
//   //     _model = _model.copyWith(
//   //       caloriesBurned: caloriesBurned,
//   //       steps: steps,
//   //     );
//   //     widget.presenter.updateView(_model);
//   //   });
//   // }

//   Future<void> _fetchHealthData(DateTime startTime, DateTime endTime) async {
    
//     DateTime bufferedStartTime = startTime.subtract(Duration(minutes: 5));

//     double totalCaloriesBurned = 0;
//     int totalSteps = 0;

//     for (int i = 0; i < _model.activities.length; i++) {
//       DateTime activityStartTime = bufferedStartTime.add(Duration(minutes: _model.durations.take(i).fold(0, (prev, duration) => prev + duration)));
//       DateTime activityEndTime = activityStartTime.add(Duration(minutes: _model.durations[i]));

//       print('Fetching calories burned from $activityStartTime to $activityEndTime');
//       double? caloriesBurned = await _healthService.getCaloriesBurnedForThatActivity(activityStartTime, activityEndTime);
//       if (caloriesBurned != null) {
//         totalCaloriesBurned += caloriesBurned;
//       }

//       print('Fetching steps from $activityStartTime to $activityEndTime');
//       int? steps = await _healthService.getStepsForThatActivity(activityStartTime, activityEndTime);
//       if (steps != null) {
//         totalSteps += steps;
//       }
//     }

//     setState(() {
//       _model = _model.copyWith(
//         caloriesBurned: totalCaloriesBurned,
//         steps: totalSteps,
//       );
//       widget.presenter.updateView(_model);
//     });
//   }

//   @override
//   void updateView(WorkoutDoneModel model) {
//     setState(() {
//       _model = model;
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'You did it!',
//                 style: TextStyle(
//                   fontSize: 30,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 30),
//               _buildStatsRow(
//                 icon: Icons.local_fire_department,
//                 text: 'Calories burned: ${_model.caloriesBurned} kcal',
//               ),

//               SizedBox(height: 30),
//               _buildStatsRow(
//                 icon: Icons.directions_walk,
//                 text: 'Steps took: ${_model.steps} steps',
//               ),
//               SizedBox(height: 30),
//               _buildStatsRow(
//                 icon: Icons.favorite,
//                 text: 'Heart rate: ${_model.heartRate} bpm',
//               ),
//               SizedBox(height: 40),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: Text(
//                   'Exit Workout',
//                   style: TextStyle(fontSize: 20),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xff031927),
//                   foregroundColor: Colors.white,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildStatsRow({required IconData icon, required String text}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(icon, size: 30),
//         SizedBox(width: 10),
//         Text(
//           text,
//           style: TextStyle(fontSize: 20),
//         ),
//       ],
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:food/pages/workout/presenters/workout_done_presenter.dart';
// import '../models/workout_done_model.dart';
// import 'package:food/services/health_service.dart';

// class WorkoutDoneView extends StatefulWidget {
//   final WorkoutDonePresenter presenter;
//   final DateTime? startTime;
//   final DateTime? endTime;
//   final List<String> activities;
//   final List<int> durations;

//   WorkoutDoneView({
//     Key? key,
//     required this.presenter,
//     this.startTime,
//     this.endTime,
//     required this.activities,
//     required this.durations,
//   }) : super(key: key);

//   @override
//   _WorkoutDoneViewState createState() => _WorkoutDoneViewState();
// }

// class _WorkoutDoneViewState extends State<WorkoutDoneView> implements WorkoutDoneViewInterface {
//   late WorkoutDoneModel _model;
//   final HealthService _healthService = HealthService();

//   @override
//   void initState() {
//     super.initState();
//     print("WorkoutDoneView initialized");

//     DateTime startTime = widget.startTime ?? DateTime.now();
//     DateTime endTime = widget.endTime ?? DateTime.now();

//     _model = WorkoutDoneModel(
//       caloriesBurned: 0,
//       heartRate: 0,
//       steps: 0,
//       startTime: startTime,
//       endTime: endTime,
//       activities: const [],
//       durations: const [],
//     );

//     widget.presenter.setModel(_model);
//     _fetchHealthData(startTime, endTime);
//   }

//   Future<void> _fetchHealthData(DateTime startTime, DateTime endTime) async {
//     print("Fetching health data...");
    
//     DateTime bufferedStartTime = startTime.subtract(Duration(minutes: 5));

//     double totalCaloriesBurned = 0;
//     int totalSteps = 0;

//     for (int i = 0; i < _model.activities.length; i++) {
//       DateTime activityStartTime = bufferedStartTime.add(Duration(minutes: _model.durations.take(i).fold(0, (prev, duration) => prev + duration)));
//       DateTime activityEndTime = activityStartTime.add(Duration(minutes: _model.durations[i]));

//       print('Fetching calories burned from $activityStartTime to $activityEndTime');
//       double? caloriesBurned = await _healthService.getCaloriesBurnedForThatActivity(activityStartTime, activityEndTime);
//       if (caloriesBurned != null) {
//         totalCaloriesBurned += caloriesBurned;
//       }

//       print('Fetching steps from $activityStartTime to $activityEndTime');
//       int? steps = await _healthService.getStepsForThatActivity(activityStartTime, activityEndTime);
//       if (steps != null) {
//         totalSteps += steps;
//       }
//     }

//     print("Total Calories Burned: $totalCaloriesBurned");
//     print("Total Steps: $totalSteps");

//     setState(() {
//       _model = _model.copyWith(
//         caloriesBurned: totalCaloriesBurned,
//         steps: totalSteps,
//       );
//       widget.presenter.updateView(_model);
//     });
//   }

//   @override
//   void updateView(WorkoutDoneModel model) {
//     setState(() {
//       _model = model;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'You did it!',
//                 style: TextStyle(
//                   fontSize: 30,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 30),
//               _buildStatsRow(
//                 icon: Icons.local_fire_department,
//                 text: 'Calories burned: ${_model.caloriesBurned} kcal',
//               ),
//               SizedBox(height: 30),
//               _buildStatsRow(
//                 icon: Icons.directions_walk,
//                 text: 'Steps took: ${_model.steps} steps',
//               ),
//               SizedBox(height: 30),
//               _buildStatsRow(
//                 icon: Icons.favorite,
//                 text: 'Heart rate: ${_model.heartRate} bpm',
//               ),
//               SizedBox(height: 40),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: Text(
//                   'Exit Workout',
//                   style: TextStyle(fontSize: 20),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xff031927),
//                   foregroundColor: Colors.white,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildStatsRow({required IconData icon, required String text}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(icon, size: 30),
//         SizedBox(width: 10),
//         Text(
//           text,
//           style: TextStyle(fontSize: 20),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:food/pages/workout/presenters/workout_done_presenter.dart';
import '../models/workout_done_model.dart';
import 'package:food/services/health_service.dart';

class WorkoutDoneView extends StatefulWidget {
  final WorkoutDonePresenter presenter;
  final DateTime? startTime;
  final DateTime? endTime;
  final List<String> activities;
  final List<int> durations;

  WorkoutDoneView({
    Key? key,
    required this.presenter,
    this.startTime,
    this.endTime,
    required this.activities,
    required this.durations,
  }) : super(key: key);

  @override
  _WorkoutDoneViewState createState() => _WorkoutDoneViewState();
}

class _WorkoutDoneViewState extends State<WorkoutDoneView> implements WorkoutDoneViewInterface {
  late WorkoutDoneModel _model;
  final HealthService _healthService = HealthService();

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

  // Future<void> _fetchHealthData(DateTime startTime, DateTime endTime) async {
  //   print("Fetching health data...");
    
  //   DateTime bufferedStartTime = startTime.subtract(Duration(minutes: 30));

  //   double totalCaloriesBurned = 0;
  //   int totalSteps = 0;

  //   for (int i = 0; i < _model.activities.length; i++) {
  //     DateTime activityStartTime = bufferedStartTime.add(Duration(minutes: _model.durations.take(i).fold(0, (prev, duration) => prev + duration)));
  //     DateTime activityEndTime = activityStartTime.add(Duration(minutes: _model.durations[i]));

  //     print('Fetching calories burned from $activityStartTime to $activityEndTime');
  //     double? caloriesBurned = await _healthService.getCaloriesBurnedForThatActivity(activityStartTime, activityEndTime);
  //     if (caloriesBurned != null) {
  //       totalCaloriesBurned += caloriesBurned;
  //     }

  //     print('Fetching steps from $activityStartTime to $activityEndTime');
  //     int? steps = await _healthService.getStepsForThatActivity(activityStartTime, activityEndTime);
  //     if (steps != null) {
  //       totalSteps += steps;
  //     }
  //   }

  //   print("Total Calories Burned: $totalCaloriesBurned");
  //   print("Total Steps: $totalSteps");

  //   setState(() {
  //     _model = _model.copyWith(
  //       caloriesBurned: totalCaloriesBurned,
  //       steps: totalSteps,
  //     );
  //     widget.presenter.updateView(_model);
  //   });
  // }

  Future<void> _fetchHealthData(DateTime startTime, DateTime endTime) async {
    print("Fetching health data...");

    // Adjust the start and end times to cover the entire workout period
    DateTime workoutStartTime = startTime.subtract(Duration(minutes: 30));
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
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Exit Workout',
                  style: TextStyle(fontSize: 20),
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
