// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food/pages/SettingupProfile/name_page.dart';
import 'package:food/pages/trainer/views/trainer_register_page.dart';
import 'package:food/services/auth/auth_service.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';

class RegisterPage extends StatefulWidget {

  final void Function()? onTap;

  const RegisterPage({ 
    super.key, 
    required this.onTap
  }) ;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  // text editing controller
  // final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
 

  void register() async {

    // get auth service
    final _authService = AuthService();

    // check if passwords match ->  create user
    if (passwordController.text == confirmPasswordController.text) {

      // try creating user
      try {
        UserCredential userCredential =  await _authService.signUpWithEmailPassword(
          emailController.text, 
          passwordController.text,
        );
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NamePage()),  // Replace with your destination page
        );

        showDialog(
          context: context, 
          builder: (context) => AlertDialog(
            title: Text('Success'),
            content: Text('Account created succesfully!'),
          ),
        );
        
      }

      // display any errors
      catch (e){
        showDialog(
          context: context, 
          builder: (context) => AlertDialog(
            // title: Text(e.toString()),
            title: Text('Error'),
            content: Text(e.toString()),
          ),
        );
      }
    }


    // if passwords don't match -> show error

    else {
      showDialog(
          context: context, 
          builder: (context) => const AlertDialog(
            title: Text("Passwords don't match!"),
          ),
        );

    }
    


  }
  
  void _navigateToTrainerRegisterPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TrainerRegisterPage(
        onTap: () {},
      )),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 25.0, left: 8.0),
                  child: Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF508AA8),
                    )
                    ),
                ),
              
              //  // full name textfield
              // MyTextField(
              //   controller: emailController, 
              //   hintText: "Full Name", 
              //   obscureText: false,  
              // ),

              // email textfield
              MyTextField(
                controller: emailController, 
                hintText: "Email", 
                obscureText: false,  
              ),
  
              const SizedBox(height:5 ),
  
              // password textfield

              MyTextField(
                controller: passwordController, 
                hintText: "Password",
                obscureText: true,
              ),

              const SizedBox(height:5 ),
  
              // confirm password textfield

              MyTextField(
                controller: confirmPasswordController, 
                hintText: "Confirm Password",
                obscureText: true,
              ),
 
              const SizedBox(height: 20 ),

              // sign in button
              MyButton(
                text: "Sign Up", 
                onTap: register,
              ),

              const SizedBox(height: 30 ),


              // Already have an account? Sign in

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ", 
                    style: TextStyle (
                      fontSize: 17,
                      color: Color(0xFF508AA8),
                    )),

                  const SizedBox(width: 15),

                  GestureDetector(
                    onTap: widget.onTap ,
                    child: Text(
                      "Sign in", 
                      style: TextStyle (
                        fontSize: 17,
                        color: Color(0xFF508AA8),
                        fontWeight: FontWeight.w900
                      )),
                  ),
                ],
              ),

              SizedBox(height: 15,),
              // register for a trainer account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Sign up for a trainer account? ", 
                    style: TextStyle (
                      fontSize: 17,
                      color: Color(0xFF508AA8),
                    )),

                  const SizedBox(width: 15),

                  GestureDetector(
                    onTap: () => _navigateToTrainerRegisterPage(context) ,
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