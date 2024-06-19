import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../workout_page.dart';
import '../community_page.dart';
import '../profile_page.dart';
import '../home_page.dart';

void main() {
  runApp(ViewUserProfilePage());
}

class ViewUserProfilePage extends StatefulWidget {
  ViewUserProfilePage({Key? key}) : super(key: key);

  @override
  _ViewUserProfilePageState createState() => _ViewUserProfilePageState();
}

class _ViewUserProfilePageState extends State<ViewUserProfilePage> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double screenWidth = mediaQueryData.size.width;
    double screenHeight = mediaQueryData.size.height;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: const Text(
              'User Profile',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 25,
                color: Colors.black,
              ),
            ),
            centerTitle: true,
            floating: true,
           
          ),
          
        ],
      ),
    );
  }
}
