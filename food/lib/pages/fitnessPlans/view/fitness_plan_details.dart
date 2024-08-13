import 'package:flutter/material.dart';
import '../model/fitness_plan_model.dart';

class FitnessPlanDetailPage extends StatefulWidget {
  final FitnessPlan fitnessPlan;
  final String userId;

  const FitnessPlanDetailPage({
    Key? key,
    required this.fitnessPlan,
    required this.userId,
  }) : super(key: key);

  @override
  _FitnessPlanDetailPageState createState() => _FitnessPlanDetailPageState();
}

class _FitnessPlanDetailPageState extends State<FitnessPlanDetailPage> {
  bool isFavorited = false; // To track if the plan is favorited

  @override
  void initState() {
    super.initState();

  }

  void toggleFavorite() {
    setState(() {
      isFavorited = !isFavorited;
    });
  }

  @override
  Widget build(BuildContext context) {
    final plan = widget.fitnessPlan;

    return Scaffold(
      appBar: AppBar(
        title: Text(plan.title),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(
              isFavorited ? Icons.star : Icons.star_border,
              color: Colors.yellow,
            ),
            onPressed: toggleFavorite,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Goals:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              plan.goals,
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Level:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              plan.level,
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Tags:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              plan.tags.join(', '),
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Activities:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: plan.activities.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(plan.activities[index]),
                    subtitle: Text('Duration: ${plan.durations[index]} minutes'),
                    contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                    leading: Icon(Icons.fitness_center),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          toggleFavorite();
        },
        child: Icon(
          isFavorited ? Icons.star : Icons.star_border,
          color: Colors.white,
        ),
        backgroundColor: Colors.yellow,
      ),
    );
  }
}
