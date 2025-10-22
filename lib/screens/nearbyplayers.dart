import 'dart:ui';

import 'package:flutter/material.dart';

class MainMapPage extends StatefulWidget {
  @override
  State<MainMapPage> createState() => _MainMapPageState();
}

final List<String> imagePaths = [
  'assets/images/person1.png',
  'assets/images/person2.png',
  'assets/images/person3.png',
  'assets/images/person4.png',
  'assets/images/person5.png',
  'assets/images/person6.png',
  'assets/images/person1.png',
  'assets/images/person6.png',
  'assets/images/person3.png',
  'assets/images/person6.png',
];
final List<String> names = [
  'Sampad Dutta',
  'John Doe',
  'Jane Smith',
  'Alice Johnson',
  'Bob Brown',
  'Charlie Davis',
  'Eve Wilson',
  'Frank Miller',
];

class _MainMapPageState extends State<MainMapPage> {
  final GlobalKey<_ProfileOverlayState> overlayKey =
      GlobalKey<_ProfileOverlayState>();

  final List<Map<String, String>> sampleUsers = List.generate(8, (i) {
    return {
      'name': names[i],
      'handle': '@' + names[i] + '_rockzz',
      'avatar': imagePaths[i],
    };
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // Top search bar
              SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            NetworkImage(sampleUsers[0]['avatar']!),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                          child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.arrow_back,
                                color: Colors.black, size: 24),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Search',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    'Anywhere · Anytime',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                              padding: EdgeInsets.all(8),
                              child: Icon(Icons.settings,
                                  color: Colors.white, size: 22),
                            ),
                          ],
                        ),
                      )),
                      SizedBox(width: 12),
                    ],
                  ),
                ),
              ),
              // Map / background image
              Flexible(
                flex: 6,
                fit: FlexFit.tight,
                child: Image.asset(
                  'assets/images/map.png',
                  fit: BoxFit.cover,
                ),
              ),
              // bottom overlay (avatars + add friends + bottom nav)
              Container(
                color: Color(0xFF070707),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // avatars row
                    SizedBox(
                      height: 110,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        itemCount: sampleUsers.length,
                        separatorBuilder: (_, __) => SizedBox(width: 12),
                        itemBuilder: (context, i) {
                          final u = sampleUsers[i];
                          return GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              overlayKey.currentState?.openForUser(u);
                            },
                            onVerticalDragStart: (_) {
                              overlayKey.currentState?.startExternalDrag();
                              overlayKey.currentState?.setUser(u);
                            },
                            onVerticalDragUpdate: (details) {
                              overlayKey.currentState
                                  ?.externalDragUpdate(details.delta.dy);
                            },
                            onVerticalDragEnd: (details) {
                              overlayKey.currentState?.endExternalDrag(
                                  details.velocity.pixelsPerSecond.dy);
                            },
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundImage: NetworkImage(u['avatar']!),
                                ),
                                SizedBox(height: 4),
                                SizedBox(
                                  width: 60,
                                  child: Text(
                                    u['name']!.split(' ')[0],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 12),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
                      child: Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => FriendsPage()));
                            },
                            icon: Icon(Icons.group,
                                color: Colors.white, size: 18),
                            label: Text('Add friends',
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 198, 239, 19),
                              shape: StadiumBorder(),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 12),
                              elevation: 0,
                            ),
                          ),
                          Spacer(),
                          // Container(
                          //   padding: EdgeInsets.symmetric(
                          //       horizontal: 10, vertical: 8),
                          //   decoration: BoxDecoration(
                          //     color: Colors.white10,
                          //     borderRadius: BorderRadius.circular(18),
                          //   ),
                          //   child: Row(
                          //     children: [
                          //       Icon(Icons.home, size: 18),
                          //       SizedBox(width: 12),
                          //       Icon(Icons.sports_cricket, size: 18),
                          //       SizedBox(width: 12),
                          //       Icon(Icons.circle_outlined, size: 18),
                          //     ],
                          //   ),
                          // )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // bottom navigation bar
              Container(
                height: 84,
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                color: Color(0xFF050505),
                child: Row(
                  children: [
                    Expanded(
                        child: _BottomNavButton(
                            icon: Icons.home, label: 'Home', onTap: () {})),
                    Expanded(
                        child: _BottomNavButton(
                            icon: Icons.play_circle_fill,
                            label: 'Play',
                            onTap: () {})),
                    Expanded(
                        child: _BottomNavButton(
                            icon: Icons.circle_outlined,
                            label: '',
                            onTap: () {})),
                    Expanded(
                        child: _BottomNavButton(
                            icon: Icons.person_search,
                            label: 'Hire',
                            onTap: () {})),
                    Expanded(
                        child: _BottomNavButton(
                            icon: Icons.menu, label: 'More', onTap: () {})),
                  ],
                ),
              ),
            ],
          ),
          // Profile overlay
          ProfileOverlay(key: overlayKey),
        ],
      ),
    );
  }
}
// import 'package:bmgr/login.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: const FirebaseOptions(
//       apiKey: "AIzaSyDU30d4OjmrRkyMmy1j1kySmP5Z9w36IBM",
//       appId: "1:811904359266:web:a71beff3afa72043c8ea3b",
//       messagingSenderId: "811904359266",
//       projectId: "bmground-62f52",
//       storageBucket: "bmground-62f52.firebasestorage.app", // optional
//     ),
//   );
//   runApp(
//     MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: LandingScreen(),
//     ),
//   );
// }

