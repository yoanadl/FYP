import 'package:firebase_auth/firebase_auth.dart';
import 'package:food/services/setting_trainer_profile_service.dart';

abstract class TrainerExpertiseView {
  void onExpertiseSaved();
  void showError(String message);
}

class TrainerExpertisePresenter {
  late TrainerExpertiseView _view;

  TrainerExpertisePresenter(this._view);

  Future<void> saveExpertise(List<String> expertise) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _view.showError('User is not authenticated');
      return;
    }

    if (expertise.isEmpty) {
      _view.showError('Please select at least one area of expertise.');
      return;
    }

    try {
      await TrainerSettingProfileService().updateSettingProfile(user.uid, {
        'expertise': expertise,
      });
      _view.onExpertiseSaved();
    } catch (e) {
      _view.showError('Failed to save expertise. Please try again later.');
    }
  }
}
