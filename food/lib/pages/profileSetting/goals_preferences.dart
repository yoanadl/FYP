// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';



class GoalsPreferences extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      
      appBar: AppBar(
        backgroundColor: Colors.white,
        
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Title(
                color: Colors.black, 
                child: Text(
                  'My Goals & Dietary Preferences',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
          
              Container(
                color: Color(0x59C8E0F4),
                margin: const EdgeInsets.only(top: 70),
                padding: const EdgeInsets.all(5.0),
                height: 400,
                width: 350,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Fitness Goal',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                        Container(
                          width: 200,
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Enter fitness goal',
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 50),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     Text(
                    //       'Dietary \nPreferences',
                    //       style: TextStyle(
                    //         fontSize: 18,
                    //         fontWeight: FontWeight.w600
                    //       ),
                    //     ),
                    //     Container(
                    //       width: 200,
                    //       child: TextField(
                    //         decoration: InputDecoration(
                    //           hintText: 'Enter dietary preferences',
                    //           filled: true,
                    //           fillColor: Colors.white,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),

                    SizedBox(height: 50),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {

                        },
                        style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff031927),
                              foregroundColor: Colors.white,
                            ),
                        child: Text('Edit'),
                      ),
                    ),
                  ],
                )
              )
            ],
          ),
        ),
      ),


    );
  }
}

