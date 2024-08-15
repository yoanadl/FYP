import 'package:flutter/material.dart';
import 'package:food/pages/trainer/models/trainer_profile_model.dart';
import 'package:food/pages/trainer/views/trainer_client_feedback_page.dart';
import 'package:food/pages/trainer/views/trainer_pending_clients.dart';
import 'package:food/pages/trainer/views/trainer_profile_setting_page.dart';
import 'package:intl/intl.dart';


class TrainerMainPage extends StatefulWidget {
  final Function(int) onTabSelected; 

  const TrainerMainPage({Key? key, required this.onTabSelected}) : super(key: key);

  @override
  _TrainerMainPageState createState() => _TrainerMainPageState();
}

class _TrainerMainPageState extends State<TrainerMainPage> {
  String name = '';
  String? profilePictureUrl;

  @override
  void initState() {
    super.initState();
    _fetchTrainerProfileData();
  }

  Future<void> _fetchTrainerProfileData() async {
    TrainerProfile trainerProfile = TrainerProfile();
    await trainerProfile.fetchUserData();
    setState(() {
      name = trainerProfile.name ?? 'Trainer';
      profilePictureUrl = trainerProfile.profilePictureUrl; // Update with Firebase URL
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('EEEE d MMMM').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        toolbarHeight: 120,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(16, 36, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, $name!',
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: profilePictureUrl != null
                          ? NetworkImage(profilePictureUrl!)
                          : AssetImage('lib/images/profile_picture.webp') as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                onPressed: () {
                  widget.onTabSelected(3);
                },
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.only(left: 16.0),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Essentials',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              children: [
                _buildGridTile(context, 'Pending\nRequest', Colors.white, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TrainerPendingClientsPage()),
                  );
                }),
                _buildGridTile(context, 'My\nClient', Color(0xFF508AA8), () {
                  widget.onTabSelected(2);
                }),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildGridTile(BuildContext context, String title, Color color, VoidCallback onTap) {
    bool isSpecialItem = title == "Pending\nRequest";
    bool isSpecialItems = title == "Pending\nRequest" || title == "Meal\nPlan";

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(45.0),
          border: isSpecialItem ? Border.all(color: const Color(0XFF9DD1F1), width: 2.0) : null,
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSpecialItems ? Color(0XFF031927) : Colors.white,
              fontSize: 24,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
