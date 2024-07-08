import 'package:flutter/material.dart';
import '../components/navbar.dart';
import 'community_page.dart';
import 'workout/workout_page.dart';
import 'profile_page.dart';
import 'package:food/pages/workout/premade_workout_summary.dart';
import 'package:food/Pre_made_Meal/Weight_Loss_Low_carb.dart';

class ExplorePremadeMeal extends StatefulWidget {
  @override
  ExplorePremadeMealState createState() => ExplorePremadeMealState();
}

Widget buildMeanPlanContainer(WeightLossLowCarb mealPlan) {
  return Container(
    width: 300,
    height: 180,
    margin: EdgeInsets.all(16.0),
    padding: EdgeInsets.all(8.0),
    decoration: BoxDecoration(
      color: Color(0x99C8E0F4),
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          mealPlan.name, 
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(height: 6.0,),
          Text(
            mealPlan.details,
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image(image: AssetImage(
            mealPlan.image),
            fit: BoxFit.cover,
            width: 300,
            height: 100,
          ),
        ),          
      ],
    ),
  );
}

class ExplorePremadeMealState extends State<ExplorePremadeMeal> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Explore Mealplan',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
          )
        ),
        backgroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 300,
                  height: 50,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search Mealplan',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: FractionalOffset.bottomLeft,
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      children: [
                        for (WeightLossLowCarb mealPlan in MealPlansType1)
                          buildMeanPlanContainer(mealPlan),
                      ],
                    ),
                  ),)
              ],
            ),
          ),

        bottomNavigationBar: Navbar(
        currentIndex: 0,
        onTap: (int index) {
          if (index != 3) {
            Navigator.pop(context);
            switch (index) {
              case 1:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const WorkoutPage()));
                break;
              case 2:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CommunityPage()));
                break;
              case 3:
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  ProfilePage()));
                break;
            }
          }
        },
      ),
    );
  }
}