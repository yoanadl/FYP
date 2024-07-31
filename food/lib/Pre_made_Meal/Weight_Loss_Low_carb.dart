import 'package:flutter/material.dart';

class WeightLossLowCarb{
  final String name;
  final String details;
  final String image;
  final String breakfast;
  final String morningSnack;
  final String lunch;
  final String afternoonSnack;
  final String dinner;

  const WeightLossLowCarb(
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

List<WeightLossLowCarb> MealPlansType1 = [
  const WeightLossLowCarb(
    name: 'Meal Plan 1',
    details: 'Cherry chicken with lettuce wraps',
    image: 'lib/images/ChickenLettureWraps.jpg',
    breakfast: 'Raspberries greek yogurt with almonds',
    morningSnack: '1 hard boiled eggs',
    lunch: 'White Bean & Veggie Salad',
    afternoonSnack: '1 Apple',
    dinner: 'Cherry chicken with lettuce wraps'
  ),

  const WeightLossLowCarb(
    name: 'Meal Plan 2',
    details:'Cauliflower Mac & Cheese',
    image: 'lib/images/CauliflowerMacCheese.jpg',
    breakfast: 'Banana Pancakes',
    morningSnack: '1 orange',
    lunch: 'Chicken Satay with Spicy Peanut Sauce',
    afternoonSnack: '1/2 cup raspberries',
    dinner: 'Cauliflower Mac & Cheese'
  ),

  const WeightLossLowCarb(
    name: 'Meal Plan 3',
    details: 'Roasted Chickens + Cauliflower Risotto',
    image: 'lib/images/RoastedChickensRisotto.jpg',
    breakfast: 'Low-Carb Blueberry Muffins',
    morningSnack: '1 pear',
    lunch: 'Egg Salad Lettuce Wraps',
    afternoonSnack: '2 plum',
    dinner: 'Roasted Chickens + Cauliflower Risotto'
  ),
];
