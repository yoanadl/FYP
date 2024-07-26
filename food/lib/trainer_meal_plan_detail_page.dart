import 'package:flutter/material.dart';

class TrainerMealPlanDetailPage extends StatefulWidget {
  @override
  _TrainerMealPlanDetailPageState createState() => _TrainerMealPlanDetailPageState();
}

class _TrainerMealPlanDetailPageState extends State<TrainerMealPlanDetailPage> {
  bool isEditing = false;

  void _toggleEditing() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure you want to delete this meal plan?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                // Delete meal plan action
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMealDetail(String meal, String detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(meal + ": "),
          Expanded(
            child: isEditing
                ? TextFormField(
                    initialValue: detail,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  )
                : Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(detail),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Plan 2'),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.check : Icons.edit),
            onPressed: _toggleEditing,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _showDeleteConfirmationDialog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Meal Type',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: 8.0,
              children: [
                Chip(label: Text('Low Calorie')),
                Chip(label: Text('Vegan')),
                Chip(label: Text('Vegetarian')),
                Chip(label: Text('High Protein')),
                Chip(label: Text('Lactose Intolerant')),
              ],
            ),
            SizedBox(height: 16.0),
            Text(
              'Days',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                7,
                (index) => CircleAvatar(
                  backgroundColor: index == 1 ? Colors.blue[100] : Colors.grey[200],
                  child: Text((index + 1).toString()),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            _buildMealDetail('Breakfast', '2 Servings Baked Banana-Nut Oatmeal Cups and 1 clementine'),
            _buildMealDetail('AM Snack', '1 medium apple, sliced and 1 Tbsp. peanut butter'),
            _buildMealDetail('Lunch', '1 serving Veggie & Hummus Sandwich'),
            _buildMealDetail('PM Snack', '1 medium banana'),
            _buildMealDetail('Dinner', '1 serving Sheet-Pan Chicken Fajita Bowls with 1/3 cup cooked brown rice'),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workout',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Client List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Meal Plan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
