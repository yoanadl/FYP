import 'package:flutter/material.dart';
import 'package:food/pages/premiumUser/trainer/service/trainer_service.dart';
import 'package:food/pages/premiumUser/trainer/trainer_details_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TrainersListPage extends StatefulWidget {
  @override
  _TrainersListPageState createState() => _TrainersListPageState();
}

class _TrainersListPageState extends State<TrainersListPage> {
  final TrainerService _trainerService = TrainerService();
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredTrainers = [];
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _filterTrainers(List<Map<String, dynamic>> trainers) {
    final query = _searchController.text.toLowerCase();
    return trainers.where((trainer) {
      final name = trainer['Name']?.toLowerCase() ?? '';
      return name.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Trainers',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildSearchBox('Search by name..'),
            SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.lightBlue, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: _trainerService.getTrainers(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No trainers found.'));
                      }

                      // Filter trainers based on the search query
                      _filteredTrainers = _filterTrainers(snapshot.data!);

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: _filteredTrainers.length,
                        itemBuilder: (context, index) {
                          final trainerProfileData = _filteredTrainers[index];
                          return _buildTrainerItem(trainerProfileData);
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox(String hintText) {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(Icons.search),
        filled: true,
        fillColor: Colors.blue[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildTrainerItem(Map<String, dynamic> trainerProfileData) {
  List<String> expertiseList = (trainerProfileData['Expertise'] as List<dynamic>?)
      ?.map((e) => e.toString())
      .toList() ?? [];

  String trainerDocId = trainerProfileData['profileId'] ?? ''; // Get the TrainerProfile document ID
  String userId = trainerProfileData['userId'] ?? ''; // Get the user document ID
  String trainerName = trainerProfileData['Name'] ?? ''; // Get the trainer's name

  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TrainerDetailsPage(
            trainerData: trainerProfileData,
            currentUserId: user?.uid ?? '',
            trainerDocId: trainerDocId, // Pass the TrainerProfile document ID
            userId: userId, // Pass the user document ID
            trainerName: trainerName, // Pass the trainer's name
          ),
        ),
      );
    },
    child: ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          trainerProfileData['profilePictureUrl'] ?? 'https://via.placeholder.com/150',
        ),
        backgroundColor: Colors.grey[300],
      ),
      title: Text(trainerProfileData['Name'] ?? 'No Name'),
      subtitle: Text(expertiseList.isNotEmpty ? expertiseList.join(', ') : 'No Expertise'),
    ),
  );
}
}
