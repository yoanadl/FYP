
abstract class UserView {
  void showUsers(List<Map<String, dynamic>> users);
  void filterUsers(String query);
}

abstract class AdminProfileView {
  void updateName(String newName);
}
