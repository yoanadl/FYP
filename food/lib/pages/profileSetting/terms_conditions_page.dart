import 'package:flutter/material.dart';

class TermsConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Terms & Conditions',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '1. Acceptance of Terms',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'By downloading, installing, or using the GoodGrit application ("App"), you ("User") agree to be bound by these Terms and Conditions ("Terms"). If you do not agree to these Terms, do not use the App.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '2. Eligibility',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'To use the App, you must be at least 16 years old and capable of entering into a legally binding agreement. By using the App, you represent and warrant that you meet these requirements.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '3. Description of Services',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'GoodGrit provides a platform for users to access various workout plans, track their progress, and participate in fitness challenges. Additional services may include personal coaching, dietary advice, etc.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '4. Health and Safety Disclaimer',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '4.1. General Health\nUsers should consult with a healthcare professional before starting any exercise program, especially if they have any medical conditions, are pregnant, or have not exercised in a long time. GoodGrit is not responsible for any health issues that may arise from using the App.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '4.2. Physical Limitations\nThe App’s workouts are designed for individuals of varying fitness levels. Users should respect their physical limitations and avoid activities that cause pain or discomfort. GoodGrit is not liable for any injuries or health issues resulting from the use of the App.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '5. User Account',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '5.1. Account Registration\nTo access certain features of the App, Users may need to create an account by providing a valid email address and creating a password. Users agree to provide accurate and complete information during registration.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '5.2. Account Security\nUsers are responsible for maintaining the confidentiality of their account login information and for all activities that occur under their account. GoodGrit is not liable for any unauthorized access to your account.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '6. Subscription and Payment',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '6.1. Subscription Plans\nUsers can subscribe to GoodGrit on a monthly or yearly basis. The monthly subscription is priced at 9.9 SGD per month, while the yearly subscription is available for 109.9 SGD. By subscribing, users gain full access to all workout plans and meal plans, the ability to contact verified trainers, and receive personalized feedback and plans tailored to their fitness goals. Subscription plans provide users with a comprehensive experience, enabling them to maximize their workout routines and dietary habits through the app.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '6.2. Payment Method\nUsers may purchase subscriptions through Credit Card, Debit Card, PayPal, Apple Pay. By providing payment information, Users agree to pay the subscription fees and authorize GoodGrit to charge the payment method.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '6.3. Refund Policy\n6.3.1. General Refund Conditions\nAll subscriptions to GoodGrit are generally non-refundable. However, we may provide a refund under specific circumstances at our sole discretion, such as accidental purchases, technical issues preventing access to the service, or unauthorized transactions.\n6.3.2. Eligibility for Refunds\nRefunds will only be considered if:\n- The request is made within 7 days of the initial purchase.\n- The user has not accessed or used any features or services offered as part of the subscription.\n- The request is due to a technical issue that GoodGrit is unable to resolve.\n6.3.3. Non-Refundable Situations\nRefunds will not be provided in the following situations:\n- Users who have fully or partially used their subscription.\n- Users who have cancelled their subscription after the billing cycle has started.\n- Any issues or dissatisfaction related to the user’s fitness results or expectations from the workouts or meal plans.\n6.3.4. Requesting a Refund\nTo request a refund, users must:\n1. Contact our customer support team with the following details:\n   - User\'s full name and account details.\n   - Date of purchase.\n   - Reason for the refund request.\n2. Provide any additional information or documentation requested by our support team to evaluate the request.\n6.3.5. Refund Process\nOnce a refund request is received, our support team will review the request and respond within 7 business days. If the request is approved, the refund will be processed and credited back to the original payment method within 30 days.\n6.3.6. Changes to Refund Policy\nGoodGrit reserves the right to modify or update this refund policy at any time. Users will be notified of any changes by posting the new policy on this page. Continued use of the App after any changes constitutes acceptance of the new policy.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '7. User Conduct',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '7.1. Prohibited Activities\nUsers agree not to engage in any of the following activities:\n- Using the App for any illegal or unauthorized purpose.\n- Harassing, abusing, or threatening other users.\n- Uploading viruses or malicious code.\n- Interfering with the operation of the App or other users\' enjoyment of the App.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '7.2. Content Ownership\nUsers retain ownership of any content they submit to the App but grant GoodGrit a worldwide, non-exclusive, royalty-free license to use, reproduce, modify, and distribute such content.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '8. Intellectual Property',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'All content, features, and functionality of the App, including text, graphics, logos, and software, are the exclusive property of GoodGrit and are protected by copyright, trademark, and other laws. Users agree not to copy, modify, or distribute any part of the App without prior written consent from GoodGrit.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '9. Third-Party Links',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'The App may contain links to third-party websites or services that are not owned or controlled by GoodGrit. GoodGrit is not responsible for the content, privacy policies, or practices of any third-party websites or services.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '10. Termination',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'GoodGrit reserves the right to suspend or terminate a User\'s access to the App at any time for any reason, including but not limited to a violation of these Terms.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '11. Limitation of Liability',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'To the fullest extent permitted by law, GoodGrit shall not be liable for any indirect, incidental, special, consequential, or punitive damages, including but not limited to loss of profits, data, or use, arising out of or in connection with the use or inability to use the App.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '12. Indemnification',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Users agree to indemnify and hold harmless GoodGrit, its affiliates, and their respective officers, directors, employees, and agents from and against any claims, liabilities, damages, judgments, awards, losses, costs, or expenses arising out of or relating to their use of the App or violation of these Terms.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '13. Governing Law',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'These Terms and any disputes arising out of or relating to these Terms or the use of the App shall be governed by and construed in accordance with the laws of Singapore, without regard to its conflict of law provisions.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              '14. Changes to Terms',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'GoodGrit reserves the right to modify or update these Terms at any time. Users will be notified of any changes by posting the new Terms on this page. Continued use of the App after any such changes constitutes acceptance of the new Terms.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
