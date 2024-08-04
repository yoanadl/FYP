import 'package:flutter/material.dart';
import 'package:food/components/navbar.dart';
import 'package:food/pages/discarded/community_page.dart';
import 'package:food/pages/workout/workout_page.dart';
import 'package:food/pages/profile_page.dart';
import 'package:food/pages/discarded/Community_page_summary.dart';

class CommunityListPage extends StatefulWidget {
  @override
  _ExploreCommunityPageState createState() => _ExploreCommunityPageState();
}

class _ExploreCommunityPageState extends State<CommunityListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Map<String, dynamic>> preCommunity = [
     {
      'name': 'Leg Day only',
      'intro': ['Squats FOR Live'],
      'amount': [150],
    },
    
    {
      'name': 'Lazy Workout',
      'intro': ['Buddha Clap'],
      'amount': [15]
    },
    {
      'name': 'Running from the Police',
      'intro': ['Always ready to run from the cops'],
      'amount': [20]
    },
    {
      'name': 'Upper Body Blast',
      'intro': ['Dead Lift 24/7'],
      'amount': [50]
    }
  ];

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredcommunity = preCommunity.where((community) {
      return community['name'].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Explore Community',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
          )
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 300,
                  height: 50,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search Community',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.filter_list),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: filteredcommunity.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> workout = filteredcommunity[index];
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommunityPageSummary(
                            communityname: workout['name'],
                            communityintro: List<String>.from(workout['intro']),
                            communitymemberamount: List<int>.from(workout['amount']),
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
                          workout['name'] ?? 'Untitled Workout',
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
            ),
          ),
        ],
      ),
      bottomNavigationBar: Navbar(
        currentIndex: 0,
        onTap: (int index) {
          if (index != 3) {
            Navigator.pop(context);
            switch (index) {
              case 1:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const WorkoutPage()));
                break;
              case 2:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CommunityPage()));
                break;
              case 3:
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  ProfilePage()));
                break;
            }
          }
        },
      ),
    );
  }
}