import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'bms_screen_04_gender.dart';
import '../services/onboarding_data.dart';

class BmsScreen03Profile extends StatefulWidget {
  const BmsScreen03Profile({super.key});

  @override
  State<BmsScreen03Profile> createState() => _BmsScreen03ProfileState();
}

class _BmsScreen03ProfileState extends State<BmsScreen03Profile> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          _profileImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Choose Profile Picture',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Color(0xFF94EA01)),
                title: const Text('Gallery', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFF94EA01)),
                title: const Text('Camera', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromCamera();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          _profileImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to take photo: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF94EA01),
              onPrimary: Colors.black,
              surface: Color(0xFF1E1E1E),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF1E1E1E),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dobController.text = '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  void _validateAndContinue() {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final dob = _dobController.text.trim();

    // Validation checks
    if (firstName.isEmpty) {
      _showErrorSnackBar('Please enter your first name');
      return;
    }

    if (firstName.length < 2) {
      _showErrorSnackBar('First name must be at least 2 characters');
      return;
    }

    if (lastName.isEmpty) {
      _showErrorSnackBar('Please enter your last name');
      return;
    }

    if (lastName.length < 2) {
      _showErrorSnackBar('Last name must be at least 2 characters');
      return;
    }

    if (dob.isEmpty) {
      _showErrorSnackBar('Please select your date of birth');
      return;
    }

    // Validate age (must be at least 13 years old)
    try {
      final parts = dob.split('/');
      if (parts.length == 3) {
        final birthYear = int.parse(parts[2]);
        final currentYear = DateTime.now().year;
        final age = currentYear - birthYear;

        if (age < 13) {
          _showErrorSnackBar('You must be at least 13 years old to use this app');
          return;
        }

        if (age > 120) {
          _showErrorSnackBar('Please enter a valid date of birth');
          return;
        }
      }
    } catch (e) {
      _showErrorSnackBar('Invalid date of birth format');
      return;
    }

    // Save to OnboardingData
    final onboardingData = OnboardingData();
    onboardingData.firstName = firstName;
    onboardingData.lastName = lastName;
    onboardingData.dateOfBirth = dob;

    // All validation passed, continue to next screen
    HapticFeedback.mediumImpact();
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const BmsScreen04Gender(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF151515),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image.asset(
                'assets/images/screens/starting screens background.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF000000),
                          Color(0xFF0A0A0A),
                          Color(0xFF1A1F1A),
                          Color(0xFF2A3A2A),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Dark overlay for better text readability
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.5),
                    ],
                  ),
                ),
              ),
            ),
            
            SafeArea(
              child: Column(
                children: [
                  // Header with back button and status bar
                  _buildHeader(),
                  
                  // Main content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          
                          // Main heading
                          const Text(
                            'Tell me some details please?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              height: 1.25,
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Subtitle
                          const Opacity(
                            opacity: 0.70,
                            child: Text(
                              'This help your friend to, find your rockit account',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 40),
                          
                          // Profile picture
                          Center(
                            child: GestureDetector(
                              onTap: _showImageSourceDialog,
                              child: Container(
                                width: 130,
                                height: 130,
                                decoration: ShapeDecoration(
                                  color: const Color(0xFFF9FAFB),
                                  shape: OvalBorder(
                                    side: BorderSide(
                                      width: 1.04,
                                      color: _profileImage != null 
                                        ? const Color(0xFF94EA01) 
                                        : const Color(0xFFE5E6EB),
                                    ),
                                  ),
                                ),
                                child: _profileImage != null
                                    ? ClipOval(
                                        child: Image.file(
                                          _profileImage!,
                                          fit: BoxFit.cover,
                                          width: 130,
                                          height: 130,
                                        ),
                                      )
                                    : const Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add_a_photo,
                                            color: Color(0xFF9EA3AE),
                                            size: 32,
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Add Photo',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xFF9EA3AE),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 40),
                          
                          // Name fields row
                          Row(
                            children: [
                              // First name field
                              Expanded(
                                child: _buildInputField(
                                  label: 'FIRST NAME',
                                  controller: _firstNameController,
                                  hintText: 'Enter first name',
                                ),
                              ),
                              
                              const SizedBox(width: 15),
                              
                              // Last name field
                              Expanded(
                                child: _buildInputField(
                                  label: 'LAST NAME',
                                  controller: _lastNameController,
                                  hintText: 'Enter last name',
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 20),
                          
                          // Date of birth field
                          _buildInputField(
                            label: 'DATE OF BIRTH',
                            controller: _dobController,
                            hintText: 'Select date',
                            hasIcon: true,
                            readOnly: true,
                            onTap: _selectDate,
                          ),
                          
                          const SizedBox(height: 40),
                          
                          // Continue button
                          SizedBox(
                            width: double.infinity,
                            height: 58,
                            child: ElevatedButton(
                              onPressed: _validateAndContinue,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFA1FF00),
                                foregroundColor: Colors.black,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Continue',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 104.02,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        children: [
          // Status bar removed

          // Back button
          Positioned(
            left: 4,
            top: 62.41,
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                if (Navigator.canPop(context)) {
                  Navigator.of(context).pop();
                }
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: ShapeDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.48),
                  ),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    String? hintText,
    bool hasIcon = false,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: readOnly ? onTap : null,
      child: Container(
        height: 58,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          border: Border.all(
            width: 1,
            color: Colors.white.withOpacity(0.2),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                readOnly: readOnly,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  height: 1.2,
                ),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.3),
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                maxLines: 1,
              ),
            ),
            if (hasIcon)
              Icon(
                Icons.calendar_today,
                color: Colors.white.withOpacity(0.4),
                size: 18,
              ),
          ],
        ),
      ),
    );
  }
}
