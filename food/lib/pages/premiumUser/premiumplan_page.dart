import 'package:flutter/material.dart';
import 'package:food/components/base_page.dart';
import 'package:food/components/navbar.dart';
import 'package:food/pages/PremiumUser/payment_method_page.dart';
import 'package:food/pages/workout/views/workout_page_view.dart';

class PremiumPlanPage extends StatefulWidget {
  @override
  _PremiumPlanPageState createState() => _PremiumPlanPageState();
}

class _PremiumPlanPageState extends State<PremiumPlanPage> {
  bool isMonthlySelected = true; // Set to true initially
  bool isAnnuallySelected = false;

  void selectMonthly() {
    setState(() {
      isMonthlySelected = true;
      isAnnuallySelected = false;
    });
  }

  void selectAnnually() {
    setState(() {
      isMonthlySelected = false;
      isAnnuallySelected = true;
    });
  }

  @override
  void initState() {
    super.initState();
    // Ensure isMonthlySelected is true when the page initializes
    isMonthlySelected = true;
    isAnnuallySelected = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Premium Plan',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            BulletPoint(text: 'Access to all workout plans'),
            BulletPoint(text: 'Access to all meal plans'),
            BulletPoint(text: 'Contact verified trainers'),
            BulletPoint(text: 'Personalized feedback and plans'),
            SizedBox(height: 40),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
                    ),
                    backgroundColor: isMonthlySelected ? Colors.blue[100] : Colors.grey[200],
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 24, horizontal: 48),
                  ),
                  onPressed: selectMonthly,
                  child: Text('9.9 SGD monthly', style: TextStyle(fontSize: 18)),
                ),
                SizedBox(height: 20),
                Center(child: Text('or', style: TextStyle(fontSize: 16))),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
                    ),
                    backgroundColor: isAnnuallySelected ? Colors.blue[100] : Colors.grey[200],
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 24, horizontal: 48),
                  ),
                  onPressed: selectAnnually,
                  child: Text('109.9 SGD annually', style: TextStyle(fontSize: 18)),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
                    ),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 38),
                  ),
                  onPressed: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PaymentMethodPage()),
                    );
                  },
                  child: Text('Upgrade Now', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;

  BulletPoint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.check, size: 20, color: Colors.black),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }
}
