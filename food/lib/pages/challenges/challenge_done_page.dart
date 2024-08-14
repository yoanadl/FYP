import 'package:flutter/material.dart';

class ChallengeDonePage extends StatelessWidget {
  final int points;

  ChallengeDonePage({required this.points});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Challenge Complete',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(35.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'You completed the challenge!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'You gained $points points!',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Here you can add the logic to update the user's points in Firestore
                  Navigator.pop(context);
                },
                child: Text('Finish'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
