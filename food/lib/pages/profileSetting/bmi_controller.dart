import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BmiController {
  double calculateBMI(double height, double weight) {
    if (height > 0 && weight > 0) {
      return weight / math.pow(height / 100, 2); // Formula for BMI (kg/m^2)
    } else {
      return 0.0; // Handle cases with invalid height or weight
    }
  }

  String getBMIStatus(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi >= 18.5 && bmi < 24.9) {
      return 'Normal';
    } else if (bmi >= 24.9 && bmi < 29.9) {
      return 'Overweight';
    } else {
      return 'Obese';
    }
  }

  Color getColorByBMIStatus(String bmiStatus) {
    switch (bmiStatus) {
      case 'Underweight':
        return Colors.orange;
      case 'Normal':
        return Colors.green;
      case 'Overweight':
        return Colors.red;
      case 'Obese':
        return Colors.redAccent;
      default:
        return Colors.black;
    }
  }

  Future<void> updateHeightAndWeight(String uid, double height, double weight) async {
    try {
      Map<String, dynamic> newData = {
        'Height(cm)': height.toString(),
        'Weight(kg)': weight.toString(),
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('UserProfile')
          .limit(1) // Ensure you're updating the correct document
          .get()
          .then((querySnapshot) {
            if (querySnapshot.docs.isNotEmpty) {
              DocumentReference docRef = querySnapshot.docs.first.reference;
              docRef.update(newData);
            }
          });

      print('Height and weight updated successfully.');
    } catch (e) {
      print('Error updating height and weight: $e');
    }
  }
}
