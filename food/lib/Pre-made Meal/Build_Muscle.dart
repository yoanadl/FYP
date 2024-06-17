import 'dart:ffi';

import 'package:flutter/material.dart';

class BuildMuscle{
  final String name;
  final Image image;
  final List<String> details;

  const BuildMuscle(
    {
      required this.name, 
      required this.image,
      required this.details
    }
  );
}

List<BuildMuscle> sampleMealPlans = [
  BuildMuscle(
    name: 'Meal Plan 1',
    image: Image.asset('lib/images/SalmonwithroastedVeg.jpg'),
    details: [
      'Salmon with roasted vegetables',
    ]
  ),

   BuildMuscle(
    name: 'Meal Plan 2',
    image: Image.asset('lib/images/SalmonwithroastedVeg.jpg'),
    details: [
      'Veggie stir-fry with brown rice',
    ]
  ),

   BuildMuscle(
    name: 'Meal Plan 3',
    image: Image.asset('lib/images/SalmonwithroastedVeg.jpg'),
    details: [
      'Tuna salad sandwich on whole-wheat bread',
    ]
  ),

];