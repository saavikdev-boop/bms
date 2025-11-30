import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectionStatusController = StreamController<bool>.broadcast();

  bool _isConnected = true;

  // Stream to listen to connectivity changes
  Stream<bool> get connectionStatus => _connectionStatusController.stream;

  // Current connectivity status
  bool get isConnected => _isConnected;

  // Initialize connectivity monitoring
  Future<void> initialize() async {
    // Check initial connectivity
    final result = await _connectivity.checkConnectivity();
    _updateConnectionStatus(result);

    // Listen to connectivity changes
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      // Use the first result or default to none
      final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
      _updateConnectionStatus([result]);
    });
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    // Check if any connection is available
    final hasConnection = results.any((result) =>
      result != ConnectivityResult.none
    );

    if (_isConnected != hasConnection) {
      _isConnected = hasConnection;
      _connectionStatusController.add(_isConnected);

      if (_isConnected) {
        print('✅ Connection restored');
      } else {
        print('⚠️ Connection lost - App is now offline');
      }
    }
  }

  // Check if network is available
  Future<bool> checkConnection() async {
    try {
      final results = await _connectivity.checkConnectivity();
      return results.any((result) => result != ConnectivityResult.none);
    } catch (e) {
      print('Error checking connectivity: $e');
      return false;
    }
  }

  void dispose() {
    _connectionStatusController.close();
  }
}
