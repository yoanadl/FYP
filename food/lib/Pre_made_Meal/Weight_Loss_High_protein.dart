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
    details: 'Boil chicken with lettuce',
    breakfast: '',
    morningSnack: '12 almond',
    lunch: '',
    afternoonSnack: '12 almond',
    dinner: ''
  ),

   const WeightLossHighProtein(
    name: 'Meal Plan 2',
    details:'Veggie stir-fry with brown rice',
    breakfast: '',
    morningSnack: '',
    lunch: '',
    afternoonSnack: '12 almond',
    dinner: ''
  ),

   const WeightLossHighProtein(
    name: 'Meal Plan 3',
    details: 'Tuna salad sandwich on whole-wheat bread',
    breakfast: '',
    morningSnack: '',
    lunch: '',
    afternoonSnack: '',
    dinner: ''
  ),
];
