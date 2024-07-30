import 'package:flutter/material.dart';
import 'trainer_pending_clients.dart';
import 'trainer_my_client_page.dart';
import 'trainer_meal_plan_page.dart';
import 'trainer_workout_plan_page.dart';

class TrainerMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Hello Trainer!', style: TextStyle(fontWeight: FontWeight.w600),),
        automaticallyImplyLeading: false, 
        actions: [
          IconButton(
            icon: CircleAvatar(
              backgroundImage: AssetImage('assets/profile_picture.png'), // Replace with actual image asset
            ),
            onPressed: () {
              // Profile picture clicked
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Tuesday, 30 Jul', style: TextStyle(fontSize: 18)),
          ),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            children: [
              _buildGridTile(context, 'Workout Plan', Color(0xFF508AA8), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TrainerWorkoutPlanPage()),
                );
              }),
              _buildGridTile(context, 'Meal Plan', Color(0xFF9DD1F1), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TrainerMealPlanPage()),
                );
              }),
              _buildGridTile(context, 'Pending Request', Color(0xFFD3E2F1), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TrainerPendingClientsPage()),
                );
              }),
              _buildGridTile(context, 'My Client', Color(0xFF000000), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TrainerMyClientPage()),
                );
              }),
            ],
          ),
          Spacer(),
          Text('More features coming soon :)'),
        ],
      ),
    
    );
  }

  Widget _buildGridTile(BuildContext context, String title, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
