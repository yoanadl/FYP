// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:food/pages/home_page.dart';
import 'package:food/services/auth/auth_service.dart'; 
import '../components/my_button.dart';
import '../components/my_textfield.dart';
import 'base_page.dart';

class LoginPage extends StatefulWidget {

  final void Function()? onTap;

  const LoginPage({
    super.key, 
    required this.onTap
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  // text editing controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // login method
  void login() async{

    // get instance of auth service
    final _authService = AuthService();

    // try sign in 
    try {
      await _authService.signInWithEmailPassword(
        emailController.text, 
        passwordController.text,
      );

      // navigate to the home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (coontext) => BasePage())
      );

    }

    // display any errors
    catch (e) {

      showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ),
      );

    }



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : true,
      body: Stack (
        children: [
          // background image
          Container (
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/images/background.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.8), BlendMode.dstATop),
              ),
            ),
          ),


        // white rectangle

        Positioned(
          left:0,
          right: 0,
          bottom: 0,
          child: Container (
            height: MediaQuery.of(context).size.height * 0.67,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: Colors.white,
            ),

            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0, left: 8.0),
                    child: Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF508AA8),
                      )
                      ),
                  ),
                
              
                // email textfield
                MyTextField(
                  controller: emailController, 
                  hintText: "Email", 
                  obscureText: false,  
                ),
                
                const SizedBox(height:20 ),
                
                // password textfield
              
                MyTextField(
                  controller: passwordController, 
                  hintText: "Password",
                  obscureText: true,
                ),
              
                const SizedBox(height:20 ),
              
                // sign in button
                MyButton(
                  text: "Sign In", 
                  onTap: login,
                ),
              
                const SizedBox(height: 15 ),
              
              
                // Don't have an account? Sign up
              
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?", 
                      style: TextStyle (
                        fontSize: 17,
                        color: Color(0xFF508AA8),
                      )),
              
                    const SizedBox(width: 15),
              
                    GestureDetector(
                      onTap: widget.onTap ,
                      child: Text(
                        "Sign up", 
                        style: TextStyle (
                          fontSize: 17,
                          color: Color(0xFF508AA8),
                          fontWeight: FontWeight.w900
                        )),
                    ),
                  ],
                )
              
                ],
              ),
            )
          ),
        ),

        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: Text(
                'Back', 
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.black.withOpacity(0.2),
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            
            
          ],
        ),
        ],
      ),
    );
  }
}