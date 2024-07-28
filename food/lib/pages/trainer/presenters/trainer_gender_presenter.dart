import 'package:firebase_auth/firebase_auth.dart';
import 'package:food/services/trainer_settingProfile_service.dart';
import 'package:food/pages/trainer/models/trainer_profile_model.dart';

abstract class GenderSelectionView {
  void onProfileSaved();
  void showError(String message);
}

class TrainerGenderPresenter {
  late GenderSelectionView _view;
  final TrainerProfile _profile;

  TrainerGenderPresenter(this._profile);

  void attachView(GenderSelectionView view) {
    _view = view;
  }

  void setGender(String gender) {
    _profile.gender = gender;
  }

  Future<void> saveProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _view.showError('User is not authenticated');
      return;
    }

    if (_profile.gender == null || _profile.gender!.isEmpty) {
      _view.showError('Please select a gender.');
      return;
    }

    try {
      await TrainerSettingProfileService().updateSettingProfile(user.uid, {
        'Gender': _profile.gender,
      });
      _view.onProfileSaved();
    } catch (e) {
      _view.showError('Failed to save gender. Please try again later.');
    }
  }
}
