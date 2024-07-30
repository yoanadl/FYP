// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/material.dart';
import 'Community_List_page.dart';
import 'Create_Community_page.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff031927),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Text(
              'Community',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Spacer(),

            IconButton(
              icon: Icon(Icons.search),
              onPressed: (){
                
              },
              color: Colors.white,
            )
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: Row(
                children: [
                  //left container
                  Container(
                    width: MediaQuery.of(context).size.width * 1,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Create a Community',
                            style: TextStyle(
                              fontSize: 35.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
        
                          SizedBox(height: 5.0,),
                          Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Phasellus egestas tellus rutrum tellus pellentesque. Tellus at urna condimentum mattis. ',
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
        
                          SizedBox(height: 10.0,),

                          ElevatedButton(
                            onPressed: () => Navigator.push(
                              context, 
                              MaterialPageRoute(builder: (context) => CreateCommunityPage()),
                              ),

                            child: Text('Create a Community'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFC8E0F4),
                              foregroundColor: Colors.black,
                            ),
                          ),

                          ElevatedButton(
                            onPressed: () => Navigator.push(
                              context, 
                              MaterialPageRoute(builder: (context) => CommunityListPage()),
                              ),
        
                            child: Text('View Community'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFC8E0F4),
                              foregroundColor: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        
            Container(
              color: Color(0xff031927),
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(12.0),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      'Join Communities',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    
                    Text(
                      'Workout never have been so fun with friends!',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
        
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
        
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: Color(0xFFC8E0F4),
                            ),
                          ),
                          SizedBox(height: 8.0,),
                          Text(
                            'Community Name #1', 
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
        
                      Column(
                        children: [
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: Color(0xFFC8E0F4),
                            ),
                          ),
                          SizedBox(height: 8.0,),
                          Text(
                            'Community Name #2', 
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
        
                  SizedBox(height: 20.0,),
        
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: Color(0xFFC8E0F4),
                            ),
                          ),
                          SizedBox(height: 8.0,),
                          Text(
                            'Community Name #3', 
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
        
                      Column(
                        children: [
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: Color(0xFFC8E0F4),
                            ),
                          ),
                          SizedBox(height: 8.0,),
                          Text(
                            'Community Name #4', 
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 20.0,),

                  InkWell(
                    child: Text('See more', 
                    style: TextStyle(fontSize: 17, color: Colors.black, 
                    fontWeight: FontWeight.bold, decoration: TextDecoration.underline),),
                    onTap: () => Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => CommunityListPage()),
                      ),
                  ),
                ],
              )
            )
          ],
        ),
      )
    );

  }
}