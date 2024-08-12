// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:food/components/navbar.dart';
// import 'package:food/components/base_page.dart';
// import 'package:food/services/notification_service.dart';

// DateTime scheduleTime = DateTime.now();

// class NotificationSettings extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: const Text(
//           'Notifications Settings',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 22,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           margin: EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Container(
//                 padding: EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.3),
//                       spreadRadius: 2,
//                       blurRadius: 5,
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'Receive exercise \n reminder every',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         Expanded(child: CupertinoDatePickerTxt()),
//                       ],
//                     ),
//                     SizedBox(height: 20),
//                     ScheduleBtn(),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 20),
//               Container(
//                 padding: EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.3),
//                       spreadRadius: 2,
//                       blurRadius: 5,
//                     ),
//                   ],
//                 ),
//                 child: Text(
//                   'Take break reminder',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: Navbar(
//         currentIndex: 3,
//         onTap: (int index) {
//           if (index != 3) {
//             Navigator.pop(context);
//             switch (index) {
//               case 0:
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const BasePage(initialIndex: 0)));
//                 break;
//               case 1:
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const BasePage(initialIndex: 1)));
//                 break;
//               case 2:
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const BasePage(initialIndex: 2)));
//                 break;
//             }
//           }
//         },
//       ),
//     );
//   }
// }

// class CupertinoDatePickerTxt extends StatefulWidget {
//   const CupertinoDatePickerTxt({Key? key}) : super(key: key);

//   @override
//   State<CupertinoDatePickerTxt> createState() => _CupertinoDatePickerTxtState();
// }

// class _CupertinoDatePickerTxtState extends State<CupertinoDatePickerTxt> {
//   TextEditingController _dateTimeController = TextEditingController();

//   void _showCupertinoDateTimePicker(BuildContext context) {
//     showCupertinoModalPopup(
//       context: context,
//       builder: (_) => Container(
//         height: 250,
//         color: Color.fromARGB(255, 255, 255, 255),
//         child: Column(
//           children: [
//             SizedBox(
//               height: 180,
//               child: CupertinoDatePicker(
//                 initialDateTime: scheduleTime,
//                 mode: CupertinoDatePickerMode.time,
//                 use24hFormat: true,
//                 onDateTimeChanged: (DateTime newDateTime) {
//                   setState(() {
//                     scheduleTime = newDateTime;
//                     _dateTimeController.text =
//                         "${scheduleTime.toLocal()}".split(' ')[1];
//                   });
//                 },
//               ),
//             ),
//             CupertinoButton(
//               child: Text('Done'),
//               onPressed: () => Navigator.of(context).pop(),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 90,
//       height: 40,
//       child: TextField(
//         controller: _dateTimeController,
//         readOnly: true,
//         onTap: () => _showCupertinoDateTimePicker(context),
//         decoration: InputDecoration(
//           hintText: 'Select Time',
//           hintStyle: TextStyle(
//             fontSize: 14, 
//           ),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ScheduleBtn extends StatelessWidget {
//   const ScheduleBtn({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: () {
//         debugPrint('Notification Scheduled for $scheduleTime');
//         NotificationService().scheduleDailyNotification(
//           title: 'Goodgrit',
//           body: 'It\'s time for your exercise!',
//           scheduledTime: scheduleTime,
//         );
//       },
//       child: const Text('Schedule notifications'),
//     );
//   }
// }


// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:food/components/navbar.dart';
// import 'package:food/components/base_page.dart';
// import 'package:food/services/notification_service.dart';

// DateTime scheduleTime = DateTime.now();

// class NotificationSettings extends StatefulWidget {
//   @override
//   _NotificationSettingsState createState() => _NotificationSettingsState();
// }

// class _NotificationSettingsState extends State<NotificationSettings> {
//   final NotificationService _notificationService = NotificationService();

//   @override
//   void initState() {
//     super.initState();
//     _notificationService.initNotification();
//   }

//   void _scheduleNotification() {
//     _notificationService.scheduleDailyNotification(
//       title: 'Goodgrit',
//       body: 'It\'s time for your exercise!',
//       scheduledTime: scheduleTime,
//     );
//     debugPrint('Notification Scheduled for $scheduleTime');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: const Text(
//           'Notifications Settings',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 22,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           margin: EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Container(
//                 padding: EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.3),
//                       spreadRadius: 2,
//                       blurRadius: 5,
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'Receive exercise \n reminder every',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         Expanded(child: CupertinoDatePickerTxt()),
//                       ],
//                     ),
//                     SizedBox(height: 20),
//                     ElevatedButton(
//                       onPressed: _scheduleNotification,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Color(0xFF031927),
//                         foregroundColor: Colors.white,
//                       ),
//                       child: const Text('Schedule notifications'),
                      
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 20),
//               Container(
//                 padding: EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.3),
//                       spreadRadius: 2,
//                       blurRadius: 5,
//                     ),
//                   ],
//                 ),
//                 child: Text(
//                   'Take break reminder',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: Navbar(
//         currentIndex: 3,
//         onTap: (int index) {
//           if (index != 3) {
//             Navigator.pop(context);
//             switch (index) {
//               case 0:
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const BasePage(initialIndex: 0)));
//                 break;
//               case 1:
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const BasePage(initialIndex: 1)));
//                 break;
//               case 2:
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const BasePage(initialIndex: 2)));
//                 break;
//             }
//           }
//         },
//       ),
//     );
//   }
// }

