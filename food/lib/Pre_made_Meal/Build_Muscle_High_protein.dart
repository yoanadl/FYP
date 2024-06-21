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
    details: 'Boil chicken with lettuce',
    breakfast: '',
    morningSnack: '',
    lunch: '',
    afternoonSnack: '',
    dinner: ''
  ),

   const BuildMuscleHighProtein(
    name: 'Meal Plan 2',
    details:'Veggie stir-fry with brown rice',
    breakfast: '',
    morningSnack: '',
    lunch: '',
    afternoonSnack: '',
    dinner: ''
  ),

   const BuildMuscleHighProtein(
    name: 'Meal Plan 3',
    details: 'Tuna salad sandwich on whole-wheat bread',
    breakfast: '',
    morningSnack: '',
    lunch: '',
    afternoonSnack: '',
    dinner: ''
  ),
];