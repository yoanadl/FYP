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
        var trainerProfilesSnapshot = await userDoc.reference.collection('TrainerProfile').get();

        for (var trainerProfileDoc in trainerProfilesSnapshot.docs) {
          var data = trainerProfileDoc.data() as Map<String, dynamic>;

          String profilePictureUrl = data['profilePictureUrl'] ?? 'https://via.placeholder.com/150';
          String name = data['name'] ?? 'No Name';
          List<dynamic> expertise = data['expertise'] ?? [];
          String age = data['age'] ?? 'No Age';
          String experience = data['experience'] ?? 'No Experience';

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
