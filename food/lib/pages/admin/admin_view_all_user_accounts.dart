import 'package:flutter/material.dart';

class AdminViewAllUserAccounts extends StatefulWidget {
  @override
  _AdminViewAllUserAccountsPageState createState() => _AdminViewAllUserAccountsPageState();
}

class _AdminViewAllUserAccountsPageState extends State<AdminViewAllUserAccounts> {
  final List<String> accounts = List.generate(10, (index) => 'account #${index + 1}');
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(accounts[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // Edit account action
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
          // Add new account action
        },
        child: Icon(Icons.add),
      ),
      
    );
  }
}