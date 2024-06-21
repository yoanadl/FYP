import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food/pages/admin/edit_profile_page.dart';
import 'create_new_profile_page.dart'; 
import 'user_profile.dart';


class UserProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(

          title: Row(
            children: <Widget>[
              // GestureDetector(
              //   onTap: () {
              //     // back
              //     // Navigator.of(context).pop();
              //   },
              //   child: SvgPicture.asset(
              //     'lib/images/back-button.svg',
              //     height: 20.0,
              //     width: 20.0,
              //   ),
              // ),
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

      body: UserProfileListView(),
      
      )
    );
  }
}

class UserProfileListView extends StatefulWidget{
  @override
  _UserProfileListView createState() => _UserProfileListView();
}

class _UserProfileListView extends State<UserProfileListView> {
  final List<UserProfile> profiles = [
    UserProfile(name: 'System Admin', role: 'Admin', permission: 'Full Access'),
    UserProfile(name: 'Free User', role: 'User', permission: 'Limited Access'),
    UserProfile(name: 'Premium User', role: 'User', permission: 'Limited Access'),
    UserProfile(name: 'Trainer', role: 'User', permission: 'Limited Access'),
    UserProfile(name: 'Community Admin', role: 'User', permission: 'Full Access'),
    UserProfile(name: 'Community Member', role: 'User', permission: 'Limited Access'),
  ];

  final TextEditingController controller = TextEditingController();
  bool isFieldEmpty = true;
  List<UserProfile> filteredProfiles = [];

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
          .where((profile) => profile.name.toLowerCase().contains(controller.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
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
              Expanded(
                child: ListView.builder(
                  itemCount: filteredProfiles.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(filteredProfiles[index].name),
                      subtitle: Text('Role: ${filteredProfiles[index].role}, Permission: ${filteredProfiles[index].permission}'),
                      trailing: IconButton(
                        icon: Icon(Icons.edit), 
                        onPressed: () {
                          // Navigate to Edit Page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfilePage(
                                profileIndex: index,
                                profileName: filteredProfiles[index].name,
                                profilePermission: filteredProfiles[index].permission,
                                profileDescription: filteredProfiles[index].description,
                              ),
                            ),
                          );
                        },
                      ),
                      // Add more UI elements as needed to display profile details
                    );
                  },
                ),
              ),

            ],
          ),
        ),
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateNewProfilePage(),
                ),
              );
            },
            child: Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}