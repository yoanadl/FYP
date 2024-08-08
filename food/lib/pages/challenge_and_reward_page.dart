import 'package:flutter/material.dart';

class ChallengePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Challenges', style: TextStyle(fontWeight: FontWeight.bold),),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total pts: 268', style: TextStyle(fontSize: 18)),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RewardPage()),
                    );
                  },
                  child: Text('Rewards'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Daily', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            CheckboxListTile(
              title: Text('Reach a minimum of 30 minutes workout time'),
              value: false,
              onChanged: (bool? value) {},
            ),
            CheckboxListTile(
              title: Text('Hit 5,000 Step Counts'),
              value: true,
              onChanged: (bool? value) {},
            ),
            CheckboxListTile(
              title: Text('2,000 Calories Burnt'),
              value: false,
              onChanged: (bool? value) {},
            ),
            SizedBox(height: 20),
            Text('Monthly', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            CheckboxListTile(
              title: Text('Reach a minimum of 120 minutes workout time'),
              value: true,
              onChanged: (bool? value) {},
            ),
            CheckboxListTile(
              title: Text('Hit 30,000 Step Counts'),
              value: false,
              onChanged: (bool? value) {},
            ),
            CheckboxListTile(
              title: Text('14,000 Calories Burnt'),
              value: false,
              onChanged: (bool? value) {},
            ),
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
            label: 'Community',
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

class RewardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Rewards', style: TextStyle(fontWeight: FontWeight.bold),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // This will navigate back to the previous page
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Total points: 268',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              Text('Premium Subscription', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ListTile(
                title: Text('3 Days (350 Points)'),
                trailing: ElevatedButton(
                  onPressed: () {
                    _showRedeemDialog(context);
                  },
                  child: Text('Redeem'),
                ),
              ),
              ListTile(
                title: Text('7 Days (650 Points)'),
                trailing: ElevatedButton(
                  onPressed: () {
                    _showRedeemDialog(context);
                  },
                  child: Text('Redeem'),
                ),
              ),
              ListTile(
                title: Text('1 Month (1,500 Points)'),
                trailing: ElevatedButton(
                  onPressed: () {
                    _showRedeemDialog(context);
                  },
                  child: Text('Redeem'),
                ),
              ),
              ListTile(
                title: Text('3 Months (3,500 Points)'),
                trailing: ElevatedButton(
                  onPressed: () {
                    _showRedeemDialog(context);
                  },
                  child: Text('Redeem'),
                ),
              ),
              ListTile(
                title: Text('6 Months (6,000 Points)'),
                trailing: ElevatedButton(
                  onPressed: () {
                    _showRedeemDialog(context);
                  },
                  child: Text('Redeem'),
                ),
              ),
              ListTile(
                title: Text('1 Year (10,000 Points)'),
                trailing: ElevatedButton(
                  onPressed: () {
                    _showRedeemDialog(context);
                  },
                  child: Text('Redeem'),
                ),
              ),
            ],
          ),
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
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _showRedeemDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Do you wish to redeem this reward?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }
}