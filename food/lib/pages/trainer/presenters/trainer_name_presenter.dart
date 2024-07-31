import 'package:firebase_auth/firebase_auth.dart';
import 'package:food/services/trainer_settingProfile_service.dart';

abstract class TrainerNameView {
  void navigateToNextPage();
  void showNameError(String message);
}

class TrainerNamePresenter {
  late TrainerNameView _view;

  TrainerNamePresenter(this._view);

  void setName(String name) {
    if (name.isEmpty) {
      _view.showNameError('Name cannot be empty');
      return;
    }

  }

  Future<void> saveProfile(String name) async {

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _view.showNameError('User is not authenticated');
      return;
    }

    print('User ID: ${user.uid}'); // Logging user ID


    try {
      await TrainerSettingProfileService().updateSettingProfile(user.uid, {
        'Name': name,
      });
      print('Profile saved successfully!'); // Add this line to log success
      _view.navigateToNextPage();
    } catch (e) {
      print('Error saving profile: $e');
      _view.showNameError('Failed to save profile. Please try again later.');
    }
  }
}
