
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:food/services/auth/auth_gate.dart';
// import '../services/auth/login_or_register.dart';
import 'register_page.dart';


class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/images/background.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.65), BlendMode.dstATop),
              ),
            ),
          ),

        Center(
          child: Column (
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // logo
              Padding(
                padding: const EdgeInsets.only(top: 100, bottom: 0),
                child: Image.asset(
                  'lib/images/logo.png',
                  height: 240,
                  ),
                ),
                
                  
              // title
              Align(
                alignment: Alignment.center,
                child: const Text(
                  'GoodGrit',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                    color: Colors.white,
                  ),
                ),
              ),
                   
              const SizedBox(height: 100),

              // sign in button
              GestureDetector(
                onTap: () => Navigator.push(
                  context,  
                  MaterialPageRoute(
                    builder: (context) => AuthGate()
                    ),
                  ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 50),
                    decoration: BoxDecoration(
                      color: Color(0xFF508AA8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.all(15),
                    child: Center(
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w600),
                        ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Create an account',
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                        fontSize: 20
                      ),

                      recognizer: TapGestureRecognizer()..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterPage(
                            onTap: () => Navigator.pop(context),
                          )),
                        );
                      }
                    )
                  ]
                )
              )




            ],
          ),
        ),
        ],
      ),
       
    );
  }
}