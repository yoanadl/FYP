// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food/components/navbar.dart';
import 'package:food/pages/base_page.dart';
import 'package:food/pages/community_page.dart';
import 'package:food/pages/workout/workout_page.dart';

import 'bmi_reports_page.dart';


class BmiPage extends StatefulWidget {

  @override
  State<BmiPage> createState() => _BmiPageState();
}

class _BmiPageState extends State<BmiPage> {

  late TextEditingController heightController;
  late TextEditingController weightController;

  double userHeight = 0.0;
  double userWeight = 0.0;

  @override 
  void initState() {
    super.initState();
    heightController = TextEditingController();
    weightController = TextEditingController();
    fetchUserHeightAndWeight();
  }

  @override  
  void dispose() {
    heightController.dispose();
    weightController.dispose();
    super.dispose();
  }

  void fetchUserHeightAndWeight() async {

    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        print('User is not authenticated');
        return;
      }

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('UserProfile')
        .limit(1) // limit to 1 document as there's only one profile document per user
        .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot docSnapshot = querySnapshot.docs.first;
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

        setState(() {
          heightController.text = data['Height(cm)'] ?? '';
          weightController.text = data['Weight(kg)'] ?? '';
          
        });
      }

      else {
        print('No profile document found');

      }
 
    }

    catch (e) {
      print('Error fetching height and weight: $e');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      
      appBar: AppBar(
        backgroundColor: Colors.white,
        
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 40, right: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My BMI',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600
                ),
              ),
        
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(  
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.white, 
                        border: Border.all(
                          style: BorderStyle.solid,
                          color: Colors.grey),
                      ),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Height',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            TextFormField(
                              controller: heightController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Enter height',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  userHeight = double.tryParse(value) ?? 0.0;
                                });
                              },
                            ),
                            SizedBox(height: 5),
                            Text(
                              'cm',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    )
                  ),
        
                  SizedBox(width: 20),
        
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(  
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.white, 
                        border: Border.all(
                          style: BorderStyle.solid,
                          color: Colors.grey),
                      ),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Weight',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            TextFormField(
                              controller: weightController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Enter your weight',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value){
                                setState(() {
                                  userWeight = double.tryParse(value) ?? 0.0;
                                });
                              },
                            ),
                            // TextField(
                            //   decoration: InputDecoration(hintText: "your weight"),
                            //   style: TextStyle(
                            //     fontSize: 24,
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            // ),
                            SizedBox(height: 5),
                            Text(
                              'kg',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    )
                  )
                ],
              ),
        
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(8.0),
                width: double.infinity,
                decoration: BoxDecoration(  
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white, 
                  border: Border.all(
                    style: BorderStyle.solid,
                    color: Colors.grey),
                ),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Current BMI',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  
                      Text(
                        '20.76',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  
                      Text(
                        'Normal',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
        
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff031927),
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Edit Height and Weight'),
                  
                ),
              ),
        
              SizedBox(height: 30),
              Text(
                'BMI Reports',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
        
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BmiReportsPage()),
                  );
                },
        
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.all(8.0),
                  color: Color(0x59C8E0F4),
                  child: Table(
                    children: [
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Date', 
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                              textAlign: TextAlign.center,
                              ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'BMI', 
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),
                              textAlign: TextAlign.center,
                              ),
                          ),
                        ],
                      ),
        
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '01-01-2024', 
                              textAlign: TextAlign.center,),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '20',
                              textAlign: TextAlign.center,),
                          ),
                        ],
                      ),
        
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '01-02-2024',
                              textAlign: TextAlign.center,),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '21',
                              textAlign: TextAlign.center,),
                          ),
                        ],
                      ),
        
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '01-03-2024',
                              textAlign: TextAlign.center,),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '19',
                               textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
        
        
                    ],
                  )
                )
              )
        
            ],
          ),
        
        ),
      ),
      

      bottomNavigationBar: Navbar(
        currentIndex: 3,
        onTap: (int index) {
          if (index != 3) {
            Navigator.pop(context);
            switch(index) {
              case 0:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const BasePage()));
                break;
              case 1:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const WorkoutPage()));
                break;
              case 2:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CommunityPage()));
                break;
            }
          }
        }

      ),
    );
  }
}