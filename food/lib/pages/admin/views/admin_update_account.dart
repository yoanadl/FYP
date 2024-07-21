import 'package:flutter/material.dart';
import 'package:food/pages/admin/models/user_account_model.dart';
import 'package:food/pages/admin/presenters/user_update_presenter.dart';
import 'package:food/pages/admin/views/user_update_view.dart';


class AdminUpdateAccount extends StatefulWidget {

  final String userId;

  AdminUpdateAccount({required this.userId});

  @override
  State<AdminUpdateAccount> createState() => _AdminUpdateAccountState();

}

class _AdminUpdateAccountState extends State<AdminUpdateAccount> implements UserUpdateView{

  late UserUpdatePresenter _presenter;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override 
  void initState() {
    super.initState();
    _presenter = UserUpdatePresenter(UserModel(), this);
    _presenter.loadUser(widget.userId);
  }
  
  @override  
  void showUser(Map<String, dynamic> user) {
    print("User data received: $user");
    setState(() {
      _nameController.text = user['name'] ?? '';
      _emailController.text = user['email'] ?? '';
    });
  }

  @override 
  void onSaveSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(
        'User updated successfully'
        )
      )
    );

    Navigator.pop(context);

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
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Are you sure you want to delete this account?'),
                                actions: [
                                  TextButton(
                                    child: Text('Cancel', style: TextStyle(color: Colors.black)),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Delete', style: TextStyle(color: Colors.red)),
                                    onPressed: () {
                                      // Add delete logic here
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Add edit logic here
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
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
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _presenter.saveUser(widget.userId, {
                      'name': _nameController.text,
                      'email': _emailController.text,
                    });
                  },
                  child: Text(
                    'Save Account',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      
    );
  }
}