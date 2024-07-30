import 'package:flutter/material.dart';
import 'package:food/pages/admin/presenters/admin_profile_presenter.dart';
import 'package:food/pages/admin/models/admin_profile_model.dart';
import 'package:food/pages/Profile%20Settings/my_profile_page.dart';
import 'package:food/pages/Profile%20Settings/settings_page.dart';

class RowData {
  final IconData icon;
  final String text;
  final Widget? destination;

  RowData({
    required this.icon,
    required this.text,
    this.destination,
  });
}

// Define the AdminProfileView interface
abstract class AdminProfileView {
  void updateName(String newName);
}

class AdminProfileViewImpl extends StatefulWidget {
  AdminProfileViewImpl({super.key});

  @override
  _AdminProfileViewImplState createState() => _AdminProfileViewImplState();
}

class _AdminProfileViewImplState extends State<AdminProfileViewImpl> implements AdminProfileView {
  late final AdminProfilePresenter presenter;

  String userName = 'Loading...';

  @override
  void initState() {
    super.initState();
    presenter = AdminProfilePresenter(
      model: AdminProfileModel(),
      view: this,
    );
    presenter.fetchUserName();
  }

  @override
  void updateName(String newName) {
    setState(() {
      userName = newName;
    });
  }

  void showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            'Are you sure you want to log out?',
            style: TextStyle(fontSize: 15),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                presenter.logout(context);
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  final List<RowData> rowData = [
    RowData(
      icon: Icons.person,
      text: 'Your Profile',
      destination: MyProfilePage(),
    ),
    RowData(
      icon: Icons.settings,
      text: 'Settings',
      destination: SettingsPage(),
    ),
    RowData(
      icon: Icons.logout,
      text: 'Log Out',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Text(
              'Profile',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Spacer(),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20.0),
            // profile image avatar
            CircleAvatar(
              backgroundColor: Colors.grey[100],
              radius: 50.0,
            ),
            // name
            SizedBox(height: 15.0),
            Text(
              userName,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(height: 25.0),
            // settings
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: rowData.length,
                itemBuilder: (context, index) =>
                    buildRowItem(context, rowData[index]),
                separatorBuilder: (context, index) => SizedBox(height: 5.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // function to build each row
  Widget buildRowItem(BuildContext context, RowData data) {
    return InkWell(
      onTap: () {
        if (data.text == 'Log Out') {
          showLogoutConfirmationDialog(context);
        } else if (data.destination != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => data.destination!),
          );
        }
      },
      child: Container(
        color: Colors.grey[100],
        margin: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Icon(data.icon),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  data.text,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
              Spacer(),
              Icon(Icons.arrow_right),
            ],
          ),
        ),
      ),
    );
  }
}
