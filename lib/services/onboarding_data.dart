import '../services/user_service.dart';

class OnboardingData {
  static final OnboardingData _instance = OnboardingData._internal();
  factory OnboardingData() => _instance;
  OnboardingData._internal();

  // User data collected during onboarding
  String firstName = '';
  String lastName = '';
  String dateOfBirth = '';
  String? gender;
  List<String> interests = [];
  String? email;
  String? photoURL;

  // Clear all data
  void clear() {
    firstName = '';
    lastName = '';
    dateOfBirth = '';
    gender = null;
    interests = [];
    email = null;
    photoURL = null;
  }

  // Check if all required data is collected
  bool get isComplete {
    return firstName.isNotEmpty &&
           lastName.isNotEmpty &&
           dateOfBirth.isNotEmpty &&
           gender != null &&
           interests.isNotEmpty;
  }

  // Save all collected data to Firebase
  Future<bool> saveToFirebase() async {
    if (!isComplete) {
      print('Onboarding data is incomplete');
      return false;
    }

    final userService = UserService();

    try {
      final success = await userService.saveUserProfile(
        firstName: firstName,
        lastName: lastName,
        dateOfBirth: dateOfBirth,
        gender: gender!,
        interests: interests,
      );

      if (success) {
        print('Onboarding data saved to Firebase successfully');
        // Optionally clear data after successful save
        // clear();
        return true;
      } else {
        print('Failed to save onboarding data to Firebase');
        return false;
      }
    } catch (e) {
      print('Error saving onboarding data: $e');
      return false;
    }
  }

  // Debug method to print current data
  void printData() {
    print('OnboardingData:');
    print('  firstName: $firstName');
    print('  lastName: $lastName');
    print('  dateOfBirth: $dateOfBirth');
    print('  gender: $gender');
    print('  interests: $interests');
    print('  email: $email');
    print('  photoURL: $photoURL');
    print('  isComplete: $isComplete');
  }
}