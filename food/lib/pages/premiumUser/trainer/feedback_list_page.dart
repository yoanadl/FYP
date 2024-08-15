import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedbackListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back, color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Feedbacks',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildSearchBox('Search Feedbacks..'),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildFeedbackItem('Feedback #1'),
                  _buildFeedbackItem('Feedback #2'),
                  _buildFeedbackItem('Feedback #3'),
                  _buildFeedbackItem('Feedback #4'),
                  _buildFeedbackItem('Feedback #5'),
                  _buildFeedbackItem('Feedback #6'),
                  _buildFeedbackItem('Feedback #7'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox(String hintText) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(Icons.search),
        filled: true,
        fillColor: Colors.blue[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildFeedbackItem(String feedback) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[300],
      ),
      title: Text(feedback),
    );
  }
}
