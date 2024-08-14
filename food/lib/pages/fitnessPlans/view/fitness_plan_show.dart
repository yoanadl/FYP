import 'package:flutter/material.dart';
import '../presenter/fitness_plan_presenter.dart';
import '../model/fitness_plan_model.dart';
import '../../profileSetting/bmi_controller.dart';
import '../view/fitness_plan_details.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FitnessPlanPage extends StatefulWidget {
  @override
  _FitnessPlanPageState createState() => _FitnessPlanPageState();
}

class _FitnessPlanPageState extends State<FitnessPlanPage> {
  late FitnessPlanPresenter fitnessPlanPresenter;
  late BmiController bmiController;
  double userHeight = 0.0;
  double userWeight = 0.0;
  double userBMI = 0.0;
  String bmiStatus = '';
  List<FitnessPlan> fitnessPlans = [];
  List<FitnessPlan> allFitnessPlans = []; // List to hold the original plans
  String userId = '';

  // Variables for filtering
  String? selectedGoal; // Nullable to handle no selection
  String? selectedLevel; // Nullable to handle no selection
  List<String> selectedTags = [];

  @override
  void initState() {
    super.initState();
    fitnessPlanPresenter = FitnessPlanPresenter();
    bmiController = BmiController();
    fetchUserDataAndPlans();
  }

  void fetchUserDataAndPlans() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        userId = user.uid;
      } else {
        print('No user is currently signed in.');
        return;
      }

      Map<String, double> userMetrics = await fitnessPlanPresenter.fetchUserHeightAndWeight();
      setState(() {
        userHeight = userMetrics['height'] ?? 0.0;
        userWeight = userMetrics['weight'] ?? 0.0;
        userBMI = bmiController.calculateBMI(userHeight, userWeight);
        bmiStatus = bmiController.getBMIStatus(userBMI);
      });

      List<FitnessPlan> plans = await FitnessPlan.fetchFitnessPlans();
      setState(() {
        allFitnessPlans = plans; // Save the original list
        fitnessPlans = filterPlans(plans); // Apply the filter
        print('Filtered Fitness Plans: ${fitnessPlans.map((plan) => plan.title).toList()}');
      });
    } catch (e) {
      print('Error fetching user data and plans: $e');
    }
  }

  // Method to filter plans based on selected criteria
  List<FitnessPlan> filterPlans(List<FitnessPlan> plans) {
    print('Filtering plans with goal: $selectedGoal, level: $selectedLevel, tags: $selectedTags');
    return plans.where((plan) {
      bool matchesGoal = selectedGoal == null || plan.goals.toLowerCase() == selectedGoal!.toLowerCase();
      bool matchesLevel = selectedLevel == null || plan.level.toLowerCase() == selectedLevel!.toLowerCase();
      bool matchesTags = selectedTags.isEmpty || selectedTags.every((tag) => plan.tags.contains(tag));

      return matchesGoal && matchesLevel && matchesTags;
    }).toList();
  }

  // Toggle selection of tags
  void toggleTagSelection(String tag) {
    setState(() {
      if (selectedTags.contains(tag)) {
        selectedTags.remove(tag);
      } else {
        selectedTags.add(tag);
      }
      print('Tags after toggle: $selectedTags');
      fitnessPlans = filterPlans(allFitnessPlans); // Use allFitnessPlans to re-filter
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use the FitnessPlanPresenter instance to get recommendations
    List<String> recommendations = fitnessPlanPresenter.getRecommendations(bmiStatus);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // Remove default shadow from AppBar
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30.0),
              Text(
                'My Fitness Plan',
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              Text(
                'Based on your BMI (${userBMI.toStringAsFixed(1)}), which is considered "$bmiStatus", here are your fitness plan goals recommendations:',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 10.0),
              Text(
                recommendations.isNotEmpty
                    ? recommendations.join(', ')
                    : 'No recommendations available',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 24.0),
             Row(
              children: [
                // Goal Dropdown
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.white,  // Background color of the dropdown
                      borderRadius: BorderRadius.circular(12.0),  // Border radius
                      border: Border.all(
                        color: Color(0XFF031927),  // Border color
                        width: 1.0,  // Border width
                      ),
                    ),
                    child: DropdownButton<String>(
                      value: selectedGoal,
                      hint: Text(
                        "Select Goal",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      isExpanded: true,  // Ensures the dropdown takes up the full width
                      underline: SizedBox(),  // Removes the default underline
                      items: [
                        'improve endurance',
                        'weight gain',
                        'weight loss',
                        'muscle gain',
                        'keep fit'
                      ].map((goal) => DropdownMenuItem<String>(
                            value: goal,
                            child: Text(
                              goal,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          )).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedGoal = value;
                          print('Selected Goal: $selectedGoal');
                          fitnessPlans = filterPlans(allFitnessPlans); // Re-filter plans
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(width: 10),
                // Level Dropdown
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.white,  // Background color of the dropdown
                      borderRadius: BorderRadius.circular(12.0),  // Border radius
                      border: Border.all(
                        color: Color(0XFF031927),  // Border color
                        width: 1.0,  // Border width
                      ),
                    ),
                    child: DropdownButton<String>(
                      value: selectedLevel,
                      hint: Text(
                        "Select Level",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      isExpanded: true,  // Ensures the dropdown takes up the full width
                      underline: SizedBox(),  // Removes the default underline
                      items: [
                        'beginner',
                        'advanced',
                        'master'
                      ].map((level) => DropdownMenuItem<String>(
                            value: level,
                            child: Text(
                              level,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          )).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedLevel = value;
                          print('Selected Level: $selectedLevel');
                          fitnessPlans = filterPlans(allFitnessPlans); // Re-filter plans
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),

              SizedBox(height: 10.0),
        
              // Tags Checkboxes
              Wrap(
                spacing: 10.0,
                children: [
                  'cardio',
                  'equipments',
                  'weights',
                  'hiit',
                  'mats',
                ].map((tag) {
                  return FilterChip(
                    label: Text(tag),
                    selected: selectedTags.contains(tag),
                    onSelected: (isSelected) {
                      toggleTagSelection(tag);
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 20.0),
        
              // Display fitness plans or show a message if no plans match the filter
              fitnessPlans.isEmpty
                  ? Center(
                      child: Text(
                        "No workout is available",
                        style: TextStyle(fontSize: 18.0, color: Colors.red),
                      ),
                    )
                  : Column(
                      children: fitnessPlans.map((plan) {
                        return Container(
                          width: double.infinity, // Make the container full width
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: SizedBox(
                            height: 120.0,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Color(0XFF031927), // Button text color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25), // Button border radius
                                ),
                                padding: EdgeInsets.symmetric(vertical: 15.0), // Button padding
                                elevation: 5, // Elevation for the shadow
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FitnessPlanDetailPage(
                                      fitnessPlan: plan,
                                      userId: userId,
                                    ),
                                  ),
                                );
                              },
                              child: Center(
                                child: Text(
                                  plan.title,
                                  style: TextStyle(fontSize: 18.0, fontFamily: 'Poppins', fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
