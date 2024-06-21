class BuildMuscleLowCarb{
  final String name;
  final String details;
  final String breakfast;
  final String morningSnack;
  final String lunch;
  final String afternoonSnack;
  final String dinner;

  const BuildMuscleLowCarb(
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

List<BuildMuscleLowCarb> MealPlansType3 = [
  const BuildMuscleLowCarb(
    name: 'Meal Plan 1',
    details: 'New York strip steak with mashed potatoes and asparagus',
    breakfast: 'Eggs and bacon with spinach',
    morningSnack: '12 almond',
    lunch: 'Baked Salmon with salad ',
    afternoonSnack: '12 almond',
    dinner: 'New York strip steak with mashed potatoes and asparagus'
  ),

   const BuildMuscleLowCarb(
    name: 'Meal Plan 2',
    details:'Salmon burger with slaw',
    breakfast: 'Scrambled eggs',
    morningSnack: '12 almond',
    lunch: 'High protein Tofu Poke Bowl',
    afternoonSnack: '12 almond',
    dinner: 'Salmon burger with slaw'
  ),

   const BuildMuscleLowCarb(
    name: 'Meal Plan 3',
    details: 'Tuna salad sandwich on whole-wheat bread',
    breakfast: 'High Protein Scramble egg with Quinoa',
    morningSnack: '1 cup edamame',
    lunch: 'Low Calorie Popcorn Chicken',
    afternoonSnack: '12 almond',
    dinner: 'High Protein Burrito Bowl'
  ),
];
