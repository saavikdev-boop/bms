class UserProfileData {
  String firstName;
  String lastName;
  String dateOfBirth;
  String? gender;
  List<String> interests;
  String? email;
  String? photoURL;

  UserProfileData({
    this.firstName = '',
    this.lastName = '',
    this.dateOfBirth = '',
    this.gender,
    this.interests = const [],
    this.email,
    this.photoURL,
  });

  // Check if profile is complete
  bool get isComplete {
    return firstName.isNotEmpty &&
           lastName.isNotEmpty &&
           dateOfBirth.isNotEmpty &&
           gender != null &&
           interests.isNotEmpty;
  }

  // Convert to map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'interests': interests,
      'email': email,
      'photoURL': photoURL,
    };
  }

  // Create from map (from Firebase)
  factory UserProfileData.fromMap(Map<String, dynamic> map) {
    return UserProfileData(
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      dateOfBirth: map['dateOfBirth'] ?? '',
      gender: map['gender'],
      interests: List<String>.from(map['interests'] ?? []),
      email: map['email'],
      photoURL: map['photoURL'],
    );
  }

  // Copy with new values
  UserProfileData copyWith({
    String? firstName,
    String? lastName,
    String? dateOfBirth,
    String? gender,
    List<String>? interests,
    String? email,
    String? photoURL,
  }) {
    return UserProfileData(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      interests: interests ?? this.interests,
      email: email ?? this.email,
      photoURL: photoURL ?? this.photoURL,
    );
  }

  @override
  String toString() {
    return 'UserProfileData(firstName: $firstName, lastName: $lastName, dateOfBirth: $dateOfBirth, gender: $gender, interests: $interests, email: $email, photoURL: $photoURL)';
  }
}