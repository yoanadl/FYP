import 'package:flutter/material.dart';

class BuildMuscleLowCarb{
  final String name;
  final String details;
  final Image image;
  final String breakfast;
  final String morningSnack;
  final String lunch;
  final String afternoonSnack;
  final String dinner;

  const BuildMuscleLowCarb(
    {
      required this.name, 
      required this.details,
      required this.image,
      required this.breakfast,
      required this.morningSnack,
      required this.lunch,
      required this.afternoonSnack,
      required this.dinner
    }
  );
}

List<BuildMuscleLowCarb> MealPlansType3 = [
  BuildMuscleLowCarb(
    name: 'Meal Plan 1',
    details: 'New York strip steak with mashed potatoes and asparagus',
    image: Image.asset('lib/images/CauliflowerMacCheese.jpg'),
    breakfast: 'Eggs and bacon with spinach',
    morningSnack: '12 almond',
    lunch: 'Baked Salmon with salad ',
    afternoonSnack: '12 almond',
    dinner: 'New York strip steak with mashed potatoes and asparagus'
  ),

  BuildMuscleLowCarb(
    name: 'Meal Plan 2',
    details:'Salmon burger with slaw',
    image: Image.asset('lib/images/CauliflowerMacCheese.jpg'),
    breakfast: 'Scrambled eggs',
    morningSnack: '12 almond',
    lunch: 'High protein Tofu Poke Bowl',
    afternoonSnack: '12 almond',
    dinner: 'Salmon burger with slaw'
  ),

  BuildMuscleLowCarb(
    name: 'Meal Plan 3',
    details: 'Tuna salad sandwich on whole-wheat bread',
    image: Image.asset('lib/images/CauliflowerMacCheese.jpg'),
    breakfast: 'High Protein Scramble egg with Quinoa',
    morningSnack: '1 cup edamame',
    lunch: 'Low Calorie Popcorn Chicken',
    afternoonSnack: '12 almond',
    dinner: 'High Protein Burrito Bowl'
  ),
];
