import 'dart:io';
import 'api_service.dart';

/// Reel model
class Reel {
  final String id;
  final String userId;
  final String videoUrl;
  final String? thumbnailUrl;
  final String? caption;
  final String? sport;
  final String? location;
  final int duration;
  final int? width;
  final int? height;
  final int? fileSize;
  final int viewsCount;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final List<String> hashtags;
  final List<String> taggedUsers;
  final bool isPublic;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Reel({
    required this.id,
    required this.userId,
    required this.videoUrl,
    this.thumbnailUrl,
    this.caption,
    this.sport,
    this.location,
    required this.duration,
    this.width,
    this.height,
    this.fileSize,
    required this.viewsCount,
    required this.likesCount,
    required this.commentsCount,
    required this.sharesCount,
    required this.hashtags,
    required this.taggedUsers,
    required this.isPublic,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Reel.fromJson(Map<String, dynamic> json) {
    return Reel(
      id: json['id'],
      userId: json['user_id'],
      videoUrl: json['video_url'],
      thumbnailUrl: json['thumbnail_url'],
      caption: json['caption'],
      sport: json['sport'],
      location: json['location'],
      duration: json['duration'],
      width: json['width'],
      height: json['height'],
      fileSize: json['file_size'],
      viewsCount: json['views_count'],
      likesCount: json['likes_count'],
      commentsCount: json['comments_count'],
      sharesCount: json['shares_count'],
      hashtags: List<String>.from(json['hashtags'] ?? []),
      taggedUsers: List<String>.from(json['tagged_users'] ?? []),
      isPublic: json['is_public'],
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

/// Comment model
class ReelComment {
  final String id;
  final String reelId;
  final String userId;
  final String text;
  final int likesCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReelComment({
    required this.id,
    required this.reelId,
    required this.userId,
    required this.text,
    required this.likesCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReelComment.fromJson(Map<String, dynamic> json) {
    return ReelComment(
      id: json['id'],
      reelId: json['reel_id'],
      userId: json['user_id'],
      text: json['text'],
      likesCount: json['likes_count'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

/// Reel API Service
class ReelApiService {
  final ApiService _apiService = ApiService();

  /// Upload and create a reel
  Future<ApiResponse<Reel>> createReel(
    String userId,
    File videoFile, {
    File? thumbnailFile,
    required Map<String, dynamic> reelData,
  }) async {
    // Upload video
    final videoUploadResponse = await _apiService.uploadFile<Map<String, dynamic>>(
      '/files/upload',
      videoFile,
      fieldName: 'file',
      additionalData: {
        'bucket': 'reels',
        'prefix': userId,
      },
    );

    if (!videoUploadResponse.isSuccess || videoUploadResponse.data == null) {
      return ApiResponse.error('Failed to upload video');
    }

    reelData['video_url'] = videoUploadResponse.data!['file_path'];

    // Upload thumbnail if provided
    if (thumbnailFile != null) {
      final thumbnailUploadResponse = await _apiService.uploadFile<Map<String, dynamic>>(
        '/files/upload',
        thumbnailFile,
        fieldName: 'file',
        additionalData: {
          'bucket': 'reels',
          'prefix': '${userId}_thumb',
        },
      );

      if (thumbnailUploadResponse.isSuccess && thumbnailUploadResponse.data != null) {
        reelData['thumbnail_url'] = thumbnailUploadResponse.data!['file_path'];
      }
    }

    // Create reel
    final response = await _apiService.post<Map<String, dynamic>>(
      '/reels/$userId',
      data: reelData,
    );

    if (response.isSuccess && response.data != null) {
      return ApiResponse.success(Reel.fromJson(response.data!));
    }

    return ApiResponse.error(response.error ?? 'Failed to create reel');
  }

  /// Get reel by ID
  Future<ApiResponse<Reel>> getReel(String reelId) async {
    final response = await _apiService.get<Map<String, dynamic>>(
      '/reels/$reelId',
      useCache: false,
    );

    if (response.isSuccess && response.data != null) {
      return ApiResponse.success(Reel.fromJson(response.data!));
    }

    return ApiResponse.error(response.error ?? 'Failed to get reel');
  }

  /// List reels (feed)
  Future<ApiResponse<List<Reel>>> listReels({
    int skip = 0,
    int limit = 20,
    String? sport,
    String? userId,
  }) async {
    final response = await _apiService.get<List<dynamic>>(
      '/reels/',
      queryParameters: {
        'skip': skip,
        'limit': limit,
        if (sport != null) 'sport': sport,
        if (userId != null) 'user_id': userId,
      },
      useCache: false,
    );

    if (response.isSuccess && response.data != null) {
      final reels = response.data!
          .map((json) => Reel.fromJson(json as Map<String, dynamic>))
          .toList();
      return ApiResponse.success(reels);
    }

    return ApiResponse.error(response.error ?? 'Failed to list reels');
  }

  /// Get user's reels
  Future<ApiResponse<List<Reel>>> getUserReels(String userId) async {
    final response = await _apiService.get<List<dynamic>>(
      '/reels/user/$userId',
      useCache: false,
    );

    if (response.isSuccess && response.data != null) {
      final reels = response.data!
          .map((json) => Reel.fromJson(json as Map<String, dynamic>))
          .toList();
      return ApiResponse.success(reels);
    }

    return ApiResponse.error(response.error ?? 'Failed to get user reels');
  }

  /// Update reel
  Future<ApiResponse<Reel>> updateReel(
    String reelId,
    Map<String, dynamic> updates,
  ) async {
    final response = await _apiService.put<Map<String, dynamic>>(
      '/reels/$reelId',
      data: updates,
    );

    if (response.isSuccess && response.data != null) {
      return ApiResponse.success(Reel.fromJson(response.data!));
    }

    return ApiResponse.error(response.error ?? 'Failed to update reel');
  }

  /// Delete reel
  Future<ApiResponse<void>> deleteReel(String reelId, String userId) async {
    final response = await _apiService.delete<Map<String, dynamic>>(
      '/reels/$reelId/$userId',
    );

    if (response.isSuccess) {
      return ApiResponse.success(null);
    }

    return ApiResponse.error(response.error ?? 'Failed to delete reel');
  }

  /// Like a reel
  Future<ApiResponse<void>> likeReel(String reelId, String userId) async {
    final response = await _apiService.post<Map<String, dynamic>>(
      '/reels/$reelId/like/$userId',
      data: {},
    );

    if (response.isSuccess) {
      return ApiResponse.success(null);
    }

    return ApiResponse.error(response.error ?? 'Failed to like reel');
  }

  /// Unlike a reel
  Future<ApiResponse<void>> unlikeReel(String reelId, String userId) async {
    final response = await _apiService.delete<Map<String, dynamic>>(
      '/reels/$reelId/like/$userId',
    );

    if (response.isSuccess) {
      return ApiResponse.success(null);
    }

    return ApiResponse.error(response.error ?? 'Failed to unlike reel');
  }

  /// Add comment
  Future<ApiResponse<ReelComment>> addComment(
    String reelId,
    String userId,
    String text,
  ) async {
    final response = await _apiService.post<Map<String, dynamic>>(
      '/reels/$reelId/comments/$userId',
      data: {'text': text},
    );

    if (response.isSuccess && response.data != null) {
      return ApiResponse.success(ReelComment.fromJson(response.data!));
    }

    return ApiResponse.error(response.error ?? 'Failed to add comment');
  }

  /// Get comments
  Future<ApiResponse<List<ReelComment>>> getComments(
    String reelId, {
    int skip = 0,
    int limit = 50,
  }) async {
    final response = await _apiService.get<List<dynamic>>(
      '/reels/$reelId/comments',
      queryParameters: {
        'skip': skip,
        'limit': limit,
      },
      useCache: false,
    );

    if (response.isSuccess && response.data != null) {
      final comments = response.data!
          .map((json) => ReelComment.fromJson(json as Map<String, dynamic>))
          .toList();
      return ApiResponse.success(comments);
    }

    return ApiResponse.error(response.error ?? 'Failed to get comments');
  }

  /// Delete comment
  Future<ApiResponse<void>> deleteComment(
    String reelId,
    String commentId,
    String userId,
  ) async {
    final response = await _apiService.delete<Map<String, dynamic>>(
      '/reels/$reelId/comments/$commentId/$userId',
    );

    if (response.isSuccess) {
      return ApiResponse.success(null);
    }

    return ApiResponse.error(response.error ?? 'Failed to delete comment');
  }

  /// Share reel
  Future<ApiResponse<void>> shareReel(String reelId, String userId) async {
    final response = await _apiService.post<Map<String, dynamic>>(
      '/reels/$reelId/share/$userId',
      data: {},
    );

    if (response.isSuccess) {
      return ApiResponse.success(null);
    }

    return ApiResponse.error(response.error ?? 'Failed to share reel');
  }
}
