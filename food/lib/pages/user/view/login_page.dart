import 'package:flutter/material.dart';
import 'package:food/components/base_page.dart';
import 'package:food/pages/user/view/register_page.dart'; 
import 'package:food/services/auth/auth_service.dart';
import '../../../components/my_button.dart';
import '../../../components/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({Key? key, required this.onTap}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // void login(BuildContext context) async {
  //   final _authService = AuthService();

  //   try {
  //     User? user = await _authService.signInWithEmailPassword(
  //       context,
  //       emailController.text,
  //       passwordController.text,
  //     );

      
  //   } catch (e) {
      
  //     showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: Text('Error'),
  //         content: Text(e.toString()),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: Text('OK'),
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  // }

  void navigateToRegisterPage() {
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => RegisterPage(
        onTap: () {
          
        },
      )),
    );
  }

  void login(BuildContext context) async {
  final _authService = AuthService();

  try {
    User? user = await _authService.signInWithEmailPassword(
      context,
      emailController.text,
      passwordController.text,
    );
    
    // Navigate to the base page or home page if login is successful
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => BasePage()),
    );

  } catch (e) {
    if (mounted) { // Check if the widget is still mounted
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevent resizing when the keyboard appears
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/images/background.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.8),
                  BlendMode.dstATop,
                ),
              ),
            ),
          ),

          // White rectangle
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.67,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: Text(
                          'Welcome Back',
                          style: TextStyle(
                            fontSize: 40.0,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF508AA8),
                          ),
                        ),
                      ),

                      // Email textfield
                      MyTextField(
                        controller: emailController,
                        hintText: "Email",
                        obscureText: false,
                      ),

                      const SizedBox(height: 20),

                      // Password textfield
                      MyTextField(
                        controller: passwordController,
                        hintText: "Password",
                        obscureText: true,
                      ),

                      const SizedBox(height: 20),

                      // Sign in button
                      MyButton(
                        text: "Sign In",
                        onTap: () => login(context),
                      ),

                      const SizedBox(height: 15),

                      // Don't have an account? Sign up
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: TextStyle(
                              fontSize: 17,
                              color: Color(0xFF508AA8),
                            ),
                          ),

                          const SizedBox(width: 15),

                          GestureDetector(
                            onTap: navigateToRegisterPage,
                            child: Text(
                              "Sign up",
                              style: TextStyle(
                                fontSize: 17,
                                color: Color(0xFF508AA8),
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // AppBar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
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
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
