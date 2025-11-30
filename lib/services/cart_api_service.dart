import 'api_service.dart';
import '../models/cart_item_model.dart';

/// Cart API Service
class CartApiService {
  final ApiService _apiService = ApiService();

  /// Add item to cart
  Future<ApiResponse<CartItem>> addToCart(
    String userId,
    Map<String, dynamic> cartItemData,
  ) async {
    final response = await _apiService.post<Map<String, dynamic>>(
      '/cart/$userId',
      data: cartItemData,
    );

    if (response.isSuccess && response.data != null) {
      return ApiResponse.success(CartItem.fromJson(response.data!));
    }

    return ApiResponse.error(response.error ?? 'Failed to add to cart');
  }

  /// Get user's cart items
  Future<ApiResponse<List<CartItem>>> getCartItems(String userId) async {
    final response = await _apiService.get<List<dynamic>>(
      '/cart/$userId',
      useCache: false,
    );

    if (response.isSuccess && response.data != null) {
      final cartItems = response.data!
          .map((json) => CartItem.fromJson(json as Map<String, dynamic>))
          .toList();
      return ApiResponse.success(cartItems);
    }

    return ApiResponse.error(response.error ?? 'Failed to get cart items');
  }

  /// Update cart item quantity
  Future<ApiResponse<CartItem>> updateCartItem(
    String userId,
    String cartItemId,
    int quantity,
  ) async {
    final response = await _apiService.put<Map<String, dynamic>>(
      '/cart/$userId/$cartItemId',
      data: {'quantity': quantity},
    );

    if (response.isSuccess && response.data != null) {
      return ApiResponse.success(CartItem.fromJson(response.data!));
    }

    return ApiResponse.error(response.error ?? 'Failed to update cart item');
  }

  /// Remove item from cart
  Future<ApiResponse<void>> removeFromCart(
    String userId,
    String cartItemId,
  ) async {
    final response = await _apiService.delete<Map<String, dynamic>>(
      '/cart/$userId/$cartItemId',
    );

    if (response.isSuccess) {
      return ApiResponse.success(null);
    }

    return ApiResponse.error(response.error ?? 'Failed to remove from cart');
  }

  /// Clear entire cart
  Future<ApiResponse<void>> clearCart(String userId) async {
    final response = await _apiService.delete<Map<String, dynamic>>(
      '/cart/$userId',
    );

    if (response.isSuccess) {
      return ApiResponse.success(null);
    }

    return ApiResponse.error(response.error ?? 'Failed to clear cart');
  }

  /// Get cart total
  Future<ApiResponse<double>> getCartTotal(String userId) async {
    final cartResponse = await getCartItems(userId);

    if (!cartResponse.isSuccess || cartResponse.data == null) {
      return ApiResponse.error('Failed to calculate cart total');
    }

    double total = 0;
    for (var item in cartResponse.data!) {
      total += (item.price * item.quantity);
    }

    return ApiResponse.success(total);
  }
}
