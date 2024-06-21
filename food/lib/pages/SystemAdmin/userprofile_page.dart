import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'admin_navbar.dart';


class UserProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
        title: Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                // back
                Navigator.of(context).pop();
              },
              child: SvgPicture.asset(
                'lib/images/back-button.svg',
                height: 20.0,
                width: 20.0,
              ),
            ),
            Expanded(
              child: Text(
                'User Profile',
                textAlign: TextAlign.center, // Center align the text
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 25.0,
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        
      ),

      body: _UserProfileListView(),
      
      )
    );
  }
}

class _UserProfileListView extends StatefulWidget{
  @override
  UserProfileListView createState() => UserProfileListView();
}

class UserProfileListView extends State<_UserProfileListView> {
  final List<String> profiles = [
    'System Admin',
    'Free User',
    'Premium User',
    'Trainer',
    'Community Admin',
    'Community Member',
  ];

  final TextEditingController controller = TextEditingController();
  bool isFieldEmpty = true;
  List<String> filteredProfiles = [];

  @override
  void initState() {
    super.initState();
    filteredProfiles = profiles;
    controller.addListener(() {
      setState(() {
        isFieldEmpty = controller.text.isEmpty;
        _onSearchIconPressed();
      });
    });
  }
  
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onSearchIconPressed() {
    setState(() {
      filteredProfiles = profiles
      .where((profile) => profile.toLowerCase().contains(controller.text.toLowerCase()))
      .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),

          TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: isFieldEmpty ? 'Search' : null,
              prefixIcon: InkWell(
                onTap: _onSearchIconPressed,
                child: Icon(Icons.search),
              ),
            ),
          ),

          const SizedBox(
            height: 20,
          ),
      
          //search result
          Expanded(
            child: ListView.builder(
              itemCount: filteredProfiles.length,
              itemBuilder: (context, index) {
                return ListTile(
                 title: Text(filteredProfiles[index])
                );
              },
            ),
          ),
        ],
      ),
    );

  }

  
}


       

