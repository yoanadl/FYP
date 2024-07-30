import 'package:food/pages/admin/models/user_account_model.dart';
import 'package:food/pages/admin/views/user_update_view.dart';

class UserUpdatePresenter {
  final UserModel _userModel;
  final UserUpdateView _view;

  UserUpdatePresenter(this._userModel, this._view);

  void loadUser(String userId) async {
    print("Loading user with userId: $userId"); // Debug print
    Map<String, dynamic>? user = await _userModel.fetchUser(userId);
    if (user != null) {
      _view.showUser(user);
    }
    else {
    print("User is null for userId: $userId");
  }
  }

  void saveUser(String userId, Map<String, dynamic> userData) async {
    await _userModel.updateUser(userId, userData);
    _view.onSaveSuccess();
  }

   void deleteUser(String userId) async {
    await _userModel.deleteUser(userId);
    _view.onDeleteSuccess();
  }
}