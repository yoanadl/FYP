import 'package:cloud_firestore/cloud_firestore.dart';

class TrainerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getTrainers() {
    return _firestore
        .collection('users')
        .where('role', isEqualTo: 'trainer')
        .snapshots()
        .asyncMap((snapshot) async {
      List<Map<String, dynamic>> trainers = [];

      for (var userDoc in snapshot.docs) {
        // Get the trainer profile documents
        var trainerProfilesSnapshot = await userDoc.reference.collection('TrainerProfile').get();

        for (var trainerProfileDoc in trainerProfilesSnapshot.docs) {
          var data = trainerProfileDoc.data() as Map<String, dynamic>;

          // Fetch the profile picture URL from the main `users` collection
          String? profilePictureUrl = userDoc.data()['profilePictureUrl'] as String?;



          String name = data['Name'] ?? 'No Name';
          List<dynamic> expertise = data['Expertise'] ?? [];
          String age = data['Age'] ?? 'No Age';
          String experience = data['Experience'] ?? 'No Experience';

          // Add user document ID and TrainerProfile document ID
          trainers.add({
            'userId': userDoc.id, // Document ID from the users collection
            'profilePictureUrl': profilePictureUrl,
            'name': name,
            'expertise': expertise,
            'age': age,
            'experience': experience,
            'profileId': trainerProfileDoc.id // Document ID from the TrainerProfile sub-collection
          });
        }
      }
      return trainers;
    }).handleError((error) {
      print('Error retrieving trainers: $error');
      return [];
    });
  }
}
