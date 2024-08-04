import 'package:flutter/material.dart';
import 'package:food/pages/trainer/trainer_main_page.dart';
import 'package:food/pages/trainer/trainer_my_client_page.dart';
import 'package:food/pages/trainer/trainer_profile_page.dart';
import 'package:food/pages/trainer/trainer_workout_plan_page.dart';
import 'package:food/pages/trainer/trainer_pending_clients.dart'; // Assuming this page exists
import 'package:food/components/trainer_navbar.dart';

class TrainerBasePage extends StatefulWidget {
  final int initialIndex;
  const TrainerBasePage({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<TrainerBasePage> createState() => _TrainerBasePageState();
}

class _TrainerBasePageState extends State<TrainerBasePage> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;

    _pages = [
      TrainerMainPage(onTabSelected: _onTabSelected),
      TrainerWorkoutPlanPage(),
      TrainerMyClientPage(),
      TrainerProfilePage(),
      TrainerPendingClientsPage(), // Assuming this is the correct page for pending requests
    ];
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex < _pages.length ? _pages[_selectedIndex] : SizedBox(),
      bottomNavigationBar: TrainerNavbar(
        currentIndex: _selectedIndex,
        onTap: _onTabSelected,
      ),
    );
  }
}
