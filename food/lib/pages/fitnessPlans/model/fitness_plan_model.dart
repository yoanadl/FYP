import 'package:cloud_firestore/cloud_firestore.dart';

class FitnessPlan {
  final List<String> activities;
  final List<String> durations;
  final String goals;
  final String level;
  final List<String> tags;

  FitnessPlan({
    required this.activities,
    required this.durations,
    required this.goals,
    required this.level,
    required this.tags,
  });

  // Factory constructor to create a FitnessPlan from a Map
  factory FitnessPlan.fromMap(Map<String, dynamic> data) {
    return FitnessPlan(
      activities: List<String>.from(data['activities'] ?? []),
      durations: List<String>.from(data['durations'] ?? []),
      goals: data['goals'] ?? '',
      level: data['level'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
    );
  }

  // Convert FitnessPlan to Map for Firebase storage
  Map<String, dynamic> toMap() {
    return {
      'activities': activities,
      'durations': durations,
      'goals': goals,
      'level': level,
      'tags': tags,
    };
  }

  // Function to fetch all fitness plans from Firebase
  static Future<List<FitnessPlan>> fetchFitnessPlans() async {
    try {
      // Fetch the fitness plans collection from Firestore
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('fitnessPlans').get();

      // Map the documents to FitnessPlan objects and include them in a list
      List<FitnessPlan> fitnessPlans = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        // Print the raw data for debugging
        print('Fetched document data: $data');

        // Create FitnessPlan from map and print its attributes
        final plan = FitnessPlan.fromMap(data);
        print('Activities: ${plan.activities}');
        print('Durations: ${plan.durations}');
        print('Goals: ${plan.goals}');
        print('Level: ${plan.level}');
        print('Tags: ${plan.tags}');

        return plan;
      }).toList();

      return fitnessPlans;
    } catch (e) {
      print('Failed to fetch fitness plans: $e');
      return [];
    }
  }
}
