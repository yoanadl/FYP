import 'package:flutter/material.dart';
import 'package:food/components/base_page.dart';
import 'package:food/pages/premiumUser/trainer/service/request_service.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';

class TrainerDetailsPage extends StatelessWidget {
  final Map<String, dynamic> trainerData;
  final String currentUserId;
  final String trainerDocId;
  final String userId; // Pass the user ID
  final String trainerName; // Pass the trainer's name
  final String profilePictureUrl;

  final RequestService _requestService = RequestService(); // Instantiate the service

  TrainerDetailsPage({
    required this.trainerData,
    required this.currentUserId,
    required this.trainerDocId,
    required this.userId, // Initialize user ID
    required this.trainerName, // Initialize trainer name
    required this.profilePictureUrl,
  });

  Future<void> _sendRequest(BuildContext context) async {
    try {
      // Check if a request already exists
      final requestQuery = await FirebaseFirestore.instance
          .collection('requests')
          .where('userId', isEqualTo: currentUserId)
          .where('trainerId', isEqualTo: userId)
          .get();

      if (requestQuery.docs.isNotEmpty) {
        // Request already exists
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You have already sent a request to this trainer.')),
        );
        return;
      }

      // Send the request
      await _requestService.sendRequest(currentUserId, userId, trainerName, profilePictureUrl); // Pass trainerName
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request sent successfully!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BasePage(initialIndex: 3), // Navigate to BasePage with TrainersPage selected
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send request: $e')),
      );
    }
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
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                          trainerData['profilePictureUrl'] ?? 'https://via.placeholder.com/100',
                        ),
                        fit: BoxFit.cover,
                      ),
                      color: Colors.grey[300],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    trainerData['name'] ?? 'No Name',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.lightBlue, width: 2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Expertise: ${trainerData['expertise']?.join(', ') ?? 'No Expertise'}',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Age: ${trainerData['age'] ?? 'Unknown'}',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Experience: ${trainerData['experience'] ?? 'Unknown'}',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 2, 41, 61),
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    onPressed: () => _sendRequest(context),
                    child: Text(
                      'Send Request',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
