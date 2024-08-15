import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food/pages/trainer/views/trainer_send_advice.dart';
import 'trainer_client_analytics_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TrainerMyClientPage extends StatefulWidget {
  @override
  _TrainerMyClientPageState createState() => _TrainerMyClientPageState();
}

class _TrainerMyClientPageState extends State<TrainerMyClientPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _clients = [];
  List<Map<String, dynamic>> _filteredClients = [];
  bool _isLoading = true;
  String _searchQuery = '';
  Map<String, dynamic>? _selectedClient;

  @override
  void initState() {
    super.initState();
    _fetchClients();
  }

  Future<void> _fetchClients() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      String trainerId = user?.uid ?? '';

      if (trainerId.isEmpty) {
        throw Exception("Trainer ID is missing.");
      }

      final requestsSnapshot = await _firestore
          .collection('requests')
          .where('trainerId', isEqualTo: trainerId)
          .where('status', isEqualTo: 'accepted')
          .get();

      List<Map<String, dynamic>> clients = [];
      for (var requestDoc in requestsSnapshot.docs) {
        final userId = requestDoc.data()['userId'];

        final userProfileSnapshot = await _firestore
            .collection('users')
            .doc(userId)
            .collection('UserProfile')
            .get();

        for (var profileDoc in userProfileSnapshot.docs) {
          final data = profileDoc.data();
          clients.add({
            'clientId': userId,
            'userName': data['Name'] ?? 'Unknown',
            'fitnessGoals': data['fitnessGoals'] ?? 'N/A',
            'trainerId': trainerId,
          });
        }
      }

      setState(() {
        _clients = clients;
        _filteredClients = clients;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterClients(String query) {
    setState(() {
      _searchQuery = query;
      _filteredClients = _clients
          .where((client) => client['userName']?.toLowerCase().contains(query.toLowerCase()) ?? false)
          .toList();
    });
  }

  void _selectClient(Map<String, dynamic> client) {
    setState(() {
      _selectedClient = client;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 0),
          child: Text(
            'My Clients',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              fontSize: 25,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            onChanged: _filterClients,
                            decoration: InputDecoration(
                              hintText: 'Search Client...',
                              hintStyle: const TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _filteredClients.isNotEmpty ? _filteredClients.length : 1,
                            itemBuilder: (context, index) {
                              if (_filteredClients.isEmpty) {
                                return Center(
                                  child: Text(
                                    'No clients found',
                                    style: TextStyle(color: Colors.black, fontSize: 16),
                                  ),
                                );
                              } else {
                                final client = _filteredClients[index];
                                final isSelected = _selectedClient == client;
                                return GestureDetector(
                                  onTap: () => _selectClient(client),
                                  child: Container(
                                    color: isSelected ? Colors.blue[100] : Colors.white,
                                    child: ListTile(
                                      title: Text(
                                        client['userName'] ?? 'Client ${index + 1}',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 18,
                                        ),
                                      ),
                                      subtitle: Text('Goals: ${client['fitnessGoals'] ?? 'N/A'}'),
                                      trailing: PopupMenuButton<String>(
                                        onSelected: (String result) {
                                          if (result == 'View Analytics') {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => TrainerClientAnalyticsPage(),
                                              ),
                                            );
                                          }
                                          // Handle menu selection
                                        },
                                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                          const PopupMenuItem<String>(
                                            value: 'View Analytics',
                                            child: Text('View Analytics'),
                                          ),
                                          const PopupMenuItem<String>(
                                            value: 'Delete Client',
                                            child: Text('Delete Client'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          if (_selectedClient != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Set the background color to black
                  foregroundColor: Colors.white, // Set the text color to white
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Optional: set rounded corners
                  ),
                ),
                onPressed: () {
                  if (_selectedClient != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SendAdvicePage(
                          clientId: _selectedClient!['clientId'],
                          userName: _selectedClient!['userName'],
                          trainerId: _selectedClient!['trainerId'],
                        ),
                      ),
                    );
                  }
                },
                child: Text('Send Advice'),
              ),
            ),
        ],
      ),
    );
  }
}
