class WeightLossHighProtein{
  final String name;
  final String details;
  final String breakfast;
  final String morningSnack;
  final String lunch;
  final String afternoonSnack;
  final String dinner;

  const WeightLossHighProtein(
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

List<WeightLossHighProtein> MealPlansType2 = [
  const WeightLossHighProtein(
    name: 'Meal Plan 1',
    details: 'Zucchini Parmesan',
    breakfast: 'Raspberries greek yogurt with almonds',
    morningSnack: '2 kiwis',
    lunch: 'Chicken Quinoa Bowl with Olives & Cucumber',
    afternoonSnack: '1 orange',
    dinner: 'Zucchini Parmesan'
  ),

   const WeightLossHighProtein(
    name: 'Meal Plan 2',
    details:'Salmon Tacos with Pineapple Salsa',
    breakfast: 'Egg Salad Avocado Toast',
    morningSnack: '1 orange',
    lunch: 'Green Salad with Edamame & Beets',
    afternoonSnack: '1 cup raspberries',
    dinner: 'Salmon Tacos with Pineapple Salsa'
  ),

   const WeightLossHighProtein(
    name: 'Meal Plan 3',
    details: 'Citrus Poached Salmon with Asparagus',
    breakfast: 'Banana Pancakes',
    morningSnack: '1 orange',
    lunch: 'Veggie & Hummus Sandwich',
    afternoonSnack: '1 Edamame',
    dinner: 'Citrus Poached Salmon with Asparagus'
  ),
];
