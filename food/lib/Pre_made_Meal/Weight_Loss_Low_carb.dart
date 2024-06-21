class WeightLossLowCarb{
  final String name;
  final String details;
  final String breakfast;
  final String morningSnack;
  final String lunch;
  final String afternoonSnack;
  final String dinner;

  const WeightLossLowCarb(
    {
      required this.name, 
      required this.details,
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
    breakfast: 'Raspberries greek yogurt with almonds',
    morningSnack: '1 hard boiled eggs',
    lunch: 'White Bean & Veggie Salad',
    afternoonSnack: '1 Apple',
    dinner: 'Cherry chicken with lettuce wraps'
  ),

   const WeightLossLowCarb(
    name: 'Meal Plan 2',
    details:'Cauliflower Mac & Cheese',
    breakfast: 'Banana Pancakes',
    morningSnack: '1 orange',
    lunch: 'Chicken Satay with Spicy Peanut Sauce',
    afternoonSnack: '1/2 cup raspberries',
    dinner: 'Cauliflower Mac & Cheese'
  ),

   const WeightLossLowCarb(
    name: 'Meal Plan 3',
    details: 'Roasted Chickens + Cauliflower Risotto',
    breakfast: 'Low-Carb Blueberry Muffins',
    morningSnack: '1 pear',
    lunch: 'Egg Salad Lettuce Wraps',
    afternoonSnack: '2 plum',
    dinner: 'Roasted Chickens + Cauliflower Risotto'
  ),
];
