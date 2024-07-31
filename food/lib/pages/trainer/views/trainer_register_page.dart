import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food/pages/SettingupProfile/name_page.dart';
import 'package:food/pages/trainer/presenters/trainer_register_presenter.dart';
import 'package:food/components/my_button.dart';
import 'package:food/components/my_textfield.dart';
import 'package:food/pages/trainer/views/trainer_name_page.dart';
import 'package:food/services/auth/auth_service.dart';



class TrainerRegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const TrainerRegisterPage({super.key, required this.onTap});

  @override
  State<TrainerRegisterPage> createState() => _TrainerRegisterPageState();
}

class _TrainerRegisterPageState extends State<TrainerRegisterPage> implements TrainerRegisterView {
  final TrainerRegisterPresenter _presenter = TrainerRegisterPresenter();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _presenter.attachView(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // background image
          Container(
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
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
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
                      'Trainer Registration',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF508AA8),
                      ),
                    ),
                  ),
                  MyTextField(
                    controller: emailController,
                    hintText: "Email",
                    obscureText: false,
                  ),
                  const SizedBox(height: 5),
                  MyTextField(
                    controller: passwordController,
                    hintText: "Password",
                    obscureText: true,
                  ),
                  const SizedBox(height: 5),
                  MyTextField(
                    controller: confirmPasswordController,
                    hintText: "Confirm Password",
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  MyButton(
                    text: "Sign Up",
                    onTap: () {
                      _presenter.registerTrainer(
                        emailController.text,
                        passwordController.text,
                        confirmPasswordController.text,
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(
                          fontSize: 17,
                          color: Color(0xFF508AA8),
                        ),
                      ),
                      const SizedBox(width: 15),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          "Sign in",
                          style: TextStyle(
                            fontSize: 17,
                            color: Color(0xFF508AA8),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                ],
              ),
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
                    color: Colors.white,
                  ),
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

  @override
  void showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
      ),
    );
  }

  @override
  void onRegisterSuccess(UserCredential userCredential) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => TrainerNamePage()),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Success'),
        content: Text('Account created successfully!'),
      ),
    );

  }
}