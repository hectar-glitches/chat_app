import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

enum NetworkStatus { online, offline }

class ConnectivityService {
  // Create a stream controller to broadcast network status changes
  final _controller = StreamController<NetworkStatus>.broadcast();
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  // Stream to listen to network status changes
  Stream<NetworkStatus> get networkStatusStream => _controller.stream;

  ConnectivityService() {
    // Initialize the stream controller
    _initializeController();
  }

  void _initializeController() async {
    // Get the initial connectivity status
    ConnectivityResult result = await _connectivity.checkConnectivity();
    _handleConnectivityChange(result);

    // Listen for connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_handleConnectivityChange);
  }

  void _handleConnectivityChange(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      _controller.add(NetworkStatus.offline);
    } else {
      _controller.add(NetworkStatus.online);
    }
  }

  // Check if the device is currently connected to the internet
  Future<bool> isConnected() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  // Clean up resources
  void dispose() {
    _connectivitySubscription?.cancel();
    _controller.close();
  }
}
