import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_phone_app/screens/bms_screen_07_dashboard.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const BookingsApp());
}

class BookingsApp extends StatelessWidget {
  const BookingsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bookings Demo',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        cardColor: const Color(0xFF111111),
        primaryColor: const Color(0xFF00C9A7),
        textTheme: GoogleFonts.lexendTextTheme(
          ThemeData.dark().textTheme,
        ).apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      ),
      home: const BookingsHome(),
    );
  }
}

class Booking {
  final String id;
  final String groundName;
  final String court;
  final String time;
  final String imageUrl;
  final DateTime date;
  final double price;
  final bool confirmed;

  Booking({
    required this.id,
    required this.groundName,
    required this.court,
    required this.time,
    required this.imageUrl,
    required this.date,
    required this.price,
    required this.confirmed,
  });
}

// Sample data
final sampleImage =
    'https://images.unsplash.com/photo-1521412644187-c49fa049e84d?w=800&q=80';
final List<Booking> todayBookings = List.generate(
  3,
  (i) => Booking(
    id: 't$i',
    groundName: 'ABC GROUND',
    court: 'Court ${i + 1}',
    time: '6:00 PM - 7:00 PM',
    imageUrl: sampleImage,
    date: DateTime.now(),
    price: 6000,
    confirmed: true,
  ),
);

final List<Booking> upcomingBookings = List.generate(
  5,
  (i) => Booking(
    id: 'u$i',
    groundName: i % 2 == 0 ? 'CKD GROUND' : 'PDA GROUND',
    court: 'Court 1',
    time: '6:00 PM - 7:00 PM',
    imageUrl: sampleImage,
    date: DateTime.now().add(Duration(days: 2 + i)),
    price: 4500 + i * 200,
    confirmed: true,
  ),
);

final List<Booking> pastBookings = List.generate(
  4,
  (i) => Booking(
    id: 'p$i',
    groundName: 'POD GROUND',
    court: 'Court 1',
    time: '6:00 PM - 7:00 PM',
    imageUrl: sampleImage,
    date: DateTime.now().subtract(Duration(days: 5 + i)),
    price: 3500 + i * 100,
    confirmed: true,
  ),
);

class BookingsHome extends StatefulWidget {
  const BookingsHome({super.key});

  @override
  State<BookingsHome> createState() => _BookingsHomeState();
}

class _BookingsHomeState extends State<BookingsHome>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => BmsScreen07Dashboard()),
            );
          },
        ),
        title: const Text('Bookings'),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).primaryColor,
          tabs: const [
            Tab(text: 'Today'),
            Tab(text: 'Upcoming'),
            Tab(text: 'Past'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          BookingListView(
              bookings: todayBookings, type: BookingListType.current),
          BookingListView(
              bookings: upcomingBookings, type: BookingListType.current),
          BookingListView(bookings: pastBookings, type: BookingListType.past),
        ],
      ),
      // bottomNavigationBar: Container(
      //   height: 120,
      //   color: Colors.black,
      //   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      //   child: Align(
      //     alignment: Alignment.bottomLeft,
      //     child: Text(
      //       'GAME ON\nALWAYS.',
      //       style: TextStyle(
      //         color: Colors.white.withOpacity(0.05),
      //         fontSize: 44,
      //         fontWeight: FontWeight.bold,
      //         height: 0.88,
      //       ),
      //     ),
      //   ),
      // ),
      bottomNavigationBar: Container(
        height: 160,
        color: Colors.black,
        alignment: Alignment.bottomLeft,
        padding: const EdgeInsets.only(left: 24, bottom: 30),
        child: Text(
          'GAME ON\nALWAYS.',
          style: TextStyle(
            color: Colors.white.withOpacity(0.06),
            fontSize: 52,
            fontWeight: FontWeight.bold,
            height: 0.9,
          ),
        ),
      ),
    );
  }
}

enum BookingListType { current, past }

