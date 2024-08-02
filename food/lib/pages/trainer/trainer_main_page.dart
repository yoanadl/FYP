import 'package:flutter/material.dart';
import 'package:food/pages/trainer/models/trainer_profile_model.dart';
import 'package:food/pages/trainer/trainer_profile_page.dart';
import 'package:intl/intl.dart';
import 'trainer_pending_clients.dart';
import 'trainer_my_client_page.dart';
import 'trainer_meal_plan_page.dart';
import 'trainer_workout_plan_page.dart';

class TrainerMainPage extends StatefulWidget {
  @override
  _TrainerMainPageState createState() => _TrainerMainPageState();
}

class _TrainerMainPageState extends State<TrainerMainPage> {
  String name = '';

  @override
  void initState() {
    super.initState();
    _fetchTrainerName();
  }

  Future<void> _fetchTrainerName() async {
    TrainerProfile trainerProfile = TrainerProfile();
    await trainerProfile.fetchUserData();
    setState(() {
      name = trainerProfile.name ?? 'Trainer';
    });

  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('EEEE d MMMM').format(DateTime.now());

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 44, 24, 32),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false, // Don't show the leading button
      
          title: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Hello, $name!',
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const CircleAvatar(
                backgroundImage: AssetImage('assets/profile_picture.png'), 
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TrainerProfilePage(),
                  ),
                );
              },
            ),
          ],

        ),

      
      
      
        body: Column(
          children: [
            const SizedBox(height: 30),
             Container(
                padding: const EdgeInsets.only(left: 16.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Essentials',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    ),
                ),
            ),

            const SizedBox(height: 16),


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

            const SizedBox(height: 30),
            
            Text(
                  'More features are coming soon :)',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    ),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridTile(BuildContext context, String title, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(45.0),
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




