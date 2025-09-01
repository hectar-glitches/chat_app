import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'utils/connectivity_service.dart';
import 'utils/local_storage_service.dart';
import 'utils/notification_service.dart';

class AppController {
  static final AppController _instance = AppController._internal();
  
  // Services
  late ConnectivityService _connectivityService;
  late NotificationService _notificationService;
  
  // Singleton constructor
  factory AppController() => _instance;
  
  AppController._internal();
  
  // Network status stream
  Stream<NetworkStatus> get networkStatusStream => _connectivityService.networkStatusStream;
  
  // Initialize all app services
  Future<void> initializeApp() async {
    try {
      // Initialize Firebase
      await Firebase.initializeApp();
      
      // Configure error reporting
      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.presentError(details);
        FirebaseCrashlytics.instance.recordFlutterError(details);
      };
      
      // Initialize local storage
      await LocalStorageService.init();
      
      // Initialize connectivity service
      _connectivityService = ConnectivityService();
      
      // Initialize notification service
      _notificationService = NotificationService();
      await _notificationService.init();
      
      // Set up user status monitoring
      _setupUserStatusMonitoring();
      
    } catch (e, stackTrace) {
      debugPrint('Error initializing app: $e');
      // Still record the error even if initialization fails
      if (Firebase.apps.isNotEmpty) {
        FirebaseCrashlytics.instance.recordError(e, stackTrace);
      }
    }
  }
  
  // Monitor user status changes for online/offline status
  void _setupUserStatusMonitoring() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        // Set up a listener for connectivity changes to update online status
        networkStatusStream.listen((status) {
          _updateUserOnlineStatus(user.uid, status == NetworkStatus.online);
        });
      }
    });
  }
  
  // Update user online status in Firestore
  Future<void> _updateUserOnlineStatus(String userId, bool isOnline) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'isOnline': isOnline,
        'lastSeen': isOnline ? null : DateTime.now(),
      });
    } catch (e) {
      debugPrint('Error updating user status: $e');
    }
  }
  
  // Get notification token
  Future<String?> getNotificationToken() async {
    return await _notificationService.getToken();
  }
  
  // Check if device is connected to the internet
  Future<bool> isConnected() async {
    return await _connectivityService.isConnected();
  }
  
  // Clean up resources
  void dispose() {
    _connectivityService.dispose();
  }
}