// class LandingScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         home: Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         children: <Widget>[
//           // Background Image
//           Positioned.fill(
//             child: Image.asset(
//               'assets/images/bg.jpg', // Replace with your image path
//               fit: BoxFit.cover,
//             ),
//           ),
//           // Logo
//           Positioned(
//             top: 60.0,
//             left: 20.0,
//             child: Image.asset(
//               'assets/images/logo.jpg', // Replace with your logo path
//               width: 150,
//             ),
//           ),
//           // Main content at the bottom
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   // "Get Started" Button
//                   ElevatedButton(
//                     onPressed: () {
//                       // Navigate to the next screen
//                       Navigator.of(context).push(
//                         MaterialPageRoute(builder: (context) => LoginScreen()),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.lightGreenAccent,
//                       padding: EdgeInsets.symmetric(
//                           horizontal: 50.0, vertical: 15.0),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30.0),
//                       ),
//                     ),
//                     child: Text(
//                       'Get Started',
//                       style: TextStyle(
//                         fontSize: 18.0,
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20.0),
//                   // "Skip" Text Button
//                   TextButton(
//                     onPressed: () {
//                       // Handle skip action
//                     },
//                     child: Text(
//                       'SKIP',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16.0,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     ));
//   }
// }
// lib/main.dart
// lib/main.dart
// lib/main.dart

void main() => runApp(MyApp());

/*
  Single-file demo:
  - Main map area (placeholder image)
  - Horizontal avatar row. Tap or drag an avatar up to reveal the profile sheet.
  - Custom ProfileOverlay (in the main Stack) that can be controlled by avatar gestures.
  - Snapping behavior at: closed (0.0), mini (0.18), mid (0.5), full (1.0).
  - Theme approximates the dark + neon Figma palette from your screenshots.
*/

class MyApp extends StatelessWidget {
  static const Color bg = Color(0xFF070808);
  static const Color surface = Color(0xFF0F1112);
  static const Color panel = Color(0xFF0B0B0C);
  static const Color accent = Color(0xFF00FF94);
  static const Color accent2 = Color(0xFF00C2FF);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Map + Drag Profile (Figma-style)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bg,
        primaryColor: accent,
        colorScheme: ColorScheme.dark(
          background: bg,
          primary: accent,
          secondary: accent2,
          surface: surface,
        ),
        textTheme: TextTheme(
          titleLarge: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
          bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
          bodyMedium: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: panel,
          elevation: 0,
          titleTextStyle: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      home: MainMapPage(),
    );
  }
}

class _BottomNavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _BottomNavButton(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 28, color: Colors.white70),
          SizedBox(height: 6),
          Text(label, style: TextStyle(fontSize: 11, color: Colors.white70)),
        ],
      ),
    );
  }
}

// Friends page, FriendState, Friend class – no changes, keep as-is
enum FriendState { add, play, requested }

class Friend {
  String name;
  String username;
  String avatar;
  FriendState state;
  Friend({
    required this.name,
    required this.username,
    required this.avatar,
    this.state = FriendState.add,
  });
}

