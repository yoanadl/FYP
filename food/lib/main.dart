import 'package:flutter/material.dart';
import 'package:food/pages/challenge_and_reward_page.dart';
import 'package:food/trainer_main_page.dart';
import 'pages/admin/admin_view_all_user_accounts.dart';
import 'pages/admin/admin_create_new_account.dart';
import 'pages/admin/admin_update_account.dart';
import 'friend_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePage(), // Change to a new HomePage
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Flutter is fun"),
      ),
      body: Container(
        color: Colors.green,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminViewAllUserAccounts()),
                  );
                },
                child: Text('Go to View All User Accounts Page'),
              ),
              SizedBox(height: 20), // Add some space between buttons
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminCreateNewAccount()),
                  );
                },
                child: Text('Go to Create New Account Page'),
              ),
              SizedBox(height: 20), // Add some space between buttons
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminUpdateAccount()),
                  );
                },
                child: Text('Go to Update Account Page'),
              ),
              SizedBox(height: 20), // Add some space between buttons
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChallengePage()), // Navigate to FriendListPage
                  );
                },
                child: Text('Go to Trainer Main Page'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
