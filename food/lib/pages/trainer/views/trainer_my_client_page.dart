import 'package:flutter/material.dart';
import 'trainer_client_analytics_page.dart';

class TrainerMyClientPage extends StatelessWidget {
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
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
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true, // Ensures the ListView is as small as possible
                itemCount: 7, // Example client count
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      'Client #${index + 1}',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                      ),
                    ),
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
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
