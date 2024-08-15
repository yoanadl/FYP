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
//   bool _isBreakReminderEnabled = false;

//   @override
//   void initState() {
//     super.initState();
//     _notificationService.initNotification();
//   }

//   String _formatTime(DateTime dateTime) {
//     return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
//   }

//   void _scheduleNotification() {
//     _notificationService.scheduleDailyNotification(
//       title: 'Goodgrit',
//       body: 'It\'s time for your exercise!',
//       scheduledTime: scheduleTime,
//     );
//     debugPrint('Notification Scheduled for $scheduleTime');

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Daily reminder set for ${_formatTime(scheduleTime)}!'),
//         duration: Duration(seconds: 2),
//       ),
//     );
//   }

//   void _toggleBreakReminder(bool value) {
//     setState(() {
//       _isBreakReminderEnabled = value;
//     });


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
//                         SizedBox(width: 10),
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
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Take break reminder',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     CupertinoSwitch(
//                       value: _isBreakReminderEnabled, 
//                       onChanged: _toggleBreakReminder,
//                     )
//                   ],
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
//     _dateTimeController.text = _formatTime(scheduleTime);
//   }

//   String _formatTime(DateTime dateTime) {
//     return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
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
//                     _dateTimeController.text = _formatTime(scheduleTime);
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
//     return TextField(
//       controller: _dateTimeController,
//       readOnly: true,
//       onTap: () => _showCupertinoDateTimePicker(context),
//       decoration: InputDecoration(
//         contentPadding: EdgeInsets.all(6.0),
//         hintText: 'Select Time',
//         hintStyle: TextStyle(
//           fontSize: 14,
//         ),
//         isDense: true,  
//         isCollapsed: true,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
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
  bool _isBreakReminderEnabled = false;

  @override
  void initState() {
    super.initState();
    _notificationService.initNotification();
    // Check current break reminder status and set the switch state accordingly
    _loadBreakReminderStatus();
  }

  void _loadBreakReminderStatus() async {
    // Load and set the break reminder status from persistent storage
    final isEnabled = await _notificationService.getBreakReminderStatus();
    setState(() {
      _isBreakReminderEnabled = isEnabled;
    });
  }

  void _scheduleNotification() {
    _notificationService.scheduleDailyNotification(
      title: 'Goodgrit',
      body: 'It\'s time for your exercise!',
      scheduledTime: scheduleTime,
    );
    debugPrint('Notification Scheduled for $scheduleTime');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Daily reminder set for ${_formatTime(scheduleTime)}!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _toggleBreakReminder(bool value) async {
    setState(() {
      _isBreakReminderEnabled = value;
    });

    if (value) {
      await _notificationService.scheduleBreakReminderNotification();
    } else {
      await _notificationService.cancelBreakReminderNotification();
    }
    
    // Save the break reminder status to persistent storage
    await _notificationService.setBreakReminderStatus(value);
  }

  String _formatTime(DateTime dateTime) {
    return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
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
                        SizedBox(width: 10),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Take break reminder',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    CupertinoSwitch(
                      value: _isBreakReminderEnabled, 
                      onChanged: _toggleBreakReminder,
                    )
                  ],
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
    return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
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
                    _dateTimeController.text = _formatTime(scheduleTime);
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
