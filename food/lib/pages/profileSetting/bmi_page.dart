import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food/components/navbar.dart';
import 'package:food/components/base_page.dart';
import 'package:food/pages/discarded/community_page.dart';
import '/pages/workout/views/workout_page_view.dart';
import 'package:food/services/setting_user_profile_service.dart';
import '../profileSetting/bmi_controller.dart';

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
  final BmiController _bmiController = BmiController(); // Instantiate BmiController

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

  Future<void> _saveHeightAndWeight() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;

    if (user != null) {
      final String uid = user.uid;
      double height = double.tryParse(heightController.text) ?? 0.0;
      double weight = double.tryParse(weightController.text) ?? 0.0;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Updating height/weight...'),
        ),
      );

      await _bmiController.updateHeightAndWeight(uid, height, weight);
      
      setState(() {
        userHeight = height;
        userWeight = weight;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Height/Weight updated successfully'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = double.tryParse(heightController.text) ?? 0.0;
    double weight = double.tryParse(weightController.text) ?? 0.0;
    double bmi = _bmiController.calculateBMI(height, weight);
    String bmiStatus = _bmiController.getBMIStatus(bmi);
    Color bmiColor = _bmiController.getColorByBMIStatus(bmiStatus);

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
                                hintText: 'Enter Weight (kg)',
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                isDense: true, // Reduce padding
                              ) :
                              InputDecoration(
                                hintText: 'Enter Weight (kg)',
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
                        bmi.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 18.0, 
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        bmiStatus,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: bmiColor,
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
                        _saveHeightAndWeight(); // Call the method to save height and weight
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff031927),
                    foregroundColor: Colors.white,
                  ),
                  child: Text(editMode ? 'Save Height and Weight' : 'Edit Height and Weight'),
                ),
              ),
              SizedBox(height: 30.0),
              Text(
                'BMI Reports',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to BMI Reports page
                },
                child: Container(
                  margin: EdgeInsets.only(top: 10.0),
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
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'BMI',
                              style: TextStyle(fontWeight: FontWeight.bold),
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
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '20',
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
                              '01-02-2024',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '21',
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
                              '01-03-2024',
                              textAlign: TextAlign.center,
                            ),
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
                  ),
                ),
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
