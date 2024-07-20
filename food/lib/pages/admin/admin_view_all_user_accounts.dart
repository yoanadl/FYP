import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food/pages/admin/admin_create_new_account.dart';
import 'package:food/pages/admin/admin_update_account.dart';

class AdminViewAllUserAccounts extends StatefulWidget {
  @override
  _AdminViewAllUserAccountsPage createState() => _AdminViewAllUserAccountsPage();
}

class _AdminViewAllUserAccountsPage extends State<AdminViewAllUserAccounts> {

  List<Map<String, dynamic>> accounts = []; // list of maps to store user data
  List<Map<String, dynamic>> displayedAccounts = [];
  final TextEditingController _searchController = TextEditingController();

  @override 
  void initState() {
    super.initState();
    fetchAccounts();
    _searchController.addListener(() {
      filterAccounts();
    });
  }

  Future<void> fetchAccounts() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .get();

      List<Map<String, dynamic>> fetchAccounts = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

      setState(() {
        accounts = fetchAccounts;
        displayedAccounts = fetchAccounts;
      });
    }

    catch (e) {
      print('Error fetching user accounts: $e');
    }
  }

   void filterAccounts() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      displayedAccounts = accounts
          .where((account) => (account['email'] ?? '').toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text(
          'User Accounts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          )),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: displayedAccounts.length,
              itemBuilder: (context, index) {
                var account = displayedAccounts[index];
                return ListTile(
                  title: Text(account['email'] ?? 'No email'),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => AdminUpdateAccount(),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdminCreateNewAccount(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      
    );
  }
}