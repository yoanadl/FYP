import 'package:flutter/material.dart';
import 'package:food/components/base_page.dart';
import 'package:food/components/navbar.dart';
import 'package:food/pages/premiumUser/trainer/advice.dart'; // Correct import for the Advice page
import 'package:food/pages/premiumUser/trainer/request_list_page.dart';
import 'package:food/pages/premiumUser/trainer/trainer_list_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food/pages/premiumUser/trainer/service/trainer_service.dart';
import 'trainer_details_page.dart';

class TrainersPage extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;
  final TrainerService _trainerService = TrainerService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.black,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trainers',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Your trainer is here to guide you on your fitness journey.',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('requests')
                  .where('userId', isEqualTo: user?.uid ?? '')
                  .where('status', isEqualTo: 'accepted')
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recommended for you',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      StreamBuilder<List<Map<String, dynamic>>>(
                        stream: _trainerService.getTrainers(),
                        builder: (context, trainerSnapshot) {
                          if (trainerSnapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (trainerSnapshot.hasError) {
                            return Center(child: Text('Error: ${trainerSnapshot.error}'));
                          }
                          if (!trainerSnapshot.hasData || trainerSnapshot.data!.isEmpty) {
                            return Center(child: Text('No trainers available.'));
                          }

                          // Display trainer cards
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: trainerSnapshot.data!.map((trainer) {
                              return _buildTrainerCard(context, trainer);
                            }).toList(),
                          );
                        },
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => TrainersListPage()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: Colors.blue[100],
                              ),
                              child: Text('Find More Trainers'),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => RequestListPage(currentUserId: user?.uid ?? '')),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.black,
                              ),
                              child: Text('Request List'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }

                // Trainer found, display "Your Trainer" section and the "Send a Message" button
                final trainerData = snapshot.data!.docs.first.data() as Map<String, dynamic>;
                final trainerName = trainerData['Name'] ?? 'Unknown Trainer';
                final trainerId = trainerData['userId'] ?? '';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Trainer',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildTrainerDetail(trainerName),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecieveAdvicePage(
                              clientId: user?.uid ?? '',
                              userName: user?.displayName ?? 'Client',
                              trainerId: trainerId,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                      ),
                      child: Text('Send a Message'),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainerCard(BuildContext context, Map<String, dynamic> trainer) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TrainerDetailsPage(
              trainerData: trainer,
              currentUserId: user?.uid ?? '',
              trainerDocId: trainer['profileId'] ?? '',
              userId: trainer['userId'],
              trainerName: trainer['Name'] ?? 'No Name',
            ),
          ),
        );
      },
      child: Column(
        children: [
          CircleAvatar(
  radius: 40,
  backgroundImage: (trainer['profilePictureUrl'] != null && trainer['profilePictureUrl']!.isNotEmpty)
      ? NetworkImage(trainer['profilePictureUrl']!)
      : AssetImage('assets/images/no_profile_pic.png') as ImageProvider,
  backgroundColor: Colors.grey[300],
),

          SizedBox(height: 8),
          Text(
            trainer['Name'],
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainerDetail(String trainerName) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey[300],
        ),
        SizedBox(width: 16),
        Text(
          trainerName,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
