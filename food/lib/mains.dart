import 'package:flutter/material.dart';
import 'package:flutter_health_connect/flutter_health_connect.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<HealthConnectDataType> types = [
    HealthConnectDataType.Steps,
    HealthConnectDataType.ExerciseSession,
  ];

  bool readOnly = true;
  String resultText = '';
  String token = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Health Connect'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ElevatedButton(
              onPressed: () async {
                var result = await HealthConnectFactory.isApiSupported();
                setState(() {
                  resultText = 'isApiSupported: $result';
                });
              },
              child: const Text('isApiSupported'),
            ),
            ElevatedButton(
              onPressed: () async {
                var result = await HealthConnectFactory.isAvailable();
                setState(() {
                  resultText = 'isAvailable: $result';
                });
              },
              child: const Text('Check installed'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await HealthConnectFactory.installHealthConnect();
                  setState(() {
                    resultText = 'Install activity started';
                  });
                } catch (e) {
                  setState(() {
                    resultText = e.toString();
                  });
                }
              },
              child: const Text('Install Health Connect'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await HealthConnectFactory.openHealthConnectSettings();
                  setState(() {
                    resultText = 'Settings activity started';
                  });
                } catch (e) {
                  setState(() {
                    resultText = e.toString();
                  });
                }
              },
              child: const Text('Open Health Connect Settings'),
            ),
            ElevatedButton(
              onPressed: () async {
                var result = await HealthConnectFactory.hasPermissions(
                  types,
                  readOnly: readOnly,
                );
                setState(() {
                  resultText = 'hasPermissions: $result';
                });
              },
              child: const Text('Has Permissions'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  token = await HealthConnectFactory.getChangesToken(types);
                  setState(() {
                    resultText = 'token: $token';
                  });
                } catch (e) {
                  setState(() {
                    resultText = e.toString();
                  });
                }
              },
              child: const Text('Get Changes Token'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  var result = await HealthConnectFactory.getChanges(token);
                  setState(() {
                    resultText = 'changes: $result';
                  });
                } catch (e) {
                  setState(() {
                    resultText = e.toString();
                  });
                }
              },
              child: const Text('Get Changes'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  var result = await HealthConnectFactory.requestPermissions(
                    types,
                    readOnly: readOnly,
                  );
                  setState(() {
                    resultText = 'requestPermissions: $result';
                  });
                } catch (e) {
                  setState(() {
                    resultText = e.toString();
                  });
                }
              },
              child: const Text('Request Permissions'),
            ),
            ElevatedButton(
              onPressed: () async {
                var startTime = DateTime.now().subtract(const Duration(days: 4));
                var endTime = DateTime.now();
                try {
                  final requests = <Future>[];
                  Map<String, dynamic> typePoints = {};
                  for (var type in types) {
                    requests.add(HealthConnectFactory.getRecord(
                      type: type,
                      startTime: startTime,
                      endTime: endTime,
                    ).then((value) => typePoints.addAll({type.name: value})));
                  }
                  await Future.wait(requests);
                  setState(() {
                    resultText = '$typePoints';
                  });
                } catch (e) {
                  setState(() {
                    resultText = e.toString();
                  });
                }
              },
              child: const Text('Get Record'),
            ),
            Text(resultText),
          ],
        ),
      ),
    );
  }
}
