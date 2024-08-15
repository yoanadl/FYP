// lib/views/user_view.dart
import 'package:flutter/material.dart';
import 'package:food/pages/admin/views/admin_create_new_account.dart';
import 'package:food/pages/admin/views/admin_update_account.dart';
import 'package:food/pages/admin/models/user_account_model.dart';
import 'package:food/pages/admin/presenters/user_account_presenter.dart';
import 'package:food/pages/admin/views/user_view.dart';

class AdminViewAllUserAccounts extends StatefulWidget {
  @override
  _AdminViewAllUserAccountsPage createState() => _AdminViewAllUserAccountsPage();
}

class _AdminViewAllUserAccountsPage extends State<AdminViewAllUserAccounts> implements UserView {
  final UserModel _userModel = UserModel();
  late final UserPresenter _presenter;
  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _displayedUsers = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _presenter = UserPresenter(_userModel, this);
    _presenter.loadUsers();
    _searchController.addListener(() {
      _presenter.filterUsers(_searchController.text);
    });
  }

  @override
  void showUsers(List<Map<String, dynamic>> users) {
    setState(() {
      _users = users;
      _displayedUsers = users;
    });
  }

  @override
  void filterUsers(String query) {
    setState(() {
      _displayedUsers = _users
          .where((user) => (user['email'] ?? '').toLowerCase().contains(query.toLowerCase()))
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
            fontSize: 22.0,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0), 
              child: ListView.builder(
                itemCount: _displayedUsers.length,
                itemBuilder: (context, index) {
                  var user = _displayedUsers[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10.0), // Space between items
                    decoration: BoxDecoration(
                      color: Color(0xFFC8E0F4).withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8.0), 
                    ),
                    child: ListTile(
                      title: Text(user['email'] ?? 'No email'),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          if (user['userId'] != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdminUpdateAccount(
                                  userId: user['userId'] as String,
                                ),
                              ),
                            );
                          } else {
                            // Handle the case where userId is null
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('User ID is missing for this user.')),
                            );
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
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
