import 'package:flutter/material.dart';

class MyChallengePage extends StatefulWidget {
  @override
  _MyChallengePageState createState() => _MyChallengePageState();
}

class _MyChallengePageState extends State<MyChallengePage> {
  bool isOngoing = true;
  String sortOption = 'own challenges';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My Challenges',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),),
      ),
      body: Column(
        children: [
          _buildTabs(),
          _buildSearchAndSort(),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.all(16),
              itemCount: 3,
              separatorBuilder: (context, index) => SizedBox(height: 16),
              itemBuilder: (context, index) => _buildChallengeCard(index),
            ),
          ),
        ],
      ),
      
    );
  }

  Widget _buildTabs() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              child: Text(
                'Ongoing',
                style: TextStyle(color: isOngoing ? Colors.white : Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isOngoing ? Colors.black : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () => setState(() => isOngoing = true),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              child: Text(
                'Completed',
                style: TextStyle(color: !isOngoing ? Colors.white : Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: !isOngoing ? Colors.black : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () => setState(() => isOngoing = false),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndSort() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          PopupMenuButton<String>(
            icon: Icon(Icons.sort),
            onSelected: (String result) {
              setState(() {
                sortOption = result;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'own challenges',
                child: Row(
                  children: [
                    Text('own challenges'),
                    if (sortOption == 'own challenges')
                      Icon(Icons.check, color: Colors.blue),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'others',
                child: Row(
                  children: [
                    Text('others'),
                    if (sortOption == 'others')
                      Icon(Icons.check, color: Colors.blue),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeCard(int index) {
    return GestureDetector(
      onTap: () {
        // TODO: Implement navigation to challenge details
        print('Clicked on challenge $index');
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Challenge Title',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              index % 2 == 0 ? 'own challenges' : 'others',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  
}