class FriendsPage extends StatefulWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  static const List<String> friendImagePaths = [
    'assets/images/person1.png',
    'assets/images/person2.png',
    'assets/images/person3.png',
    'assets/images/person4.png',
    'assets/images/person5.png',
    'assets/images/person6.png',
    'assets/images/person1.png',
    'assets/images/person6.png',
    'assets/images/person3.png',
    'assets/images/person4.png',
  ];
  static const List<String> friendnames = [
    'Sampad Dutta',
    'John Doe',
    'Jane Smith',
    'Alice Johnson',
    'Bob Brown',
    'Charlie Davis',
    'Eve Wilson',
    'Frank Miller',
    'Grace Lee',
    'Hank Green',
  ];
  final List<Friend> friends = List.generate(10, (i) {
    return Friend(
      name: _FriendsPageState.friendnames[i],
      username: '@${_FriendsPageState.friendnames[i][0]}_rockzz',
      avatar: _FriendsPageState.friendImagePaths[i],
      state: FriendState.add,
    );
  });

  void _nextState(int index) {
    setState(() {
      final cur = friends[index].state;
      if (cur == FriendState.add) {
        friends[index].state = FriendState.play;
      } else if (cur == FriendState.play) {
        friends[index].state = FriendState.requested;
      }
    });
  }

  String _labelFor(FriendState s) {
    switch (s) {
      case FriendState.add:
        return 'Add';
      case FriendState.play:
        return 'Play';
      case FriendState.requested:
        return 'Requested';
    }
  }

  Color _colorFor(FriendState s) {
    switch (s) {
      case FriendState.add:
        return Colors.green.shade600;
      case FriendState.play:
        return Colors.amber.shade700;
      case FriendState.requested:
        return Colors.grey.shade600;
    }
  }

  Color _textColorFor(FriendState s) {
    return (s == FriendState.requested) ? Colors.white : Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      body: SafeArea(
        child: Column(
          children: [
            // Stylish search bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(friends[0].avatar),
                    radius: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          const Icon(Icons.search,
                              color: Colors.white54, size: 22),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: 'Search',
                                hintStyle: TextStyle(color: Colors.white54),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.settings,
                                color: Colors.white, size: 22),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Friends list
            Expanded(
              child: ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                itemCount: friends.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final f = friends[i];
                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF18191B),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(f.avatar),
                        radius: 26,
                        backgroundColor: Colors.white10,
                      ),
                      title: Text(
                        f.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        f.username,
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 13),
                      ),
                      trailing: Container(
                        decoration: BoxDecoration(
                          color: _colorFor(f.state),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: GestureDetector(
                          onTap: () => _nextState(i),
                          child: Text(
                            _labelFor(f.state),
                            style: TextStyle(
                              color: _textColorFor(f.state),
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Bottom nav bar and "Nearby X"
            Padding(
              padding: const EdgeInsets.only(
                  left: 18, right: 18, bottom: 10, top: 2),
              child: Row(
                children: [
                  Text(
                    'Nearby ${friends.length}',
                    style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF18191B),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    child: Row(
                      children: [
                        Icon(Icons.home, color: Colors.white54, size: 24),
                        const SizedBox(width: 18),
                        Icon(Icons.play_circle_fill,
                            color: Colors.white54, size: 24),
                        const SizedBox(width: 18),
                        Icon(Icons.circle_outlined,
                            color: Colors.white54, size: 24),
                        const SizedBox(width: 18),
                        Icon(Icons.person_search,
                            color: Colors.white54, size: 24),
                        const SizedBox(width: 18),
                        Icon(Icons.menu, color: Colors.white54, size: 24),
                      ],
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
}

// ProfileOverlay – unchanged
class ProfileOverlay extends StatefulWidget {
  ProfileOverlay({Key? key}) : super(key: key);

  @override
  _ProfileOverlayState createState() => _ProfileOverlayState();
}

class _ProfileOverlayState extends State<ProfileOverlay>
    with SingleTickerProviderStateMixin {
  Map<String, String>? _user;
  double _fraction = 0.0;
  late AnimationController _anim;
  double _animStart = 0.0, _animEnd = 0.0;
  final ScrollController _innerScroll = ScrollController();

  static const double closedF = 0.0;
  static const double miniF = 0.18;
  static const double midF = 0.5;
  static const double fullF = 1.0;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this)
      ..addListener(() {
        setState(() {
          _fraction = lerpDouble(_animStart, _animEnd, _anim.value)!;
        });
      });
  }

  @override
  void dispose() {
    _anim.dispose();
    _innerScroll.dispose();
    super.dispose();
  }

  void setUser(Map<String, String> user) {
    setState(() => _user = user);
  }

  void openForUser(Map<String, String> user, {bool openFull = false}) {
    setState(() => _user = user);
    animateTo(openFull ? fullF : miniF);
  }

  void startExternalDrag() {
    if (_anim.isAnimating) _anim.stop();
  }

  void externalDragUpdate(double deltaDyPixels) {
    final h = MediaQuery.of(context).size.height;
    final deltaFraction = -deltaDyPixels / h;
    if (_fraction >= 0.98 &&
        _innerScroll.hasClients &&
        _innerScroll.offset > 0) {
      return;
    }
    setState(() => _fraction = (_fraction + deltaFraction).clamp(0.0, 1.0));
  }

  void endExternalDrag(double velocityY) {
    if (velocityY < -800) {
      animateTo(fullF);
      return;
    }
    if (velocityY > 800) {
      animateTo(closedF);
      return;
    }
    if (_fraction >= 0.75) {
      animateTo(fullF);
    } else if (_fraction >= 0.33) {
      animateTo(midF);
    } else if (_fraction > 0.05) {
      animateTo(miniF);
    } else {
      animateTo(closedF);
    }
  }

  void animateTo(double target) {
    _animStart = _fraction;
    _animEnd = target;
    _anim.duration = Duration(
        milliseconds: (300 * ((_animStart - _animEnd).abs() + 0.2)).round());
    _anim.forward(from: 0.0);
  }

  void startHandleDrag() {
    if (_anim.isAnimating) _anim.stop();
  }

  void handleDragUpdate(double deltaDyPixels) =>
      externalDragUpdate(deltaDyPixels);

  void handleDragEnd(double velocityY) => endExternalDrag(velocityY);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final overlayVisible = _fraction > 0.001;
    final sheetHeight = size.height * _fraction;

    return overlayVisible
        ? Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: sheetHeight,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onVerticalDragStart: (_) => startHandleDrag(),
              onVerticalDragUpdate: (d) => handleDragUpdate(d.delta.dy),
              onVerticalDragEnd: (d) =>
                  handleDragEnd(d.velocity.pixelsPerSecond.dy),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF070707),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(18)),
                    boxShadow: [
                      BoxShadow(color: Colors.black54, blurRadius: 14)
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 12),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (_fraction < 0.5) {
                                  animateTo(fullF);
                                } else {
                                  animateTo(miniF);
                                }
                              },
                              child: Container(
                                width: 46,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: Colors.white12,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                      Expanded(
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (notification) => false,
                          child: SingleChildScrollView(
                            controller: _innerScroll,
                            physics: (_fraction >= 0.98)
                                ? BouncingScrollPhysics()
                                : NeverScrollableScrollPhysics(),
                            child: _buildContent(size),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : SizedBox.shrink();
  }

  Widget _buildContent(Size size) {
    final user = _user ??
        {
          'name': 'Unknown',
          'handle': '@unknown',
          'avatar': 'https://i.pravatar.cc/150?img=1',
        };

    final posts =
        List.generate(6, (i) => 'https://picsum.photos/seed/p${i + 6}/400/600');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                  radius: 32, backgroundImage: NetworkImage(user['avatar']!)),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user['name']!,
                          style: Theme.of(context).textTheme.titleLarge),
                      SizedBox(height: 6),
                      Text(user['handle']!,
                          style: TextStyle(color: Colors.white70)),
                    ]),
              ),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF00FF94),
                      shape: StadiumBorder(),
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    child: Text('Add', style: TextStyle(color: Colors.black)),
                  ),
                  SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.white12),
                      shape: StadiumBorder(),
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    child: Text('Play'),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: posts.length,
              separatorBuilder: (_, __) => SizedBox(width: 10),
              itemBuilder: (context, i) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(posts[i],
                      width: 120, height: 140, fit: BoxFit.cover),
                );
              },
            ),
          ),
          SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 22),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text('GAMES PLAYED', style: TextStyle(color: Colors.white70)),
                SizedBox(height: 6),
                ShaderMask(
                  shaderCallback: (rect) => LinearGradient(
                    colors: [Color(0xFF00F5A0), Color(0xFF00C2FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(Rect.fromLTWH(0, 0, rect.width, rect.height)),
                  child: Text('366',
                      style: TextStyle(
                          fontSize: 72,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
                SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _smallStat('Cricket', '100'),
                      _smallStat('Football', '100'),
                      _smallStat('Badminton', '100'),
                      _smallStat('Others', '66'),
                    ]),
              ],
            ),
          ),
          SizedBox(height: 22),
          Text('MOST ACTIVE',
              style: TextStyle(color: Colors.white70, fontSize: 12)),
          SizedBox(height: 12),
          Container(
            height: 170,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white10, borderRadius: BorderRadius.circular(12)),
            child: Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.show_chart, size: 44, color: Colors.white24),
                SizedBox(height: 8),
                Text('Graph placeholder\nuse fl_chart or charts_flutter',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white54)),
              ]),
            ),
          ),
          SizedBox(height: 18),
          Row(
            children: [
              ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.message),
                  label: Text('Message')),
              SizedBox(width: 12),
              OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.place),
                  label: Text('Navigate')),
            ],
          ),
          SizedBox(height: 28),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _smallStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}
