import 'package:cloud_firestore/cloud_firestore.dart';

class FitnessPlan {
  final List<String> activities;
  final List<int> durations;
  final String goals;
  final String level;
  final List<String> tags;
  final String title;

  FitnessPlan({
    required this.activities,
    required this.durations,
    required this.goals,
    required this.level,
    required this.tags,
    required this.title,
  });

  // Factory constructor to create a FitnessPlan from a Map
  factory FitnessPlan.fromMap(Map<String, dynamic> data) {
    return FitnessPlan(
      activities: List<String>.from(data['activities'] ?? []),
      durations: List<int>.from(data['durations'] ?? []),
      goals: data['goals'] ?? '',
      level: data['level'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
      title: data ['title'] ?? '',
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
      'title' : title,
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
        // print('Fetched document data: $data');

        // Create FitnessPlan from map and print its attributes
        final plan = FitnessPlan.fromMap(data);
        // print('Activities: ${plan.activities}');
        // print('Durations: ${plan.durations}');
        // print('Goals: ${plan.goals}');
        // print('Level: ${plan.level}');
        // print('Tags: ${plan.tags}');
        // print('Title: ${plan.title}');

        return plan;
      }).toList();

      return fitnessPlans;
    } catch (e) {
      print('Failed to fetch fitness plans: $e');
      return [];
    }
  }

  static Future<List<FitnessPlan>> fetchFitnessPlansWorkout() async {
    try {
      // Fetch the fitness plans collection from Firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('fitnessPlans')
          .get();

      // Map the documents to FitnessPlan objects and include them in a list
      List<FitnessPlan> fitnessPlans = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        // Create a FitnessPlan from map but include only the necessary fields
        final plan = FitnessPlan.fromMap({
          'activities': List<String>.from(data['activities'] ?? []),
          'durations': List<int>.from(data['durations'] ?? []),
          'title': data['title'] ?? '',
          'goals': '', // Add empty default values for fields you don't need
          'level': '',
          'tags': [],
        });

        return plan;
      }).toList();

      return fitnessPlans;
    } catch (e) {
      print('Failed to fetch fitness plans with details: $e');
      return [];
    }
  }


}
