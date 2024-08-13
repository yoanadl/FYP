import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/fitness_plan_model.dart';

class FitnessPlanPresenter {
  // Fetch user's height and weight from Firestore
  Future<Map<String, double>> fetchUserHeightAndWeight() async {
    double userHeight = 0.0;
    double userWeight = 0.0;

    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        print('User is not authenticated');
        return {'height': userHeight, 'weight': userWeight};
      }

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('UserProfile')
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot docSnapshot = querySnapshot.docs.first;
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

        userHeight = double.tryParse(data['Height(cm)'] ?? '0') ?? 0.0;
        userWeight = double.tryParse(data['Weight(kg)'] ?? '0') ?? 0.0;
        
      } else {
        print('No profile document found');
      }
    } catch (e) {
      print('Error fetching height and weight: $e');
    }

    return {'height': userHeight, 'weight': userWeight};
  }

  // Fetch and present fitness plans
  Future<void> presentFitnessPlans() async {
    List<FitnessPlan> fitnessPlans = await FitnessPlan.fetchFitnessPlans();

    for (var plan in fitnessPlans) {
      // Process the fetched fitness plans
      // For example, you could print them, filter them, etc.
      print('Fitness Plan: ${plan.goals}, Level: ${plan.level}, Tags: ${plan.tags.join(', ')}');
    }
  }

  // Function to get fitness recommendations based on BMI status
  List<String> getRecommendations(String bmiStatus) {
    switch (bmiStatus) {
      case 'Underweight':
        return ['Muscle Gain', 'Weight Gain', 'Improve Endurance'];
      case 'Normal':
        return ['Muscle Gain', 'Keep Fit', 'Improve Endurance'];
      case 'Overweight':
        return ['Muscle Gain', 'Weight Loss'];
      case 'Obese':
        return ['Muscle Gain', 'Keep Fit', 'Weight Loss'];
      default:
        return [];
    }
  }


  // Generate a fitness plan based on height and weight
  void generateFitnessPlan(double height, double weight) {
    // Your logic to generate a fitness plan based on height and weight
    // For example, you might calculate recommended exercises, calories, etc.
    print('Generating fitness plan for height: $height cm and weight: $weight kg');
  }

  // Combine the fetching of user data and presentation of fitness plans
  Future<void> fetchAndPresentUserFitnessPlans() async {
    // Fetch the user's height and weight
    Map<String, double> userMetrics = await fetchUserHeightAndWeight();

    // Use height and weight to generate a fitness plan (if needed)
    generateFitnessPlan(userMetrics['height'] ?? 0.0, userMetrics['weight'] ?? 0.0);

    // Fetch and present fitness plans
    await presentFitnessPlans();
  }
}
