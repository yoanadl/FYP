// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class EditWorkoutPage extends StatefulWidget {
//   final String userId;
//   final String workoutId;
//   final String workoutTitle;
//   final List<int> duration;
//   final List<String> activities;

//   EditWorkoutPage({
//     required this.userId,
//     required this.workoutId,
//     required this.workoutTitle,
//     required this.duration,
//     required this.activities,
//   });

//   @override
//   _EditWorkoutPageState createState() => _EditWorkoutPageState();
// }

// class _EditWorkoutPageState extends State<EditWorkoutPage> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _durationController = TextEditingController();
//   final TextEditingController _activitiesController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _loadWorkoutDetails();
//   }

//   void _loadWorkoutDetails() {
//     _titleController.text = widget.workoutTitle;
//     _durationController.text = widget.duration.join(', ');
//     _activitiesController.text = widget.activities.join(', ');
//   }

//   void _saveWorkout() {
//     if (_formKey.currentState!.validate()) {
//       try {
//         List<int> durations = _durationController.text.split(',').map((e) => int.parse(e.trim())).toList();
//         List<String> activities = _activitiesController.text.split(',').map((e) => e.trim()).toList();

//         FirebaseFirestore.instance
//           .collection('users')
//           .doc(widget.userId)
//           .collection('workouts')
//           .doc(widget.workoutId)
//           .update({
//             'title': _titleController.text,
//             'duration': durations,
//             'activities': activities,
//           });

//         Navigator.pop(context);
//       } catch (e) {
//         print('Error saving workout: $e');
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: Text('Error'),
//             content: Text('Failed to save workout. Please try again later.'),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: Text('OK'),
//               ),
//             ],
//           ),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Workout'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               TextFormField(
//                 controller: _titleController,
//                 decoration: InputDecoration(labelText: 'Workout Title'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a title';
//                   }
//                   return null;
//                 },
//               ),
//               _buildActivityField('Workout Activity 1', _activitiesController),
//               _buildDurationField('Duration', _durationController),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _saveWorkout,
//                 child: Text('Save Workout'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//     Widget _buildActivityField(String labelText, TextEditingController controller) {
//     List<String> activities = widget.activities;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         SizedBox(height: 20),
//         Text(
//           labelText,
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 16,
//           ),
//         ),
//         ListView.builder(
//           shrinkWrap: true,
//           itemCount: activities.length,
//           itemBuilder: (context, index) {
//             return TextField(
//               controller: TextEditingController(text: activities[index]),
//               onChanged: (value) {
//                 activities[index] = value;
//               },
//               decoration: InputDecoration(
//                 hintText: 'Enter workout activity',
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }

