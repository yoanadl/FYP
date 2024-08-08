import 'package:food/pages/admin/models/admin_profile_model.dart';
import 'package:food/pages/admin/models/user_account_model.dart';
import 'package:food/pages/admin/models/user_profile.dart'; 

class AdminViewUserProfilesViewInterface {
  void updateUserProfileList(List<UserProfile> profiles) {}
  void showError(String error) {}
}

class AdminViewUserProfilesPresenter {
  final AdminViewUserProfilesViewInterface view;
  final UserModel userModel;
  final AdminProfileModel adminProfileModel;

  AdminViewUserProfilesPresenter(this.view, this.userModel, this.adminProfileModel);

  void fetchUserProfiles() async {
    try {
      var users = await userModel.fetchUsers();
      var profiles = users.map((data) => UserProfile.fromMap(data)).toList();
      view.updateUserProfileList(profiles);
    } catch (e) {
      view.showError(e.toString());
    }
  }

  void searchUserProfiles(String query, List<UserProfile> profiles) {
    var filteredProfiles = profiles
        .where((profile) => profile.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    view.updateUserProfileList(filteredProfiles);
  }
}
