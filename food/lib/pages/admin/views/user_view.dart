// lib/views/user_view.dart
abstract class UserView {
  void showUsers(List<Map<String, dynamic>> users);
  void filterUsers(String query);
}
