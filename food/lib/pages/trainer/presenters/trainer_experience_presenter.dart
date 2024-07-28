import 'package:firebase_auth/firebase_auth.dart';
import 'package:food/services/trainer_settingProfile_service.dart';

abstract class TrainerExperienceView {
  void showExperienceError(String message);
  void navigateToNextPage();
}

class TrainerExperiencePresenter {
  final TrainerExperienceView _view;
  String? _experience;

  TrainerExperiencePresenter(this._view);

  void updateExperience(String experience) {
    _experience = experience;
  }

  Future<void> setExperience() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _view.showExperienceError('User is not authenticated');
      return;
    }

    if (_experience == null || _experience!.isEmpty) {
      _view.showExperienceError('Please input your years of experience.');
      return;
    }

    try {
      await TrainerSettingProfileService().updateSettingProfile(user.uid, {
        'Experience': _experience,
      });

      _view.navigateToNextPage();
    } catch (e) {
      _view.showExperienceError('Failed to save experience. Please try again later.');
    }
  }
}
