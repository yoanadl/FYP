class TrainerProfile {
  String? name;
  int? age;
  int? experience;
  List<String>? expertise;
  String? profilePictureUrl;

  TrainerProfile({
    this.name,
    this.age,
    this.experience,
    this.expertise,
    this.profilePictureUrl,
  });

  // Factory constructor to create a TrainerProfile instance from a map
  factory TrainerProfile.fromMap(Map<String, dynamic> map) {
    return TrainerProfile(
      name: map['name'] as String?,
      age: map['age'] as int?,
      experience: map['experience'] as int?,
      expertise: (map['expertise'] as List<dynamic>?)?.map((e) => e as String).toList(),
      profilePictureUrl: map['profilePictureUrl'] as String?,
    );
  }

  // Method to convert TrainerProfile instance to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'experience': experience,
      'expertise': expertise,
      'profilePictureUrl': profilePictureUrl,
    };
  }
}

