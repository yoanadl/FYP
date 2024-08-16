import 'package:firebase_auth/firebase_auth.dart';
import 'package:food/services/auth/auth_service.dart';

class TrainerRegisterPresenter {
  final AuthService _authService = AuthService();
  late TrainerRegisterView _view;

  void attachView(TrainerRegisterView view) {
    _view = view;
  }

  void registerTrainer(String email, String password, String confirmPassword) async {
    if (password != confirmPassword) {
      _view.showError("Passwords don't match!");
      return;
    }

    try {
      UserCredential userCredential = await _authService.registerTrainer(email, password);
      _view.onRegisterSuccess(userCredential);
    } catch (e) {
      _view.showError(e.toString());
    }
  }
}

abstract class TrainerRegisterView {
  void showError(String message);
  void onRegisterSuccess(UserCredential userCredential);
}
