import 'api_service.dart';
import '../models/address_model.dart';

/// Address API Service
class AddressApiService {
  final ApiService _apiService = ApiService();

  /// Create a new address
  Future<ApiResponse<Address>> createAddress(
    String userId,
    Map<String, dynamic> addressData,
  ) async {
    final response = await _apiService.post<Map<String, dynamic>>(
      '/addresses/$userId',
      data: addressData,
    );

    if (response.isSuccess && response.data != null) {
      return ApiResponse.success(Address.fromJson(response.data!));
    }

    return ApiResponse.error(response.error ?? 'Failed to create address');
  }

  /// Get user's addresses
  Future<ApiResponse<List<Address>>> getUserAddresses(String userId) async {
    final response = await _apiService.get<List<dynamic>>(
      '/addresses/$userId',
      useCache: true,
    );

    if (response.isSuccess && response.data != null) {
      final addresses = response.data!
          .map((json) => Address.fromJson(json as Map<String, dynamic>))
          .toList();
      return ApiResponse.success(addresses);
    }

    return ApiResponse.error(response.error ?? 'Failed to get addresses');
  }

  /// Get address by ID
  Future<ApiResponse<Address>> getAddress(
    String userId,
    String addressId,
  ) async {
    final response = await _apiService.get<Map<String, dynamic>>(
      '/addresses/$userId/$addressId',
    );

    if (response.isSuccess && response.data != null) {
      return ApiResponse.success(Address.fromJson(response.data!));
    }

    return ApiResponse.error(response.error ?? 'Failed to get address');
  }

  /// Update address
  Future<ApiResponse<Address>> updateAddress(
    String userId,
    String addressId,
    Map<String, dynamic> updates,
  ) async {
    final response = await _apiService.put<Map<String, dynamic>>(
      '/addresses/$userId/$addressId',
      data: updates,
    );

    if (response.isSuccess && response.data != null) {
      _apiService.clearCache();
      return ApiResponse.success(Address.fromJson(response.data!));
    }

    return ApiResponse.error(response.error ?? 'Failed to update address');
  }

  /// Delete address
  Future<ApiResponse<void>> deleteAddress(
    String userId,
    String addressId,
  ) async {
    final response = await _apiService.delete<Map<String, dynamic>>(
      '/addresses/$userId/$addressId',
    );

    if (response.isSuccess) {
      _apiService.clearCache();
      return ApiResponse.success(null);
    }

    return ApiResponse.error(response.error ?? 'Failed to delete address');
  }

  /// Get default address
  Future<ApiResponse<Address?>> getDefaultAddress(String userId) async {
    final addressesResponse = await getUserAddresses(userId);

    if (!addressesResponse.isSuccess || addressesResponse.data == null) {
      return ApiResponse.error('Failed to get default address');
    }

    final defaultAddress = addressesResponse.data!
        .where((address) => address.isDefault)
        .firstOrNull;

    return ApiResponse.success(defaultAddress);
  }
}

extension FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
