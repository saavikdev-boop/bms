import 'api_service.dart';

/// Wallet model
class Wallet {
  final String id;
  final String userId;
  final double balance;
  final DateTime createdAt;
  final DateTime updatedAt;

  Wallet({
    required this.id,
    required this.userId,
    required this.balance,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      id: json['id'],
      userId: json['user_id'],
      balance: (json['balance'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

/// Transaction model
class Transaction {
  final String id;
  final String walletId;
  final double amount;
  final String type; // credit, debit
  final String status; // pending, success, failed
  final String? description;
  final String? referenceId;
  final DateTime createdAt;

  Transaction({
    required this.id,
    required this.walletId,
    required this.amount,
    required this.type,
    required this.status,
    this.description,
    this.referenceId,
    required this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      walletId: json['wallet_id'],
      amount: (json['amount'] as num).toDouble(),
      type: json['type'],
      status: json['status'],
      description: json['description'],
      referenceId: json['reference_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

/// Wallet API Service
class WalletApiService {
  final ApiService _apiService = ApiService();

  /// Get wallet balance
  Future<ApiResponse<Wallet>> getWallet(String userId) async {
    final response = await _apiService.get<Map<String, dynamic>>(
      '/wallet/$userId',
      useCache: false, // Don't cache wallet balance
    );

    if (response.isSuccess && response.data != null) {
      return ApiResponse.success(Wallet.fromJson(response.data!));
    }

    return ApiResponse.error(response.error ?? 'Failed to get wallet');
  }

  /// Create transaction (credit/debit)
  Future<ApiResponse<Transaction>> createTransaction(
    String userId,
    Map<String, dynamic> transactionData,
  ) async {
    final response = await _apiService.post<Map<String, dynamic>>(
      '/wallet/$userId/transactions',
      data: transactionData,
    );

    if (response.isSuccess && response.data != null) {
      return ApiResponse.success(Transaction.fromJson(response.data!));
    }

    return ApiResponse.error(response.error ?? 'Failed to create transaction');
  }

  /// Get transaction history
  Future<ApiResponse<List<Transaction>>> getTransactionHistory(
    String userId,
  ) async {
    final response = await _apiService.get<List<dynamic>>(
      '/wallet/$userId/transactions',
      useCache: false,
    );

    if (response.isSuccess && response.data != null) {
      final transactions = response.data!
          .map((json) => Transaction.fromJson(json as Map<String, dynamic>))
          .toList();
      return ApiResponse.success(transactions);
    }

    return ApiResponse.error(response.error ?? 'Failed to get transactions');
  }

  /// Get transaction by ID
  Future<ApiResponse<Transaction>> getTransaction(
    String userId,
    String transactionId,
  ) async {
    final response = await _apiService.get<Map<String, dynamic>>(
      '/wallet/$userId/transactions/$transactionId',
    );

    if (response.isSuccess && response.data != null) {
      return ApiResponse.success(Transaction.fromJson(response.data!));
    }

    return ApiResponse.error(response.error ?? 'Failed to get transaction');
  }

  /// Add money to wallet
  Future<ApiResponse<Transaction>> addMoney(
    String userId,
    double amount,
    String paymentMethod,
  ) async {
    return await createTransaction(userId, {
      'amount': amount,
      'type': 'credit',
      'description': 'Added via $paymentMethod',
      'status': 'success',
    });
  }

  /// Withdraw money from wallet
  Future<ApiResponse<Transaction>> withdrawMoney(
    String userId,
    double amount,
    String? bankDetails,
  ) async {
    return await createTransaction(userId, {
      'amount': amount,
      'type': 'debit',
      'description': 'Withdrawal to bank',
      'reference_id': bankDetails,
      'status': 'pending',
    });
  }
}
