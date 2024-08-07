import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food/components/navbar.dart';
import 'package:food/pages/base_page.dart';
import 'package:food/services/health_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:food/services/SettingProfile_service.dart';
import 'package:intl/intl.dart';

class DataAnalyticsPage extends StatefulWidget {
  const DataAnalyticsPage({super.key});

  @override
  _DataAnalyticsPageState createState() => _DataAnalyticsPageState();
}

class _DataAnalyticsPageState extends State<DataAnalyticsPage> {
  final HealthService healthService = HealthService();
  int steps = 0;
  double? heartRate;
  double? calories;
  double? averageHeartRate;
  double? maxHeartRate;
  String selectedPeriod = 'Today';
  String name = '';
  String? profilePictureUrl;
  
  bool _isLoading = true;
  List<Map<String, dynamic>> weeklyData = [];

  double? averageWeeklyHeartRate = 0.0;
  int? averageWeeklySteps = 0;
  double? averageWeeklyCalories = 0.0;
  int totalStepsInMonth = 0;
  double totalCaloriesInMonth = 0.0;
  double? averageMonthlyHeartRate;
  double? maxHeartRateInMonth = 0.0;

  DateTime? _fromDate;
  DateTime? _toDate;

  int? filterSteps = 0;
  double? filterCalories = 0.0;
  double? filterAverageHeartRate = 0.0;
  double? filterMaxHeartRate = 0.0;

  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();


  @override
  void initState() {
    super.initState();
    fetchUserProfile();
    fetchData();
    _fetchWeeklyData();
    _fetchMonthlyData(DateTime.now());
  }

  Future<void> fetchUserProfile() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        Map<String, dynamic>? userData =
            await SettingprofileService().fetchUserData(user.uid);

