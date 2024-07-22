// lib/presenters/user_presenter.dart
import 'package:food/pages/admin/models/user_account_model.dart';
import 'package:food/pages/admin/views/user_view.dart';

class UserPresenter {
  final UserModel _userModel;
  final UserView _view;

  UserPresenter(this._userModel, this._view);

  void loadUsers() async {
    List<Map<String, dynamic>> users = await _userModel.fetchUsers();
    _view.showUsers(users);
  }

  void filterUsers(String query) {
    _view.filterUsers(query);
  }

  void deleteUser(String userId) async {
    await _userModel.deleteUser(userId);
    loadUsers();
  }
}
