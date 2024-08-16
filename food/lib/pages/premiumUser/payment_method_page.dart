import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:food/components/base_page.dart';
import 'package:food/components/navbar.dart';
import 'package:food/pages/user/view/home_page.dart';
import 'package:food/pages/workout/views/workout_page_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class PaymentMethodPage extends StatelessWidget {
  PaymentMethodPage({Key? key}) : super(key: key);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> initPayment(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    String email = user?.email ?? 'demo@test.com'; // Default email if user is null

    try {
      // Fetch the payment sheet parameters from your server
      final response = await http.post(
        Uri.parse('https://us-central1-fyp-goodgrit-a8601.cloudfunctions.net/stripePaymentIntentRequest'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'priceId': 'price_1PmiRYGwNxjo4qONcll1wDVs', // Your price ID
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to initialize payment sheet: ${response.body}');
      }

      final paymentSheetData = jsonDecode(response.body);

      // Initialize the Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentSheetData['paymentIntent'],
          merchantDisplayName: 'GoodGrit',
          customerId: paymentSheetData['customer'],
          customerEphemeralKeySecret: paymentSheetData['ephemeralKey'],
          style: ThemeMode.light,
          billingDetails: BillingDetails(
            email: email,
            // Add other billing details here if required
          ),
        ),
      );

      // Present the Payment Sheet
      await Stripe.instance.presentPaymentSheet();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment is successful and subscription created!'),
        ),
      );

       // Update the user's role after successful payment
      if (user != null) {
        await updateUserRole(user.uid);
      }
      
      // Navigate to home page or any other page after successful payment
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BasePage()),
      );

    } catch (error) {
      if (error is StripeException) {
        log('Stripe error: ${error.error.localizedMessage}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Stripe error: ${error.error.localizedMessage}'),
          ),
        );
      } else {
        log('An error occurred: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: $error'),
          ),
        );
      }
    }
  }

  Future<void> updateUserRole(String userId) async {
    // Reference to the document within the users collection
    DocumentReference userDocRef = FirebaseFirestore.instance
        .collection('users') // Main collection
        .doc(userId); // Specific user document

    // Update the 'role' field
    await userDocRef.update({
      'role': 'premium user', // Update the role field to 'premium user'
    }).then((_) {
      print("User role updated successfully!");
    }).catchError((error) {
      print("Failed to update user role: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Method',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Credit & Debit Card',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: ListTile(
                leading: Icon(Icons.credit_card),
                title: Text('Add new card'),
                onTap: () async {
                  await initPayment(context);
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'More Options',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Center(
            child: Text(
              'Coming Soon....',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }
}
