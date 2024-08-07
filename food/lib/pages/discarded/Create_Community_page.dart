//temp code

import 'package:flutter/material.dart';
import 'package:food/pages/workout/views/workout_page_view.dart';

import '../../components/navbar.dart';
import 'community_page.dart';
import '../user/view/profile_page.dart';

import 'package:food/pages/discarded/Pre_made_Meal/Weight_Loss_Low_carb.dart';

Widget buildMeanPlanContainer(WeightLossLowCarb mealPlan) {
  return Container(
    width: 250,
    height: 200,
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
        SizedBox(height: 8.0,),
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
            width: 230,
            height: 80,
          ),
        ),          
      ],
    ),
  );
}

class CreateCommunityPage extends StatelessWidget {
  const CreateCommunityPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Meal Plans',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              children: [
                for (WeightLossLowCarb mealPlan in MealPlansType1)
                  buildMeanPlanContainer(mealPlan),
              ],
            ),
          ),
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