        if (userData != null) {
          setState(() {
            name = userData['Name'] ?? 'No name';
            profilePictureUrl = userData['profilePictureUrl'];
          });
        } else {
          print('No user data found for uid: ${user.uid}');
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    } else {
      print('No user is currently signed in.');
    }
  }

  Future<void> fetchData() async {
    
    DateTime now = DateTime.now();
    DateTime startDate;

    switch (selectedPeriod) {
      case 'Week':
        startDate = now.subtract(Duration(days: now.weekday - 1));
        break;
      case 'Today':
      default:
        startDate = DateTime(now.year, now.month, now.day);
        break;
    }

    try {
      int? fetchedSteps = await healthService.getSteps();
      double? fetchedHeartRate = await healthService.getHeartRate();
      double? fetchedCalories = await healthService.getCalories();
      double? fetchedAverageHeartRate = await healthService.getAverageHeartRateForToday();
      double? fetchedMaxHeartRate = await healthService.getMaximumHeartRateForToday();


      setState(() {
        steps = fetchedSteps ?? 0;
        heartRate = fetchedHeartRate ?? 0.0;
        calories = fetchedCalories ?? 0.0;
        averageHeartRate = fetchedAverageHeartRate ?? 0.0;
        maxHeartRate = fetchedMaxHeartRate ?? 0.0;
      
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

   Future<void> _fetchWeeklyData() async {
    List<Map<String, dynamic>> data = [];

    double? averageHeartRatePerWeek = await healthService.getAverageWeeklyHeartRate();
    double? averageCaloriesPerWeek = await healthService.getAverageWeeklyCalories();
    int? averageStepsPerWeek = await healthService.getAverageWeeklySteps();

    for (int i = 0; i < 7; i++) {
      DateTime date = DateTime.now().subtract(Duration(days: i));
      int steps = await healthService.getStepsForThatDay(date);
      double heartRate = await healthService.getHeartRateForThatDay(date);
      double calories = await healthService.getCaloriesForThatDay(date);
      

      print('Date: $date, Steps: $steps, Calories: $calories',); // Debugging line

     
      data.add({
        'date': date,
        'steps': steps,
        'heartRate': heartRate,
        'calories': calories,
       
      });
    }

    setState(() {
      weeklyData = data;
      averageWeeklyHeartRate = averageHeartRatePerWeek;
      averageWeeklyCalories = averageCaloriesPerWeek;
      averageWeeklySteps = averageStepsPerWeek;

    });
  }

  Future<void> _fetchMonthlyData(DateTime month) async {
    
    final totalSteps = await healthService.getStepsForThatMonth(month);
    final totalCalories = await healthService.getCaloriesForThatMonth(month);
    final averageHeartRateInMonth = await healthService.getAverageMonthlyHeartRate(month);
    final maxMonthlyHeartRate = await healthService.getMaximumHeartRateForMonth(month);

    setState(() {
      totalStepsInMonth = totalSteps;
      totalCaloriesInMonth = totalCalories;
      averageMonthlyHeartRate = averageHeartRateInMonth;
      maxHeartRateInMonth = maxMonthlyHeartRate;
      
    });

  }

  void _fetchFilterData() async {

    print('From Date: $_fromDate');
    print('To Date: $_toDate');

    if (_fromDate != null && _toDate != null) {
      var data = await healthService.getFilterHealthData(_fromDate!, _toDate!);

      setState(() {
        filterSteps = data['totalSteps'];
        filterCalories = data['totalCalories'];
        filterAverageHeartRate = data['averageHeartRate'];
        filterMaxHeartRate = data['maxHeartRate'];
      });
    }
    else {
      print('Please select both from and to dates.');
    }
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    
    showCupertinoModalPopup(
      context: context, 
      builder: (_) => SafeArea(
        child: Container(
          height: 250,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 180,
                  child: CupertinoDatePicker(
                    initialDateTime: DateTime.now(),
                    onDateTimeChanged: (DateTime newDate) {
                      setState(() {
                        controller.text = DateFormat('yyyy-MM-dd').format(newDate);
                        if (controller == _fromDateController) {
                          _fromDate = newDate;

                        }
                        else if (controller == _toDateController) {
                          _toDate = newDate;
                        }
                      });
                    },
                    use24hFormat: true,
                    mode: CupertinoDatePickerMode.date,
                  ),
                ),
                CupertinoButton(
                  child: Text('OK'), 
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }

  Widget buildFilterDataTable() {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Column (
        crossAxisAlignment: CrossAxisAlignment.start,
        
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Steps',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              Text(
                '${filterSteps?.toString() ?? 'N/A'}',
                  style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Divider(color: Colors.grey.shade400),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Calories Burned',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              Text(
                '${filterCalories?.toStringAsFixed(1) ?? 'N/A'} kcal',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Divider(color: Colors.grey),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Average Heart Rate',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              Text(
                '${filterAverageHeartRate?.toStringAsFixed(1) ?? 'N/A'} bpm',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Divider(color: Colors.grey),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Maximum Heart Rate',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              Text(
                '${filterAverageHeartRate?.toStringAsFixed(1) ?? 'N/A'} bpm',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );

  }



  Widget buildTodayDataTable() {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Column (
        crossAxisAlignment: CrossAxisAlignment.start,
        
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Steps',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              Text(
                '${steps?.toString() ?? 'N/A'}',
                  style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Divider(color: Colors.grey.shade400),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Calories Burned',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              Text(
                '${calories?.toStringAsFixed(1) ?? 'N/A'} kcal',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Divider(color: Colors.grey),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Average Heart Rate',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              Text(
                '${averageHeartRate?.toStringAsFixed(1) ?? 'N/A'} bpm',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Divider(color: Colors.grey),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Maximum Heart Rate',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              Text(
                '${maxHeartRate?.toStringAsFixed(1) ?? 'N/A'} bpm',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );

  }

  Widget buildWeeklyDataTable() {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10), 

        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Date'),
              Row(
                children: [
                  Icon(Icons.directions_walk),
                  SizedBox(width: 4,),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.favorite),
                  SizedBox(width: 4,),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.local_fire_department),
                  SizedBox(width: 4,),
                ],
              ),
            ],
          ),
          for (var data in weeklyData)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormat('EEE').format(data['date'])),
                Text('${data['steps']}'),
                Text('${data['heartRate']}'),
                Text('${data['calories']}'),
              ],
            ),
        ],
      ),
    );
  }

  Widget buildMonthlyDataTable() {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Column (
        crossAxisAlignment: CrossAxisAlignment.start,
        
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Steps',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              Text(
                '${totalStepsInMonth}',
                  style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Divider(color: Colors.grey.shade400),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Calories Burned',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              Text(
                '${totalCaloriesInMonth?.toStringAsFixed(1) ?? 'N/A'} kcal',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Divider(color: Colors.grey),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Average Heart Rate',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              Text(
                '${averageMonthlyHeartRate?.toStringAsFixed(1) ?? 'N/A'} bpm',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Divider(color: Colors.grey),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Maximum Heart Rate',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              Text(
                '${maxHeartRateInMonth?.toStringAsFixed(1) ?? 'N/A'} bpm',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );

  }

  
  Widget _buildProfileImage() {
  return CircleAvatar(
    radius: 24,
    child: profilePictureUrl != null
      ? CachedNetworkImage(
          imageUrl: profilePictureUrl!,
          fit: BoxFit.cover,
        )
      : Icon(Icons.person), // Default profile icon
  );
}


  Widget loadProfilePicture(BuildContext context, String uid) {
    final settingProfileService = SettingprofileService();

    return FutureBuilder<String?>(
      future: settingProfileService.fetchProfilePictureUrl(uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String? url = snapshot.data;
          return CircleAvatar(
            radius: 30, 
            backgroundImage: CachedNetworkImageProvider(url!),
          );
        } else if (snapshot.hasError) {
          print('Error fetching profile picture URL: ${snapshot.error}');
          return CircularProgressIndicator(); // Show a loading indicator
        }
        return CircleAvatar(
          radius: 30, 
          child: Icon(Icons.person),
        ); // Placeholder
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    String formattedDate = DateFormat('EEEE d MMMM').format(DateTime.now());
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white, 
          centerTitle: false,
          actions: [
            // Notification icon
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[300],
                ),
                child: IconButton(
                  onPressed: () {}, 
                  icon: Icon(Icons.notifications),
                  iconSize: 25,
                  color: Colors.black,
                ),
              ),
            ),
            
            //profile icon
            if (user != null)
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => BasePage(initialIndex: 3),
                      ),
                    );
                  },
                child: loadProfilePicture(context, user.uid),
              ),
            ),
          ],
          iconTheme: IconThemeData(color: Colors.white),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 17.0),
                child: Text(
                  'Hello, $name!',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 17.0),
                child: Text(
                  formattedDate,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Statistics',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildPeriodButton('Today'),
                  SizedBox(width: 3,),
                  _buildPeriodButton('Week'),
                  SizedBox(width: 3,),
                  _buildPeriodButton('Month'),
                  SizedBox(width: 3,),
                  _buildPeriodButton('Filter'),
                  
                ],
              ),
              SizedBox(height: 16),
                

                if (selectedPeriod == 'Today') ...[
                  _todayData(),
                  buildTodayDataTable(),
                ],

                if (selectedPeriod == 'Week') ... [
                  _weekdata(),
                  SizedBox(height: 15,),
                  buildWeeklyDataTable(),
                ], 

                if (selectedPeriod == 'Month')
                  buildMonthlyDataTable(),

                if (selectedPeriod == 'Filter') ... [
                  SizedBox(height: 15,),
                  buildFilterWidget(),
                  SizedBox(height: 35,),
                  buildFilterDataTable(),
                ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: Navbar(
        currentIndex: 0,
        onTap: (int index) {
        
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BasePage(initialIndex: index),
            ),
          ) ;
        },
      ),
    );
  }


  Widget buildFilterWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'From',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: TextFormField(
                  controller: _fromDateController,
                  decoration: InputDecoration(
                    labelText: 'From Date',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(context, _fromDateController),
                ),
              ),
            ),
            SizedBox(width: 10),
            Text(
              'To',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(width: 5,),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: TextFormField(
                  controller: _toDateController,
                  decoration: InputDecoration(
                    labelText: 'To Date',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(context, _toDateController),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 15,),
        Align(
          alignment: Alignment.center,
          child: ElevatedButton(
            onPressed: () {
              _fetchFilterData();
            }, 
            child: Text('Get Data',
              style: TextStyle(
                color: Colors.white,
              ),
             ),
             style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF031927), 
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
             ),
            ),
        )
       
        
      ],
    );
  }


   Widget _todayData() {
    return Container(
      width: 350,
      height: 190,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(15),
      
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: 10),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white, 
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey.shade300,
                )
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Heart Rate \n ${heartRate?.toStringAsFixed(1) ?? 'N/A'} bpm',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(Icons.favorite, color: Color(0xFF508AA8)),
                  ],
                
                ),
              ),
            ),
          ),
          

          Expanded(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                    color: Colors.grey.shade300,
                )
                  ),
                  
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Calories \n ${calories?.toStringAsFixed(1) ?? 'N/A'} kcal',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(width: 5),
                        Icon(Icons.local_fire_department, color: Color(0xFF508AA8)),
                        
                        ],
                      ),
                    ),
                  ),
          
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white, 
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                    color: Colors.grey.shade300,
                )
                  ),
          
                    child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Steps \n ${steps?.toString() ?? 'N/A'} steps',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(width: 5),
                        FaIcon(FontAwesomeIcons.shoePrints, color: Color(0xFF508AA8)),
                        
                          ],
                        ),
                      ),
                    ),
                  ],
              
              ),)
            ],
            )
          );
  }

  Widget _weekdata() {
    return Container(
      width: 350,
      height: 260,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(15),
      
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 240,
              margin: EdgeInsets.only(right: 10),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white, 
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey.shade300,
                )
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Average \n Heart \n Rate \n ${averageWeeklyHeartRate?.toStringAsFixed(1) ?? 'N/A'} bpm',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(width: 5),
                    Icon(Icons.favorite, color: Color(0xFF508AA8)),
                  ],
                
                ),
              ),
            ),
          ),
          

          Flexible(
            child: Column(
              children: [
                Container(
                  height: 110,
                  margin: EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                    color: Colors.grey.shade300,
                )
                  ),
                  
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Average \n Calories \n ${averageWeeklyCalories?.toStringAsFixed(1) ?? 'N/A'} kcal',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),
                          
                        ),
                        SizedBox(width: 5),
                        Icon(Icons.local_fire_department, color: Color(0xFF508AA8)),
                        
                        ],
                      ),
                    ),
                  ),
          
                Container(
                  height: 110,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white, 
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                    color: Colors.grey.shade300,
                )
                  ),
          
                    child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Average \n Steps \n ${averageWeeklySteps?.toString() ?? 'N/A'} steps',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(width: 5),
                        FaIcon(FontAwesomeIcons.shoePrints, color: Color(0xFF508AA8)),
                        
                          ],
                        ),
                      ),
                    ),
                  ],
              
              ),)
            ],
            )
          );
  }

  Widget _buildPeriodButton(String period) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedPeriod = period;
          fetchData();
        });
      },
      child: Text(period),
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedPeriod == period ? Color(0xFF031927) : Colors.grey.shade200,
        foregroundColor: selectedPeriod == period ? Colors.white: Colors.black,
      ),
      
    );
  }



}


