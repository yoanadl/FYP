
class UserProfile {
  final String id;
  final String name;
  final String email;
  final String gender;
  final int height; // Height in centimeters
  final double weight; // Weight in kilograms
  final int age;
  final List<String> goals; // List of goals

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.gender,
    required this.height,
    required this.weight,
    required this.age,
    required this.goals,
  });

  // Factory method to create a UserProfile from JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      gender: json['gender'] as String,
      height: json['height'] as int,
      weight: (json['weight'] as num).toDouble(),
      age: json['age'] as int,
      goals: List<String>.from(json['goals'] as List),
    );
  }

  // Method to convert a UserProfile to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'gender': gender,
      'height': height,
      'weight': weight,
      'age': age,
      'goals': goals,
    };
  }
}
