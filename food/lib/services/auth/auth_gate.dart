import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food/pages/admin/admin_base_page.dart';
import 'package:food/components/base_page.dart';
import 'package:food/pages/trainer/views/trainer_base_page.dart';
import 'package:food/services/auth/auth_service.dart';
import 'package:food/services/auth/login_or_register.dart';

class AuthGate extends StatelessWidget { 
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is logged in
          if (snapshot.hasData) {

            String uid = FirebaseAuth.instance.currentUser!.uid;
            return FutureBuilder<String>(
              future: AuthService().getUserRole(uid), 
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator()
                  );
                
                }

                else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}')
                  );
                }

                else if (snapshot.hasData) {

                  String role = snapshot.data!;
                  print('User role: $role');

                  if (role == 'admin') {
                    return AdminBasePage();
                  }

                  else if (role == 'trainer') {
                    return TrainerBasePage();
                  }

                  else {
                    return BasePage();
                  }

                }

                  else {
                    return LoginOrRegister();
                  }
                }
              );

          }

          // user is not logged in
          else {
            return const LoginOrRegister();
          } 
        },
      ),
    );
  }
}