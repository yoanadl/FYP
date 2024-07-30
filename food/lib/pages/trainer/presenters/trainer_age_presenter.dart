import 'package:firebase_auth/firebase_auth.dart';
import 'package:food/services/trainer_settingProfile_service.dart';


abstract class TrainerAgeView {
  void showAgeError(String message);
  void navigateToNextPage();
}

class TrainerAgePresenter {
  final TrainerAgeView _view;
  String? _age;

  TrainerAgePresenter(this._view);

  void updateAge(String age) {
    _age = age;
  }

  Future<void> setAge() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _view.showAgeError('User is not authenticated');
      return;
    }

    if (_age == null || _age!.isEmpty) {
      _view.showAgeError('Please input your age.');
      return;
    }

    try {
      await TrainerSettingProfileService().updateSettingProfile(user.uid, {
        'Age': _age,
      });

      // Navigate to the next page
      _view.navigateToNextPage();
    } catch (e) {
      _view.showAgeError('Failed to save Age. Please try again later.');
    }
  }
}
