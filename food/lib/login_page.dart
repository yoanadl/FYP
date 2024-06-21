import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{

  //text controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();




  @override 
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.blue[200],

      body: SafeArea(
        child: Center(
          child: Column(children:[

            //Hi
            Text(
              'Hello Again!',
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 24),
              ),
            SizedBox(height: 20),

            //email text field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(12)
                ),

                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Email',
                    )
                  ),
                ),
              ),
            ),

            SizedBox(height: 10),
            
            //password textfield

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(12)
                ),

                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Password',
                    )
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),
            

            //sign in button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(12)
                ),
                child: Center(
                  child: Text(
                    'Sign in',
                    style: TextStyle(color: Colors.white),
                  )
                ),
              ),
            ),

            //not a member? register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Not a member?', style: TextStyle(color: Colors.black)),

                Text(' Register Now', style: TextStyle(color: Colors.blue))
              ],
            )

            ]

          )
        )
      ),
    );

  }

}