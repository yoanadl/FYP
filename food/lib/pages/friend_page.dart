import 'package:flutter/material.dart';

class FriendListPage extends StatefulWidget {
  @override
  _FriendListPageState createState() => _FriendListPageState();
}

class _FriendListPageState extends State<FriendListPage> {
  int selectedIndex = 0;
  int _selectedNavIndex = 2; // Set Community as the default selected index
  List<String> friends = ["Friend friend #1", "Friend friend #2", "Friend friend #3"];
  List<String> friendRequests = ["Friend friend msfks", "Friend friend msfks", "Friend friend msfks"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Friends"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = 0;
                    });
                  },
                  child: Container(
                    color: selectedIndex == 0 ? Colors.grey : Colors.white,
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "My Friend",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = 1;
                    });
                  },
                  child: Container(
                    color: selectedIndex == 1 ? Colors.grey : Colors.white,
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "Friend Request",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search ID/Username...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: selectedIndex == 0 ? buildFriendList() : buildFriendRequestList(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workout',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedNavIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedNavIndex = index;
            // Handle navigation to different pages if needed
          });
        },
      ),
    );
  }

  Widget buildFriendList() {
    return ListView.builder(
      itemCount: friends.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(friends[index]),
          trailing: PopupMenuButton<String>(
            onSelected: (String result) {
              if (result == 'view') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              } else if (result == 'delete') {
                _showDeleteConfirmationDialog(index);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'view',
                child: Text('View friend'),
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('Delete friend'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildFriendRequestList() {
    return ListView.builder(
      itemCount: friendRequests.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(friendRequests[index]),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  _showAcceptConfirmationDialog(index);
                },
              ),
              IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  _showRejectConfirmationDialog(index);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text("Are you sure you want to delete this friend?"),
          actions: [
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                setState(() {
                  friends.removeAt(index);
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAcceptConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text("Are you sure you want to accept this request?"),
          actions: [
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                setState(() {
                  friends.add(friendRequests[index]);
                  friendRequests.removeAt(index);
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showRejectConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text("Are you sure you want to reject this request?"),
          actions: [
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                setState(() {
                  friendRequests.removeAt(index);
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
            ),
            SizedBox(height: 16),
            Text("Member#1kwehfiueheihs ihfesalefkhskjslmdfjkl"),
            SizedBox(height: 16),
            Text("Joined on: 10.05.2024"),
            SizedBox(height: 16),
            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _showUnfriendConfirmationDialog(context);
              },
              child: Text("Unfriend"),
            ),
          ],
        ),
      ),
    );
  }

  void _showUnfriendConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text("Are you sure you want to unfriend this account?"),
          actions: [
            TextButton(
              child: Text("Yes"),
              onPressed: () {
                // Perform unfriend action
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}