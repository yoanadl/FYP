import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:food/components/navbar.dart';
import 'package:food/pages/premium_user/card_details_page.dart';
import 'package:food/pages/base_page.dart';
import 'package:food/pages/community_page.dart';
import 'package:food/pages/home_page.dart';
import 'package:food/pages/workout/workout_page.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class PaymentMethodPage extends StatelessWidget {
  const PaymentMethodPage({Key? key}) : super(key: key);

  Future<void> initPayment({
  required String email,
  required double amount,
  required BuildContext context,
}) async {
  try {
    final response = await http.post(
      Uri.parse(
          'https://us-central1-fyp-goodgrit-a8601.cloudfunctions.net/stripePaymentIntentRequest'),
      body: {
        'email': email,
        'amount': amount.toString(),
      },
    );

    // Log the raw response for debugging
    log('Response status: ${response.statusCode}');
    log('Response body: ${response.body}');

    // Check if the response is successful
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      log('JSON Response: $jsonResponse');

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: jsonResponse['paymentIntent'],
          merchantDisplayName: 'GoodGrit',
          customerId: jsonResponse['customer'],
          customerEphemeralKeySecret: jsonResponse['ephemeralKey'],
        ),
      );
      await Stripe.instance.presentPaymentSheet();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment is successful'),
        ),
      );
    } else {
      // Handle non-200 status codes
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Server error: ${response.statusCode} ${response.reasonPhrase}'),
        ),
      );
    }
  } catch (error) {
    if (error is FormatException) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Format Exception: $error'),
        ),
      );
    } else if (error is StripeException) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Stripe error: ${error.error.localizedMessage}'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $error'),
        ),
      );
    }
  }
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
                  await initPayment(
                      amount: 990.0, context: context, email: 'demo@test.com');
                    
                  Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => HomePage()));
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
                leading: Icon(Icons.account_balance_wallet),
                title: Text('Paypal'),
                onTap: () {
                  // Handle Paypal selection
                },
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
                leading: Icon(Icons.apple),
                title: Text('Apple Pay'),
                onTap: () {
                  // Handle Apple Pay selection
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Navbar(
        currentIndex: 3,
        onTap: (int index) {
          if (index != 3) {
            Navigator.pop(context);
            switch (index) {
              case 0:
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const BasePage()));
                break;
              case 1:
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const WorkoutPage()));
                break;
              case 2:
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const CommunityPage()));
                break;
            }
          }
        },
      ),
    );
  }
}
