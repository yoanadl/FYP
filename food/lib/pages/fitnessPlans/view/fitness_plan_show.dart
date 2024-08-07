import 'package:flutter/material.dart';
import '../model/fitness_plan_model.dart'; 

class FitnessPlanShow extends StatefulWidget {
  @override
  _FitnessPlanShowState createState() => _FitnessPlanShowState();
}

class _FitnessPlanShowState extends State<FitnessPlanShow> {
  late Future<List<FitnessPlan>> _fitnessPlans;

  @override
  void initState() {
    super.initState();
    _fitnessPlans = FitnessPlan.fetchFitnessPlans();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fitness Plans'),
      ),
      body: FutureBuilder<List<FitnessPlan>>(
        future: _fitnessPlans,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No Fitness Plans Available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                FitnessPlan plan = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(plan.goals),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Level: ${plan.level}'),
                        Text('Tags: ${plan.tags.join(', ')}'),
                        SizedBox(height: 5),
                        Text('Activities:'),
                        for (int i = 0; i < plan.activities.length; i++)
                          Text(
                            '${plan.activities[i]} - ${plan.durations[i]}',
                            style: TextStyle(fontSize: 12),
                          ),
                      ],
                    ),
                    isThreeLine: true,
                    onTap: () {
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
