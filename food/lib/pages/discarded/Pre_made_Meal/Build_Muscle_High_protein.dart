class BuildMuscleHighProtein{
  final String name;
  final String details;
  final String breakfast;
  final String morningSnack;
  final String lunch;
  final String afternoonSnack;
  final String dinner;

  const BuildMuscleHighProtein(
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

List<BuildMuscleHighProtein> MealPlansType4 = [
  const BuildMuscleHighProtein(
    name: 'Meal Plan 1',
    details: 'Chopped Power Salad with Chicken',
    breakfast: 'Baked Omelet Muffins',
    morningSnack: '1 apple',
    lunch: 'Tuna Melt',
    afternoonSnack: '1 cup edamame',
    dinner: 'Chopped Power Salad with Chicken'
  ),

   const BuildMuscleHighProtein(
    name: 'Meal Plan 2',
    details:'Creamy Chicken Noodle Casserole',
    breakfast: 'Chocolate-Peanut Butter Protein Shake',
    morningSnack: '20 unsalted almonds',
    lunch: 'Salmon-Stuffed Avocados',
    afternoonSnack: 'Greek yogurt with blackberries',
    dinner: 'Creamy Chicken Noodle Casserole'
  ),

   const BuildMuscleHighProtein(
    name: 'Meal Plan 3',
    details: 'Stuffed Cabbage Soup',
    breakfast: 'Chocolate-Peanut Butter Protein Shake',
    morningSnack: 'Greek yogurt with sliced strawberries',
    lunch: 'Turkey BLT Wrap',
    afternoonSnack: '1 cup edamame',
    dinner: 'Stuffed Cabbage Soup'
  ),
];