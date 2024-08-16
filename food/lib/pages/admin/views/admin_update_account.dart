import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:food/pages/admin/models/user_account_model.dart';
import 'package:food/pages/admin/presenters/user_update_presenter.dart';
import 'package:food/pages/admin/views/user_update_view.dart';

class AdminUpdateAccount extends StatefulWidget {
  final String userId;

  AdminUpdateAccount({required this.userId});

  @override
  State<AdminUpdateAccount> createState() => _AdminUpdateAccountState();
}

class _AdminUpdateAccountState extends State<AdminUpdateAccount> implements UserUpdateView {
  late UserUpdatePresenter _presenter;
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _presenter = UserUpdatePresenter(UserModel(), this);
    _presenter.loadUser(widget.userId);
  }

  @override
  void showUser(Map<String, dynamic> user) {
    setState(() {
      _emailController.text = user['email'] ?? '';
    });
  }

  @override
  void onSaveSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User updated successfully'))
    );
    Navigator.pop(context);
  }

  @override
  void onDeleteSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User deleted successfully'))
    );
    Navigator.pop(context);
  }

  @override
  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $message'))
    );
  }

  Future<void> _deleteUser() async {
    final url = 'https://us-central1-fyp-goodgrit-a8601.cloudfunctions.net/deleteUser?uid=${widget.userId}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        onDeleteSuccess();
      } else {
        showError('Failed to delete user');
      }
    } catch(e) {
      showError('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40), // To give some top padding
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Update Account',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          showCupertinoDialog(
                            context: context,
                            builder: (context) => CupertinoAlertDialog(
                              title: Text('Are you sure you want to delete this account?'),
                              actions: [
                                CupertinoDialogAction(
                                  child: Text('Cancel'),
                                  isDestructiveAction: false,
                                  onPressed: () => Navigator.pop(context),
                                ),
                                CupertinoDialogAction(
                                  child: Text('Delete', style: TextStyle(color: Colors.red)),
                                  isDestructiveAction: true, // Sets red color for destructive action
                                  onPressed: () {
                                    _deleteUser();
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );

                        },
                      ),
                    
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              
            ],
          ),
        ),
      ),
    );
  }
}
