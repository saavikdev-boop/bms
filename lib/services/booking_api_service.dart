import 'api_service.dart';

/// Booking model for API
class Booking {
  final String id;
  final String userId;
  final String sport;
  final String venueName;
  final String venueAddress;
  final String? venueImageUrl;
  final DateTime date;
  final String startTime;
  final String endTime;
  final int duration;
  final double price;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Booking({
    required this.id,
    required this.userId,
    required this.sport,
    required this.venueName,
    required this.venueAddress,
    this.venueImageUrl,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.price,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      userId: json['user_id'],
      sport: json['sport'],
      venueName: json['venue_name'],
      venueAddress: json['venue_address'],
      venueImageUrl: json['venue_image_url'],
      date: DateTime.parse(json['date']),
      startTime: json['start_time'],
      endTime: json['end_time'],
      duration: json['duration'],
      price: (json['price'] as num).toDouble(),
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sport': sport,
      'venue_name': venueName,
      'venue_address': venueAddress,
      'venue_image_url': venueImageUrl,
      'date': date.toIso8601String(),
      'start_time': startTime,
      'end_time': endTime,
      'duration': duration,
      'price': price,
    };
  }
}

/// Booking API Service
class BookingApiService {
  final ApiService _apiService = ApiService();

  /// Create a new booking
  Future<ApiResponse<Booking>> createBooking(
    String userId,
    Map<String, dynamic> bookingData,
  ) async {
    final response = await _apiService.post<Map<String, dynamic>>(
      '/bookings/$userId',
      data: bookingData,
    );

    if (response.isSuccess && response.data != null) {
      return ApiResponse.success(Booking.fromJson(response.data!));
    }

    return ApiResponse.error(response.error ?? 'Failed to create booking');
  }

  /// Get user's bookings
  Future<ApiResponse<List<Booking>>> getUserBookings(
    String userId, {
    String? statusFilter,
  }) async {
    final response = await _apiService.get<List<dynamic>>(
      '/bookings/$userId',
      queryParameters: statusFilter != null ? {'status_filter': statusFilter} : null,
      useCache: false,
    );

    if (response.isSuccess && response.data != null) {
      final bookings = response.data!
          .map((json) => Booking.fromJson(json as Map<String, dynamic>))
          .toList();
      return ApiResponse.success(bookings);
    }

    return ApiResponse.error(response.error ?? 'Failed to get bookings');
  }

  /// Get booking by ID
  Future<ApiResponse<Booking>> getBooking(
    String userId,
    String bookingId,
  ) async {
    final response = await _apiService.get<Map<String, dynamic>>(
      '/bookings/$userId/$bookingId',
    );

    if (response.isSuccess && response.data != null) {
      return ApiResponse.success(Booking.fromJson(response.data!));
    }

    return ApiResponse.error(response.error ?? 'Failed to get booking');
  }

  /// Update booking status
  Future<ApiResponse<Booking>> updateBooking(
    String userId,
    String bookingId,
    Map<String, dynamic> updates,
  ) async {
    final response = await _apiService.put<Map<String, dynamic>>(
      '/bookings/$userId/$bookingId',
      data: updates,
    );

    if (response.isSuccess && response.data != null) {
      return ApiResponse.success(Booking.fromJson(response.data!));
    }

    return ApiResponse.error(response.error ?? 'Failed to update booking');
  }

  /// Cancel booking
  Future<ApiResponse<void>> cancelBooking(
    String userId,
    String bookingId,
  ) async {
    final response = await _apiService.delete<Map<String, dynamic>>(
      '/bookings/$userId/$bookingId',
    );

    if (response.isSuccess) {
      return ApiResponse.success(null);
    }

    return ApiResponse.error(response.error ?? 'Failed to cancel booking');
  }
}
