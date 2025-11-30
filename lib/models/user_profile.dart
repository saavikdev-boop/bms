/// User Profile Model
/// Matches backend PostgreSQL schema for users table
class UserProfile {
  final String uid;
  final String? email;
  final String? phoneNumber;
  final String? displayName;
  final String? photoUrl;
  final String? name;
  final int? age;
  final String? gender;
  final List<String>? sports;
  final List<String>? interests;
  final String? authProvider;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.uid,
    this.email,
    this.phoneNumber,
    this.displayName,
    this.photoUrl,
    this.name,
    this.age,
    this.gender,
    this.sports,
    this.interests,
    this.authProvider,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create from JSON (from API response)
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      uid: json['uid'] as String,
      email: json['email'] as String?,
      phoneNumber: json['phone_number'] as String?,
      displayName: json['display_name'] as String?,
      photoUrl: json['photo_url'] as String?,
      name: json['name'] as String?,
      age: json['age'] as int?,
      gender: json['gender'] as String?,
      sports: json['sports'] != null ? List<String>.from(json['sports']) : null,
      interests: json['interests'] != null ? List<String>.from(json['interests']) : null,
      authProvider: json['auth_provider'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Convert to JSON (for API requests)
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      if (email != null) 'email': email,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (displayName != null) 'display_name': displayName,
      if (photoUrl != null) 'photo_url': photoUrl,
      if (name != null) 'name': name,
      if (age != null) 'age': age,
      if (gender != null) 'gender': gender,
      if (sports != null) 'sports': sports,
      if (interests != null) 'interests': interests,
      if (authProvider != null) 'auth_provider': authProvider,
    };
  }

  /// Copy with new values
  UserProfile copyWith({
    String? email,
    String? phoneNumber,
    String? displayName,
    String? photoUrl,
    String? name,
    int? age,
    String? gender,
    List<String>? sports,
    List<String>? interests,
    String? authProvider,
  }) {
    return UserProfile(
      uid: uid,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      sports: sports ?? this.sports,
      interests: interests ?? this.interests,
      authProvider: authProvider ?? this.authProvider,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  /// Get display name or fallback
  String get displayNameOrFallback {
    if (displayName != null && displayName!.isNotEmpty) return displayName!;
    if (name != null && name!.isNotEmpty) return name!;
    if (email != null) return email!.split('@')[0];
    if (phoneNumber != null) return phoneNumber!;
    return 'User';
  }

  /// Check if profile is complete
  bool get isProfileComplete {
    return name != null &&
           age != null &&
           gender != null &&
           (sports != null && sports!.isNotEmpty) &&
           (interests != null && interests!.isNotEmpty);
  }

  /// Get auth provider display name
  String get authProviderDisplay {
    switch (authProvider) {
      case 'google':
        return 'Google';
      case 'phone':
        return 'Phone';
      case 'email':
        return 'Email';
      default:
        return 'Unknown';
    }
  }

  @override
  String toString() {
    return 'UserProfile(uid: $uid, email: $email, phone: $phoneNumber, name: $name, provider: $authProvider)';
  }
}
