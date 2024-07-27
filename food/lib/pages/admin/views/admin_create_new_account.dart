import 'package:flutter/material.dart';
import 'package:food/pages/admin/models/user_account_model.dart';
import 'package:food/pages/admin/presenters/admin_create_new_account_presenter.dart';


class AdminCreateNewAccount extends StatefulWidget {
  @override
  State<AdminCreateNewAccount> createState() => _AdminCreateNewAccountState();
}

class _AdminCreateNewAccountState extends State<AdminCreateNewAccount> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; 

  late AdminCreateNewAccountPresenter _presenter;

  @override 
  void initState() {
    super.initState();
    _presenter = AdminCreateNewAccountPresenter(
      UserModel(), 
      _onSuccess,
      _onError, 
      _onLoading
    );
  }

  void _onSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User created successfully')),
    );
    Navigator.pop(context);
  }

  void _onError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to create user')),
    );
  }

  void _onLoading(bool _isLoading) {
    setState(() {
      _isLoading = _isLoading;
    });
    
  }

  void _createUser() {
    _presenter.createUser(
      _emailController.text, 
      _passwordController.text
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Create New Account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 40),
            Text(
              'Email',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Password',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              obscureText: true,
              controller: _passwordController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 32),
            Center(
              child: _isLoading
                  ? CircularProgressIndicator() // Show loading indicator
                  : ElevatedButton(
                      onPressed: _createUser,
                      child: Text(
                        'Create Account',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        textStyle: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
