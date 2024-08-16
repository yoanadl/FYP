import 'package:flutter/material.dart';

class FaqItem {
  final String question;
  final String answer;
  bool isExpanded = false;

  FaqItem({
    required this.question,
    required this.answer,
  });
}

class FaqItemWidget extends StatefulWidget {
  final FaqItem faqItem;
  final VoidCallback onTap;

  const FaqItemWidget({
    required this.faqItem,
    required this.onTap,
  });

  @override
  _FaqItemWidgetState createState() => _FaqItemWidgetState();
}

class _FaqItemWidgetState extends State<FaqItemWidget> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 50),
      height: widget.faqItem.isExpanded ? null : 90.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        color: Color(0xFFC8E0F4).withOpacity(0.4),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(widget.faqItem.question),
            trailing: IconButton(
              icon: Icon(
                widget.faqItem.isExpanded ? Icons.expand_less : Icons.expand_more,
              ),
              onPressed: widget.onTap,
            ),
          ),
          if (widget.faqItem.isExpanded)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(widget.faqItem.answer),
            ),
        ],
      ),
    );
  }
}

class HelpCenterPage extends StatefulWidget {
  @override
  _HelpCenterPageState createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<FaqItem> _faqItems = [
    FaqItem(
      question: 'What is included in the GoodGrit subscription plan?',
      answer: 'The GoodGrit subscription plan provides users with comprehensive access to all the features and services offered by the app. This includes:\n\n'
          'Workout Plans: Customized and varied workout plans designed for different fitness levels and goals.\n'
          'Challenges: Access to exclusive fitness challenges to keep you motivated and track your progress.\n'
          'Personal Coaching: The ability to contact verified trainers for personalized guidance and feedback.\n\n'
          'You can choose between a monthly subscription at 9.9 SGD or a yearly subscription at 109.9 SGD, allowing you to select the plan that best fits your needs and commitment level.',
    ),
    FaqItem(
      question: 'How do the fitness challenges work?',
      answer: 'Fitness challenges in the GoodGrit app are designed to keep you motivated and engaged by setting specific goals and tasks. Here’s how they work:\n\n'
          'Challenge Types: Challenges may vary from daily workouts to weekly goals or longer-term fitness objectives.\n'
          'Participation: You can join any active challenge directly from the app. Some challenges might require you to meet certain criteria or complete specific tasks.\n'
          'Rewards and Recognition: Successful completion of challenges may earn you rewards, badges, or recognition within the app community, helping you stay motivated.\n\n'
          'Each challenge is designed to be inclusive and achievable for various fitness levels, ensuring that everyone can participate and benefit.',
    ),
    FaqItem(
      question: 'Can I cancel my subscription and get a refund?',
      answer: 'Yes, you can cancel your subscription at any time, but please note the following refund policy details:\n\n'
          'Cancellation: You can cancel your subscription through your account settings in the app. Once canceled, your subscription will remain active until the end of the current billing cycle.\n'
          'Refund Eligibility: Refunds are generally not provided. However, exceptions may be made under specific circumstances such as accidental purchases or technical issues. Refunds will only be considered if:\n'
          'The request is made within 7 days of the initial purchase.\n'
          'You have not accessed or used any features or services.\n'
          'The issue is due to a technical problem that GoodGrit could not resolve.\n\n'
          'To request a refund, contact our customer support team with your account details, date of purchase, and reason for the request. If approved, refunds will be processed to your original payment method within 30 days.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Help Center',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
            decoration: BoxDecoration(
              color: Color(0xff031927),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TabBar(
              controller: _tabController,
              labelStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withOpacity(0.7),
              indicator: BoxDecoration(
                color: Colors.transparent, // Remove indicator
              ),
              tabs: [
                Tab(
                  child: SizedBox(
                    width: 210, 
                    child: Container(
                      decoration: BoxDecoration(
                        color: _tabController.index == 0
                            ? Color(0xFF508AA8)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'FAQ',
                          style: TextStyle(
                            color: _tabController.index == 0
                                ? Colors.white
                                : Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: SizedBox(
                    width: 210, 
                    child: Container(
                      decoration: BoxDecoration(
                        color: _tabController.index == 1
                            ? Color(0xFF508AA8)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Contact Us',
                          style: TextStyle(
                            color: _tabController.index == 1
                                ? Colors.white
                                : Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              onTap: (index) {
                setState(() {}); // Trigger a rebuild to update colors
              },
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ListView.builder(
                  itemCount: _faqItems.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        FaqItemWidget(
                          faqItem: _faqItems[index],
                          onTap: () => setState(() => _faqItems[index].isExpanded = !_faqItems[index].isExpanded),
                        ),
                        Divider(
                          height: 20.0,
                          color: Colors.white,
                        ),
                      ],
                    );
                  },
                ),
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 35),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            color: Color(0xFFC8E0F4).withOpacity(0.4),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'If you have any further inquiries, don\'t hesitate \n to contact us through:',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.mail),
                                    SizedBox(width: 16),
                                    Text(
                                      'goodgrit@gmail.com',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.public),
                                    SizedBox(width: 8),
                                    Text(
                                      'https://goodgritworkout.wordpress.com',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