class BookingListView extends StatelessWidget {
  final List<Booking> bookings;
  final BookingListType type;
  const BookingListView(
      {super.key, required this.bookings, required this.type});

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return const Center(child: Text('No bookings'));
    }

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final b = bookings[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: BookingCard(
              booking: b,
              isPast: type == BookingListType.past,
            ),
          );
        },
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final Booking booking;
  final bool isPast;
  const BookingCard({super.key, required this.booking, this.isPast = false});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                BookingDetailsScreen(booking: booking, isPast: isPast),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.groundName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text('${booking.court}, ${booking.time}',
                        style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BookingDetailsScreen(
                                    booking: booking, isPast: isPast),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            side: BorderSide(
                                color: Colors.white.withOpacity(0.06)),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)),
                          ),
                          child: const Text('View Details',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white)),
                        ),
                      ],
                    )
                  ],
                ),
              ),

              // image
              const SizedBox(width: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  booking.imageUrl,
                  width: 120,
                  height: 78,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(
                    width: 120,
                    height: 78,
                    color: Colors.grey.shade800,
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BookingDetailsScreen extends StatelessWidget {
  final Booking booking;
  final bool isPast;
  const BookingDetailsScreen(
      {super.key, required this.booking, this.isPast = false});

  void _showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<bool?> _confirmDialog(
      BuildContext context, String title, String subtitle) {
    return showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(title),
        content: Text(subtitle),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(c, false),
              child: const Text('No')),
          TextButton(
              onPressed: () => Navigator.pop(c, true),
              child: const Text('Yes')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
        backgroundColor: Colors.black,
        elevation: 0,
        leading: BackButton(color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // framed map/image
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      booking.imageUrl,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => Container(
                        height: 140,
                        color: Colors.grey.shade900,
                        child: const Icon(Icons.map, size: 48),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(booking.groundName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 6),
                    const Text('Anytown Cricket Club',
                        style: TextStyle(
                          color: Colors.white70,
                          fontFamily: 'Lexend',
                        )),
                    const SizedBox(height: 18),

                    // details list
                    _detailRow(context, Icons.calendar_today,
                        '${_formatDate(booking.date)} · ${booking.time}'),
                    const SizedBox(height: 12),
                    _detailRow(context, Icons.access_time, '2 hours'),
                    const SizedBox(height: 12),
                    _detailRow(context, Icons.check_circle,
                        booking.confirmed ? 'Confirmed' : 'Pending'),
                    const SizedBox(height: 12),
                    _detailRow(context, Icons.attach_money,
                        '₹ ${booking.price.toStringAsFixed(0)}'),

                    const Spacer(),

                    // bottom action buttons
                    if (!isPast) ...[
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _showSnackBar(
                                  context, 'Share feature coming soon'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[850],
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('SHARE BOOKING',
                                  style: TextStyle(
                                      letterSpacing: 1.2,
                                      fontFamily: 'Lexend',
                                      color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () async {
                                final ok = await _confirmDialog(
                                    context,
                                    'Cancel booking',
                                    'Are you sure you want to cancel this booking?');
                                if (ok == true) {
                                  _showSnackBar(context, 'Booking cancelled');
                                  Navigator.pop(context);
                                }
                              },
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                side: BorderSide(
                                    color: Colors.white.withOpacity(0.06)),
                              ),
                              child: const Text('CANCEL BOOKING',
                                  style: TextStyle(
                                      letterSpacing: 1.2, color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ] else ...[
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                final ok = await _confirmDialog(
                                    context,
                                    'Re-book venue',
                                    'Proceed to re-book this venue for a new slot?');
                                if (ok == true) {
                                  _showSnackBar(context, 'Re-booked (demo)');
                                  Navigator.pop(context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('RE BOOK VENUE',
                                  style: TextStyle(
                                      letterSpacing: 1.2, color: Colors.black)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ]
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  static String _formatDate(DateTime d) {
    return '${_monthName(d.month)} ${d.day}, ${d.year}';
  }

  static String _monthName(int m) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[m - 1];
  }
}

Widget _detailRow(BuildContext context, IconData icon, String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.tealAccent.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Colors.tealAccent,
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    ),
  );
}
