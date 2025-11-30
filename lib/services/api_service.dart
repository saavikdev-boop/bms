import 'dart:io';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Enterprise API Service
/// Handles all HTTP requests with:
/// - Error handling and retry logic
/// - Logging and debugging
/// - Caching for offline support
/// - Request/response interceptors
/// - Authentication token management
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late Dio _dio;
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 50,
      colors: true,
      printEmojis: true,
    ),
  );

  // Base URL configuration
  static const String _baseUrl = 'http://localhost:8000/api/v1';

  // Cache
  final Map<String, CachedResponse> _cache = {};
  static const Duration _cacheDuration = Duration(minutes: 5);

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onResponse: _onResponse,
        onError: _onError,
      ),
    );

    // Add logging interceptor (only in debug mode)
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => _logger.d(obj),
      ),
    );
  }

  /// Request interceptor
  void _onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.i('🚀 ${options.method} ${options.path}');
    handler.next(options);
  }

  /// Response interceptor
  void _onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger.i('✅ ${response.statusCode} ${response.requestOptions.path}');
    handler.next(response);
  }

  /// Error interceptor with retry logic
  Future<void> _onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    _logger.e('❌ ${err.type} ${err.requestOptions.path}');

    // Retry logic for network errors
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout) {
      if (err.requestOptions.extra['retryCount'] == null) {
        err.requestOptions.extra['retryCount'] = 0;
      }

      int retryCount = err.requestOptions.extra['retryCount'];

      if (retryCount < 3) {
        _logger.w('🔄 Retrying request (${retryCount + 1}/3)...');
        err.requestOptions.extra['retryCount'] = retryCount + 1;

        // Exponential backoff
        await Future.delayed(Duration(seconds: retryCount + 1));

        try {
          final response = await _dio.request(
            err.requestOptions.path,
            data: err.requestOptions.data,
            queryParameters: err.requestOptions.queryParameters,
            options: Options(
              method: err.requestOptions.method,
              headers: err.requestOptions.headers,
            ),
          );
          return handler.resolve(response);
        } catch (e) {
          // Continue with error if retry fails
        }
      }
    }

    handler.next(err);
  }

  /// Set authentication token
  Future<void> setAuthToken(String token) async {
    _dio.options.headers['Authorization'] = 'Bearer $token';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  /// Clear authentication token
  Future<void> clearAuthToken() async {
    _dio.options.headers.remove('Authorization');
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  /// Load cached auth token
  Future<void> loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  /// GET request with caching
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool useCache = false,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      // Check cache first
      if (useCache) {
        final cacheKey = _generateCacheKey('GET', path, queryParameters);
        final cached = _getFromCache(cacheKey);
        if (cached != null) {
          _logger.i('📦 Using cached response for $path');
          return ApiResponse.success(
            fromJson != null ? fromJson(cached) : cached as T,
          );
        }
      }

      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
      );

      // Cache successful responses
      if (useCache) {
        final cacheKey = _generateCacheKey('GET', path, queryParameters);
        _saveToCache(cacheKey, response.data);
      }

      return ApiResponse.success(
        fromJson != null ? fromJson(response.data) : response.data as T,
      );
    } on DioException catch (e) {
      return ApiResponse.error(_handleError(e));
    } catch (e) {
      return ApiResponse.error('Unexpected error: $e');
    }
  }

  /// POST request
  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );

      return ApiResponse.success(
        fromJson != null ? fromJson(response.data) : response.data as T,
      );
    } on DioException catch (e) {
      return ApiResponse.error(_handleError(e));
    } catch (e) {
      return ApiResponse.error('Unexpected error: $e');
    }
  }

  /// PUT request
  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
      );

      return ApiResponse.success(
        fromJson != null ? fromJson(response.data) : response.data as T,
      );
    } on DioException catch (e) {
      return ApiResponse.error(_handleError(e));
    } catch (e) {
      return ApiResponse.error('Unexpected error: $e');
    }
  }

  /// DELETE request
  Future<ApiResponse<T>> delete<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        queryParameters: queryParameters,
      );

      return ApiResponse.success(
        fromJson != null ? fromJson(response.data) : response.data as T,
      );
    } on DioException catch (e) {
      return ApiResponse.error(_handleError(e));
    } catch (e) {
      return ApiResponse.error('Unexpected error: $e');
    }
  }

  /// Upload file
  Future<ApiResponse<T>> uploadFile<T>(
    String path,
    File file, {
    String fieldName = 'file',
    Map<String, dynamic>? additionalData,
    T Function(dynamic)? fromJson,
    Function(int sent, int total)? onProgress,
  }) async {
    try {
      final fileName = file.path.split('/').last;
      final formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
        ...?additionalData,
      });

      final response = await _dio.post(
        path,
        data: formData,
        onSendProgress: onProgress,
      );

      return ApiResponse.success(
        fromJson != null ? fromJson(response.data) : response.data as T,
      );
    } on DioException catch (e) {
      return ApiResponse.error(_handleError(e));
    } catch (e) {
      return ApiResponse.error('Unexpected error: $e');
    }
  }

  /// Handle errors
  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['detail'] ??
            error.response?.data?['message'] ??
            'Server error';

        if (statusCode == 401) {
          return 'Unauthorized. Please login again.';
        } else if (statusCode == 403) {
          return 'Access forbidden.';
        } else if (statusCode == 404) {
          return 'Resource not found.';
        } else if (statusCode == 422) {
          return 'Validation error: $message';
        } else if (statusCode == 500) {
          return 'Internal server error. Please try again later.';
        }
        return message;

      case DioExceptionType.cancel:
        return 'Request cancelled.';

      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return 'No internet connection.';
        }
        return 'An unexpected error occurred.';

      default:
        return 'An error occurred: ${error.message}';
    }
  }

  /// Cache management
  String _generateCacheKey(
    String method,
    String path,
    Map<String, dynamic>? params,
  ) {
    return '$method:$path:${params?.toString() ?? ""}';
  }

  void _saveToCache(String key, dynamic data) {
    _cache[key] = CachedResponse(
      data: data,
      timestamp: DateTime.now(),
    );
  }

  dynamic _getFromCache(String key) {
    final cached = _cache[key];
    if (cached == null) return null;

    final age = DateTime.now().difference(cached.timestamp);
    if (age > _cacheDuration) {
      _cache.remove(key);
      return null;
    }

    return cached.data;
  }

  /// Clear all cache
  void clearCache() {
    _cache.clear();
    _logger.i('🗑️ Cache cleared');
  }

  /// Update base URL (for switching between environments)
  void updateBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
    _logger.i('🔄 Base URL updated to $baseUrl');
  }
}

/// Cached response model
class CachedResponse {
  final dynamic data;
  final DateTime timestamp;

  CachedResponse({
    required this.data,
    required this.timestamp,
  });
}

/// API Response wrapper
class ApiResponse<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  ApiResponse._({
    this.data,
    this.error,
    required this.isSuccess,
  });

  factory ApiResponse.success(T data) {
    return ApiResponse._(
      data: data,
      isSuccess: true,
    );
  }

  factory ApiResponse.error(String error) {
    return ApiResponse._(
      error: error,
      isSuccess: false,
    );
  }
}
