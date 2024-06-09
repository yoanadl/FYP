// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:food/components/navbar.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // track the currently selected item
  int _seletectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    String formattedDate = DateFormat('EEEE d MMMM').format(DateTime.now());

    return Scaffold(

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          automaticallyImplyLeading: false, // hide the back button
          backgroundColor: Colors.white,
          centerTitle: false,
          actions: [

            // sync to smart watch icon

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),

                child: IconButton(
                  onPressed: () {}, 
                  icon: Icon(Icons.sync),
                  iconSize: 25,
                  color: Colors.black,
                ),
              ),
            ),


            // notification icon
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[300],
                ),

                child: IconButton(
                  onPressed: () {}, 
                  icon: Icon(Icons.notifications),
                  iconSize: 25,
                  color: Colors.black,
                ),
              ),
            ),
            
            //profile icon
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: SizedBox(
                width: 100,
                height: 100,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                  ),
                ),
              ),
              )

          ],

          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 17.0),
                child: Text(
                  'Hello, Username!',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 17.0),
                child: Text(
                  formattedDate,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),


      body: Container(
        color: Colors.white,
        child: Center(
          child: Text('Home Page Content'),
          
        ),
      ),

      bottomNavigationBar: Navbar(
        currentIndex: _seletectedIndex,
        onTap: (int index) {
          setState(() {
            _seletectedIndex = index;
          });
        }
      ),
    );
  }
}