import 'dart:io';
import 'api_service.dart';

/// Venue model
class Venue {
  final String id;
  final String name;
  final String? description;
  final String address;
  final String city;
  final String state;
  final String pincode;
  final double? latitude;
  final double? longitude;
  final List<String> imageUrls;
  final String? thumbnailUrl;
  final List<String> sportsAvailable;
  final List<String> amenities;
  final double pricePerHour;
  final double rating;
  final int totalReviews;
  final String? openingTime;
  final String? closingTime;
  final bool isActive;
  final int totalCourts;
  final String? contactPhone;
  final String? contactEmail;
  final DateTime createdAt;
  final DateTime updatedAt;

  Venue({
    required this.id,
    required this.name,
    this.description,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    this.latitude,
    this.longitude,
    required this.imageUrls,
    this.thumbnailUrl,
    required this.sportsAvailable,
    required this.amenities,
    required this.pricePerHour,
    required this.rating,
    required this.totalReviews,
    this.openingTime,
    this.closingTime,
    required this.isActive,
    required this.totalCourts,
    this.contactPhone,
    this.contactEmail,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      pincode: json['pincode'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      imageUrls: List<String>.from(json['image_urls'] ?? []),
      thumbnailUrl: json['thumbnail_url'],
      sportsAvailable: List<String>.from(json['sports_available'] ?? []),
      amenities: List<String>.from(json['amenities'] ?? []),
      pricePerHour: (json['price_per_hour'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      totalReviews: json['total_reviews'],
      openingTime: json['opening_time'],
      closingTime: json['closing_time'],
      isActive: json['is_active'],
      totalCourts: json['total_courts'],
      contactPhone: json['contact_phone'],
      contactEmail: json['contact_email'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

/// Venue API Service
class VenueApiService {
  final ApiService _apiService = ApiService();

  /// Create a new venue
  Future<ApiResponse<Venue>> createVenue(Map<String, dynamic> venueData) async {
    final response = await _apiService.post<Map<String, dynamic>>(
      '/venues/',
      data: venueData,
    );

    if (response.isSuccess && response.data != null) {
      return ApiResponse.success(Venue.fromJson(response.data!));
    }

    return ApiResponse.error(response.error ?? 'Failed to create venue');
  }

  /// Get venue by ID
  Future<ApiResponse<Venue>> getVenue(String venueId) async {
    final response = await _apiService.get<Map<String, dynamic>>(
      '/venues/$venueId',
      useCache: true,
    );

    if (response.isSuccess && response.data != null) {
      return ApiResponse.success(Venue.fromJson(response.data!));
    }

    return ApiResponse.error(response.error ?? 'Failed to get venue');
  }

  /// List venues with filtering
  Future<ApiResponse<List<Venue>>> listVenues({
    int skip = 0,
    int limit = 20,
    String? city,
    String? sport,
    bool? isActive,
  }) async {
    final response = await _apiService.get<List<dynamic>>(
      '/venues/',
      queryParameters: {
        'skip': skip,
        'limit': limit,
        if (city != null) 'city': city,
        if (sport != null) 'sport': sport,
        if (isActive != null) 'is_active': isActive,
      },
      useCache: true,
    );

    if (response.isSuccess && response.data != null) {
      final venues = response.data!
          .map((json) => Venue.fromJson(json as Map<String, dynamic>))
          .toList();
      return ApiResponse.success(venues);
    }

    return ApiResponse.error(response.error ?? 'Failed to list venues');
  }

  /// Update venue
  Future<ApiResponse<Venue>> updateVenue(
    String venueId,
    Map<String, dynamic> updates,
  ) async {
    final response = await _apiService.put<Map<String, dynamic>>(
      '/venues/$venueId',
      data: updates,
    );

    if (response.isSuccess && response.data != null) {
      _apiService.clearCache();
      return ApiResponse.success(Venue.fromJson(response.data!));
    }

    return ApiResponse.error(response.error ?? 'Failed to update venue');
  }

  /// Delete venue
  Future<ApiResponse<void>> deleteVenue(String venueId) async {
    final response = await _apiService.delete<Map<String, dynamic>>(
      '/venues/$venueId',
    );

    if (response.isSuccess) {
      _apiService.clearCache();
      return ApiResponse.success(null);
    }

    return ApiResponse.error(response.error ?? 'Failed to delete venue');
  }

  /// Add images to venue
  Future<ApiResponse<void>> addVenueImages(
    String venueId,
    List<File> imageFiles,
  ) async {
    List<String> uploadedPaths = [];

    // Upload each image
    for (var imageFile in imageFiles) {
      final uploadResponse = await _apiService.uploadFile<Map<String, dynamic>>(
        '/files/upload',
        imageFile,
        fieldName: 'file',
        additionalData: {
          'bucket': 'venue_images',
          'prefix': venueId,
        },
      );

      if (uploadResponse.isSuccess && uploadResponse.data != null) {
        uploadedPaths.add(uploadResponse.data!['file_path']);
      }
    }

    // Add image paths to venue
    if (uploadedPaths.isNotEmpty) {
      final response = await _apiService.post<Map<String, dynamic>>(
        '/venues/$venueId/images',
        data: uploadedPaths,
      );

      if (response.isSuccess) {
        _apiService.clearCache();
        return ApiResponse.success(null);
      }
    }

    return ApiResponse.error('Failed to add venue images');
  }
}
