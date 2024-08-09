import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as datetime_picker;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:food/services/notifi_service.dart';

DateTime scheduleTime = DateTime.now();
List<ScheduledNotification> scheduledNotifications = [];

class ScheduledNotification {
  final int id;
  final String title;
  final String body;
  final DateTime dateTime;

  ScheduledNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.dateTime,
  });
}

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key, required this.title});

  final String title;

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  void _handleNotificationScheduled() {
    setState(() {
      scheduledNotifications.add(ScheduledNotification(
        id: DateTime.now().millisecondsSinceEpoch % 10000,
        title: 'Scheduled Notification',
        body: '$scheduleTime',
        dateTime: scheduleTime,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const DatePickerTxt(),
            ScheduleBtn(onNotificationScheduled: _handleNotificationScheduled),
            Expanded(
              child: ListView.builder(
                itemCount: scheduledNotifications.length,
                itemBuilder: (context, index) {
                  final notification = scheduledNotifications[index];
                  return ListTile(
                    title: Text('${notification.title}: ${notification.dateTime}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DatePickerTxt extends StatefulWidget {
  const DatePickerTxt({
    Key? key,
  }) : super(key: key);

  @override
  State<DatePickerTxt> createState() => _DatePickerTxtState();
}

class _DatePickerTxtState extends State<DatePickerTxt> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        datetime_picker.DatePicker.showDateTimePicker(
          context,
          showTitleActions: true,
          onChanged: (date) => setState(() => scheduleTime = date),
          onConfirm: (date) => setState(() => scheduleTime = date),
        );
      },
      child: const Text(
        'Select Date Time',
        style: TextStyle(color: Colors.blue),
      ),
    );
  }
}

class ScheduleBtn extends StatelessWidget {
  final VoidCallback onNotificationScheduled;

  const ScheduleBtn({Key? key, required this.onNotificationScheduled}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text('Schedule Workout notifications'),
      onPressed: () async {
        final int notificationId = DateTime.now().millisecondsSinceEpoch % 10000; // Unique ID for each notification
        bool success = await NotificationService().scheduleNotification(
            id: notificationId,
            title: 'Scheduled Notification',
            body: '$scheduleTime',
            scheduledNotificationDateTime: scheduleTime);

        if (success) {
          onNotificationScheduled(); // Notify parent widget
        }

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(success ? 'Success' : 'Failed'),
              content: Text(success
                  ? 'Notification successfully scheduled for $scheduleTime'
                  : 'Failed to schedule notification for $scheduleTime'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
