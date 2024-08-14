import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food/pages/workout/models/workout_model.dart';
import 'package:food/pages/workout/presenters/workout_presenter.dart';
import 'package:food/pages/workout/presenters/workout_summary_presenter.dart';
import 'package:food/pages/workout/views/create_new_workout_view.dart';
import 'package:food/pages/workout/views/explore_workouts_view.dart';
import 'package:food/pages/workout/views/workout_summary_view.dart';

abstract class WorkoutPageView {
  void onWorkoutsLoaded(List<Map<String, dynamic>> workouts);
  void onWorkoutsSearched(List<Map<String, dynamic>> workouts);
  void onError(String message);
}

class WorkoutPage extends StatefulWidget {
  
  const WorkoutPage({Key? key}) : super(key: key);


  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> implements WorkoutPageView {

  late WorkoutPresenter _presenter;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Map<String, dynamic>> _workouts = [];
  List<Map<String, dynamic>> _filteredWorkouts = [];
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _presenter = WorkoutPresenter(WorkoutModel(), this);
    _searchController.addListener(_onSearchChanged);
    if (_user != null) {
      _presenter.loadWorkouts(_user!.uid);
    }
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _presenter.searchWorkouts(_searchQuery, _workouts);
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void onWorkoutsLoaded(List<Map<String, dynamic>> workouts) {
    setState(() {
      _workouts = workouts;
      _presenter.searchWorkouts(_searchQuery, _workouts);
    });
  }

  @override
  void onWorkoutsSearched(List<Map<String, dynamic>> workouts) {
    setState(() {
      _filteredWorkouts = workouts;
    });
  }

  @override
  void onError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _refreshWorkouts() {
    if (_user != null) {
      _presenter.loadWorkouts(_user!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Spacer(),
            Text(
              'My Workouts',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer()
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        child: DefaultTabController(
          length: 2, // Number of tabs
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xff031927),
                ),
                child: TabBar(
                  labelStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white,
                  tabs: [
                    Tab(text: 'Ongoing'),
                    Tab(text: 'Completed'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 300,
                      height: 50,
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search Workouts',
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildWorkoutList('ongoing'),
                    _buildWorkoutList('completed'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 20,
            right: 20,
            child: Theme(
              data: Theme.of(context).copyWith(
                popupMenuTheme: PopupMenuThemeData(
                  color: Color(0xff031927),
                ),
              ),
              child: PopupMenuButton<String>(
                onSelected: (String result) {
                  if (result == 'new_workout') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CreateNewWorkoutView()),
                    );
                  } else if (result == 'explore_workouts') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ExploreWorkoutsPage()),
                    );
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'new_workout',
                    child: Row(
                      children: [
                        Icon(Icons.add, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          'Create New Workout',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'explore_workouts',
                    child: Row(
                      children: [
                        Icon(Icons.explore, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          'Explore Pre-made Workouts',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Color(0XFF031927),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.add, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutList(String type) {
  return FutureBuilder<List<Map<String, dynamic>>>(
    future: _user != null ? _presenter.loadWorkouts(_user!.uid) : Future.value([]),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }
      if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Center(child: Text('No workouts found.'));
      }

      List<Map<String, dynamic>> workouts = snapshot.data!;
      if (_searchQuery.isNotEmpty) {
        workouts = workouts.where((workout) {
          String title = workout['title'] ?? 'Untitled Workout';
          return title.toLowerCase().contains(_searchQuery.toLowerCase());
        }).toList();
      }

      return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> workout = workouts[index];
          String workoutId = workout['id'];
          bool isPremade = workout['isPremade'] ?? false;

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkoutSummaryView(
                      presenter: WorkoutSummaryPresenter(
                        workoutTitle: workout['title'],
                        duration: List<int>.from(workout['durations']),
                        activities: List<String>.from(workout['activities']),
                        userId: _user!.uid, // Pass userId from _user object
                        workoutId: workoutId,
                        onDelete: _refreshWorkouts,
                      ),
                      userId: _user!.uid,
                      workoutId: workoutId,
                      isPremade: isPremade,
                    ),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  color: Colors.grey[200],
                ),
                child: Center(
                  child: Text(
                    workout['title'] ?? 'Untitled Workout',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

}
