// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food/components/navbar.dart';
import 'package:food/components/base_page.dart';
import 'package:food/pages/discarded/community_page.dart';
import 'package:food/pages/workout/views/workout_page_view.dart';

class FaqItem {
  final String question;
  final String answer;
  bool isExpanded = false;

  FaqItem(
    {
      required this.question,
      required this.answer,
    }
  );
}

class FaqItemWidget extends StatefulWidget {
  final FaqItem faqItem;
  final VoidCallback onTap;
  
  const FaqItemWidget(
    {
      required this.faqItem,
      required this.onTap,
    }
  );

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


class _HelpCenterPageState extends State<HelpCenterPage> {

  final List<FaqItem> _faqItems = [
    FaqItem(question: 'Question #1', answer: 'Answer to question #1'),
    FaqItem(question: 'Question #2', answer: 'Answer to question #2'),
    FaqItem(question: 'Question #3', answer: 'Answer to question #3'),
    // ... add more FAQ items
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Help Center',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            )),
        ),
      ),

      body: Container(
        color: Colors.white,
        child: DefaultTabController(
          length: 2, // Number of tabs
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(50),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xff031927),
                ),
                child: TabBar(
                  labelStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white,
                  tabs: [
                    Tab(
                      text: 'FAQ',
                    ),
                    Tab(text: 'Contact Us'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // FAQ tab content
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
                          )
                        ],
                      );

                    },
                  ),


                    // contact us tab
                    SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 35,),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 450,
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
                                      'If you have any further inquiries, don\'t hesitate \n to contact us through: ',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.mail),
                                        SizedBox(width: 8,),
                                        Text(
                                          'goodgrit@gmail.com',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            decoration: TextDecoration.underline,
                                          ),
                                        )
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
                                            fontSize: 16,
                                            color: Colors.black,
                                            decoration: TextDecoration.underline,
                                          ),
                                        )
                                      ],
                                    )
                        
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
        ),
      ),

      bottomNavigationBar: Navbar(
        currentIndex: 3,
        onTap: (int index) {
          if (index != 3) {
            Navigator.pop(context);
            switch (index) {
              case 0:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const BasePage(initialIndex: 0,)));
                break;
              case 1:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const BasePage(initialIndex: 1,)));
                break;
              case 2:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const BasePage(initialIndex: 2,)));
                break;
            }
          }
        },
      ),
    );
  }


}




