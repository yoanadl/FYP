
class UserProfile {
  final String name;
  final String role;
  final String permission;
  final String description;

  UserProfile({
    required this.name,
    required this.role,
    required this.permission,
    this.description= '',
    
  });

   // Factory constructor to create UserProfile from a map
  factory UserProfile.fromMap(Map<String, dynamic> data) {
    return UserProfile(
      name: data['name'] ?? '',
      role: data['role'] ?? '',
      permission: data['permission'] ?? '',
      description: data['description'] ?? '',
    );
  }
  
}

class UserProfileList{
  final List<UserProfile> profiles = [
    UserProfile(name: 'System Admin', role: 'Admin', permission: "Permission A"),
    UserProfile(name: 'Free User', role: 'User', permission: "Permission A"),
    UserProfile(name: 'Premium User', role: 'PremiumUser', permission: "Permission A"),
    UserProfile(name: 'Trainer', role: 'Trainer', permission: "Permission A"),
  ];
}
