import 'api_service.dart';
import '../models/product_model.dart';

/// Product API Service
class ProductApiService {
  final ApiService _apiService = ApiService();

  /// Create a new product
  Future<ApiResponse<Product>> createProduct(Map<String, dynamic> productData) async {
    final response = await _apiService.post<Map<String, dynamic>>(
      '/products/',
      data: productData,
    );

    if (response.isSuccess && response.data != null) {
      return ApiResponse.success(Product.fromJson(response.data!));
    }

    return ApiResponse.error(response.error ?? 'Failed to create product');
  }

  /// Get product by ID
  Future<ApiResponse<Product>> getProduct(String productId) async {
    final response = await _apiService.get<Map<String, dynamic>>(
      '/products/$productId',
      useCache: true,
    );

    if (response.isSuccess && response.data != null) {
      return ApiResponse.success(Product.fromJson(response.data!));
    }

    return ApiResponse.error(response.error ?? 'Failed to get product');
  }

  /// List products with filtering
  Future<ApiResponse<List<Product>>> listProducts({
    int skip = 0,
    int limit = 20,
    String? category,
  }) async {
    final response = await _apiService.get<List<dynamic>>(
      '/products/',
      queryParameters: {
        'skip': skip,
        'limit': limit,
        if (category != null) 'category': category,
      },
      useCache: true,
    );

    if (response.isSuccess && response.data != null) {
      final products = response.data!
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();
      return ApiResponse.success(products);
    }

    return ApiResponse.error(response.error ?? 'Failed to list products');
  }

  /// Update product
  Future<ApiResponse<Product>> updateProduct(
    String productId,
    Map<String, dynamic> updates,
  ) async {
    final response = await _apiService.put<Map<String, dynamic>>(
      '/products/$productId',
      data: updates,
    );

    if (response.isSuccess && response.data != null) {
      _apiService.clearCache();
      return ApiResponse.success(Product.fromJson(response.data!));
    }

    return ApiResponse.error(response.error ?? 'Failed to update product');
  }

  /// Delete product
  Future<ApiResponse<void>> deleteProduct(String productId) async {
    final response = await _apiService.delete<Map<String, dynamic>>(
      '/products/$productId',
    );

    if (response.isSuccess) {
      _apiService.clearCache();
      return ApiResponse.success(null);
    }

    return ApiResponse.error(response.error ?? 'Failed to delete product');
  }

  /// Search products by name or category
  Future<ApiResponse<List<Product>>> searchProducts(String query) async {
    // Note: Implement search endpoint in backend if needed
    return await listProducts();
  }
}