//     Widget _buildDurationField(String labelText, TextEditingController controller) {
//     List<int> durations = widget.duration;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         SizedBox(height: 20),
//         Text(
//           labelText,
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 16,
//           ),
//         ),
//         ListView.builder(
//           shrinkWrap: true,
//           itemCount: durations.length,
//           itemBuilder: (context, index) {
//             return TextField(
//               controller: TextEditingController(text: durations[index].toString()),
//               onChanged: (value) {
//                 durations[index] = int.parse(value);
//               },
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 hintText: 'Enter duration in minutes',
//                 border: OutlineInputBorder(),
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }
//   @override
//   void dispose() {
//     _titleController.dispose();
//     _durationController.dispose();
//     _activitiesController.dispose();
//     super.dispose();
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class EditWorkoutPage extends StatefulWidget {
//   final String userId;
//   final String workoutId;
//   final String workoutTitle;
//   final List<int> duration;
//   final List<String> activities;

//   EditWorkoutPage({
//     required this.userId,
//     required this.workoutId,
//     required this.workoutTitle,
//     required this.duration,
//     required this.activities,
//   });

//   @override
//   _EditWorkoutPageState createState() => _EditWorkoutPageState();
// }

// class _EditWorkoutPageState extends State<EditWorkoutPage> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _titleController = TextEditingController();
//   final List<TextEditingController> _activityControllers = [];
//   final List<TextEditingController> _durationControllers = [];

//   @override
//   void initState() {
//     super.initState();
//     _titleController.text = widget.workoutTitle;
//     _activityControllers.addAll(widget.activities.map((activity) => TextEditingController(text: activity)));
//     _durationControllers.addAll(widget.duration.map((duration) => TextEditingController(text: duration.toString())));
//   }

//   void _saveWorkout() {
//     if (_formKey.currentState!.validate()) {
//       try {
//         List<String> activities = _activityControllers.map((controller) => controller.text.trim()).toList();
//         List<int> durations = _durationControllers.map((controller) => int.parse(controller.text.trim())).toList();

//         FirebaseFirestore.instance
//           .collection('users')
//           .doc(widget.userId)
//           .collection('workouts')
//           .doc(widget.workoutId)
//           .update({
//             'title': _titleController.text,
//             'activities': activities,
//             'duration': durations,
//           });

//         Navigator.pop(context);
//       } catch (e) {
//         print('Error saving workout: $e');
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: Text('Error'),
//             content: Text('Failed to save workout. Please try again later.'),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: Text('OK'),
//               ),
//             ],
//           ),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Workout'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               TextFormField(
//                 controller: _titleController,
//                 decoration: InputDecoration(labelText: 'Workout Title'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a title';
//                   }
//                   return null;
//                 },
//               ),
//               ..._buildActivityFields(),
//               ..._buildDurationFields(),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _saveWorkout,
//                 child: Text('Save Workout'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   List<Widget> _buildActivityFields() {
//     return _activityControllers.asMap().entries.map((entry) {
//       int index = entry.key;
//       TextEditingController controller = entry.value;
//       return _buildActivityField('Workout Activity ${index + 1}', controller);
//     }).toList();
//   }

//   List<Widget> _buildDurationFields() {
//     return _durationControllers.asMap().entries.map((entry) {
//       int index = entry.key;
//       TextEditingController controller = entry.value;
//       return _buildDurationField('Duration ${index + 1}', controller);
//     }).toList();
//   }

//   Widget _buildActivityField(String labelText, TextEditingController controller) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         SizedBox(height: 20),
//         Text(
//           labelText,
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 16,
//           ),
//         ),
//         TextField(
//           controller: controller,
//           decoration: InputDecoration(
//             hintText: 'Enter workout activity',
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildDurationField(String labelText, TextEditingController controller) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         SizedBox(height: 20),
//         Text(
//           labelText,
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 16,
//           ),
//         ),
//         TextField(
//           controller: controller,
//           keyboardType: TextInputType.number,
//           decoration: InputDecoration(
//             hintText: 'Enter duration in minutes',
//             border: OutlineInputBorder(),
//           ),
//         ),
//       ],
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class EditWorkoutPage extends StatefulWidget {
//   final String userId;
//   final String workoutId;
//   final String workoutTitle;
//   final List<int> duration;
//   final List<String> activities;

//   EditWorkoutPage({
//     required this.userId,
//     required this.workoutId,
//     required this.workoutTitle,
//     required this.duration,
//     required this.activities,
//   });

//   @override
//   _EditWorkoutPageState createState() => _EditWorkoutPageState();
// }

// class _EditWorkoutPageState extends State<EditWorkoutPage> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _titleController = TextEditingController();
//   final List<TextEditingController> _activityControllers = [];
//   final List<TextEditingController> _durationControllers = [];

//   @override
//   void initState() {
//     super.initState();

//     // initialize controllers with existing workout details
//     _titleController.text = widget.workoutTitle;
//     _activityControllers.addAll(widget.activities.map((activity) => TextEditingController(text: activity)));
//     _durationControllers.addAll(widget.duration.map((duration) => TextEditingController(text: duration.toString())));
//   }

//   void _saveWorkout() {
//     if (_formKey.currentState!.validate()) {

//       try {

//         // collect updated data from controllers
//         List<String> activities = _activityControllers.map((controller) => controller.text.trim()).toList();
//         List<int> durations = _durationControllers.map((controller) => int.parse(controller.text.trim())).toList();

//         // update firestore document with new data
//         FirebaseFirestore.instance
//             .collection('users')
//             .doc(widget.userId)
//             .collection('workouts')
//             .doc(widget.workoutId)
//             .update({
//           'title': _titleController.text,
//           'duration': durations,
//           'activities': activities,
//         });

//         // Navigate back after successful update
//         Navigator.pop(context);
//       } catch (e) {
//         print('Error saving workout: $e');

//         // show error dialog if update fails
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: Text('Error'),
//             content: Text('Failed to save workout. Please try again later.'),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: Text('OK'),
//               ),
//             ],
//           ),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Workout'),
//         backgroundColor: Colors.white,
//       ),
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [

//               // workout title input field
//               TextFormField(
//                 controller: _titleController,
//                 decoration: InputDecoration(labelText: 'Workout Title'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a title';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 20),
//               Column(
//                 children: List.generate(
//                   _activityControllers.length,
//                   (index) => Column(
//                     children: [
//                       _buildActivityField('Workout Activity ${index + 1}', _activityControllers[index]),
//                       SizedBox(height: 10),
//                       _buildDurationField('Duration', _durationControllers[index]),
//                       SizedBox(height: 20),
//                     ],
//                   ),
//                 ),
//               ),

//               // save button
//               ElevatedButton(
//                 onPressed: _saveWorkout,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xff031927), 
//                   foregroundColor: Colors.white, 
//                 ),
//                 child: Text(
//                   'Save Workout'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildActivityField(String labelText, TextEditingController controller) {
//     return TextFormField(
//       controller: controller,
//       decoration: InputDecoration(labelText: labelText),
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please enter a value';
//         }
//         return null;
//       },
//     );
//   }

//   Widget _buildDurationField(String labelText, TextEditingController controller) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: TextInputType.number,
//       decoration: InputDecoration(
//         labelText: labelText,
//         hintText: 'Enter duration in minutes',
//       ),
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please enter a value';
//         }
//         return null;
//       },
//     );
//   }

//   @override
//   void dispose() {
    
//     // dispose controllers to avoid memory leaks
//     _titleController.dispose();
//     _activityControllers.forEach((controller) => controller.dispose());
//     _durationControllers.forEach((controller) => controller.dispose());
//     super.dispose();
//   }
// }



import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditWorkoutPage extends StatefulWidget {
  final String userId;
  final String workoutId;
  final String workoutTitle;
  final List<int> duration;
  final List<String> activities;

  EditWorkoutPage({
    required this.userId,
    required this.workoutId,
    required this.workoutTitle,
    required this.duration,
    required this.activities,
  });

  @override
  _EditWorkoutPageState createState() => _EditWorkoutPageState();
}

class _EditWorkoutPageState extends State<EditWorkoutPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final List<TextEditingController> _activityControllers = [];
  final List<TextEditingController> _durationControllers = [];

  @override
  void initState() {
    super.initState();

    // initialize controllers with existing workout details
    _titleController.text = widget.workoutTitle;
    _activityControllers.addAll(widget.activities.map((activity) => TextEditingController(text: activity)));
    _durationControllers.addAll(widget.duration.map((duration) => TextEditingController(text: duration.toString())));
  }

  void _saveWorkout() {
    if (_formKey.currentState!.validate()) {

      try {
        // collect updated data from controllers
        List<String> activities = _activityControllers.map((controller) => controller.text.trim()).toList();
        List<int> durations = _durationControllers.map((controller) => int.parse(controller.text.trim())).toList();

        // update firestore document with new data
        FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .collection('workouts')
            .doc(widget.workoutId)
            .update({
              'title': _titleController.text,
              'duration': durations,
              'activities': activities,
        });

        // Navigate back after successful update
        Navigator.pop(context);

      } 
      catch (e) {
        print('Error saving workout: $e');

        // show error dialog if update fails
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Failed to save workout. Please try again later.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Workout'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [

              // workout title input field
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Workout Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              Column(
                children: List.generate(
                  _activityControllers.length,
                  (index) => Column(
                    children: [
                      _buildActivityField('Workout Activity ${index + 1}', _activityControllers[index]),
                      SizedBox(height: 10),
                      _buildDurationField('Duration', _durationControllers[index]),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // save button
              ElevatedButton(
                onPressed: _saveWorkout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff031927), 
                  foregroundColor: Colors.white, 
                ),
                child: Text(
                  'Save Workout'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityField(String labelText, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a value';
        }
        return null;
      },
    );
  }

  Widget _buildDurationField(String labelText, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: 'Enter duration in minutes',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a value';
        }
        int? duration = int.tryParse(value);
        if (duration == null || duration <= 0) {
          return 'Please enter a valid duration (positive number)';
        }
        return null;
      },
    );
  }

  @override
  void dispose() {
    
    // dispose controllers to avoid memory leaks
    _titleController.dispose();
    _activityControllers.forEach((controller) => controller.dispose());
    _durationControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }
}


