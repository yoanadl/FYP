// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food/components/navbar.dart';
import 'package:food/components/base_page.dart';
import 'package:food/pages/discarded/community_page.dart';
import 'package:food/pages/workout/views/workout_page_view.dart';
import 'package:food/services/setting_user_profile_service.dart';
import 'dart:math' as math;



class BmiPage extends StatefulWidget {
  @override
  _BmiPageState createState() => _BmiPageState();
}

class _BmiPageState extends State<BmiPage> {
  late TextEditingController heightController;
  late TextEditingController weightController;

  double userHeight = 0.0;
  double userWeight = 0.0;
  bool editMode = false;

  final SettingProfileService settingprofileService = SettingProfileService();

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

          userHeight = double.tryParse(data['Height(cm)'] ?? '0') ?? 0.0;
          userWeight = double.tryParse(data['Weight(kg)'] ?? '0') ?? 0.0;
        });
      } else {
        print('No profile document found');
      }
    } catch (e) {
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
          margin: EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30.0),
              Text(
                'My BMI',
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.white,
                        border: Border.all(style: BorderStyle.solid, color: Colors.grey),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Height',
                            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5.0),
                          TextField(
                            controller: heightController,
                            keyboardType: TextInputType.number,
                            enabled: editMode,
                            decoration: editMode ?  // Apply border if editMode is true
                              InputDecoration(
                                hintText: 'Enter Height (cm)',
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                isDense: true, // Reduce padding
                              ) :
                              InputDecoration(
                                hintText: 'Enter Height (cm)',
                                // No border when not editable
                                border: InputBorder.none,
                                isDense: true, // Reduce padding
                              ),
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            'cm',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 20.0),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.white,
                        border: Border.all(style: BorderStyle.solid, color: Colors.grey),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Weight',
                            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5.0),
                          TextField(
                            controller: weightController,
                            keyboardType: TextInputType.number,
                            enabled: editMode,
                            decoration: editMode ?  // Apply border if editMode is true
                              InputDecoration(
                                hintText: 'Enter Height (cm)',
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                isDense: true, // Reduce padding
                              ) :
                              InputDecoration(
                                hintText: 'Enter Height (cm)',
                                // No border when not editable
                                border: InputBorder.none,
                                isDense: true, // Reduce padding
                              ),
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            'kg',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
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
                          fontSize: 18.0, 
                          fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        calculateBMI(
                          double.tryParse(heightController.text) ?? 0.0, 
                          double.tryParse(weightController.text) ?? 0.0)
                          .toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 18.0, 
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        getBMIStatus(calculateBMI(
                          double.tryParse(heightController.text) ?? 0.0, 
                          double.tryParse(weightController.text) ?? 0.0)),
                        style: TextStyle(
                          fontSize: 16.0,
                          color:getColorByBMIStatus(getBMIStatus(calculateBMI(
                            double.tryParse(heightController.text) ?? 0.0,
                            double.tryParse(weightController.text) ?? 0.0))),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      editMode = !editMode;
                      if (!editMode) {

                        final FirebaseAuth _auth = FirebaseAuth.instance;
                        // get current user
                        final User? user = _auth.currentUser;

                        if (user != null) {
                          final String uid = user.uid;

                          // show a snackbar while updating
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Updating height/weight...'),
                            ),
                          );

                          // update firestore with height and weight
                          Map<String, dynamic> newData = {
                          'Height(cm)': heightController.text,
                          'Weight(kg)' : weightController.text,
                        };
                        settingprofileService.updateSettingProfile(uid, newData)
                          .then((_) {
                            // show success message
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Height/Weight updated successfully'),
                              ),
                            );
                          }).catchError((error) {
                          // Handle errors (optional)
                          print('Error updating profile: $error');
                          
                        });;
                          
                        }
                        
                      }
                    });
                  },
                  
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff031927),
                    foregroundColor: Colors.white,
                  ),
                  child: Text(editMode ? 'Save Height and Weight' : 'Edit Height and Weight'),
                  )
                ),
              
             
              
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => const BasePage(initialIndex: 0,)));
                break;
              case 1:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const BasePage(initialIndex: 1,)));
                break;
              case 2:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const BasePage(initialIndex: 2,)));
                break;
            }
          }
        }

      ),
    );
  }

  double calculateBMI(double height, double weight) {

    if (height > 0 && weight > 0) {
      return weight /math.pow(height / 100, 2); // Formula for BMI (kg/m^2)
    } 
    else {
      return 0.0; // Handle cases with invalid height or weight
    }
  }

  String getBMIStatus(double bmi) {

    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi >= 18.5 && bmi < 24.9) {
      return 'Normal';
    } else if (bmi >= 24.9 && bmi < 29.9) {
      return 'Overweight';
    } else {
      return 'Obese';
    }
  }

  Color getColorByBMIStatus(String bmiStatus) {

    switch (bmiStatus) {
      case 'Underweight':
        return Colors.orange;
      case 'Normal':
        return Colors.green;
      case 'Overweight':
        return Colors.red;
      case 'Obese':
        return Colors.redAccent;
      default:
        return Colors.black;

    }
  }

  
}