// class CupertinoDatePickerTxt extends StatefulWidget {
//   const CupertinoDatePickerTxt({Key? key}) : super(key: key);

//   @override
//   State<CupertinoDatePickerTxt> createState() => _CupertinoDatePickerTxtState();
// }

// class _CupertinoDatePickerTxtState extends State<CupertinoDatePickerTxt> {
//   TextEditingController _dateTimeController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _dateTimeController.text = "${scheduleTime.toLocal()}".split(' ')[1];
//   }

//   String _formatTime(DateTime dateTime) {
//     // format the time to exclude seconds
//     return "${dateTime.hour.toString().padLeft(2,'0')}:${dateTime.minute.toString().padLeft(2, '0')}";
//   }

//   void _showCupertinoDateTimePicker(BuildContext context) {
//     showCupertinoModalPopup(
//       context: context,
//       builder: (_) => Container(
//         height: 250,
//         color: Color.fromARGB(255, 255, 255, 255),
//         child: Column(
//           children: [
//             SizedBox(
//               height: 180,
//               child: CupertinoDatePicker(
//                 initialDateTime: scheduleTime,
//                 mode: CupertinoDatePickerMode.time,
//                 use24hFormat: true,
//                 onDateTimeChanged: (DateTime newDateTime) {
//                   setState(() {
//                     scheduleTime = newDateTime;
//                     _dateTimeController.text =
//                       _formatTime(scheduleTime);
//                   });
//                 },
//               ),
//             ),
//             CupertinoButton(
//               child: Text('Done'),
//               onPressed: () => Navigator.of(context).pop(),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 90,
//       height: 40,
//       child: TextField(
//         controller: _dateTimeController,
//         readOnly: true,
//         onTap: () => _showCupertinoDateTimePicker(context),
//         decoration: InputDecoration(
//           hintText: 'Select Time',
//           hintStyle: TextStyle(
//             fontSize: 14,
//           ),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food/components/navbar.dart';
import 'package:food/components/base_page.dart';
import 'package:food/services/notification_service.dart';

DateTime scheduleTime = DateTime.now();

class NotificationSettings extends StatefulWidget {
  @override
  _NotificationSettingsState createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _notificationService.initNotification();
  }

  void _scheduleNotification() {
    _notificationService.scheduleDailyNotification(
      title: 'Goodgrit',
      body: 'It\'s time for your exercise!',
      scheduledTime: scheduleTime,
    );
    debugPrint('Notification Scheduled for $scheduleTime');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Notifications Settings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Receive exercise \n reminder every',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 10,),
                        Expanded(child: CupertinoDatePickerTxt()),
                      ],
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _scheduleNotification,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF031927),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Schedule notifications'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Text(
                  'Take break reminder',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Navbar(
        currentIndex: 3,
        onTap: (int index) {
          if (index != 3) {
            Navigator.pop(context);
            switch (index) {
              case 0:
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BasePage(initialIndex: 0)));
                break;
              case 1:
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BasePage(initialIndex: 1)));
                break;
              case 2:
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BasePage(initialIndex: 2)));
                break;
            }
          }
        },
      ),
    );
  }
}

class CupertinoDatePickerTxt extends StatefulWidget {
  const CupertinoDatePickerTxt({Key? key}) : super(key: key);

  @override
  State<CupertinoDatePickerTxt> createState() => _CupertinoDatePickerTxtState();
}

class _CupertinoDatePickerTxtState extends State<CupertinoDatePickerTxt> {
  TextEditingController _dateTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateTimeController.text = _formatTime(scheduleTime);
  }

  String _formatTime(DateTime dateTime) {
    // Format the time to exclude seconds
    return "${dateTime.hour.toString().padLeft(2,'0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  void _showCupertinoDateTimePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: Color.fromARGB(255, 255, 255, 255),
        child: Column(
          children: [
            SizedBox(
              height: 180,
              child: CupertinoDatePicker(
                initialDateTime: scheduleTime,
                mode: CupertinoDatePickerMode.time,
                use24hFormat: true,
                onDateTimeChanged: (DateTime newDateTime) {
                  setState(() {
                    scheduleTime = newDateTime;
                    _dateTimeController.text =
                      _formatTime(scheduleTime);
                  });
                },
              ),
            ),
            CupertinoButton(
              child: Text('Done'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _dateTimeController,
      readOnly: true,
      onTap: () => _showCupertinoDateTimePicker(context),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(6.0),
        hintText: 'Select Time',
        hintStyle: TextStyle(
          fontSize: 14,
        ),
        isDense: true,  
        isCollapsed: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
