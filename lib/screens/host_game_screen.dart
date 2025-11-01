import 'package:flutter/material.dart';
import 'select_location_screen.dart';
import 'pick_sports_screen.dart';
import 'game_details_screen.dart';

class HostGameScreen extends StatefulWidget {
  const HostGameScreen({Key? key}) : super(key: key);

  @override
  State<HostGameScreen> createState() => _HostGameScreenState();
}

class _HostGameScreenState extends State<HostGameScreen> {
  String? selectedSport;
  String? selectedLocation;
  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  int? playerCount;
  double? playerShare;
  bool isFreeGame = false;
  bool isFriendly = true;
  bool isPublic = true;

  void _hostGame() {
    // Validate required fields
    if (selectedSport == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a sport')),
      );
      return;
    }

    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date')),
      );
      return;
    }

    if (startTime == null || endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select start and end time')),
      );
      return;
    }

    if (selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a location')),
      );
      return;
    }

    if (playerCount == null || playerCount! <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter number of players')),
      );
      return;
    }

    if (!isFreeGame && (playerShare == null || playerShare! <= 0)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter player share amount')),
      );
      return;
    }

    // Navigate to Game Details screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameDetailsScreen(
          sport: selectedSport,
          location: selectedLocation,
          date: selectedDate,
          startTime: startTime,
          endTime: endTime,
          playerCount: playerCount,
          playerShare: playerShare,
          isFreeGame: isFreeGame,
          isFriendly: isFriendly,
          isPublic: isPublic,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Host a Game',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    
                    // Pick your Sport
                    const Text(
                      'Pick your Sport',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PickSportsScreen(),
                          ),
                        );
                        if (result != null) {
                          setState(() {
                            selectedSport = result;
                          });
                        }
                      },
                      child: Container(
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFF222222),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                selectedSport ?? 'Select sport',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  color: selectedSport != null ? Colors.white : Colors.white.withOpacity(0.6),
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Date
                    const Text(
                      'Date',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (date != null) {
                          setState(() {
                            selectedDate = date;
                          });
                        }
                      },
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFF222222),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                selectedDate != null
                                    ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                                    : 'Select date',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  color: selectedDate != null ? Colors.white : Colors.white.withOpacity(0.6),
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.calendar_today,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Time selection
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (time != null) {
                                setState(() {
                                  startTime = time;
                                });
                              }
                            },
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xFF222222),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      startTime != null
                                          ? startTime!.format(context)
                                          : 'Select start time',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                        color: startTime != null ? Colors.white : Colors.white.withOpacity(0.6),
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.access_time,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (time != null) {
                                setState(() {
                                  endTime = time;
                                });
                              }
                            },
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xFF222222),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      endTime != null
                                          ? endTime!.format(context)
                                          : 'Select end time',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                        color: endTime != null ? Colors.white : Colors.white.withOpacity(0.6),
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.access_time,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Location
                    InkWell(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SelectLocationScreen(),
                          ),
                        );
                        if (result != null) {
                          setState(() {
                            selectedLocation = result;
                          });
                        }
                      },
                      child: Container(
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFF222222),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                selectedLocation ?? 'Select  location',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  color: selectedLocation != null ? Colors.white : Colors.white.withOpacity(0.6),
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Player Settings
                    const Text(
                      'Player Settings',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Total players
                    Container(
                      height: 39,
                      decoration: BoxDecoration(
                        color: const Color(0xFF222222),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextField(
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Colors.white,
                        ),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Total no of players ( including you )',
                          hintStyle: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.6),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (value) {
                          setState(() {
                            playerCount = int.tryParse(value);
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 13),

                    // Per Player Share
                    const Text(
                      'Per Player Share',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13.612,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Container(
                      height: 43,
                      decoration: BoxDecoration(
                        color: const Color(0xFF222222),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: TextField(
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Colors.white,
                        ),
                        keyboardType: TextInputType.number,
                        enabled: !isFreeGame,
                        decoration: InputDecoration(
                          hintText: 'Enter  amount',
                          hintStyle: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.6),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (value) {
                          setState(() {
                            playerShare = double.tryParse(value);
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 11),

                    // Free Game Toggle
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Free Game',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          Switch(
                            value: isFreeGame,
                            onChanged: (value) {
                              setState(() {
                                isFreeGame = value;
                              });
                            },
                            activeColor: Colors.white,
                            activeTrackColor: Colors.grey.withOpacity(0.4),
                            inactiveThumbColor: const Color(0xFFEEEEEE),
                            inactiveTrackColor: Colors.grey.withOpacity(0.2),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Friendly/Competitive Toggle
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF222222),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  isFriendly = true;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isFriendly ? const Color(0xFF020202) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: isFriendly
                                      ? [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1),
                                            blurRadius: 4,
                                          ),
                                        ]
                                      : null,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Friendly',
                                  style: TextStyle(
                                    fontFamily: 'Lexend',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: isFriendly ? Colors.white : const Color(0xFF929292),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  isFriendly = false;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: !isFriendly ? const Color(0xFF020202) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: !isFriendly
                                      ? [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1),
                                            blurRadius: 4,
                                          ),
                                        ]
                                      : null,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Competitive',
                                  style: TextStyle(
                                    fontFamily: 'Lexend',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: !isFriendly ? Colors.white : const Color(0xFF929292),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 21),

                    // Public/Private Toggle
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF222222),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  isPublic = true;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isPublic ? const Color(0xFF020202) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: isPublic
                                      ? [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1),
                                            blurRadius: 4,
                                          ),
                                        ]
                                      : null,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Public',
                                  style: TextStyle(
                                    fontFamily: 'Lexend',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: isPublic ? Colors.white : const Color(0xFF929292),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  isPublic = false;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: !isPublic ? const Color(0xFF020202) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: !isPublic
                                      ? [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1),
                                            blurRadius: 4,
                                          ),
                                        ]
                                      : null,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Private',
                                  style: TextStyle(
                                    fontFamily: 'Lexend',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: !isPublic ? Colors.white : const Color(0xFF929292),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Host Game Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _hostGame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B2B2B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'HOST GAME',
                    style: TextStyle(
                      fontFamily: 'Lexend',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
