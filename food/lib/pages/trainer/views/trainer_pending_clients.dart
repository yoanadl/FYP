import 'package:flutter/material.dart';
import 'package:food/components/trainer_navbar.dart';
import 'package:food/pages/trainer/views/trainer_base_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:food/pages/premiumUser/trainer/service/request_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TrainerPendingClientsPage extends StatefulWidget {
  @override
  _TrainerPendingClientsPageState createState() => _TrainerPendingClientsPageState();
}

class _TrainerPendingClientsPageState extends State<TrainerPendingClientsPage> {
  final RequestService _requestService = RequestService();
  List<Map<String, dynamic>> _pendingRequests = [];
  List<Map<String, dynamic>> _filteredRequests = [];
  bool _isLoading = true;
  String? _errorMessage;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterRequests);
    _fetchPendingRequests();
  }

  Future<void> _fetchPendingRequests() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      String trainerId = user?.uid ?? '';
      if (trainerId.isEmpty) {
        throw Exception("Trainer ID is missing.");
      }

      final requests = await _requestService.fetchPendingRequests(trainerId);
      setState(() {
        _pendingRequests = requests;
        _filteredRequests = requests; // Initialize filtered list
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterRequests() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredRequests = _pendingRequests
          .where((request) =>
              request['userName'].toLowerCase().contains(query))
          .toList();
    });
  }

  void _handleAccept(String requestId) async {
    try {
      await _requestService.updateRequestStatus(requestId, 'accepted');
      _fetchPendingRequests(); // Refresh the list
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  void _handleReject(String requestId) async {
    try {
      await _requestService.updateRequestStatus(requestId, 'rejected');
      _fetchPendingRequests(); // Refresh the list
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmAction(
      String message, String requestId, void Function() action) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmation'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Yes'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      action();
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterRequests);
    _searchController.dispose();
    super.dispose();
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
      ),
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Pending Clients',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      _buildSearchBox('Search name..'),
                      SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _filteredRequests.isNotEmpty
                              ? _filteredRequests.length
                              : 1,
                          itemBuilder: (context, index) {
                            if (_filteredRequests.isEmpty) {
                              return ListTile(
                                title: Center(
                                  child: Text(
                                    'Currently no clients',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  ),
                                ),
                              );
                            } else {
                              final request = _filteredRequests[index];
                              return ListTile(
                                title: Text(request['userName'] ??
                                    'Client ${index + 1}'),
                                subtitle: Text(
                                    'Goals: ${request['fitnessGoals'] ?? 'N/A'}'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.check,
                                          color: Colors.green),
                                      onPressed: () {
                                        _confirmAction(
                                          'Do you want to accept this client?',
                                          request['requestId'],
                                          () => _handleAccept(
                                              request['requestId']),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.close,
                                          color: Colors.red),
                                      onPressed: () {
                                        _confirmAction(
                                          'Do you want to reject this client?',
                                          request['requestId'],
                                          () => _handleReject(
                                              request['requestId']),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
      bottomNavigationBar: TrainerNavbar(
        currentIndex: 2,
        onTap: (int index) {
          if (index != 2) {
            Navigator.pop(context);
            switch (index) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const TrainerBasePage(initialIndex: 0),
                  ),
                );
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const TrainerBasePage(initialIndex: 1),
                  ),
                );
                break;
              case 3:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const TrainerBasePage(initialIndex: 3),
                  ),
                );
                break;
            }
          }
        },
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
}
