// import 'package:flutter/material.dart';
// import 'package:food/pages/admin/models/admin_profile_model.dart';
// import 'package:food/pages/admin/models/user_account_model.dart';
// import 'package:food/pages/admin/models/user_profile.dart'; 
// import 'package:food/pages/admin/presenters/admin_view_user_profiles_presenter.dart';
// import 'package:food/pages/admin/edit_profile_page.dart';
// import 'package:food/pages/admin/create_new_profile_page.dart';

// class AdminViewUserProfilesView extends StatefulWidget {
//   @override
//   _AdminViewUserProfilesViewState createState() => _AdminViewUserProfilesViewState();
// }

// class _AdminViewUserProfilesViewState extends State<AdminViewUserProfilesView> implements AdminViewUserProfilesViewInterface {
//   late AdminViewUserProfilesPresenter _presenter;
//   final TextEditingController _searchController = TextEditingController();
//   List<UserProfile> _profiles = [];
//   List<UserProfile> _filteredProfiles = [];

//   final List<UserProfile> _sampleProfiles = [
//     UserProfile(name: 'System Admin', role: 'Admin', permission: 'Full Access'),
//     UserProfile(name: 'Free User', role: 'User', permission: 'Limited Access'),
//     UserProfile(name: 'Premium User', role: 'User', permission: 'Limited Access'),
//     UserProfile(name: 'Trainer', role: 'User', permission: 'Limited Access'),
//     UserProfile(name: 'Community Admin', role: 'User', permission: 'Full Access'),
//     UserProfile(name: 'Community Member', role: 'User', permission: 'Limited Access'),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _presenter = AdminViewUserProfilesPresenter(this, UserModel(), AdminProfileModel()); // Initialize models
//     _searchController.addListener(_onSearchChanged);
//     _presenter.fetchUserProfiles();
//   }

//   void _onSearchChanged() {
//     setState(() {
//       String query = _searchController.text.toLowerCase();
//       _filteredProfiles = _profiles.where((profile) {
//         return profile.name.toLowerCase().contains(query);
//       }).toList();
//     });
//   }

//   @override
//   void dispose() {
//     _searchController.removeListener(_onSearchChanged);
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   void updateUserProfileList(List<UserProfile> profiles) {
//     setState(() {
//       if (profiles.isEmpty) {
//         _profiles = _sampleProfiles;
//       } else {
//         _profiles = profiles;
//       }
//       _filteredProfiles = _profiles;
//       print('Profiles updated: ${_profiles.length}'); // Debug log
//     });
//   }

//   @override
//   void showError(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
//     print('Error: $message'); // Debug log
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Row(
//           children: <Widget>[
//             Expanded(
//               child: Text(
//                 'All User Profiles',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 22.0,
//                   fontFamily: 'Poppins',
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(24.0),
//             child: Column(
//               children: [
//                 TextField(
//                   controller: _searchController,
//                   decoration: InputDecoration(
//                     labelText: _searchController.text.isEmpty ? 'Search' : null,
//                     prefixIcon: Icon(Icons.search),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: _filteredProfiles.length,
//                     itemBuilder: (context, index) {
//                       UserProfile profile = _filteredProfiles[index];
//                       return ListTile(
//                         title: Text(profile.name),
//                         subtitle: Text('Role: ${profile.role}, Permission: ${profile.permission}'),
//                         trailing: IconButton(
//                           icon: Icon(Icons.edit),
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => EditProfilePage(
//                                   profileIndex: index,
//                                   profileName: profile.name,
//                                   profilePermission: profile.permission,
//                                   profileDescription: profile.description,
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             bottom: 16.0,
//             right: 16.0,
//             child: FloatingActionButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => CreateNewProfilePage(),
//                   ),
//                 );
//               },
//               child: Icon(Icons.add),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// static list of sample user profiles without fetching data from a backend

import 'package:flutter/material.dart';
import 'package:food/pages/admin/models/user_profile.dart';
import 'package:food/pages/admin/edit_profile_page.dart';
import 'package:food/pages/admin/create_new_profile_page.dart';

class AdminViewUserProfilesView extends StatefulWidget {
  @override
  _AdminViewUserProfilesViewState createState() => _AdminViewUserProfilesViewState();
}

class _AdminViewUserProfilesViewState extends State<AdminViewUserProfilesView> {
  final TextEditingController _searchController = TextEditingController();
  final List<UserProfile> _sampleProfiles = [
    UserProfile(name: 'System Admin', role: 'Admin', permission: 'Full Access'),
    UserProfile(name: 'Free User', role: 'User', permission: 'Limited Access'),
    UserProfile(name: 'Premium User', role: 'User', permission: 'Limited Access'),
    UserProfile(name: 'Trainer', role: 'User', permission: 'Limited Access'),
    UserProfile(name: 'Community Admin', role: 'User', permission: 'Full Access'),
    UserProfile(name: 'Community Member', role: 'User', permission: 'Limited Access'),
  ];
  List<UserProfile> _filteredProfiles = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _filteredProfiles = _sampleProfiles; // Initialize filtered profiles
  }

  void _onSearchChanged() {
    setState(() {
      String query = _searchController.text.toLowerCase();
      _filteredProfiles = _sampleProfiles.where((profile) {
        return profile.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'All User Profiles',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: _searchController.text.isEmpty ? 'Search' : null,
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredProfiles.length,
                    itemBuilder: (context, index) {
                      UserProfile profile = _filteredProfiles[index];
                      return ListTile(
                        title: Text(profile.name),
                        subtitle: Text('Role: ${profile.role}, Permission: ${profile.permission}'),
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfilePage(
                                  profileIndex: index,
                                  profileName: profile.name,
                                  profilePermission: profile.permission,
                                  profileDescription: profile.description,
                                ),
                              ),
                            );
                          },
                        ),
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
      ),
    );
  }
}