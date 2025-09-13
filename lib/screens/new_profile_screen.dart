import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'bms_screen_04_gender.dart';
import '../services/onboarding_data.dart';

class NewProfileScreen extends StatefulWidget {
  const NewProfileScreen({super.key});

  @override
  State<NewProfileScreen> createState() => _NewProfileScreenState();
}

class _NewProfileScreenState extends State<NewProfileScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final TextEditingController _firstNameController = TextEditingController(text: 'Oscar');
  final TextEditingController _lastNameController = TextEditingController(text: 'Sun');
  final TextEditingController _dobController = TextEditingController(text: '09/10/1998');

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

  void _continue() {
    HapticFeedback.mediumImpact();

    // Save profile data to shared state
    final onboardingData = OnboardingData();
    onboardingData.firstName = _firstNameController.text.trim();
    onboardingData.lastName = _lastNameController.text.trim();
    onboardingData.dateOfBirth = _dobController.text.trim();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const BmsScreen04Gender(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF151515),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          width: 390,
          height: 844,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(color: Color(0xFF151515)),
          child: Stack(
            children: [
              // Background circle
              Positioned(
                left: -126,
                top: -95,
                child: Opacity(
                  opacity: 0.08,
                  child: Container(
                    width: 282.94,
                    height: 282.94,
                    decoration: ShapeDecoration(
                      color: const Color(0xFF94EA01),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(141.47),
                      ),
                    ),
                  ),
                ),
              ),

              // Status bar
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 390,
                  height: 104.02,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(),
                  child: Stack(
                    children: [
                      // Back button
                      Positioned(
                        left: 24.97,
                        top: 62.41,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.48),
                              ),
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),

                      // Status bar content
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 390.09,
                          height: 45.77,
                          child: Stack(
                            children: [
                              // Battery
                              Positioned(
                                left: 349.43,
                                top: 18.03,
                                child: Opacity(
                                  opacity: 0.35,
                                  child: Container(
                                    width: 22.89,
                                    height: 11.79,
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(width: 1.04, color: Colors.white),
                                        borderRadius: BorderRadius.circular(2.77),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 351.51,
                                top: 20.11,
                                child: Container(
                                  width: 18.72,
                                  height: 7.63,
                                  decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(1.39),
                                    ),
                                  ),
                                ),
                              ),

                              // Time
                              Positioned(
                                left: 21.84,
                                top: 13.52,
                                child: Container(
                                  width: 56.17,
                                  height: 21.84,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 0,
                                        top: 3.12,
                                        child: SizedBox(
                                          width: 56.17,
                                          child: Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: '9:4',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14.56,
                                                    fontFamily: 'SF Pro Text',
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: -0.29,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: '1',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14.56,
                                                    fontFamily: 'SF Pro Text',
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Title
              Positioned(
                left: 24.97,
                top: 133.15,
                child: SizedBox(
                  width: 319.35,
                  child: Text(
                    'Tell me some details please?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                    ),
                  ),
                ),
              ),

              // Subtitle
              Positioned(
                left: 24.97,
                top: 233.01,
                child: SizedBox(
                  width: 290.22,
                  child: Opacity(
                    opacity: 0.70,
                    child: Text(
                      'This help your friend to, find your rockit account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),
                    ),
                  ),
                ),
              ),

              // Profile picture placeholder
              Positioned(
                left: 130.03,
                top: 332.87,
                child: Container(
                  width: 130,
                  height: 130,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(72.82),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 130.03,
                          height: 130.03,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFF9FAFB),
                            shape: OvalBorder(
                              side: BorderSide(
                                width: 1.04,
                                color: const Color(0xFFE5E6EB),
                              ),
                            ),
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 60,
                            color: Color(0xFF9EA3AE),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // First Name field
              Positioned(
                left: 24.97,
                top: 499.31,
                child: Container(
                  width: 160,
                  height: 58,
                  child: TextField(
                    controller: _firstNameController,
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      height: 1.50,
                    ),
                    decoration: InputDecoration(
                      labelText: 'FIRST NAME',
                      labelStyle: const TextStyle(
                        color: Color(0xFF9EA3AE),
                        fontSize: 11,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF9FAFB),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.32),
                        borderSide: const BorderSide(
                          width: 1.04,
                          color: Color(0xFFE5E6EB),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.32),
                        borderSide: const BorderSide(
                          width: 1.04,
                          color: Color(0xFFE5E6EB),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.32),
                        borderSide: const BorderSide(
                          width: 1.04,
                          color: Color(0xFF94EA01),
                        ),
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(16.64, 12.48, 16.64, 12.48),
                    ),
                  ),
                ),
              ),

              // Last Name field
              Positioned(
                left: 203.89,
                top: 499.31,
                child: Container(
                  width: 161.24,
                  height: 58,
                  child: TextField(
                    controller: _lastNameController,
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      height: 1.50,
                    ),
                    decoration: InputDecoration(
                      labelText: 'LAST NAME',
                      labelStyle: const TextStyle(
                        color: Color(0xFF9EA3AE),
                        fontSize: 11,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF9FAFB),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.32),
                        borderSide: const BorderSide(
                          width: 1.04,
                          color: Color(0xFFE5E6EB),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.32),
                        borderSide: const BorderSide(
                          width: 1.04,
                          color: Color(0xFFE5E6EB),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.32),
                        borderSide: const BorderSide(
                          width: 1.04,
                          color: Color(0xFF94EA01),
                        ),
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(16.64, 12.48, 16.64, 12.48),
                    ),
                  ),
                ),
              ),

              // Date of Birth field
              Positioned(
                left: 24.97,
                top: 574.21,
                child: Container(
                  width: 340,
                  height: 58,
                  child: TextField(
                    controller: _dobController,
                    readOnly: true,
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime(1998, 10, 9),
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: Color(0xFF94EA01),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        _dobController.text = '${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}';
                      }
                    },
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      height: 1.50,
                    ),
                    decoration: InputDecoration(
                      labelText: 'DATE OF BIRTH',
                      labelStyle: const TextStyle(
                        color: Color(0xFF9EA3AE),
                        fontSize: 11,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      ),
                      suffixIcon: const Icon(
                        Icons.calendar_today,
                        size: 20,
                        color: Color(0xFF9EA3AE),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF9FAFB),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.32),
                        borderSide: const BorderSide(
                          width: 1.04,
                          color: Color(0xFFE5E6EB),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.32),
                        borderSide: const BorderSide(
                          width: 1.04,
                          color: Color(0xFFE5E6EB),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.32),
                        borderSide: const BorderSide(
                          width: 1.04,
                          color: Color(0xFF94EA01),
                        ),
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(16.64, 12.48, 16.64, 12.48),
                    ),
                  ),
                ),
              ),

              // Continue button
              Positioned(
                left: 24.97,
                top: 724,
                child: GestureDetector(
                  onTap: _continue,
                  child: Container(
                    width: 340,
                    height: 58,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Container(
                            width: 340,
                            height: 58,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFA1FF00),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  width: 1.04,
                                  strokeAlign: BorderSide.strokeAlignCenter,
                                  color: Color(0x00E5E6EB),
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 132.05,
                          top: 16.57,
                          child: Text(
                            'Continue',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              height: 1.50,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom safe area
              Positioned(
                left: 0,
                top: 809.30,
                child: Container(
                  width: 390.09,
                  height: 35.37,
                  child: const Stack(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}